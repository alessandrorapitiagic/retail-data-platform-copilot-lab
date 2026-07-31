truncate silver.sales_line, silver.inventory_snapshot, silver.budget, silver.customer_conformed, silver.product_conformed, silver.store_conformed, silver.ecommerce_reconciliation;

insert into silver.customer_conformed
select distinct on (coalesce(nullif(trim(vat_number),''),nullif(lower(trim(email)),''),'ID:'||customer_id::text))
 coalesce(nullif(trim(vat_number),''),nullif(lower(trim(email)),''),'ID:'||customer_id::text) customer_bk,
 customer_id, customer_code, full_name, lower(trim(email)), nullif(trim(vat_number),''), city, region, coalesce(segment,'UNKNOWN'), consent_marketing,
 (email is not null or vat_number is not null), _run_id
from bronze.crm_customer
order by coalesce(nullif(trim(vat_number),''),nullif(lower(trim(email)),''),'ID:'||customer_id::text), updated_at desc;

insert into silver.store_conformed select store_id,store_code,store_name,region,store_type,is_active,_run_id from bronze.erp_store;
insert into silver.product_conformed select product_id,sku,product_name,coalesce(category_code,'UNKNOWN'),coalesce(category_name,'Unknown'),brand,standard_cost,(category_code is not null),_run_id from bronze.erp_product;

-- DQ-PROD-001: prodotto senza categoria -> le vendite collegate non vengono pubblicate in Silver/Gold.
insert into audit.data_quality_issue(run_id,rule_code,source_table,record_key,severity,details)
select _run_id,'DQ-PROD-001','bronze.erp_product',product_id::text,'ERROR','Missing category' from bronze.erp_product where category_code is null;

-- DQ-CUST-001: cliente senza e-mail e senza P.IVA -> golden record creato con chiave tecnica (warning, non bloccante).
insert into audit.data_quality_issue(run_id,rule_code,source_table,record_key,severity,details)
select _run_id,'DQ-CUST-001','silver.customer_conformed',customer_bk,'WARNING','Cliente privo di e-mail e P.IVA, riconciliato con chiave tecnica basata su customer_id' from silver.customer_conformed where not is_valid;

-- DQ-STORE-001: ordine di vendita che referenzia uno store non presente nell'anagrafica ERP sincronizzata -> lo scarico dallo star schema, non è affidabile.
insert into audit.data_quality_issue(run_id,rule_code,source_table,record_key,severity,details)
select distinct o._run_id,'DQ-STORE-001','bronze.erp_sales_order',o.order_id::text,'ERROR','Store '||o.store_id||' non presente in silver.store_conformed: ordine scartato'
from bronze.erp_sales_order o
left join silver.store_conformed s on s.store_id=o.store_id
where s.store_id is null;

insert into silver.sales_line
select l.order_line_id,o.order_id,o.document_number,o.order_date,o.store_id,l.product_id,
 coalesce(nullif(trim(c.vat_number),''),nullif(lower(trim(c.email)),''),'ID:'||c.customer_id::text),o.channel,l.quantity,
 l.quantity*l.unit_price,
 case when l.quantity<0 then -abs(l.discount_amount) else abs(l.discount_amount) end,
 l.quantity*l.unit_price - case when l.quantity<0 then -abs(l.discount_amount) else abs(l.discount_amount) end,
 l.quantity*l.standard_cost,
 (l.quantity*l.unit_price - case when l.quantity<0 then -abs(l.discount_amount) else abs(l.discount_amount) end) - l.quantity*l.standard_cost,
 l._run_id
from bronze.erp_sales_order_line l join bronze.erp_sales_order o on o.order_id=l.order_id
left join bronze.crm_customer c on c.customer_id=o.customer_id
join silver.product_conformed p on p.product_id=l.product_id and p.is_valid
join silver.store_conformed s on s.store_id=o.store_id
where o.status in ('COMPLETED','RETURNED');

insert into silver.inventory_snapshot select snapshot_date,store_id,product_id,on_hand_qty,reserved_qty,on_hand_qty-reserved_qty,_run_id from bronze.erp_inventory_snapshot;
insert into silver.budget select year,month,upper(scenario),store_code,category_code,budget_amount,_run_id from bronze.budget;

-- DQ-STOCK-001: disponibilità negativa (riservato > giacenza) -> segnalazione al team supply chain, non blocca il refresh.
insert into audit.data_quality_issue(run_id,rule_code,source_table,record_key,severity,details)
select _run_id,'DQ-STOCK-001','silver.inventory_snapshot',snapshot_date||'|'||store_id||'|'||product_id,'WARNING','Available qty negativa: '||available_qty from silver.inventory_snapshot where available_qty < 0;

-- Riconciliazione e-commerce (ShopNow) vs ERP: la piattaforma e-commerce è uno staging pre-fatturazione,
-- l'ERP resta la source of truth per le vendite (vedi 01-discovery-analysis/05-data-source-register.md).
-- Un ordine e-commerce fatturato (INVOICED) deve sempre trovare un ordine corrispondente in ERP (document_number = web_order_id).
insert into silver.ecommerce_reconciliation
select w.web_order_id, w.order_ts, lower(trim(w.email)), w.sku, w.gross_amount, w.status, o.document_number, (o.document_number is not null), w._run_id
from bronze.ecommerce_web_order w
left join bronze.erp_sales_order o on o.document_number = w.web_order_id;

-- DQ-ECOM-001: ordine e-commerce marcato INVOICED ma assente in ERP -> possibile rottura dell'integrazione ShopNow -> ERP.
insert into audit.data_quality_issue(run_id,rule_code,source_table,record_key,severity,details)
select _run_id,'DQ-ECOM-001','silver.ecommerce_reconciliation',web_order_id,'ERROR','Ordine e-commerce fatturato ma non ricevuto in ERP entro il ciclo di ingestion' from silver.ecommerce_reconciliation where status='INVOICED' and not is_matched;
