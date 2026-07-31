# RAID Log

| ID | Tipo | Descrizione | Prob. | Impatto | Mitigazione |
|---|---|---|---|---|---|
| R-01 | Risk | qualità anagrafica cliente insufficiente | Alta | Alto | profiling e regole golden record |
| R-02 | Risk | variazioni schema ERP | Media | Alto | schema contract e test |
| A-01 | Assumption | SKU stabile nel tempo | - | Alto | validare con Product Owner |
| I-01 | Issue | IVA non chiarita | - | Medio | decisione entro sprint 1 |
| D-01 | Dependency | disponibilità accessi DB | - | Alto | richiesta anticipata |
| R-03 | Risk | Power BI Desktop richiede il driver Npgsql per il connettore PostgreSQL nativo: se assente sulla macchina demo il refresh fallisce | Media | Medio | verificare installazione driver prima di ogni demo (vedi 05-powerbi/README.md) |
| D-02 | Dependency | refresh pianificato in Power BI Service richiede On-premises Data Gateway raggiungibile dal DW cliente | - | Alto | ISSUE-104, da chiudere prima del go-live |
