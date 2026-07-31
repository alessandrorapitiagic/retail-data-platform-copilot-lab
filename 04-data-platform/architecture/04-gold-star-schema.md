# Gold Star Schema

## Dimensions
- dim_date
- dim_store
- dim_product
- dim_customer
- dim_channel

## Facts
- fact_sales: una riga per order_line.
- fact_inventory: una riga per date/store/product.
- fact_budget: una riga per month/store/category/scenario.

Relazioni 1:* dalle dimensioni ai fatti. Nessuna relazione bidirezionale.

## Tabelle satellite (non fanno parte dello star schema analitico)
- `security_user_store`: mapping utente/ruolo/store/region utilizzato esclusivamente per la Row-Level Security
  del modello Power BI (vedi `05-powerbi/security-model.md`). Importata nel modello come tabella nascosta,
  senza relazioni con fatti o dimensioni: viene interrogata solo dalle espressioni DAX dei ruoli tramite `LOOKUPVALUE`.
