---
title: "[Data Quality] SLA alerting per esecuzioni ETL oltre le 06:30"
labels: [data-quality, operations, alerting]
milestone: "Release 2"
---

## Rule code
DQ-SLA-001 (nuova regola, da aggiungere a `04-data-platform/operations/data-quality-rules.md`)

## Evidence
FR-010 ("Alert SLA - Run oltre 06:30 evidenziata come violazione") e `06-open-questions.md` punto 5
("Definire canale di notifica per violazioni SLA") sono ancora aperti. `audit.etl_run` registra già
`started_at`/`ended_at`/`status`, quindi il dato per calcolare la violazione SLA esiste, ma:
- non c'è nessun controllo automatico che confronti l'orario di fine run con la soglia delle 06:30;
- non è stato scelto il canale di notifica (Teams webhook? e-mail? issue automatica?).

## Severity
Warning (violazione SLA non blocca il refresh, ma va segnalata al data owner)

## Acceptance criteria
- [ ] Aggiungere in `scripts/run_etl.py` un controllo che confronta `ended_at` con la soglia SLA (parametrizzabile
      via `.env`, default `06:30` ora locale) e logga `DQ-SLA-001` in `audit.data_quality_issue` in caso di violazione.
- [ ] Decidere e documentare il canale di notifica (proposta: webhook Teams via variabile d'ambiente `ALERT_WEBHOOK_URL`,
      nessuna chiamata esterna se non configurata - compatibile con l'ambiente di laboratorio offline).
- [ ] Aggiungere un test in `06-testing/` che verifichi la presenza della regola quando l'ETL supera la soglia
      (simulabile forzando `RECONCILIATION_THRESHOLD` di test o un run_id con `started_at` fittizio).
- [ ] Aggiornare `04-data-platform/operations/runbook.md` con la procedura di escalation.
