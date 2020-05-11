-- -----------------------------------------------------
-- Set default schema
-- -----------------------------------------------------
ALTER ROLE qqbzxiqr IN DATABASE qqbzxiqr SET search_path TO system;

-- -----------------------------------------------------
-- table tb_system
-- -----------------------------------------------------
delete from tb_system;
select insert('tb_system', '{}','{"id":0,"name":"Forms","expire_date":"31/12/2020","price":"100.00"}');
update tb_system set session = '{"id_system":1,"id_table":1,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_menu
-- -----------------------------------------------------
delete from tb_menu;
select insert('tb_menu', '{}','{"id":0,"name":"Home","id_parent":0,"url":"go(1,2,3);"}');
select insert('tb_menu', '{}','{"id":0,"name":"Entry","id_parent":0,"url":"go(1,2,3);"}');
select insert('tb_menu', '{}','{"id":0,"name":"Setup","id_parent":2,"url":"go(1,2,3);"}');
select insert('tb_menu', '{}','{"id":0,"name":"Help","id_parent":2,"url":"go(1,2,3);"}');
update tb_menu set session = '{"id_system":1,"id_table":2,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_table
-- -----------------------------------------------------
delete from tb_table;
select insert('tb_table', '{"id_system":1,"id_table":3,"id_user":1,"id_action":1}','{"id":0,"id_system":1,"name":"System","id_type":1,"title":"System","table_name":"tb_system"}');
select insert('tb_table', '{"id_system":1,"id_table":3,"id_user":1,"id_action":1}','{"id":0,"id_system":1,"name":"Menu","id_type":1,"title":"Menu","table_name":"tb_menu"}');
select insert('tb_table', '{"id_system":1,"id_table":3,"id_user":1,"id_action":1}','{"id":0,"id_system":1,"name":"Table","id_type":1,"title":"Table","table_name":"tb_table"}');
select insert('tb_table', '{"id_system":1,"id_table":3,"id_user":1,"id_action":1}','{"id":0,"id_system":1,"name":"Field","id_type":1,"title":"Field","table_name":"tb_field"}');
select insert('tb_table', '{"id_system":1,"id_table":3,"id_user":1,"id_action":1}','{"id":0,"id_system":1,"name":"Domain","id_type":1,"title":"Domain","table_name":"tb_domain"}');
select insert('tb_table', '{"id_system":1,"id_table":3,"id_user":1,"id_action":1}','{"id":0,"id_system":1,"name":"Event","id_type":1,"title":"Event", "table_name":"tb_event"}');
select insert('tb_table', '{"id_system":1,"id_table":3,"id_user":1,"id_action":1}','{"id":0,"id_system":1,"name":"Code","id_type":1,"title":"Code","table_name":"tb_code"}');

-- -----------------------------------------------------
-- table tb_field
-- -----------------------------------------------------
delete from tb_field;
-- tb_system
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":1,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":1,"label":"Name","name":"name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":1,"label":"Expire Date","name":"expire_date","field_type":"date","size":0,"mask":"dd/mm/yyyy","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":1,"label":"Price","name":"price","field_type":"decimal","size":0,"mask":"1.000,00","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
-- tb_menu
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":2,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":2,"label":"Name","name":"name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":2,"label":"Parent","name":"id_parent","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":2,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":2,"label":"Url","name":"url","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
-- tb_table
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"System","name":"id_system","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":1,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Type","name":"id_type","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":5,"domain":"tb_table_type"}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Title","name":"title","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":3,"label":"Table Name","name":"table_name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
-- tb_field
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Table","name":"id_table","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":3,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Label","name":"label","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Name","name":"name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Type","name":"field_type","field_type":"string","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":5,"domain":"tb_field_type"}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Size","name":"size","field_type":"integer","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Mask","name":"mask","field_type":"string","size":50,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Mandatory","name":"id_mandatory","field_type":"boolean","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":5,"domain":"tb_bool"}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Unique","name":"id_unique","field_type":"boolean","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":5,"domain":"tb_bool"}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Fk","name":"id_fk","field_type":"integer","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":3,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":4,"label":"Domain","name":"domain","field_type":"string","size":50,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":0,"domain":""}');
-- tb_domain
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Key","name":"key","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Value","name":"value","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":5,"label":"Domain","name":"domain","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
-- tb_event
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Name","name":"name","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Target","name":"id_target","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":5,"domain":"tb_target"}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Table","name":"id_table","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":3,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Field","name":"id_field","field_type":"integer","size":0,"mask":"","id_mandatory":"N","id_unique":"N","id_fk":4,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Event","name":"id_event","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":5,"domain":"tb_event"}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Display Type","name":"id_event_type","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":5,"domain":"tb_event_type"}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Display","name":"display","field_type":"string","size":50,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":6,"label":"Code","name":"code","field_type":"string","size":500,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
-- tb_code
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":7,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}');
select insert('tb_field', '{}','{"id":0,"id_system":1,"id_table":7,"label":"Code","name":"code","field_type":"text","size":500,"mask":"","id_mandatory":"Y","id_unique":"N","id_fk":0,"domain":""}');
-- Fix session for all records
update tb_field set session = '{"id_system":1,"id_table":4,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_domain
-- -----------------------------------------------------
delete from tb_domain;
-- tb_bool
select insert('tb_domain', '{}','{"id":1,"id_system":1,"key":"Y","value":"Yes","domain":"tb_bool"}');
select insert('tb_domain', '{}','{"id":2,"id_system":1,"key":"N","value":"No","domain":"tb_bool"}');
-- tb_field_type
select insert('tb_domain', '{}','{"id":3,"id_system":1,"key":"integer","value":"Integer","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":4,"id_system":1,"key":"decimal","value":"Decimal","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":5,"id_system":1,"key":"string","value":"String","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":6,"id_system":1,"key":"date","value":"Date","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":7,"id_system":1,"key":"boolean","value":"Boolean","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":8,"id_system":1,"key":"text","value":"Text","domain":"tb_field_type"}');
-- tb_target
select insert('tb_domain', '{}','{"id":9, "id_system":1,"key":1,"value":"Report","domain":"tb_target"}');
select insert('tb_domain', '{}','{"id":10,"id_system":1,"key":2,"value":"Form","domain":"tb_target"}');
-- tb_event
select insert('tb_domain', '{}','{"id":11,"id_system":1,"key":1,"value":"OnClick","domain":"tb_event"}');
select insert('tb_domain', '{}','{"id":12,"id_system":1,"key":2,"value":"OnFocus","domain":"tb_event"}');
select insert('tb_domain', '{}','{"id":13,"id_system":1,"key":3,"value":"OnBlur","domain":"tb_event"}');
-- tb_event_type
select insert('tb_domain', '{}','{"id":11,"id_system":1,"key":1,"value":"None","domain":"tb_event_type"}');
select insert('tb_domain', '{}','{"id":12,"id_system":1,"key":2,"value":"Caption","domain":"tb_event_type"}');
select insert('tb_domain', '{}','{"id":13,"id_system":1,"key":3,"value":"Image","domain":"tb_event_type"}');
-- tb_rel_event
select insert('tb_domain', '{}','{"id":14,"id_system":1,"key":"new","value":"save","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":15,"id_system":1,"key":"new","value":"back","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":16,"id_system":1,"key":"edit","value":"save","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":17,"id_system":1,"key":"edit","value":"back","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":18,"id_system":1,"key":"delete","value":"save","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":19,"id_system":1,"key":"delete","value":"back","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":20,"id_system":1,"key":"filter1","value":"filter2","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":21,"id_system":1,"key":"filter1","value":"back","domain":"tb_rel_event"}');
-- tb_operator
select insert('tb_domain', '{}','{"id":22,"id_system":1,"key":"=","value":"=","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":23,"id_system":1,"key":"<>","value":"<>","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":24,"id_system":1,"key":">","value":">","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":25,"id_system":1,"key":">=","value":">=","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":26,"id_system":1,"key":"<","value":"<","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":27,"id_system":1,"key":"<=","value":"<=","domain":"tb_operator"}');
-- tb_bool
select insert('tb_domain', '{}','{"id":1,"id_system":1,"key":1,"value":"System","domain":"tb_table_type"}');
select insert('tb_domain', '{}','{"id":2,"id_system":1,"key":2,"value":"User","domain":"tb_table_type"}');
-- set the session
update tb_domain set session = '{"id_system":1,"id_table":5,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_event (on trigger)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- table tb_code
-- -----------------------------------------------------
delete from tb_code;
select insert('tb_code', '{}','{"id":1,"code":"function helloWorld() {alert(''''Hello World'''');}"}');
update tb_code set session = '{"id_system":1,"id_table":7,"id_user":1,"id_action":1}';