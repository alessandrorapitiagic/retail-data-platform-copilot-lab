import os, psycopg
from dotenv import load_dotenv
load_dotenv()
DSN=f"host={os.getenv('DW_DB_HOST','localhost')} port={os.getenv('DW_DB_PORT','5434')} dbname={os.getenv('DW_DB_NAME','retail_dw')} user={os.getenv('DB_USER','lab_user')} password={os.getenv('DB_PASSWORD','lab_password')}"
def q(sql):
  with psycopg.connect(DSN) as c: return c.execute(sql).fetchone()[0]
def test_fact_sales_not_empty(): assert q('select count(*) from gold.fact_sales') > 0
def test_no_orphan_product(): assert q('select count(*) from gold.fact_sales f left join gold.dim_product d on d.product_key=f.product_key where d.product_key is null') == 0
def test_no_orphan_store(): assert q('select count(*) from gold.fact_sales f left join gold.dim_store d on d.store_key=f.store_key where d.store_key is null') == 0
def test_no_orphan_channel(): assert q('select count(*) from gold.fact_sales f left join gold.dim_channel d on d.channel_key=f.channel_key where d.channel_key is null') == 0
def test_margin_formula(): assert q('select count(*) from gold.fact_sales where abs(margin_amount-(net_amount-cost_amount))>0.01') == 0

# DQ-PROD-001: prodotto senza categoria -> viene registrato e la vendita correlata non compare in Gold.
def test_dq_prod_001_logged():
  assert q("select count(*) from audit.data_quality_issue where rule_code='DQ-PROD-001'") > 0
  assert q("select count(*) from gold.fact_sales f join gold.dim_product p on p.product_key=f.product_key where p.category_code='UNKNOWN'") == 0

# DQ-CUST-001: cliente senza e-mail/VAT -> warning loggato, golden record comunque presente in Gold con chiave tecnica.
def test_dq_cust_001_logged():
  assert q("select count(*) from audit.data_quality_issue where rule_code='DQ-CUST-001'") > 0

# DQ-STOCK-001: disponibilità negativa -> warning loggato (seed contiene un caso di riservato > giacenza).
def test_dq_stock_001_logged():
  assert q("select count(*) from audit.data_quality_issue where rule_code='DQ-STOCK-001'") > 0
  assert q("select count(*) from gold.fact_inventory where available_qty < 0") > 0

# DQ-ECOM-001: ordine e-commerce fatturato ma assente in ERP -> error loggato (seed contiene WEB-2026-0003).
def test_dq_ecom_001_logged():
  assert q("select count(*) from audit.data_quality_issue where rule_code='DQ-ECOM-001'") > 0

def test_security_user_store_populated():
  assert q("select count(*) from gold.security_user_store") > 0

