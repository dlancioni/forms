-- -----------------------------------------------------
-- view vw_table
-- -----------------------------------------------------

create or replace view vw_table  as
select
tb_field.id id,
tb_field.data->>'id_company' id_company,
tb_field.data->>'id_system' id_system,
tb_field.data->>'id_table' id_table,
tb_field.data->>'label' field_label,
tb_field.data->>'name' field_name,
tb_field.data->>'id_type' id_type,
tb_field_type.data->>'value' field_type,
tb_field.data->>'size' field_size,
tb_field.data->>'mask' field_mask,
tb_field.data->>'id_fk' id_fk,
tb_field.data->>'id_mandatory' id_mandatory,
tb_mandatory.data->>'value'  field_mandatory,
tb_field.data->>'id_unique' id_unique,
tb_unique.data->>'value' field_unique,
tb_table.data->>'table_name' table_name

from tb_field

inner join tb_table on
tb_field.data->>'id_company' = tb_table.data->>'id_company' and
tb_field.data->>'id_system' = tb_table.data->>'id_system' and            
(tb_field.data->>'id_table')::int = tb_table.id

inner join tb_domain tb_field_type on
tb_field.data->>'id_type' = tb_field_type.data->>'id_domain'
and tb_field_type.data->>'domain' = 'tb_field_type'

inner join tb_domain tb_mandatory on
tb_field.data->>'id_mandatory' = tb_mandatory.data->>'id_domain'
and tb_mandatory.data->>'domain' = 'tb_bool'

inner join tb_domain tb_unique on
tb_field.data->>'id_unique' = tb_unique.data->>'id_domain'
and tb_unique.data->>'domain' = 'tb_bool'

order by 
tb_table.id,
tb_field.id;
