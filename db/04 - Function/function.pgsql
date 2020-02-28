/*
author: david lancioni
target: crop data from string 
select crop('id,name, ', ',' );
*/
drop function if exists crop;
create or replace function crop(text text, value text)
returns character varying
language plpgsql
as $function$
begin
    return btrim(trim(text), value);
end;
$function$;

/*
author: david lancioni
target: set value between double quote
select dbqt('david');
select dbqt('');
*/
drop function if exists dbqt;
create or replace function dbqt(value text)
returns character varying
language plpgsql
as $function$
begin
    if (value != '') then
        value = concat('"', value, '"');
    else
        value = concat('"', '"');    
    end if;

    return value;
end;
$function$;

/*
author: david lancioni
target: check if the record is unique at the table
select is_unique(1,1,'tb_system', 'name', 'formsss') -- true, dont exists
select is_unique(1,1,'tb_system', 'name', 'forms') -- false, already exists 
*/
drop function if exists is_unique;
create or replace function is_unique(id_system integer, table_name character varying, field_name character varying, field_value character varying)
returns boolean
language plpgsql
as $function$
declare
    sql varchar := '';
    item record;    
begin

    sql = concat(sql, ' select * from ', table_name);
    sql = concat(sql, ' where (data->', qt('session'), '->>', qt('id_system'), ')::int = ', id_system);
    sql = concat(sql, ' and data->', qt('field'), '->>', qt(field_name), ' = ', qt(field_value));
    for item in execute sql loop
        return false;    
    end loop;
    return true;
end;
$function$;

/*
author: david lancioni
target: set value between single quote
select qt('david');
*/
drop function if exists qt;
create or replace function qt(value character varying)
returns character varying
language plpgsql
as $function$
begin
    return '''' || value || '''';    
end;
$function$;

/*
author: david lancioni
target: just output values for debug porpouse
select trace('david');
*/
drop function if exists trace;
create or replace function trace(value text)
returns void
language plpgsql
as $function$
begin
    raise notice '%', value;
end;
$function$;

/*
author: david lancioni
target: check if the record is unique at the table
select table_json(1,1,1,'I')
select jsonb_set(table_json(1,1,1,'I'), '{"field", "id"}', '999')
*/
drop function if exists table_json;
create or replace function table_json(id_system int, id_table int, action char(1))
returns jsonb
language plpgsql
as $function$
declare
    sql text := '';
    session text := '';
    field text := '';
    item record;   
begin

    -- Create session
    session = concat(session, dbqt('session'), ':', '{');
    session = concat(session, dbqt('id_system'), ':', id_system, ',');
    session = concat(session, dbqt('id_table'), ':', id_table, ',');
    session = concat(session, dbqt('action'), ':', dbqt(action));
    session = concat(session, '}');

    -- Create record
    field = concat(field, dbqt('field'), ':', '{');
    sql := concat(sql, ' select field_name from vw_table');
    sql := concat(sql, ' where id_system = ', id_system);
    sql := concat(sql, ' and id_table = ', id_table);
    for item in execute sql loop        
        field = concat(field, dbqt(item.field_name), ':', dbqt(''), ',');        
    end loop;
    field := concat(crop(field, ','), '}');

    -- Create final JSONB
    return concat('{', session, ',', field, '}');

end;
$function$;

/*
author: david lancioni
target: Format numbers based on mask
*/
create or replace function format_number(number numeric, mask text)
returns text
language plpgsql
as $function$
declare output text := '';
begin
    -- select format_number1(1000, '999.999'); -- 1.000
    if (trim(mask) = '') then
        raise exception 'mascara [%] invalida', mask;
    end if;
    -- revert mask to en-us format
    mask := replace(replace(replace(mask, ',', '?'), '.', ','), '?', '.');
    -- apply mask to value 
    output := replace(replace(replace(to_char(number, mask), ',', '?'), '.', ','), '?', '.');
    -- just return it
    return output;
end;
$function$;




