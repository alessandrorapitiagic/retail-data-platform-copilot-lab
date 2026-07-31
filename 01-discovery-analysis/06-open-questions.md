# Open Questions

1. Confermare trattamento IVA nei KPI di fatturato.
2. Definire algoritmo definitivo per duplicati cliente senza e-mail/VAT.
3. Confermare se i buoni regalo sono vendite o passività.
4. Confermare gestione categorie storiche in una futura release SCD2.
5. Definire canale di notifica per violazioni SLA.
6. Definire la SLA di riconciliazione ShopNow -> ERP (oggi DQ-ECOM-001 valuta il disallineamento al momento
   dell'esecuzione dell'ETL giornaliero; da confermare se serve una finestra di tolleranza, es. T+1 giorno lavorativo,
   prima di segnalare l'anomalia come Error anziché Warning).
7. FR-005 richiede di distinguere versioni di budget "Original" vs "Latest": lo schema attuale
   (`silver.budget`/`gold.fact_budget`, colonna `scenario`) non implementa ancora un vero versioning storicizzato,
   supporta solo scenari nominali (es. BUDGET, LATEST) sovrascritti a ogni caricamento. Da chiarire con Controlling
   se serve conservare lo storico delle revisioni (impatta il modello dati e le misure di confronto).
