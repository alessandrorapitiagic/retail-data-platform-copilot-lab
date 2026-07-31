# Data Quality Rules

| Code | Regola | Severità | Azione |
|---|---|---|---|
| DQ-PROD-001 | prodotto senza categoria | Error | non pubblicare vendite correlate |
| DQ-STORE-001 | store inesistente | Error | scarto |
| DQ-CUST-001 | cliente senza e-mail e VAT | Warning | chiave tecnica |
| DQ-SALES-001 | net sales non riconciliato >0,1% | Error | blocco refresh |
| DQ-STOCK-001 | available < 0 | Warning | segnalazione |
| DQ-ECOM-001 | ordine e-commerce fatturato assente in ERP | Error | segnalazione + verifica integrazione ShopNow |

Tutte le regole sono implementate in `04-data-platform/sql/transform/20_silver.sql` (log su `audit.data_quality_issue`)
ad eccezione di DQ-SALES-001, applicata come gate Python in `scripts/run_etl.py::check_sales_reconciliation` dopo il
caricamento del Gold: se la soglia viene superata l'intera transazione ETL viene annullata (il Gold precedente resta
valido) e l'issue viene comunque registrata su una connessione dedicata per non perdere la segnalazione.
