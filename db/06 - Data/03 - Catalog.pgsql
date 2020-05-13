-- -----------------------------------------------------
-- Set default schema
-- -----------------------------------------------------
ALTER ROLE qqbzxiqr IN DATABASE qqbzxiqr SET search_path TO system;

-- -----------------------------------------------------
-- table tb_catalog
-- -----------------------------------------------------
delete from tb_catalog;
-- Page title
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":1,"key":"System","value":"System"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"System","value":"Sistema"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":1,"key":"Menu","value":"Menu"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Menu","value":"Menu"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":1,"key":"Table","value":"Table"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Table","value":"Tabela"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":1,"key":"Field","value":"Field"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Field","value":"Campos"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":1,"key":"Domain","value":"Domain"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Domain","value":"Domínio"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":1,"key":"Event","value":"Event"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Event","value":"Eventos"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":1,"key":"Code","value":"Code"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Code","value":"Código"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":1,"key":"Catalog","value":"Catalog"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Catalog","value":"Catalogo"}');
-- Buttons
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":3,"key":"new","value":"New"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":3,"key":"new","value":"Novo"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":3,"key":"edit","value":"Edit"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":3,"key":"edit","value":"Editar"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":3,"key":"delete","value":"Delete"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":3,"key":"delete","value":"Excluir"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":3,"key":"save","value":"Save"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":3,"key":"save","value":"Salvar"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":3,"key":"filter1","value":"Filter"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":3,"key":"filter1","value":"Filtrar"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":3,"key":"filter2","value":"Filter"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":3,"key":"filter2","value":"Filtrar"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":1,"id_type":3,"key":"back","value":"Back"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":3,"key":"back","value":"Voltar"}');
-- Finish
update tb_catalog set session = '{"id_system":1,"id_table":8,"id_user":1,"id_action":1}';
