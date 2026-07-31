# Requirements Traceability Matrix

| Requirement | Design | Implementation | Test |
|---|---|---|---|
| FR-001 | 02-source-to-target.md | scripts/run_etl.py (copy_table) | test_reconciliation.py::test_sales_reconciliation |
| FR-002 | 03-transformation-rules.md | sql/transform/20_silver.sql (silver.customer_conformed) | test_data_quality.py |
| FR-003 | 03-transformation-rules.md | sql/transform/20_silver.sql (silver.sales_line) | test_data_quality.py::test_margin_formula |
| FR-004 | 02-source-to-target.md | sql/transform/20_silver.sql (silver.inventory_snapshot) | test_data_quality.py |
| FR-005 | 02-source-to-target.md | sql/init/02_tables.sql (bronze.budget / silver.budget) | *gap: nessun test di versioning, vedi 06-open-questions.md #6* |
| FR-006 | 04-gold-star-schema.md | sql/transform/30_gold.sql | test_data_quality.py::test_no_orphan_product / test_no_orphan_store |
| FR-007 | 05-powerbi/security-model.md | RetailAnalytics.SemanticModel/definition/roles/*.tmdl | 06-testing/02-uat-scenarios.md (UAT-SEC-01..03) |
| FR-008 | 05-audit-logging.md | scripts/run_etl.py (audit.etl_run / audit.etl_step) | test_data_quality.py |
| FR-011 | 02-source-to-target.md | sql/transform/20_silver.sql (silver.ecommerce_reconciliation) | test_reconciliation.py::test_ecommerce_reconciliation |
