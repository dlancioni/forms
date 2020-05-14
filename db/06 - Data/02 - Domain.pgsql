-- -----------------------------------------------------
-- Set default schema
-- -----------------------------------------------------
ALTER ROLE qqbzxiqr IN DATABASE qqbzxiqr SET search_path TO system;

-- -----------------------------------------------------
-- table tb_domain
-- -----------------------------------------------------
delete from tb_domain;
-- tb_bool
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"Y","value":"Yes","domain":"tb_bool"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"N","value":"No","domain":"tb_bool"}');
-- tb_field_type
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"integer","value":"Integer","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"decimal","value":"Decimal","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"string","value":"String","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"date","value":"Date","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"boolean","value":"Boolean","domain":"tb_field_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"text","value":"Text","domain":"tb_field_type"}');
-- tb_target
select insert('tb_domain', '{}','{"id":0, "id_system":1,"key":1,"value":"Report","domain":"tb_target"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":2,"value":"Form","domain":"tb_target"}');
-- tb_event
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":1,"value":"OnClick","domain":"tb_event"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":2,"value":"OnFocus","domain":"tb_event"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":3,"value":"OnBlur","domain":"tb_event"}');
-- tb_event_type
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":1,"value":"None","domain":"tb_event_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":2,"value":"Caption","domain":"tb_event_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":3,"value":"Image","domain":"tb_event_type"}');
-- tb_rel_event
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"new","value":"save","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"new","value":"back","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"edit","value":"save","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"edit","value":"back","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"delete","value":"save","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"delete","value":"back","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"filter1","value":"filter2","domain":"tb_rel_event"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"filter1","value":"back","domain":"tb_rel_event"}');
-- tb_operator
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"=","value":"=","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"<>","value":"<>","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":">","value":">","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":">=","value":">=","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"<","value":"<","domain":"tb_operator"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"<=","value":"<=","domain":"tb_operator"}');
-- tb_table_type
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":1,"value":"System","domain":"tb_table_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":2,"value":"User","domain":"tb_table_type"}');
-- tb_language
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":1,"value":"English","domain":"tb_language"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":2,"value":"Portuguese","domain":"tb_language"}');
-- tb_language
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"1","value":"Page Title","domain":"tb_catalog_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"2","value":"Field Name","domain":"tb_catalog_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"3","value":"Button Name","domain":"tb_catalog_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"5","value":"Domain Value","domain":"tb_catalog_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"6","value":"Dropdown","domain":"tb_catalog_type"}');
select insert('tb_domain', '{}','{"id":0,"id_system":1,"key":"4","value":"Message Code","domain":"tb_catalog_type"}');
-- set the session
update tb_domain set session = '{"id_system":1,"id_table":5,"id_user":1,"id_action":1}';

-- -----------------------------------------------------
-- table tb_code
-- -----------------------------------------------------
delete from tb_code;
select insert('tb_code', '{}','{"id":1,"code":"function helloWorld() {alert(''''Hello World'''');}"}');
update tb_code set session = '{"id_system":1,"id_table":7,"id_user":1,"id_action":1}';