---
title: "[Feature] Misura Days of Cover e pagina Inventory in Power BI"
labels: [enhancement, powerbi, inventory]
milestone: "Release 1"
---

## Business need
`05-powerbi/report-specification.md` (sezione 4 - Inventory) richiede "stock, available, days of cover, slow movers,
warehouse vs store", ma il modello semantico espone oggi solo `Stock Qty` e `Available Qty`. US-05 del backlog
("Come buyer voglio stock e days of cover per categoria") non è quindi soddisfatta end-to-end.

## Acceptance criteria
- [ ] Aggiungere in `Fact Sales.tmdl`/`Fact Inventory.tmdl` le misure `Avg Daily Units Sold` e `Days Of Cover`
      (bozza DAX già presente in `05-powerbi/dax/measures.md`, sezione "Backlog DAX").
- [ ] Aggiungere la distinzione `store_type` (STORE vs WAREHOUSE, già presente in `gold.dim_store`) come slicer
      di pagina per abilitare il confronto warehouse vs store.
- [ ] Definire la soglia "slow mover" (proposta: nessuna vendita negli ultimi 30 giorni) e tradurla in una colonna
      calcolata o misura dedicata.
- [ ] Costruire la pagina "Inventory" nel report seguendo il tema `05-powerbi/theme/retailone-theme.json`.
- [ ] Validare con UAT-04/05 estesi in `06-testing/02-uat-scenarios.md`.

## Data sources
- `gold.fact_inventory`, `gold.dim_product`, `gold.dim_store`.

## Note
Priorità 2 in backlog (US-05); dipende da almeno un ciclo ETL completo con snapshot di stock recenti.
