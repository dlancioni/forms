-- -----------------------------------------------------
-- Set default schema
-- -----------------------------------------------------
ALTER ROLE qqbzxiqr IN DATABASE qqbzxiqr SET search_path TO system;

-- -----------------------------------------------------
-- table tb_system
-- -----------------------------------------------------
drop table if exists tb_system cascade;
create table if not exists tb_system (id serial, session jsonb, field jsonb);
insert into tb_system (field) values ('{"id":1,"name":"forms","expire_date":"31/12/2020","price":"100.00"}');
update tb_system set session = '{"id_system":1,"id_table":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_table
-- -----------------------------------------------------
drop table if exists tb_table cascade;
create table if not exists tb_table (id serial, session jsonb, field jsonb);
insert into tb_table (field) values ('{"id":1,"id_system":1,"name":"system","url":"index.php?id_layout=1&id_table=1&page_offset=0","table_name":"tb_system"}');
insert into tb_table (field) values ('{"id":2,"id_system":1,"name":"table","url":"index.php?id_layout=1&id_table=2&page_offset=0","table_name":"tb_table"}');
insert into tb_table (field) values ('{"id":3,"id_system":1,"name":"field","url":"index.php?id_layout=1&id_table=3&page_offset=0","table_name":"tb_field"}');
insert into tb_table (field) values ('{"id":4,"id_system":1,"name":"domain","url":"index.php?id_layout=4&id_table=1&page_offset=0","table_name":"tb_domain"}');
update tb_table set session = '{"id_system":1,"id_table":2,"id_action":1}';

-- -----------------------------------------------------
-- table tb_field
-- -----------------------------------------------------
drop table if exists tb_field cascade;
create table if not exists tb_field (id serial, session jsonb, field jsonb);
insert into tb_field (field) values ('{"id":1,"id_system":1,"id_table":1,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":2,"id_system":1,"id_table":1,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":3,"id_system":1,"id_table":1,"label":"Expire Date","name":"expire_date","id_type":4,"size":0,"mask":"dd/mm/yyyy","id_mandatory":1,"id_unique":0,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":4,"id_system":1,"id_table":1,"label":"Price","name":"price","id_type":2,"size":0,"mask":"1.000,00","id_mandatory":1,"id_unique":0,"id_fk":0,"domain":""}');

insert into tb_field (field) values ('{"id":5,"id_system":1,"id_table":2,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":6,"id_system":1,"id_table":2,"label":"System","name":"id_system","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":0,"id_fk":1,"domain":""}');
insert into tb_field (field) values ('{"id":7,"id_system":1,"id_table":2,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":8,"id_system":1,"id_table":2,"label":"Link","name":"url","id_type":3,"size":1000,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":9,"id_system":1,"id_table":2,"label":"Table Name","name":"table_name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');

insert into tb_field (field) values ('{"id":10,"id_system":1,"id_table":3,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":11,"id_system":1,"id_table":3,"label":"Table","name":"id_table","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":0,"id_fk":2,"domain":""}');
insert into tb_field (field) values ('{"id":12,"id_system":1,"id_table":3,"label":"Label","name":"label","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":0,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":13,"id_system":1,"id_table":3,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":14,"id_system":1,"id_table":3,"label":"Type","name":"id_type","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":0,"id_fk":4,"domain":"tb_field_type"}');
insert into tb_field (field) values ('{"id":15,"id_system":1,"id_table":3,"label":"Size","name":"size","id_type":1,"size":0,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":16,"id_system":1,"id_table":3,"label":"Mask","name":"mask","id_type":3,"size":50,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":17,"id_system":1,"id_table":3,"label":"Mandatory","name":"id_mandatory","id_type":5,"size":0,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":4,"domain":"tb_bool"}');
insert into tb_field (field) values ('{"id":18,"id_system":1,"id_table":3,"label":"Unique","name":"id_unique","id_type":5,"size":0,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":4,"domain":"tb_bool"}');
insert into tb_field (field) values ('{"id":19,"id_system":1,"id_table":3,"label":"Fk","name":"id_fk","id_type":1,"size":0,"mask":"","id_mandatory":0,"id_unique":0,"id_fk":2,"domain":""}');
insert into tb_field (field) values ('{"id":20,"id_system":1,"id_table":3,"label":"Domain","name":"domain","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');

insert into tb_field (field) values ('{"id":21,"id_system":1,"id_table":4,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":22,"id_system":1,"id_table":4,"label":"Id Domain","name":"id_domain","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":23,"id_system":1,"id_table":4,"label":"Value","name":"value","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":24,"id_system":1,"id_table":4,"label":"Domain","name":"domain","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');

update tb_field set session = '{"id_system":1,"id_table":1,"id_action":3}';



-- -----------------------------------------------------
-- table tb_domain
-- -----------------------------------------------------
drop table if exists tb_domain cascade;
create table if not exists tb_domain (id serial, session jsonb, field jsonb);
insert into tb_domain (field) values ('{"id":1,"id_system":1,"id_domain":1,"value":"Sim","domain":"tb_bool"}');
insert into tb_domain (field) values ('{"id":2,"id_system":1,"id_domain":0,"value":"Não","domain":"tb_bool"}');
insert into tb_domain (field) values ('{"id":3,"id_system":1,"id_domain":1,"value":"Inteiro","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":4,"id_system":1,"id_domain":2,"value":"decimal","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":5,"id_system":1,"id_domain":3,"value":"String","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":6,"id_system":1,"id_domain":4,"value":"field","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":7,"id_system":1,"id_domain":5,"value":"Booleano","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":8,"id_system":1,"id_domain":6,"value":"Texto","domain":"tb_field_type"}');
update tb_domain set session = '{"id_system":1,"id_table":4,"id_action":1}'