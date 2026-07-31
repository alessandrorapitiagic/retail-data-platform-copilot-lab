# Source-to-Target Mapping

| Source | Bronze | Silver | Gold |
|---|---|---|---|
| crm.customer | bronze.crm_customer | silver.customer_conformed | gold.dim_customer |
| erp.product | bronze.erp_product | silver.product_conformed | gold.dim_product |
| erp.store | bronze.erp_store | silver.store_conformed | gold.dim_store |
| erp.sales_order + line | bronze.erp_sales_* | silver.sales_line | gold.fact_sales |
| inventory_snapshot | bronze.erp_inventory_snapshot | silver.inventory_snapshot | gold.fact_inventory |
| budget CSV | bronze.budget | silver.budget | gold.fact_budget |
| ecommerce.web_order (ShopNow) | bronze.ecommerce_web_order | silver.ecommerce_reconciliation | *non pubblicato in Gold* |

> **ShopNow non alimenta il Gold.** L'export e-commerce è uno staging pre-fatturazione: l'ordine diventa
> parte del layer certificato solo quando ERP lo riceve e genera il documento (`erp.sales_order.document_number`).
> `silver.ecommerce_reconciliation` esiste esclusivamente per rilevare rotture di integrazione (DQ-ECOM-001),
> non come sorgente addizionale di vendite: evita doppio conteggio tra canale ONLINE (ERP) e ShopNow.
