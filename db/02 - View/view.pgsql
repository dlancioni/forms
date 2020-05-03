-- -----------------------------------------------------
-- view vw_table
-- -----------------------------------------------------
drop view if exists vw_table;
create or replace view vw_table  as
select
tb_field.id id,
(tb_field.session->>'id_system')::int id_system,
(tb_field.field->>'id_table')::int id_table,
trim(tb_field.field->>'label') field_label,
trim(tb_field.field->>'name') field_name,
(tb_field.field->>'id_type')::int id_type,
trim(tb_field_type.field->>'value') field_type,
(tb_field.field->>'size')::int field_size,
trim(tb_field.field->>'mask') field_mask,
(tb_field.field->>'id_fk')::int id_fk,
(tb_field.field->>'id_mandatory')::int id_mandatory,
trim(tb_mandatory.field->>'value')  field_mandatory,
(tb_field.field->>'id_unique')::int id_unique,
trim(tb_unique.field->>'value') field_unique,
trim(tb_table.field->>'table_name') table_name,
trim(tb_field.field->>'domain') domain_name

from tb_field

inner join tb_table on
tb_field.session->>'id_system' = tb_table.session->>'id_system' and            
(tb_field.field->>'id_table')::int = tb_table.id

inner join tb_domain tb_field_type on
tb_field.field->>'id_type' = tb_field_type.field->>'key'
and tb_field_type.field->>'domain' = 'tb_field_type'

inner join tb_domain tb_mandatory on
tb_field.field->>'id_mandatory' = tb_mandatory.field->>'key'
and tb_mandatory.field->>'domain' = 'tb_bool'

inner join tb_domain tb_unique on
tb_field.field->>'id_unique' = tb_unique.field->>'key'
and tb_unique.field->>'domain' = 'tb_bool'

order by 
tb_table.id,
tb_field.id;

