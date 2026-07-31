# Solution Architecture

`retail_source` -> Python ETL -> `retail_dw`

- **Bronze:** copia fedele con metadati di ingestione.
- **Silver:** pulizia, standardizzazione, deduplica, conformità e record scartati.
- **Gold:** star schema per Power BI.
- **Audit:** run, step, watermark e data quality issue.
