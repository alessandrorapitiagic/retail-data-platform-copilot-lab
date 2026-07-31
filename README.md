# Retail Data Platform - GitHub Copilot Lab

Repository didattica completa per simulare un progetto Data & Analytics dalla richiesta iniziale del cliente alla realizzazione di una piattaforma Bronze/Silver/Gold e di un modello semantico Power BI.

## Scenario
RetailOne opera con negozi fisici ed e-commerce. I dati sono distribuiti tra ERP, CRM, piattaforma e-commerce e file budget. Il cliente vuole un'unica fonte certificata per vendite, margine, clienti e stock.

## Obiettivi del laboratorio
1. Leggere gli scambi e-mail e ricavare requisiti e domande aperte.
2. Creare WBS, backlog, RAID log e piano di progetto.
3. Avviare due database PostgreSQL: `retail_source` e `retail_dw`.
4. Profilare i dati sorgente e definire regole di qualità.
5. Costruire layer Bronze, Silver e Gold.
6. Eseguire ETL e test automatici.
7. Aprire/versionare il modello Power BI in formato PBIP/TMDL.
8. Produrre documentazione, UAT e handover.

## Avvio rapido
```bash
cp .env.example .env
make up            # docker compose up -d --wait: avvia retail_source e retail_dw ed attende gli healthcheck
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
make etl            # python scripts/run_etl.py: bronze -> silver -> gold + gate di riconciliazione DQ-SALES-001
make test            # pytest -q: SIT tecnici (orfani, DQ, riconciliazione ERP/e-commerce)
```

In alternativa allo script `make`, i comandi equivalenti sono descritti nel [Makefile](Makefile) (`docker compose up -d --wait`,
`python scripts/run_etl.py`, `pytest -q`). Target utili aggiuntivi:

| Comando | Effetto |
|---|---|
| `make demo` | esegue in sequenza `up`, `etl`, `test`: ricostruisce l'intera demo da zero |
| `make pgadmin` | avvia pgAdmin su http://localhost:8081 con `retail_source` e `retail_dw` pre-configurati |
| `make psql-source` / `make psql-dw` | apre una shell `psql` dentro il container del database indicato |
| `make down` | ferma i container e rimuove i volumi (reset completo dei dati) |

## Aprire la demo in Power BI Desktop

1. Completare l'avvio rapido sopra (stack Docker up, ETL eseguito con successo, test verdi).
2. Aprire `05-powerbi/RetailAnalytics.pbip` con Power BI Desktop: il modello TMDL contiene già le partition
   che si connettono allo schema `gold` di `retail_dw` (host `localhost:5434`).
3. Seguire i passi dettagliati, i prerequisiti (driver Npgsql) e le credenziali in [`05-powerbi/README.md`](05-powerbi/README.md).
4. Testare la Row-Level Security con **View As** usando gli utenti seed descritti in
   [`05-powerbi/security-model.md`](05-powerbi/security-model.md).

## Percorso demo consigliato
- `00-customer-input/`: materiale grezzo ricevuto dal cliente.
- `01-discovery-analysis/`: analisi funzionale e catalogo KPI.
- `02-project-management/`: WBS, backlog, RAID log e issue pronte per GitHub (`02-project-management/issues/`).
- `03-source-system/`: database operativo sorgente (ERP, CRM, e-commerce).
- `04-data-platform/`: data warehouse, pipeline Bronze/Silver/Gold, regole di qualità e audit.
- `05-powerbi/`: modello semantico TMDL (con partition Postgres attive), DAX e specifiche report.
- `06-testing/`: test tecnici, SIT e UAT.
- `.github/`: istruzioni, prompt, agent e skill per Copilot.

> Nota Power BI: il modello semantico è versionato in TMDL/PBIP ed è già collegato via M/PostgreSQL allo schema
> Gold (nessuna configurazione manuale del connettore richiesta oltre alle credenziali). Il report visuale incluso
> è uno shell minimale: le pagine vengono costruite live durante la demo seguendo `05-powerbi/report-specification.md`.

