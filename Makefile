up:
	docker compose up -d --wait
etl:
	python scripts/run_etl.py
test:
	pytest -q
demo: up etl test
	@echo "Demo stack up, ETL eseguito, test superati. Apri 05-powerbi/RetailAnalytics.pbip in Power BI Desktop."
pgadmin:
	docker compose --profile tools up -d --wait pgadmin
	@echo "pgAdmin disponibile su http://localhost:8081 (demo@retailone-demo.local / lab_password)"
psql-source:
	docker compose exec source-db psql -U lab_user -d retail_source
psql-dw:
	docker compose exec dw-db psql -U lab_user -d retail_dw
logs:
	docker compose logs -f
down:
	docker compose down -v
