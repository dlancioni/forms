-- -----------------------------------------------------
-- Set string into single quote
-- -----------------------------------------------------
drop function qt;
create or replace function qt(value varchar)
returns varchar as
$$
begin
    -- select qt('david');
    return '''' || value || '''';
end;
$$ language plpgsql;
-- -----------------------------------------------------
-- is unique in table
-- -----------------------------------------------------
drop function is_unique;
create or replace function is_unique(table_name varchar, field_name varchar, field_value varchar)
returns boolean as
$$
declare
    count int;
    sql varchar;
begin
    -- select is_unique('tb_system', 'name', 'forms');
    sql := concat('select * from ', table_name, ' where data->>', qt(field_name), ' = ', qt(field_value));
    execute sql;
    get diagnostics count = row_count;
    if (count > 0) then
        return false;
    else
        return true;    
    end if;    
end;
$$ language plpgsql;

