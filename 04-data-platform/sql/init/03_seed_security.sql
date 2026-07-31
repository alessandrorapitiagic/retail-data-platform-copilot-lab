-- Seed data for gold.security_user_store
-- Demo identities used to validate Power BI RLS roles (Store Manager / Area Manager / Executive).
-- These accounts are fictitious and only meaningful inside the training environment.

insert into gold.security_user_store(user_email, role_code, store_code, region) values
('ceo@retailone-demo.local', 'EXECUTIVE', null, null),
('cfo@retailone-demo.local', 'EXECUTIVE', null, null),
('area.manager.lombardia@retailone-demo.local', 'AREA_MANAGER', null, 'Lombardia'),
('area.manager.lazio@retailone-demo.local', 'AREA_MANAGER', null, 'Lazio'),
('store.manager.milano@retailone-demo.local', 'STORE_MANAGER', 'S001', 'Lombardia'),
('store.manager.roma@retailone-demo.local', 'STORE_MANAGER', 'S002', 'Lazio'),
('store.manager.torino@retailone-demo.local', 'STORE_MANAGER', 'S099', 'Piemonte');
