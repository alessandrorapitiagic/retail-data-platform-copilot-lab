create schema if not exists erp;
create schema if not exists crm;
create schema if not exists ecommerce;

create table erp.store(store_id int primary key, store_code varchar(10) unique, store_name varchar(100), region varchar(50), store_type varchar(20), is_active boolean, opened_date date, closed_date date);
create table erp.product(product_id int primary key, sku varchar(30) unique, product_name varchar(150), category_code varchar(20), category_name varchar(100), brand varchar(80), standard_cost numeric(18,2), is_active boolean, updated_at timestamp);
create table crm.customer(customer_id int primary key, customer_code varchar(30), full_name varchar(150), email varchar(150), vat_number varchar(30), city varchar(80), region varchar(50), segment varchar(30), consent_marketing boolean, created_at timestamp, updated_at timestamp);
create table erp.sales_order(order_id bigint primary key, document_number varchar(30), order_date date, store_id int references erp.store, customer_id int, channel varchar(20), status varchar(20), updated_at timestamp);
create table erp.sales_order_line(order_line_id bigint primary key, order_id bigint references erp.sales_order, product_id int references erp.product, quantity numeric(18,3), unit_price numeric(18,2), discount_amount numeric(18,2), tax_amount numeric(18,2), standard_cost numeric(18,2), original_order_line_id bigint null, updated_at timestamp);
create table erp.inventory_snapshot(snapshot_date date, store_id int references erp.store, product_id int references erp.product, on_hand_qty numeric(18,3), reserved_qty numeric(18,3), updated_at timestamp, primary key(snapshot_date,store_id,product_id));
create table ecommerce.web_order(web_order_id varchar(30) primary key, order_ts timestamp, email varchar(150), sku varchar(30), quantity numeric(18,3), gross_amount numeric(18,2), status varchar(20));
