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
-- data for table tb_field_type
-- -----------------------------------------------------
-- insert into tb_field_type (name) values ('integer');
-- insert into tb_field_type (name) values ('decimal');
-- insert into tb_field_type (name) values ('string');
-- insert into tb_field_type (name) values ('date');
-- insert into tb_field_type (name) values ('boolean');
-- insert into tb_field_type (name) values ('text()');

-- -----------------------------------------------------
-- data for table tb_field
-- -----------------------------------------------------
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 1, 'Name', 'name', 3, 50, 'null', 1, 1, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 1, 'Expire Date', 'expire_date', 4, 0, 'dd/mm/yyyy', 1, 0, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 1, 'Price', 'price', 2, 0, '1.000,00', 1, 0, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 3, 'Company', 'id_company', 1, 0, 'null', 1, 0, 1);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 2, 'Name', 'name', 3, 50, 'null', 1, 1, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 3, 'System', 'id_system', 1, 0, 'null', 1, 0, 1);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 3, 'Name', 'name', 3, 50, 'null', 1, 1, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 3, 'Link', 'url', 3, 1000, 'null', 1, 1, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Table Name', 'table_name', 3, 50, 'null', 1, 1, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Table', 'id_table', 1, 0, 'null', 1, 0, 1);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Label', 'label', 3, 50, 'null', 1, 0, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Name', 'name', 3, 50, 'null', 1, 1, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Type', 'id_type', 1, 0, 'null', 1, 0, 4);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Size', 'size', 1, 0, 'null', 0, 0, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Mask', 'mask', 3, 50, 'null', 0, 0, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Mandatory', 'id_mandatory', 5, 0, 'null', 0, 0, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Unique', 'id_unique', 5, 0, 'null', 0, 0, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 4, 'Inner Table', 'id_fk', 1, 0, 'null', 0, 0, 0);
insert into tb_field (id_company, id_system, id_table, label, name, id_type, size, mask, id_mandatory, id_unique, id_fk) values (1, 1, 5, 'Name', 'name', 3, 50, 'null', 1, 1, 0);