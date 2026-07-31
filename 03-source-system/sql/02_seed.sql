insert into erp.store values
(1,'S001','Milano Duomo','Lombardia','STORE',true,'2018-01-10',null),
(2,'S002','Roma Centro','Lazio','STORE',true,'2019-03-15',null),
(3,'WH01','Deposito Centrale','Lombardia','WAREHOUSE',true,'2017-01-01',null),
(4,'S099','Torino Vecchio','Piemonte','STORE',false,'2016-01-01','2024-12-31');

insert into erp.product values
(101,'SKU-001','Sneaker Alpha','CAT01','Calzature','NorthWind',40,true,now()),
(102,'SKU-002','T-shirt Basic','CAT02','Abbigliamento','NorthWind',8,true,now()),
(103,'SKU-003','Zaino Urban','CAT03','Accessori','CityLab',22,true,now()),
(104,'SKU-004','Prodotto senza categoria',null,null,'Unknown',15,true,now());

insert into crm.customer values
(1001,'C001','Anna Verdi','anna.verdi@example.com','IT001','Milano','Lombardia','LOYAL',true,'2024-01-01',now()),
(1002,'C002','Anna Verdi Dup',' ANNA.VERDI@example.com ','IT001','Milano','Lombardia','STANDARD',true,'2024-06-01',now()),
(1003,'C003','Luca Neri','luca.neri@example.com',null,'Roma','Lazio','STANDARD',false,'2025-05-10',now()),
(1004,'C004','Cliente incompleto',null,null,null,null,null,false,'2026-01-01',now());

insert into erp.sales_order values
(5001,'INV-2026-0001','2026-01-05',1,1001,'STORE','COMPLETED',now()),
(5002,'INV-2026-0002','2026-01-05',2,1003,'STORE','COMPLETED',now()),
(5003,'WEB-2026-0001','2026-01-06',1,1002,'ONLINE','COMPLETED',now()),
(5004,'RET-2026-0001','2026-01-08',1,1001,'STORE','RETURNED',now());

insert into erp.sales_order_line values
(9001,5001,101,2,100,10,39.6,40,null,now()),
(9002,5001,102,3,25,5,15.4,8,null,now()),
(9003,5002,103,1,80,0,17.6,22,null,now()),
(9004,5003,101,1,110,10,22,40,null,now()),
(9005,5004,101,-1,100,0,-22,40,9001,now());

insert into erp.inventory_snapshot values
('2026-01-08',1,101,12,2,now()),('2026-01-08',1,102,40,5,now()),('2026-01-08',2,103,8,1,now()),('2026-01-08',3,101,100,20,now()),
-- over-allocated reservation: available_qty risulterà negativo -> DQ-STOCK-001
('2026-01-08',2,101,3,5,now());

-- ShopNow (piattaforma e-commerce) export grezzo utilizzato per la riconciliazione pre-fatturazione.
-- WEB-2026-0001 è già stato fatturato e trasferito in ERP (INV/WEB-2026-0001 sopra) -> riconciliato.
-- WEB-2026-0002 è ancora PENDING lato e-commerce, non presente in ERP -> atteso, non è un'anomalia.
-- WEB-2026-0003 è stato marcato INVOICED sulla piattaforma ma non è mai arrivato in ERP: anomalia di integrazione -> DQ-ECOM-001.
insert into ecommerce.web_order values
('WEB-2026-0001','2026-01-06 10:00','anna.verdi@example.com','SKU-001',1,100,'INVOICED'),
('WEB-2026-0002','2026-01-07 12:00','unknown@example.com','SKU-999',1,50,'PENDING'),
('WEB-2026-0003','2026-01-07 15:30','luca.neri@example.com','SKU-003',2,160,'INVOICED');
