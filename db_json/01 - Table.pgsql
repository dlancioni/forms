
-- ALTER ROLE qqbzxiqr IN DATABASE qqbzxiqr SET search_path TO system;

-- -----------------------------------------------------
-- table tb_company
-- -----------------------------------------------------
drop table if exists tb_company cascade;
create table if not exists tb_company (id serial, data jsonb);
insert into tb_company (data) values ('{"name":"lancioni it","expire_date":"2021-01-01","price":1200}');

-- -----------------------------------------------------
-- table tb_system
-- -----------------------------------------------------
drop table if exists tb_system cascade;
create table if not exists tb_system (id serial, data jsonb);
insert into tb_system (data) values ('{"id_company":1,"name":"forms"}');

-- -----------------------------------------------------
-- table tb_table
-- -----------------------------------------------------
drop table if exists tb_table cascade;
create table if not exists tb_table (id serial, data jsonb);
insert into tb_table (data) values ('{"id_company":1,"id_system":1,"name":"company","url":"-","table_name":"tb_company"}');
insert into tb_table (data) values ('{"id_company":1,"id_system":1,"name":"system","url":"-","table_name":"tb_system"}');
insert into tb_table (data) values ('{"id_company":1,"id_system":1,"name":"table","url":"-","table_name":"tb_table"}');
insert into tb_table (data) values ('{"id_company":1,"id_system":1,"name":"field","url":"-","table_name":"tb_field"}');
insert into tb_table (data) values ('{"id_company":1,"id_system":1,"name":"field type","url":"-","table_name":"tb_field_type"}');
insert into tb_table (data) values ('{"id_company":1,"id_system":1,"name":"field event","url":"-","table_name":"tb_field_event"}');
insert into tb_table (data) values ('{"id_company":1,"id_system":1,"name":"report action","url":"-","table_name":"tb_report_action"}');
insert into tb_table (data) values ('{"id_company":1,"id_system":1,"name":"form action","url":"-","table_name":"tb_form_action"}');
insert into tb_table (data) values ('{"id_company":1,"id_system":1,"name":"event","url":"-","table_name":"tb_event"}');

-- -----------------------------------------------------
-- table tb_field
-- -----------------------------------------------------
drop table if exists tb_field cascade;
create table if not exists tb_field (id serial, data jsonb);
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":1,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":1,"label":"Expire Date","name":"expire_date","id_type":4,"size":0,"mask":"dd/mm/yyyy","id_mandatory":1,"id_unique":0,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":1,"label":"Price","name":"price","id_type":2,"size":0,"mask":"1.000,00","id_mandatory":1,"id_unique":0,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":2,"label":"Company","name":"id_company","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":0,"id_fk":1,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":2,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":3,"label":"System","name":"id_system","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":0,"id_fk":2,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":3,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":3,"label":"Link","name":"url","id_type":3,"size":1000,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Table Name","name":"table_name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Table","name":"id_table","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":0,"id_fk":1,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Label","name":"label","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":0,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Type","name":"id_type","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":0,"id_fk":5,"domain":"tb_field_type"}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Size","name":"size","id_type":1,"size":0,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Mask","name":"mask","id_type":3,"size":50,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":0,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Mandatory","name":"id_mandatory","id_type":5,"size":0,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":5,"domain":"tb_bool"}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Unique","name":"id_unique","id_type":5,"size":0,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":5,"domain":"tb_bool"}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Inner Table","name":"id_fk","id_type":1,"size":0,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":4,"domain":""}');
insert into tb_field (data) values ('{"id_company":1,"id_system":1,"id_table":4,"label":"Domain","name":"domain","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');

-- -----------------------------------------------------
-- table tb_field
-- -----------------------------------------------------
drop table if exists tb_domain cascade;
create table if not exists tb_domain (id serial, data jsonb);
insert into tb_domain (data) values ('{"id_company":1,"id_system":1,"id_domain":1,"value":"Sim","domain":"tb_bool"}');
insert into tb_domain (data) values ('{"id_company":1,"id_system":1,"id_domain":0,"value":"Não","domain":"tb_bool"}');
insert into tb_domain (data) values ('{"id_company":1,"id_system":1,"id_domain":1,"value":"Inteiro","domain":"tb_field_type"}');
insert into tb_domain (data) values ('{"id_company":1,"id_system":1,"id_domain":2,"value":"decimal","domain":"tb_field_type"}');
insert into tb_domain (data) values ('{"id_company":1,"id_system":1,"id_domain":3,"value":"String","domain":"tb_field_type"}');
insert into tb_domain (data) values ('{"id_company":1,"id_system":1,"id_domain":4,"value":"Data","domain":"tb_field_type"}');
insert into tb_domain (data) values ('{"id_company":1,"id_system":1,"id_domain":5,"value":"Booleano","domain":"tb_field_type"}');
insert into tb_domain (data) values ('{"id_company":1,"id_system":1,"id_domain":6,"value":"Texto","domain":"tb_field_type"}');