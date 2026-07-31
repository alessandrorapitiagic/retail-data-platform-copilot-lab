from pathlib import Path
root=Path(__file__).parents[1]
required=[
    'README.md','docker-compose.yml',
    '03-source-system/sql/01_schema.sql','03-source-system/sql/02_seed.sql',
    '04-data-platform/sql/init/02_tables.sql','04-data-platform/sql/init/03_seed_security.sql',
    '04-data-platform/sql/transform/20_silver.sql','04-data-platform/sql/transform/30_gold.sql',
    '05-powerbi/RetailAnalytics.pbip',
    '05-powerbi/RetailAnalytics.SemanticModel/definition/tables/Dim Channel.tmdl',
    '05-powerbi/RetailAnalytics.SemanticModel/definition/tables/SecurityUserStore.tmdl',
]
missing=[x for x in required if not (root/x).exists()]
if missing: raise SystemExit(f'Missing: {missing}')
print(f'OK: {sum(1 for p in root.rglob("*") if p.is_file())} files')
