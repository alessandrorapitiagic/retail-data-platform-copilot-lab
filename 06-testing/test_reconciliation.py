import os, psycopg
from dotenv import load_dotenv
load_dotenv()
SRC=f"host={os.getenv('SOURCE_DB_HOST','localhost')} port={os.getenv('SOURCE_DB_PORT','5433')} dbname={os.getenv('SOURCE_DB_NAME','retail_source')} user={os.getenv('DB_USER','lab_user')} password={os.getenv('DB_PASSWORD','lab_password')}"
DW=f"host={os.getenv('DW_DB_HOST','localhost')} port={os.getenv('DW_DB_PORT','5434')} dbname={os.getenv('DW_DB_NAME','retail_dw')} user={os.getenv('DB_USER','lab_user')} password={os.getenv('DB_PASSWORD','lab_password')}"
def test_sales_reconciliation():
  with psycopg.connect(SRC) as s, psycopg.connect(DW) as d:
    source=s.execute("select sum(l.quantity*l.unit_price-case when l.quantity<0 then -abs(l.discount_amount) else abs(l.discount_amount) end) from erp.sales_order_line l join erp.sales_order o using(order_id) join erp.product p on p.product_id=l.product_id where o.status in ('COMPLETED','RETURNED') and p.category_code is not null").fetchone()[0]
    gold=d.execute('select sum(net_amount) from gold.fact_sales').fetchone()[0]
    assert abs(source-gold) <= max(abs(source)*0.001,0.01)

def test_ecommerce_reconciliation():
  """FR-011: ogni ordine e-commerce fatturato (INVOICED) deve avere un corrispondente documento ERP,
  ed ogni eccezione deve risultare tracciata come DQ-ECOM-001 (audit.data_quality_issue è un log
  append-only: si verifica l'esistenza della segnalazione per record, non il conteggio totale)."""
  with psycopg.connect(DW) as d:
    unmatched=d.execute("select web_order_id from silver.ecommerce_reconciliation where status='INVOICED' and not is_matched").fetchall()
    assert len(unmatched) >= 1  # il dataset demo contiene volutamente WEB-2026-0003 non riconciliato
    for (web_order_id,) in unmatched:
      flagged=d.execute("select count(*) from audit.data_quality_issue where rule_code='DQ-ECOM-001' and record_key=%s",(web_order_id,)).fetchone()[0]
      assert flagged >= 1, f'{web_order_id} non riconciliato ma privo di segnalazione DQ-ECOM-001'


