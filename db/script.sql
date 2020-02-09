
-- {"session": {"id_company": 1, "id_system": 1, "id_user": 1, "id_table": 1}}

create table tb_company (id serial, data json);
create table tb_system (id serial, data json);
create table tb_table (id serial, data json);


-- tb_company
insert into tb_company (data) values ('{"data": {"id": 0, "name": "Lancioni Cons.", "type": 1, "expire_date": "2020-12-31T00:00:00", "price": "0.00"}}');
-- tb_system
insert into tb_system (data) values ('{"data": {"id": 0, "id_company": 1, "name": "Forms Inc"}}');
-- tb_table
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Company", "name": "tb_company"}}');
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "System", "name": "tb_system"}}');
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Table", "name": "tb_table"}}');
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Field", "name": "tb_field"}}');
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Field", "name": "tb_field_type"}}');
insert into tb_table (data) values ('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Field", "name": "tb_field_event"}}');