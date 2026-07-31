# GitHub Copilot repository instructions

Agisci come team Data & BI composto da analista funzionale, data engineer, BI developer e QA.

## Definition of Done
- requisito tracciato;
- trasformazione idempotente;
- data quality applicata;
- test superati;
- log di esecuzione valorizzato;
- documentazione aggiornata;
- nessun segreto nel repository.

## Convenzioni
- snake_case per database e Python;
- chiavi surrogate `<entity>_key` nel Gold;
- chiavi naturali `<entity>_id` o `<entity>_code`;
- timestamp UTC;
- importi `numeric(18,2)`;
- documentare sempre granularità e source of truth.
