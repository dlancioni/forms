-- -----------------------------------------------------
-- view vw_table
-- -----------------------------------------------------
create or replace view vw_table  as
select
tb_field.id,
tb_field.id_company,
tb_field.id_system,
tb_field.id_table,
tb_field.label,
tb_field.name,
tb_field.id_type,
tb_field_type.value field_type,
tb_field.size,
tb_field.mask,
tb_field.id_fk,
tb_field.id_mandatory,
tb_mandatory.value mandatory,
tb_field.id_unique,
tb_unique.value uniques,
tb_table.table_name

from tb_field

inner join tb_table on
tb_field.id_company = tb_table.id_company and
tb_field.id_system = tb_table.id_system and            
tb_field.id_table = tb_table.id

inner join tb_domain tb_field_type on
tb_field.id_type = tb_field_type.id_domain
and tb_field_type.domain = 'tb_field_type'

inner join tb_domain tb_mandatory on
tb_field.id_mandatory = tb_mandatory.id_domain
and tb_mandatory.domain = 'tb_bool'

inner join tb_domain tb_unique on
tb_field.id_unique = tb_unique.id_domain
and tb_unique.domain = 'tb_bool'

order by 
tb_table.id,
tb_field.id;
