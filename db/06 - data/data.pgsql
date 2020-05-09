-- -----------------------------------------------------
-- Set default schema
-- -----------------------------------------------------
ALTER ROLE qqbzxiqr IN DATABASE qqbzxiqr SET search_path TO system;

-- -----------------------------------------------------
-- table tb_system
-- -----------------------------------------------------
delete from tb_system;
select stamp('tb_system', '{}','{"id":0,"name":"Forms","expire_date":"31/12/2020","price":"100.00"}');
update tb_system set session = '{"id_system":1,"id_table":1,"id_user":1,"id_action":1}';
-- -----------------------------------------------------
-- table tb_table
-- -----------------------------------------------------
delete from tb_table;
select stamp('tb_table', '{}','{"id":0,"id_system":1,"name":"System","caption":"System","table_name":"tb_system"}');
select stamp('tb_table', '{}','{"id":0,"id_system":1,"name":"Table","caption":"Table","table_name":"tb_table"}');
select stamp('tb_table', '{}','{"id":0,"id_system":1,"name":"Field","caption":"Field","table_name":"tb_field"}');
select stamp('tb_table', '{}','{"id":0,"id_system":1,"name":"Domain","caption":"Domain","table_name":"tb_domain"}');
select stamp('tb_table', '{}','{"id":0,"id_system":1,"name":"Event","caption":"Event", "table_name":"tb_event"}');
select stamp('tb_table', '{}','{"id":0,"id_system":1,"name":"Code","caption":"Code","table_name":"tb_code"}');
update tb_table set session = '{"id_system":1,"id_table":1,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_field
-- -----------------------------------------------------
delete from tb_field;
-- tb_system
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":1,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":1,"label":"Name","name":"name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":1,"label":"Expire Date","name":"expire_date","field_type":"date","size":0,"mask":"dd/mm/yyyy","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":1,"label":"Price","name":"price","field_type":"decimal","size":0,"mask":"1.000,00","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
-- tb_table
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":2,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":2,"label":"System","name":"id_system","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":1,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":2,"label":"Title","name":"name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":2,"label":"Table Name","name":"table_name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
-- tb_field
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Table","name":"id_table","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":2,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Label","name":"label","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Name","name":"name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Type","name":"field_type","field_type":"string","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":4,"domain":"tb_field_type"}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Size","name":"size","field_type":"integer","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Mask","name":"mask","field_type":"string","size":50,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Mandatory","name":"id_mandatory","field_type":"boolean","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":4,"domain":"tb_bool"}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Unique","name":"id_unique","field_type":"boolean","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":4,"domain":"tb_bool"}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Fk","name":"id_fk","field_type":"integer","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":2,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Domain","name":"domain","field_type":"string","size":50,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":0,"domain":""}');
-- tb_domain
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Key","name":"key","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Value","name":"value","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Domain","name":"domain","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
-- tb_event
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Name","name":"name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Target","name":"id_target","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":4,"domain":"tb_target"}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Table","name":"id_table","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":2,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Field","name":"id_field","field_type":"integer","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":3,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Event","name":"id_event","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":4,"domain":"tb_event"}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Display Type","name":"id_event_type","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":4,"domain":"tb_event_type"}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Display","name":"display","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Code","name":"code","field_type":"string","size":500,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
-- tb_code
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select stamp('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Code","name":"code","field_type":"text","size":500,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
-- Fix session for all records
update tb_field set session = '{"id_system":1,"id_table":3,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_domain
-- -----------------------------------------------------
delete from tb_domain;
-- tb_bool
select stamp('tb_domain', '{}','{"id":1,"id_system":1,"key":"Y","value":"Yes","domain":"tb_bool"}');
select stamp('tb_domain', '{}','{"id":2,"id_system":1,"key":"N","value":"No","domain":"tb_bool"}');
-- tb_field_type
select stamp('tb_domain', '{}','{"id":3,"id_system":1,"key":"integer","value":"Integer","domain":"tb_field_type"}');
select stamp('tb_domain', '{}','{"id":4,"id_system":1,"key":"decimal","value":"Decimal","domain":"tb_field_type"}');
select stamp('tb_domain', '{}','{"id":5,"id_system":1,"key":"string","value":"String","domain":"tb_field_type"}');
select stamp('tb_domain', '{}','{"id":6,"id_system":1,"key":"date","value":"Date","domain":"tb_field_type"}');
select stamp('tb_domain', '{}','{"id":7,"id_system":1,"key":"boolean","value":"Boolean","domain":"tb_field_type"}');
select stamp('tb_domain', '{}','{"id":8,"id_system":1,"key":"text","value":"Text","domain":"tb_field_type"}');
-- tb_target
select stamp('tb_domain', '{}','{"id":9, "id_system":1,"key":1,"value":"Report","domain":"tb_target"}');
select stamp('tb_domain', '{}','{"id":10,"id_system":1,"key":2,"value":"Form","domain":"tb_target"}');
-- tb_event
select stamp('tb_domain', '{}','{"id":11,"id_system":1,"key":1,"value":"OnClick","domain":"tb_event"}');
select stamp('tb_domain', '{}','{"id":12,"id_system":1,"key":2,"value":"OnFocus","domain":"tb_event"}');
select stamp('tb_domain', '{}','{"id":13,"id_system":1,"key":3,"value":"OnBlur","domain":"tb_event"}');
-- tb_event_type
select stamp('tb_domain', '{}','{"id":11,"id_system":1,"key":1,"value":"None","domain":"tb_event_type"}');
select stamp('tb_domain', '{}','{"id":12,"id_system":1,"key":2,"value":"Caption","domain":"tb_event_type"}');
select stamp('tb_domain', '{}','{"id":13,"id_system":1,"key":3,"value":"Image","domain":"tb_event_type"}');
-- tb_rel_event
select stamp('tb_domain', '{}','{"id":14,"id_system":1,"key":"new","value":"save","domain":"tb_rel_event"}');
select stamp('tb_domain', '{}','{"id":15,"id_system":1,"key":"new","value":"back","domain":"tb_rel_event"}');
select stamp('tb_domain', '{}','{"id":16,"id_system":1,"key":"edit","value":"save","domain":"tb_rel_event"}');
select stamp('tb_domain', '{}','{"id":17,"id_system":1,"key":"edit","value":"back","domain":"tb_rel_event"}');
select stamp('tb_domain', '{}','{"id":18,"id_system":1,"key":"delete","value":"save","domain":"tb_rel_event"}');
select stamp('tb_domain', '{}','{"id":19,"id_system":1,"key":"delete","value":"back","domain":"tb_rel_event"}');
select stamp('tb_domain', '{}','{"id":20,"id_system":1,"key":"filter1","value":"filter2","domain":"tb_rel_event"}');
select stamp('tb_domain', '{}','{"id":21,"id_system":1,"key":"filter1","value":"back","domain":"tb_rel_event"}');
-- tb_operator
select stamp('tb_domain', '{}','{"id":22,"id_system":1,"key":"=","value":"=","domain":"tb_operator"}');
select stamp('tb_domain', '{}','{"id":23,"id_system":1,"key":"<>","value":"<>","domain":"tb_operator"}');
select stamp('tb_domain', '{}','{"id":24,"id_system":1,"key":">","value":">","domain":"tb_operator"}');
select stamp('tb_domain', '{}','{"id":25,"id_system":1,"key":">=","value":">=","domain":"tb_operator"}');
select stamp('tb_domain', '{}','{"id":26,"id_system":1,"key":"<","value":"<","domain":"tb_operator"}');
select stamp('tb_domain', '{}','{"id":27,"id_system":1,"key":"<=","value":"<=","domain":"tb_operator"}');
-- set the session
update tb_domain set session = '{"id_system":1,"id_table":4,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_event (on trigger)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- table tb_code
-- -----------------------------------------------------
delete from tb_code;
select stamp('tb_code', '{}','{"id":1,"code":"function helloWorld() {alert(''''Hello World'''');}"}');
update tb_code set session = '{"id_system":1,"id_table":6,"id_user":1,"id_action":1}';