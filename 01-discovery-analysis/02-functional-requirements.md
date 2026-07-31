# Functional Requirements

| ID | Requisito | Priorità | Acceptance criteria |
|---|---|---|---|
| FR-001 | Acquisire vendite ERP | Must | Tutte le righe modificate dall'ultimo watermark sono nel Bronze |
| FR-002 | Consolidare cliente CRM | Must | E-mail normalizzata o VAT identifica il golden record |
| FR-003 | Calcolare vendite nette | Must | Resi e sconti inclusi secondo formula approvata |
| FR-004 | Creare snapshot stock | Must | Una riga per giorno/prodotto/location |
| FR-005 | Caricare budget versionato | Must | Original e Latest distinguibili |
| FR-006 | Pubblicare star schema | Must | Dimensioni conformi e fatti alla granularità definita |
| FR-007 | Applicare RLS | Must | Utente vede solo regioni/negozi autorizzati |
| FR-008 | Audit ETL | Must | Ogni run registra righe lette, scritte, scartate e stato |
| FR-009 | Drill-through documento | Should | Da KPI a dettaglio documento |
| FR-010 | Alert SLA | Should | Run oltre 06:30 evidenziata come violazione |
| FR-011 | Riconciliare ordini e-commerce (ShopNow) vs ERP | Must | Ogni ordine e-commerce fatturato ha un documento ERP corrispondente entro il ciclo di ingestion; le eccezioni sono loggate come DQ-ECOM-001 |
