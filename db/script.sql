drop schema if exists admin;
create schema admin;
use admin;

-- {"session": {"id_company": 1, "id_system": 1, "id_user": 1, "id_table": 1}}

create table tb_company (id serial, data json);
create table tb_system (id serial, data json);
create table tb_table (id serial, data json);
create table tb_field (id serial, data json);


-- tb_company
insert into tb_company (data) values ('{"data": {"id": 0, "name": "Lancioni Cons.", "type": 1, "expire_date": "2020-12-31T00:00:00", "price": "0.00"}}');
-- tb_system
insert into tb_system (data) values ('{"data": {"id": 0, "id_company": 1, "name": "Forms Inc"}}');
-- tb_table
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Company", "name": "tb_company"}}');
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "System", "name": "tb_system"}}');
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Table", "name": "tb_table"}}');
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Field", "name": "tb_field"}}');
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Domain", "name": "tb_domain"}}');
-- tb_field
    -- tb_company
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Name", "name": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Type", "type": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 5, "domain": "tb_company_type"}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Expire Date", "name": "expire_date", "id_type": 4, "size": 0, "mask": "dd/MM/yyyy", "mandatory": 1, "unique": 0, "id_fk": 0, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Price", "name": "price", "id_type": 2, "size": 0, "mask": "1.000,00", "mandatory": 1, "unique": 0, "id_fk": 0, "domain": ""}}');
    -- tb_system
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Company", "name": "id_company", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 1, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Name", "name": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');
    -- tb_table
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "System", "name": "id_system", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 2, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Name", "name": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Url", "name": "url", "id_type": 3, "size": 500, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Table Name", "name": "table", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');
    -- tb_field
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Table", "name": "id_table", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 3, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Label", "name": "label", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Name", "name": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Type", "name": "id_type", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 5, "domain": "tb_field_type"}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Size", "name": "size", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Mask", "name": "mask", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Mandatory", "name": "id_mandatory", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 5, "domain": "tb_bool"}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Unique", "name": "id_unique", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 5, "domain": "tb_bool"}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "FK", "name": "id_fk", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 3, "domain": ""}}');
insert into tb_field (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Domain", "name": "domain", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}');