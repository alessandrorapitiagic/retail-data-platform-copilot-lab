# Technical Design Document

La soluzione usa due database PostgreSQL separati. Il source simula sistemi operativi; il DW implementa Medallion Architecture. L'ETL Python effettua full load didattico, mentre la roadmap prevede watermark incrementale. Il modello Power BI consuma esclusivamente Gold.
