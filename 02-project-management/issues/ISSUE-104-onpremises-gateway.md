---
title: "[Feature] On-premises Data Gateway per il refresh pianificato in Power BI Service"
labels: [enhancement, powerbi, go-live, infrastructure]
milestone: "Go-Live"
---

## Business need
Il modello semantico (`05-powerbi/RetailAnalytics.SemanticModel`) si connette a `retail_dw` su Docker locale
(`localhost:5434`). Questo è corretto e sufficiente per la demo/training in Power BI **Desktop**, ma **non è
raggiungibile da Power BI Service** una volta pubblicato: senza un **On-premises Data Gateway** installato sulla
rete del cliente, il refresh pianificato del dataset fallirà con errore di connessione. Questo gap va chiuso prima
del go-live (vedi `07-documentation/03-handover-checklist.md`).

## Acceptance criteria
- [ ] Documentare in `07-documentation/01-technical-design.md` l'architettura di refresh target: gateway
      installato su una macchina con accesso di rete a PostgreSQL (o migrazione del DW su un servizio
      raggiungibile pubblicamente/via VPN, es. Azure Database for PostgreSQL).
- [ ] Definire in `04-data-platform/operations/runbook.md` la cadenza di refresh pianificato coerente con l'SLA
      delle 06:30 (FR-010) e la dipendenza dal completamento con successo dell'ETL (`audit.etl_run.status='SUCCESS'`).
- [ ] Valutare l'uso di un **refresh policy incrementale** per `Fact Sales` quando il volume storico crescerà oltre
      la finestra di demo (oggi il modello è full import, accettabile solo per il dataset di laboratorio).
- [ ] Aggiungere ai criteri di go-live (`07-documentation/03-handover-checklist.md`) la verifica end-to-end del
      refresh pianificato in ambiente cliente, non solo in Power BI Desktop.

## Data sources
- `05-powerbi/RetailAnalytics.SemanticModel/definition/expressions.tmdl` (parametri di connessione).

## Note
Rischio da tracciare anche in `02-project-management/04-raid-log.md` (dipendenza infrastrutturale cliente).
