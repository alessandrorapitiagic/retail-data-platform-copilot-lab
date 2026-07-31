truncate gold.fact_sales, gold.fact_inventory, gold.fact_budget restart identity;
truncate gold.dim_store, gold.dim_product, gold.dim_customer, gold.dim_channel restart identity cascade;

insert into gold.dim_date
select to_char(d,'YYYYMMDD')::int,d,extract(year from d)::int,extract(quarter from d)::int,extract(month from d)::int,to_char(d,'FMMonth'),to_char(d,'YYYY-MM'),extract(week from d)::int,extract(isodow from d)::int,to_char(d,'FMDay')
from generate_series('2021-01-01'::date,'2027-12-31'::date,'1 day') d
on conflict do nothing;
insert into gold.dim_store(store_id,store_code,store_name,region,store_type,is_active) select store_id,store_code,store_name,region,store_type,is_active from silver.store_conformed;
insert into gold.dim_product(product_id,sku,product_name,category_code,category_name,brand) select product_id,sku,product_name,category_code,category_name,brand from silver.product_conformed where is_valid;
insert into gold.dim_customer(customer_bk,customer_code,full_name,email,city,region,segment,consent_marketing) select customer_bk,customer_code,full_name,normalized_email,city,region,segment,consent_marketing from silver.customer_conformed;
insert into gold.dim_channel(channel_code,channel_name) values('STORE','Negozio'),('ONLINE','E-commerce') on conflict do nothing;
insert into gold.fact_sales
select s.order_line_id,s.order_id,s.document_number,to_char(s.order_date,'YYYYMMDD')::int,st.store_key,p.product_key,c.customer_key,ch.channel_key,s.quantity,s.gross_amount,s.discount_amount,s.net_amount,s.cost_amount,s.margin_amount
from silver.sales_line s join gold.dim_store st on st.store_id=s.store_id join gold.dim_product p on p.product_id=s.product_id left join gold.dim_customer c on c.customer_bk=s.customer_bk join gold.dim_channel ch on ch.channel_code=s.channel;
insert into gold.fact_inventory
select to_char(i.snapshot_date,'YYYYMMDD')::int,s.store_key,p.product_key,i.on_hand_qty,i.reserved_qty,i.available_qty from silver.inventory_snapshot i join gold.dim_store s on s.store_id=i.store_id join gold.dim_product p on p.product_id=i.product_id;
insert into gold.fact_budget
select (b.year*10000+b.month*100+1),s.store_key,b.category_code,b.scenario,b.budget_amount from silver.budget b join gold.dim_store s on s.store_code=b.store_code;
