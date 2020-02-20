-- -----------------------------------------------------
-- delete data all tables
-- -----------------------------------------------------
delete from tb_domain;
delete from tb_field;
delete from tb_table;
delete from tb_system;
delete from tb_company;

-- -----------------------------------------------------
-- data for table tb_company
-- -----------------------------------------------------
insert into tb_company (name, expire_date, price) values ('lancioni it', '2021-01-01', 1200.0);

-- -----------------------------------------------------
-- data for table tb_system
-- -----------------------------------------------------
insert into tb_system (id_company, name) values (1, 'forms');

-- -----------------------------------------------------
-- data for table tb_table
-- -----------------------------------------------------
insert into tb_table (id_company, id_system, name, url, table_name) values (1, 1, 'company', '-', 'tb_company');
insert into tb_table (id_company, id_system, name, url, table_name) values (1, 1, 'system', '-', 'tb_system');
insert into tb_table (id_company, id_system, name, url, table_name) values (1, 1, 'table', '-', 'tb_table');
insert into tb_table (id_company, id_system, name, url, table_name) values (1, 1, 'field', '-', 'tb_field');
insert into tb_table (id_company, id_system, name, url, table_name) values (1, 1, 'field type', '-', 'tb_field_type');
insert into tb_table (id_company, id_system, name, url, table_name) values (1, 1, 'field event', '-', 'tb_field_event');
insert into tb_table (id_company, id_system, name, url, table_name) values (1, 1, 'report action', '-', 'tb_report_action');
insert into tb_table (id_company, id_system, name, url, table_name) values (1, 1, 'form action', '-', 'tb_form_action');
insert into tb_table (id_company, id_system, name, url, table_name) values (1, 1, 'event', '-', 'tb_event');

-- -----------------------------------------------------
-- data for table tb_field
-- -----------------------------------------------------
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 1, 'Name', 'name', 3, 50, 'null', 1, 1, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 1, 'Expire Date', 'expire_date', 4, 0, 'dd/mm/yyyy', 1, 0, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 1, 'Price', 'price', 2, 0, '1.000,00', 1, 0, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 3, 'Company', 'id_company', 1, 0, 'null', 1, 0, 1, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 2, 'Name', 'name', 3, 50, 'null', 1, 1, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 3, 'System', 'id_system', 1, 0, 'null', 1, 0, 1, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 3, 'Name', 'name', 3, 50, 'null', 1, 1, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 3, 'Link', 'url', 3, 1000, 'null', 1, 1, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Table Name', 'table_name', 3, 50, 'null', 1, 1, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Table', 'id_table', 1, 0, 'null', 1, 0, 1, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Label', 'label', 3, 50, 'null', 1, 0, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Name', 'name', 3, 50, 'null', 1, 1, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Type', 'id_type', 1, 0, 'null', 1, 0, 5, 'tb_field_type');
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Size', 'size', 1, 0, 'null', 0, 0, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Mask', 'mask', 3, 50, 'null', 0, 0, 0, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Mandatory', 'id_mandatory', 5, 0, 'null', 0, 0, 5, 'tb_bool');
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Unique', 'id_unique', 5, 0, 'null', 0, 0, 5, 'tb_bool');
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Inner Table', 'id_fk', 1, 0, 'null', 0, 0, 4, null);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk, domain) values (1, 1, 4, 'Domain', 'domain', 3, 50, 'null', 1, 1, 0, null);

-- -----------------------------------------------------
-- data for table tb_domain
-- -----------------------------------------------------
insert into tb_domain (id_company, id_system, id_domain, value, domain) values (1, 1, 1, 'Sim', 'tb_bool');
insert into tb_domain (id_company, id_system, id_domain, value, domain) values (1, 1, 0, 'Não', 'tb_bool');
insert into tb_domain (id_company, id_system, id_domain, value, domain) values (1, 1, 1, 'Inteiro', 'tb_field_type');
insert into tb_domain (id_company, id_system, id_domain, value, domain) values (1, 1, 2, 'decimal', 'tb_field_type');
insert into tb_domain (id_company, id_system, id_domain, value, domain) values (1, 1, 3, 'String', 'tb_field_type');
insert into tb_domain (id_company, id_system, id_domain, value, domain) values (1, 1, 4, 'Data', 'tb_field_type');
insert into tb_domain (id_company, id_system, id_domain, value, domain) values (1, 1, 5, 'Booleano', 'tb_field_type');
insert into tb_domain (id_company, id_system, id_domain, value, domain) values (1, 1, 6, 'Texto', 'tb_field_type');
