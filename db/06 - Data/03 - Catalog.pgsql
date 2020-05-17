/*
Notes
1) We dont need to book translation for pt and us as labels are already in english
2) If translate codes or ids yoy have to book for both langguages
3) For system fields we are accumulating info (not necessary to translate field name, type, id for all tables)
4) ID is not translated
5) Translation happens as:
        Page Title: get_title()
        Fields: vw_table
        Buttons: get_events()
        Domain:
        Dropdown:
        Messages:
*/
-- -----------------------------------------------------
-- TB_CATALOG
-- -----------------------------------------------------
delete from tb_catalog;
-- -----------------------------------------------------
-- Titles
-- -----------------------------------------------------
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"System","value":"Sistema"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Menu","value":"Menu"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Table","value":"Tabela"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Field","value":"Campos"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Domain","value":"Domínio"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Event","value":"Eventos"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Code","value":"Código"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":1,"key":"Catalog","value":"Catalogo"}');
-- -----------------------------------------------------
-- Fields
-- -----------------------------------------------------
-- tb_system
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"name","value":"Nome"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"expire_date","value":"Expira em"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"price","value":"Preço"}');
-- tb_menu
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_parent","value":"Menu pai"}');
-- tb_table
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_system","value":"Sistema"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_type","value":"Tipo"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"title","value":"Titulo"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"table_name","value":"Nome da Tabela"}');
-- tb_field
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_table","value":"Tabela"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"field_type","value":"Tipo do Campo"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"size","value":"Tamanho"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"mask","value":"Mascara"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_mandatory","value":"Obrigatório"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_unique","value":"Unico"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_fk","value":"Tabela"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"domain","value":"Domínio"}');
-- tb_domain
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"key","value":"Chave"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"value","value":"Valor"}');
-- tb_event
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_page","value":"Tabela ou Formulário"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_page","value":"Tabela ou Formulário"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_field","value":"Campo"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_event","value":"Evento"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_event_type","value":"Tipo de Evento"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"display","value":"Exibir"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"code","value":"Código"}');
-- tb_catalog
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":2,"key":"id_language","value":"Idioma"}');
-- -----------------------------------------------------
-- Buttons
-- -----------------------------------------------------
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
-- -----------------------------------------------------
-- Domain
-- -----------------------------------------------------
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Report","value":"Relatório"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Form","value":"Formulário"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"None","value":"Não se aplica"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Caption","value":"Texto"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Image","value":"Imagem"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"System","value":"Sistema"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"User","value":"Usuário"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"English","value":"Inglês"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Portuguese","value":"Português"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Page Title","value":"Titulo da Página"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Field Name","value":"Nome do Campo"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Field Name","value":"Texto do botão"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Message Code","value":"Código de Mensagem"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Domain Value","value":"Valor de Domínio"}');
select insert('tb_catalog', '{}','{"id":0,"id_system":1,"id_language":2,"id_type":4,"key":"Dropdown","value":"Lista de Opções"}');

-- -----------------------------------------------------
-- DropDown
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Message Codes
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Finish
-- -----------------------------------------------------
update tb_catalog set session = '{"id_system":1,"id_table":8,"id_user":1,"id_action":1}';
