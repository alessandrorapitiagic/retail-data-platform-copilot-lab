---
title: "[Feature] Versioning storico del budget (Original vs Latest)"
labels: [enhancement, data-platform, controlling]
milestone: "Release 2"
---

## Business need
FR-005 richiede di distinguere versioni di budget "Original" vs "Latest" per confrontare la revisione approvata
a inizio anno con l'ultima forecast condivisa da Controlling. Lo schema attuale (`silver.budget` / `gold.fact_budget`)
gestisce lo `scenario` come stringa nominale (es. `BUDGET`, `LATEST`) ma sovrascrive ad ogni caricamento: non esiste
storicizzazione delle revisioni, quindi non è possibile rispondere a "quanto era il budget originale di gennaio prima
della revisione di marzo?" (vedi `01-discovery-analysis/06-open-questions.md`, punto 7).

## Acceptance criteria
- [ ] `bronze.budget` e `silver.budget` conservano una colonna `version_label`/`loaded_at` per ogni caricamento, senza
      sovrascrivere le versioni precedenti (append-only, non più `TRUNCATE` prima del load).
- [ ] `gold.fact_budget` espone l'ultima versione per scenario come vista/misura di default, ma lo storico resta
      interrogabile per audit.
- [ ] Aggiornare `04-data-platform/architecture/03-transformation-rules.md` e `04-gold-star-schema.md` con la nuova regola.
- [ ] Aggiungere un test di regressione in `06-testing/` che verifichi la non sovrascrittura delle versioni storiche.
- [ ] Aggiornare la misura `Budget Variance` in Power BI per permettere lo slicing per versione.

## Data sources
- `00-customer-input/05-sample-budget.csv` (estratto Controlling, oggi caricato "a sostituzione").
- `04-data-platform/sql/init/02_tables.sql` (bronze.budget, silver.budget, gold.fact_budget).

## Note
Collegato a backlog US-05 (buyer: stock e days of cover) e US-03 (store manager: actual vs budget).
