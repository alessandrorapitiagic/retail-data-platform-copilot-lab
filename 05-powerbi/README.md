# Power BI Project

Il modello è versionato in formato **PBIP/TMDL** (testo, diffabile in Git). Il file [`RetailAnalytics.pbip`](RetailAnalytics.pbip)
punta alla cartella [`RetailAnalytics.SemanticModel`](RetailAnalytics.SemanticModel/) (modello) e
[`RetailAnalytics.Report`](RetailAnalytics.Report/) (report). Tutte le tabelle hanno già una **partition** M che
si connette allo schema `gold` del database `retail_dw` (vedi `04-data-platform/sql/init` e `04-data-platform/sql/transform`).

## Prerequisiti

- Power BI Desktop (versione recente, con "PBIP" abilitato in **File > Options > Preview features > Power BI Project (.pbip) save option**).
- Driver **Npgsql** per il connettore PostgreSQL di Power BI Desktop (richiesto da Microsoft per il connettore nativo):
  scaricare da [npgsql.org](https://www.npgsql.org/) o dalla pagina del connettore in Power BI Desktop al primo utilizzo.
- Docker Desktop con lo stack del laboratorio avviato (`docker compose up -d`) e almeno un'esecuzione ETL completata
  (`python scripts/run_etl.py`), altrimenti lo schema `gold` è vuoto e il refresh non troverà dati.

## Passi per aprire e aggiornare il modello

1. Avviare lo stack: `docker compose up -d` e attendere che i container siano `healthy` (`docker compose ps`).
2. Eseguire l'ETL end-to-end: `python scripts/run_etl.py` (popola bronze/silver/gold e la tabella di sicurezza RLS).
3. Aprire `RetailAnalytics.pbip` con doppio click: Power BI Desktop genera automaticamente il modello e il report
   a partire dai file TMDL/PBIR.
4. Al primo refresh (**Home > Refresh**) Power BI chiederà le credenziali per `localhost:5434` (parametri
   `PostgreSQL_Server`/`PostgreSQL_Database` in `RetailAnalytics.SemanticModel/definition/expressions.tmdl`):
   usare **Database** con utente `lab_user` e password `lab_password` (vedi `.env.example`), livello di privacy "Organizational".
5. Verificare in **Modeling > Manage Roles** i tre ruoli RLS (Executive, Area Manager, Store Manager) e testarli con **View As**
   (dettagli in [`security-model.md`](security-model.md)).
6. Costruire/estendere le pagine del report seguendo [`report-specification.md`](report-specification.md) e il tema
   [`theme/retailone-theme.json`](../05-powerbi/theme/retailone-theme.json): il report incluso è uno shell minimale,
   intenzionalmente lasciato come esercizio guidato della demo (analista + BI developer + Copilot).

## Note per la demo

- I parametri di connessione sono centralizzati in `expressions.tmdl`: per puntare a un DW diverso (es. un ambiente
  cloud) basta modificare `PostgreSQL_Server`/`PostgreSQL_Database` senza toccare le singole tabelle.
- Se si preferisce non digitare credenziali durante la demo dal vivo, è possibile impostare la password come
  variabile d'ambiente `PGPASSWORD` sulla macchina demo prima di aprire Power BI Desktop.
- In caso di errore "Impossibile trovare il driver Npgsql", riavviare Power BI Desktop dopo l'installazione del driver.
