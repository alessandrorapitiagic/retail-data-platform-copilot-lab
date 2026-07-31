# Work Breakdown Structure

| WBS | Deliverable/Task | Dipendenza | Owner | Effort gg |
|---|---|---|---|---:|
| 1 | Discovery e requisiti | - | Functional Analyst | 8 |
| 1.1 | Interviste stakeholder | - | FA | 3 |
| 1.2 | KPI catalog e acceptance | 1.1 | FA | 3 |
| 1.3 | Scope e sign-off | 1.2 | PM | 2 |
| 2 | Architettura e data design | 1 | Data Architect | 8 |
| 2.1 | Source assessment | 1.2 | Data Engineer | 2 |
| 2.2 | Bronze/Silver/Gold | 2.1 | Data Architect | 3 |
| 2.3 | Semantic model | 2.2 | BI Developer | 3 |
| 3 | Build data platform | 2 | Data Engineer | 20 |
| 3.1 | Source DB e seed | 2.1 | DE | 3 |
| 3.2 | Bronze ingestion | 3.1 | DE | 4 |
| 3.3 | Silver quality/conformance | 3.2 | DE | 6 |
| 3.4 | Gold star schema | 3.3 | DE | 5 |
| 3.5 | Audit e orchestration | 3.2 | DE | 2 |
| 4 | Power BI | 2.3,3.4 | BI Developer | 14 |
| 4.1 | TMDL semantic model | 3.4 | BI | 5 |
| 4.2 | DAX e RLS | 4.1 | BI | 4 |
| 4.3 | Report pages | 4.2 | BI | 5 |
| 5 | Test e release | 3,4 | QA/Business | 12 |
| 5.1 | SIT e reconciliation | 3.4 | QA | 4 |
| 5.2 | UAT | 4.3,5.1 | Business | 4 |
| 5.3 | Go-live e handover | 5.2 | Team | 4 |
