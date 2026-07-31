from __future__ import annotations
import csv, os
from pathlib import Path
from datetime import datetime, timezone
from dotenv import load_dotenv
import psycopg

load_dotenv()
SRC=f"host={os.getenv('SOURCE_DB_HOST','localhost')} port={os.getenv('SOURCE_DB_PORT','5433')} dbname={os.getenv('SOURCE_DB_NAME','retail_source')} user={os.getenv('DB_USER','lab_user')} password={os.getenv('DB_PASSWORD','lab_password')}"
DW=f"host={os.getenv('DW_DB_HOST','localhost')} port={os.getenv('DW_DB_PORT','5434')} dbname={os.getenv('DW_DB_NAME','retail_dw')} user={os.getenv('DB_USER','lab_user')} password={os.getenv('DB_PASSWORD','lab_password')}"

TABLES=[
 ('crm.customer','bronze.crm_customer'),('erp.store','bronze.erp_store'),('erp.product','bronze.erp_product'),
 ('erp.sales_order','bronze.erp_sales_order'),('erp.sales_order_line','bronze.erp_sales_order_line'),('erp.inventory_snapshot','bronze.erp_inventory_snapshot'),
 ('ecommerce.web_order','bronze.ecommerce_web_order')]

# DQ-SALES-001 (data-quality-rules.md): scostamento massimo tollerato tra il net sales di source e il net sales del Gold.
# Oltre soglia il refresh viene bloccato: la transazione dell'intero run viene annullata e il Gold precedente resta valido.
RECONCILIATION_THRESHOLD_PCT=0.001

def copy_table(src,dw,source,target,run_id):
    rows=src.execute(f'SELECT * FROM {source}').fetchall()
    cols=[d.name for d in src.execute(f'SELECT * FROM {source} LIMIT 0').description]
    dw.execute(f'TRUNCATE {target}')
    placeholders=','.join(['%s']*(len(cols)+2))
    dw.executemany(f"INSERT INTO {target} ({','.join(cols)},_ingested_at,_run_id) VALUES ({placeholders})", [tuple(r)+(datetime.now(timezone.utc),run_id) for r in rows])
    return len(rows)

def check_sales_reconciliation(src,dw,run_id):
    """DQ-SALES-001: blocca il refresh se il net sales del Gold si scosta oltre soglia dalla source."""
    source_net=src.execute("""
        select sum(l.quantity*l.unit_price-case when l.quantity<0 then -abs(l.discount_amount) else abs(l.discount_amount) end)
        from erp.sales_order_line l join erp.sales_order o using(order_id) join erp.product p on p.product_id=l.product_id
        where o.status in ('COMPLETED','RETURNED') and p.category_code is not null
    """).fetchone()[0] or 0
    gold_net=dw.execute('select coalesce(sum(net_amount),0) from gold.fact_sales').fetchone()[0]
    variance_pct=abs(source_net-gold_net)/abs(source_net) if source_net else 0
    if variance_pct > RECONCILIATION_THRESHOLD_PCT:
        # Il DQ issue viene registrato su una connessione dedicata cosi' resta committato anche se il run principale viene annullato.
        with psycopg.connect(DW) as log:
            log.execute(
                "INSERT INTO audit.data_quality_issue(run_id,rule_code,source_table,record_key,severity,details) VALUES(%s,'DQ-SALES-001','gold.fact_sales','ALL','ERROR',%s)",
                (run_id,f'Net sales source={source_net} gold={gold_net} variance={variance_pct:.4%} (soglia {RECONCILIATION_THRESHOLD_PCT:.2%})'))
            log.commit()
        raise RuntimeError(f'DQ-SALES-001: scostamento net sales {variance_pct:.4%} oltre soglia {RECONCILIATION_THRESHOLD_PCT:.2%}: refresh bloccato')

def main():
  with psycopg.connect(SRC) as src, psycopg.connect(DW) as dw:
    run_id=dw.execute("INSERT INTO audit.etl_run(pipeline_name,started_at,status) VALUES('daily_retail',now(),'RUNNING') RETURNING run_id").fetchone()[0]
    dw.commit()  # il run va reso visibile subito: se il pipeline fallisce dopo, l'UPDATE a FAILED deve trovare la riga.
    try:
      for source,target in TABLES:
        count=copy_table(src,dw,source,target,run_id)
        dw.execute("INSERT INTO audit.etl_step(run_id,step_name,rows_read,rows_written,rows_rejected,status,started_at,ended_at) VALUES(%s,%s,%s,%s,0,'SUCCESS',now(),now())",(run_id,source,count,count))
      budget_path=Path(__file__).parents[1]/'00-customer-input/05-sample-budget.csv'
      dw.execute('TRUNCATE bronze.budget')
      with budget_path.open() as f:
        rows=list(csv.DictReader(f))
      dw.executemany("INSERT INTO bronze.budget(year,month,scenario,store_code,category_code,budget_amount,_ingested_at,_run_id) VALUES(%s,%s,%s,%s,%s,%s,now(),%s)",[(r['year'],r['month'],r['scenario'],r['store_code'],r['category_code'],r['budget_amount'],run_id) for r in rows])
      for sql_file in ['04-data-platform/sql/transform/20_silver.sql','04-data-platform/sql/transform/30_gold.sql']:
        dw.execute((Path(__file__).parents[1]/sql_file).read_text())
      check_sales_reconciliation(src,dw,run_id)
      dw.execute("UPDATE audit.etl_run SET ended_at=now(),status='SUCCESS' WHERE run_id=%s",(run_id,))
      dw.commit()
      print(f'ETL completed, run_id={run_id}')
    except Exception as exc:
      dw.rollback()
      with psycopg.connect(DW) as log:
        log.execute("UPDATE audit.etl_run SET ended_at=now(),status='FAILED',message=%s WHERE run_id=%s",(str(exc),run_id)); log.commit()
      raise
if __name__=='__main__': main()
