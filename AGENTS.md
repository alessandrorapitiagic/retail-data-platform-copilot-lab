# Agent Instructions

Questo repository rappresenta un progetto Data & Analytics regolamentato.

- Non inventare campi, KPI o regole di business: segnala le assunzioni.
- Prima di modificare SQL, verifica il data dictionary e il source-to-target mapping.
- Le trasformazioni devono rispettare Bronze -> Silver -> Gold.
- Ogni trasformazione deve avere test di qualità, riconciliazione e logging.
- Non eseguire DROP/TRUNCATE su ambienti non locali.
- SQL target: PostgreSQL 16.
- DAX: usare misure esplicite, naming leggibile e cartelle di visualizzazione.
- La documentazione deve essere aggiornata insieme al codice.
