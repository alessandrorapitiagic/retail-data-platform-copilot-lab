create table audit.etl_run(run_id bigserial primary key, pipeline_name varchar(100), started_at timestamptz, ended_at timestamptz, status varchar(20), message text);
create table audit.etl_step(step_id bigserial primary key, run_id bigint references audit.etl_run, step_name varchar(100), rows_read bigint, rows_written bigint, rows_rejected bigint, status varchar(20), started_at timestamptz, ended_at timestamptz);
create table audit.data_quality_issue(issue_id bigserial primary key, run_id bigint, rule_code varchar(50), source_table varchar(100), record_key varchar(200), severity varchar(20), details text, detected_at timestamptz default now());

create table bronze.crm_customer(customer_id int, customer_code varchar(30), full_name varchar(150), email varchar(150), vat_number varchar(30), city varchar(80), region varchar(50), segment varchar(30), consent_marketing boolean, created_at timestamp, updated_at timestamp, _ingested_at timestamptz, _run_id bigint);
create table bronze.erp_store(store_id int, store_code varchar(10), store_name varchar(100), region varchar(50), store_type varchar(20), is_active boolean, opened_date date, closed_date date, _ingested_at timestamptz, _run_id bigint);
create table bronze.erp_product(product_id int, sku varchar(30), product_name varchar(150), category_code varchar(20), category_name varchar(100), brand varchar(80), standard_cost numeric(18,2), is_active boolean, updated_at timestamp, _ingested_at timestamptz, _run_id bigint);
create table bronze.erp_sales_order(order_id bigint, document_number varchar(30), order_date date, store_id int, customer_id int, channel varchar(20), status varchar(20), updated_at timestamp, _ingested_at timestamptz, _run_id bigint);
create table bronze.erp_sales_order_line(order_line_id bigint, order_id bigint, product_id int, quantity numeric(18,3), unit_price numeric(18,2), discount_amount numeric(18,2), tax_amount numeric(18,2), standard_cost numeric(18,2), original_order_line_id bigint, updated_at timestamp, _ingested_at timestamptz, _run_id bigint);
create table bronze.erp_inventory_snapshot(snapshot_date date, store_id int, product_id int, on_hand_qty numeric(18,3), reserved_qty numeric(18,3), updated_at timestamp, _ingested_at timestamptz, _run_id bigint);
create table bronze.budget(year int, month int, scenario varchar(20), store_code varchar(10), category_code varchar(20), budget_amount numeric(18,2), _ingested_at timestamptz, _run_id bigint);
create table bronze.ecommerce_web_order(web_order_id varchar(30), order_ts timestamp, email varchar(150), sku varchar(30), quantity numeric(18,3), gross_amount numeric(18,2), status varchar(20), _ingested_at timestamptz, _run_id bigint);

create table silver.customer_conformed(customer_bk varchar(200) primary key, source_customer_id int, customer_code varchar(30), full_name varchar(150), normalized_email varchar(150), vat_number varchar(30), city varchar(80), region varchar(50), segment varchar(30), consent_marketing boolean, is_valid boolean, _run_id bigint);
create table silver.store_conformed(store_id int primary key, store_code varchar(10), store_name varchar(100), region varchar(50), store_type varchar(20), is_active boolean, _run_id bigint);
create table silver.product_conformed(product_id int primary key, sku varchar(30), product_name varchar(150), category_code varchar(20), category_name varchar(100), brand varchar(80), standard_cost numeric(18,2), is_valid boolean, _run_id bigint);
create table silver.sales_line(order_line_id bigint primary key, order_id bigint, document_number varchar(30), order_date date, store_id int, product_id int, customer_bk varchar(200), channel varchar(20), quantity numeric(18,3), gross_amount numeric(18,2), discount_amount numeric(18,2), net_amount numeric(18,2), cost_amount numeric(18,2), margin_amount numeric(18,2), _run_id bigint);
create table silver.inventory_snapshot(snapshot_date date, store_id int, product_id int, on_hand_qty numeric(18,3), reserved_qty numeric(18,3), available_qty numeric(18,3), _run_id bigint, primary key(snapshot_date,store_id,product_id));
create table silver.budget(year int, month int, scenario varchar(20), store_code varchar(10), category_code varchar(20), budget_amount numeric(18,2), _run_id bigint, primary key(year,month,scenario,store_code,category_code));
create table silver.ecommerce_reconciliation(web_order_id varchar(30) primary key, order_ts timestamp, email varchar(150), sku varchar(30), gross_amount numeric(18,2), status varchar(20), matched_document_number varchar(30), is_matched boolean, _run_id bigint);

create table gold.dim_date(date_key int primary key, full_date date unique, year int, quarter int, month_number int, month_name varchar(20), year_month varchar(7), week_number int, day_of_week int, day_name varchar(20));
create table gold.dim_store(store_key bigserial primary key, store_id int unique, store_code varchar(10), store_name varchar(100), region varchar(50), store_type varchar(20), is_active boolean);
create table gold.dim_product(product_key bigserial primary key, product_id int unique, sku varchar(30), product_name varchar(150), category_code varchar(20), category_name varchar(100), brand varchar(80));
create table gold.dim_customer(customer_key bigserial primary key, customer_bk varchar(200) unique, customer_code varchar(30), full_name varchar(150), email varchar(150), city varchar(80), region varchar(50), segment varchar(30), consent_marketing boolean);
create table gold.dim_channel(channel_key serial primary key, channel_code varchar(20) unique, channel_name varchar(50));
create table gold.fact_sales(order_line_id bigint primary key, order_id bigint, document_number varchar(30), date_key int references gold.dim_date, store_key bigint references gold.dim_store, product_key bigint references gold.dim_product, customer_key bigint references gold.dim_customer, channel_key int references gold.dim_channel, quantity numeric(18,3), gross_amount numeric(18,2), discount_amount numeric(18,2), net_amount numeric(18,2), cost_amount numeric(18,2), margin_amount numeric(18,2));
create table gold.fact_inventory(date_key int references gold.dim_date, store_key bigint references gold.dim_store, product_key bigint references gold.dim_product, on_hand_qty numeric(18,3), reserved_qty numeric(18,3), available_qty numeric(18,3), primary key(date_key,store_key,product_key));
create table gold.fact_budget(date_key int references gold.dim_date, store_key bigint references gold.dim_store, category_code varchar(20), scenario varchar(20), budget_amount numeric(18,2), primary key(date_key,store_key,category_code,scenario));

-- Row-level security mapping used by the Power BI semantic model (see 05-powerbi/security-model.md).
-- role_code: EXECUTIVE (full access, store_code/region null) | AREA_MANAGER (region scoped, store_code null) | STORE_MANAGER (single store scoped)
create table gold.security_user_store(
	security_user_store_id bigserial primary key,
	user_email varchar(150) not null,
	role_code varchar(20) not null check (role_code in ('EXECUTIVE','AREA_MANAGER','STORE_MANAGER')),
	store_code varchar(10) null,
	region varchar(50) null,
	unique (user_email, role_code, store_code, region)
);
