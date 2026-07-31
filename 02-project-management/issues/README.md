# Issue Backlog (bozze pronte per GitHub Issues)

Questa cartella contiene bozze di issue in formato Markdown, pronte per essere create su GitHub
(manualmente o con `gh issue create -F <file>`) una volta che il repository viene pubblicato con un remote.
Il repository di laboratorio non è ancora collegato a un remote Git: fino a quel momento queste bozze
fungono da backlog tecnico versionato, coerenti con i template in `.github/ISSUE_TEMPLATE/`.

| ID | Titolo | Collegata a |
|---|---|---|
| [ISSUE-101](ISSUE-101-budget-versioning.md) | Versioning storico del budget (Original vs Latest) | FR-005, US-03 |
| [ISSUE-102](ISSUE-102-days-of-cover.md) | Misura Days of Cover e pagina Inventory | US-05 |
| [ISSUE-103](ISSUE-103-sla-alerting.md) | SLA alerting per esecuzioni ETL oltre le 06:30 | FR-010 |
| [ISSUE-104](ISSUE-104-onpremises-gateway.md) | On-premises Data Gateway per refresh pianificato | Go-Live |

## Come promuoverle a issue reali
```bash
gh issue create --title "<primo H1 del file>" --body-file 02-project-management/issues/ISSUE-101-budget-versioning.md --label enhancement
```
