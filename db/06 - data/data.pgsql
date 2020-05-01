-- -----------------------------------------------------
-- Set default schema
-- -----------------------------------------------------
ALTER ROLE qqbzxiqr IN DATABASE qqbzxiqr SET search_path TO system;

-- -----------------------------------------------------
-- table tb_system
-- -----------------------------------------------------
delete from tb_system;
insert into tb_system (field) values ('{"id":1,"name":"forms","expire_date":"31/12/2020","price":"100.00"}');
update tb_system set session = '{"id_system":1,"id_table":1,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_table
-- -----------------------------------------------------
delete from tb_table;
insert into tb_table (session, field) values ('{"id_system":1,"id_table":2,"id_user":1,"id_action":1}','{"id":1,"id_system":1,"name":"system","caption":"System","table_name":"tb_system"}');
insert into tb_table (session, field) values ('{"id_system":1,"id_table":2,"id_user":1,"id_action":1}','{"id":2,"id_system":1,"name":"table","caption":"Table","table_name":"tb_table"}');
insert into tb_table (session, field) values ('{"id_system":1,"id_table":2,"id_user":1,"id_action":1}','{"id":3,"id_system":1,"name":"field","caption":"Field","table_name":"tb_field"}');
insert into tb_table (session, field) values ('{"id_system":1,"id_table":2,"id_user":1,"id_action":1}','{"id":4,"id_system":1,"name":"domain","caption":"Domain","table_name":"tb_domain"}');
insert into tb_table (session, field) values ('{"id_system":1,"id_table":2,"id_user":1,"id_action":1}','{"id":5,"id_system":1,"name":"Event","caption":"Event", "table_name":"tb_event"}');
insert into tb_table (session, field) values ('{"id_system":1,"id_table":2,"id_user":1,"id_action":1}','{"id":6,"id_system":1,"name":"Code","caption":"Code","table_name":"tb_code"}');

-- -----------------------------------------------------
-- table tb_field
-- -----------------------------------------------------
delete from tb_field;
-- tb_system
insert into tb_field (field) values ('{"id":1,"id_system":1,"id_table":1,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":2,"id_system":1,"id_table":1,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":3,"id_system":1,"id_table":1,"label":"Expire Date","name":"expire_date","id_type":4,"size":0,"mask":"dd/mm/yyyy","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":4,"id_system":1,"id_table":1,"label":"Price","name":"price","id_type":2,"size":0,"mask":"1.000,00","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
-- tb_table
insert into tb_field (field) values ('{"id":5,"id_system":1,"id_table":2,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":6,"id_system":1,"id_table":2,"label":"System","name":"id_system","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":1,"domain":""}');
insert into tb_field (field) values ('{"id":7,"id_system":1,"id_table":2,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":8,"id_system":1,"id_table":2,"label":"Link","name":"caption","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":9,"id_system":1,"id_table":2,"label":"Table Name","name":"table_name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
-- tb_field
insert into tb_field (field) values ('{"id":10,"id_system":1,"id_table":3,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":11,"id_system":1,"id_table":3,"label":"Table","name":"id_table","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":2,"domain":""}');
insert into tb_field (field) values ('{"id":12,"id_system":1,"id_table":3,"label":"Label","name":"label","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":13,"id_system":1,"id_table":3,"label":"Name","name":"name","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":14,"id_system":1,"id_table":3,"label":"Type","name":"id_type","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":4,"domain":"tb_field_type"}');
insert into tb_field (field) values ('{"id":15,"id_system":1,"id_table":3,"label":"Size","name":"size","id_type":1,"size":0,"mask":"","id_mandatory":2,"id_unique":2,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":16,"id_system":1,"id_table":3,"label":"Mask","name":"mask","id_type":3,"size":50,"mask":"","id_mandatory":2,"id_unique":2,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":17,"id_system":1,"id_table":3,"label":"Mandatory","name":"id_mandatory","id_type":5,"size":0,"mask":"","id_mandatory":2,"id_unique":2,"id_fk":4,"domain":"tb_bool"}');
insert into tb_field (field) values ('{"id":18,"id_system":1,"id_table":3,"label":"Unique","name":"id_unique","id_type":5,"size":0,"mask":"","id_mandatory":2,"id_unique":2,"id_fk":4,"domain":"tb_bool"}');
insert into tb_field (field) values ('{"id":19,"id_system":1,"id_table":3,"label":"Fk","name":"id_fk","id_type":1,"size":0,"mask":"","id_mandatory":2,"id_unique":2,"id_fk":2,"domain":""}');
insert into tb_field (field) values ('{"id":20,"id_system":1,"id_table":3,"label":"Domain","name":"domain","id_type":3,"size":50,"mask":"","id_mandatory":2,"id_unique":2,"id_fk":0,"domain":""}');
-- tb_domain
insert into tb_field (field) values ('{"id":21,"id_system":1,"id_table":4,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":22,"id_system":1,"id_table":4,"label":"Id Domain","name":"id_domain","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":23,"id_system":1,"id_table":4,"label":"Value","name":"value","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":24,"id_system":1,"id_table":4,"label":"Domain","name":"domain","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
-- tb_event
insert into tb_field (field) values ('{"id":25,"id_system":1,"id_table":5,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":26,"id_system":1,"id_table":5,"label":"Target","name":"id_target","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":4,"domain":"tb_target"}');
insert into tb_field (field) values ('{"id":27,"id_system":1,"id_table":5,"label":"Table","name":"id_table","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":2,"domain":""}');
insert into tb_field (field) values ('{"id":28,"id_system":1,"id_table":5,"label":"Field","name":"id_field","id_type":1,"size":0,"mask":"","id_mandatory":2,"id_unique":2,"id_fk":3,"domain":""}');
insert into tb_field (field) values ('{"id":29,"id_system":1,"id_table":5,"label":"Event","name":"id_event","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":4,"domain":"tb_event"}');
insert into tb_field (field) values ('{"id":30,"id_system":1,"id_table":5,"label":"Display Type","name":"id_event_type","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":4,"domain":"tb_event_type"}');
insert into tb_field (field) values ('{"id":31,"id_system":1,"id_table":5,"label":"Display","name":"display","id_type":3,"size":50,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":32,"id_system":1,"id_table":5,"label":"Code","name":"code","id_type":3,"size":500,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
-- tb_code
insert into tb_field (field) values ('{"id":33,"id_system":1,"id_table":6,"label":"Id","name":"id","id_type":1,"size":0,"mask":"","id_mandatory":1,"id_unique":1,"id_fk":0,"domain":""}');
insert into tb_field (field) values ('{"id":34,"id_system":1,"id_table":6,"label":"Code","name":"code","id_type":6,"size":500,"mask":"","id_mandatory":1,"id_unique":2,"id_fk":0,"domain":""}');
-- Fix session for all records
update tb_field set session = '{"id_system":1,"id_table":3,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_domain
-- -----------------------------------------------------
delete from tb_domain;
-- tb_bool
insert into tb_domain (field) values ('{"id":1,"id_system":1,"id_domain":1,"value":"Yes","domain":"tb_bool"}');
insert into tb_domain (field) values ('{"id":2,"id_system":1,"id_domain":2,"value":"No","domain":"tb_bool"}');
-- tb_field_type
insert into tb_domain (field) values ('{"id":3,"id_system":1,"id_domain":1,"value":"Integer","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":4,"id_system":1,"id_domain":2,"value":"Decimal","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":5,"id_system":1,"id_domain":3,"value":"String","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":6,"id_system":1,"id_domain":4,"value":"Date","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":7,"id_system":1,"id_domain":5,"value":"Boolean","domain":"tb_field_type"}');
insert into tb_domain (field) values ('{"id":8,"id_system":1,"id_domain":6,"value":"Text","domain":"tb_field_type"}');
-- tb_target
insert into tb_domain (field) values ('{"id":9,"id_system":1,"id_domain":1,"value":"Report","domain":"tb_target"}');
insert into tb_domain (field) values ('{"id":10,"id_system":1,"id_domain":2,"value":"Form","domain":"tb_target"}');
-- tb_event
insert into tb_domain (field) values ('{"id":11,"id_system":1,"id_domain":1,"value":"OnClick","domain":"tb_event"}');
insert into tb_domain (field) values ('{"id":12,"id_system":1,"id_domain":2,"value":"OnFocus","domain":"tb_event"}');
insert into tb_domain (field) values ('{"id":13,"id_system":1,"id_domain":3,"value":"OnBlur","domain":"tb_event"}');
-- tb_event_type
insert into tb_domain (field) values ('{"id":11,"id_system":1,"id_domain":1,"value":"None","domain":"tb_event_type"}');
insert into tb_domain (field) values ('{"id":12,"id_system":1,"id_domain":2,"value":"Caption","domain":"tb_event_type"}');
insert into tb_domain (field) values ('{"id":13,"id_system":1,"id_domain":3,"value":"Image","domain":"tb_event_type"}');
-- tb_rel_event
insert into tb_domain (field) values ('{"id":14,"id_system":1,"id_domain":1,"value":"4","domain":"tb_rel_event"}');
insert into tb_domain (field) values ('{"id":15,"id_system":1,"id_domain":1,"value":"7","domain":"tb_rel_event"}');
insert into tb_domain (field) values ('{"id":16,"id_system":1,"id_domain":2,"value":"4","domain":"tb_rel_event"}');
insert into tb_domain (field) values ('{"id":17,"id_system":1,"id_domain":2,"value":"7","domain":"tb_rel_event"}');
insert into tb_domain (field) values ('{"id":18,"id_system":1,"id_domain":3,"value":"4","domain":"tb_rel_event"}');
insert into tb_domain (field) values ('{"id":19,"id_system":1,"id_domain":3,"value":"7","domain":"tb_rel_event"}');
insert into tb_domain (field) values ('{"id":20,"id_system":1,"id_domain":5,"value":"6","domain":"tb_rel_event"}');
insert into tb_domain (field) values ('{"id":21,"id_system":1,"id_domain":5,"value":"7","domain":"tb_rel_event"}');
-- tb_operator
insert into tb_domain (field) values ('{"id":22,"id_system":1,"id_domain":"=","value":"=","domain":"tb_operator"}');
insert into tb_domain (field) values ('{"id":23,"id_system":1,"id_domain":"<>","value":"<>","domain":"tb_operator"}');
insert into tb_domain (field) values ('{"id":24,"id_system":1,"id_domain":">","value":">","domain":"tb_operator"}');
insert into tb_domain (field) values ('{"id":25,"id_system":1,"id_domain":">=","value":">=","domain":"tb_operator"}');
insert into tb_domain (field) values ('{"id":26,"id_system":1,"id_domain":"<","value":"<","domain":"tb_operator"}');
insert into tb_domain (field) values ('{"id":27,"id_system":1,"id_domain":"<=","value":"<=","domain":"tb_operator"}');
-- set the session
update tb_domain set session = '{"id_system":1,"id_table":4,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_event (on trigger)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- table tb_code
-- -----------------------------------------------------
delete from tb_code;
insert into tb_code (field) values ('{"id":1,"code":"function helloWorld() {alert(''Hello World'');}"}');
update tb_code set session = '{"id_system":1,"id_table":6,"id_user":1,"id_action":1}';