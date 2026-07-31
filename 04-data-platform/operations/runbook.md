# Operations Runbook

1. Verificare disponibilità source e DW (`docker compose ps`, entrambi i container in stato `healthy`).
2. Eseguire `python scripts/run_etl.py`.
3. Controllare `audit.etl_run` e `audit.etl_step`; in caso di `status='FAILED'` leggere `message` per la causa
   (es. blocco DQ-SALES-001) e non procedere al refresh Power BI.
4. Consultare `audit.data_quality_issue` per il run corrente e condividerlo con i data owner (regole in
   `04-data-platform/operations/data-quality-rules.md`).
5. Eseguire `pytest -q`.
6. Verificare quadratura Net Sales source vs Gold (automatica nel gate DQ-SALES-001, ripetuta in CI da `pytest`).
7. Aggiornare Power BI solo dopo esito positivo di ETL e test (Home > Refresh in Power BI Desktop, o refresh
   pianificato via gateway in Power BI Service).
