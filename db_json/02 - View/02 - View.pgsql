-- -----------------------------------------------------
-- view vw_table
-- -----------------------------------------------------
drop view vw_table;
create or replace view vw_table  as
select
tb_field.id id,
(tb_field.data->'data'->>'id_company')::int id_company,
(tb_field.data->'data'->>'id_system')::int id_system,
(tb_field.data->'data'->>'id_table')::int id_table,
trim(tb_field.data->'data'->>'label') field_label,
trim(tb_field.data->'data'->>'name') field_name,
(tb_field.data->'data'->>'id_type')::int id_type,
trim(tb_field_type.data->'data'->>'value') field_type,
(tb_field.data->'data'->>'size')::int field_size,
trim(tb_field.data->'data'->>'mask') field_mask,
(tb_field.data->'data'->>'id_fk')::int id_fk,
(tb_field.data->'data'->>'id_mandatory')::int id_mandatory,
trim(tb_mandatory.data->'data'->>'value')  field_mandatory,
(tb_field.data->'data'->>'id_unique')::int id_unique,
trim(tb_unique.data->'data'->>'value') field_unique,
trim(tb_table.data->'data'->>'table_name') table_name

from tb_field

inner join tb_table on
tb_field.data->'session'->>'id_company' = tb_table.data->'session'->>'id_company' and
tb_field.data->'session'->>'id_system' = tb_table.data->'session'->>'id_system' and            
(tb_field.data->'data'->>'id_table')::int = tb_table.id

inner join tb_domain tb_field_type on
tb_field.data->'data'->>'id_type' = tb_field_type.data->'data'->>'id_domain'
and tb_field_type.data->'data'->>'domain' = 'tb_field_type'

inner join tb_domain tb_mandatory on
tb_field.data->'data'->>'id_mandatory' = tb_mandatory.data->'data'->>'id_domain'
and tb_mandatory.data->'data'->>'domain' = 'tb_bool'

inner join tb_domain tb_unique on
tb_field.data->'data'->>'id_unique' = tb_unique.data->'data'->>'id_domain'
and tb_unique.data->'data'->>'domain' = 'tb_bool'

order by 
tb_table.id,
tb_field.id;
