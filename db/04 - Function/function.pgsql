/*
Crop data from string 
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
Set value between double quote
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
Format numbers based on mask
*/
drop function if exists format_number;
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

/*
Get dynamic and condition
*/
drop function if exists get_condition;
create or replace function get_condition(json jsonb)
returns text
language plpgsql
as $function$
declare
    id_system int := 0;
    id_table int := 0;
    sql text := '';
    output text := '';
    item record;
    data text;
begin
/*
Call sample:
select get_condition('{"session":{"id_system":1,"id_table":1,"id_action":1},"criteria":[{"field_name":"name", "operator":"=", "field_value":"1"}]}')
*/
id_system := json->'session'->>'id_system';
id_table := json->'session'->>'id_table';
data := qt(json_extract_path(json::json, 'criteria')::text);

sql := concat(sql, ' select x.field_name, x.operator, x.field_value::text, v.id_type field_type');
sql := concat(sql, ' from json_to_recordset(', data, ') as x(field_name text, operator text, field_value int)');
sql := concat(sql, ' inner join vw_table v on x.field_name = v.field_name');
sql := concat(sql, ' where v.id_system = ', id_system);
sql := concat(sql, ' and v.id_table = ', id_table);

for item in execute sql
loop    
    output := concat(output, sql_condition(item.field_name, item.field_type, item.operator, item.field_value), ' and');
end loop;
output := crop(output, ' and');

return output;

end;
$function$;

/*
Get table name
select get_table(1,1) -- success
select get_table(1,9) -- fail
*/
drop function if exists get_table;
create or replace function get_table(id_system integer, id_table integer)
returns text
language plpgsql
as $function$
declare
    sql text;
    item record;
begin
    sql = concat(sql, 'select');
    sql = concat(sql, sql_column('table_name', 3));
    sql = concat(sql, ' from tb_table');
    sql = concat(sql, ' where id = ', id_table);
    sql = concat(sql, ' and ', sql_condition('id_system', 1, '=', id_system::text));
    for item in execute sql loop
    return item.table_name;
    end loop;
    raise exception 'tabela nao encontrada para codigo de sistema (%) e tabela (%)', id_system, id_table;
end;
$function$;

/*
Check if the record is unique at the table
select is_unique(1,'tb_system', 'name', 'formsss') -- true, dont exists
select is_unique(1,'tb_system', 'name', 'forms') -- false, already exists 
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
Check if the record is unique at the table
select table_json(1,1,1,'I')
select jsonb_set(table_json(1,1,1,'I'), '{"field", "id"}', '999')
*/
drop function if exists json_in;
create or replace function json_in(id_system int, id_table int, id_action int)
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
    session = concat(session, dbqt('id_action'), ':', id_action);
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
Format numbers based on mask
select return(1, 'I', 23, '', '')
select return(0, 'U', 23, 'exception goes here', 'warning goes here')
*/
drop function if exists json_out;
create or replace function json_out(status int, id_action int, id int, error text, warning text)
returns jsonb
language plpgsql
as $function$
declare 
    output text := '';
    message text := '';
begin
    if (id_action = 1) then 
        message := 'Registro INCLUÍDO com sucesso' || '. id: ' || id::text;
    elsif (id_action = 2) then
        message := 'Registro ALTERADO com sucesso' || '. id: ' || id::text;
    elsif (id_action = 3) then
        message := 'Registro EXCLUÍDO com sucesso' || '. id: ' || id::text;
    else
        message := 'Invalid action';    
    end if;

    output := concat(output, '{');
    output := concat(output, '"status":', status, ',');
    output := concat(output, '"id":', id, ',');
    output := concat(output, '"action":', id_action, ',');
    output := concat(output, '"message":', dbqt(message), ',');
    output := concat(output, '"error":', dbqt(error), ',');
    output := concat(output, '"warning":', dbqt(warning));
    output := concat(output, '}');
    return output;
end;
$function$;

/*
Parse string in a valid date
select parse_date('', 'yyyy/MM/dd') -- true (nothing to parse)
select parse_date('2020/12/31', 'yyyy/MM/dd') -- true
select parse_date('', 'dd/mm/yyyy') -- false
*/
drop function if exists parse_date;
create or replace function parse_date(date text, mask text)
returns boolean
language plpgsql
as $function$
declare
    output text;
begin
    -- empty return true
    date := trim(date);
    mask := trim(mask);
    if (date = '') then
        return true;
    end if;

    -- parse string into date
    select to_date(date, mask)::date into output;
    -- input must have same size as mask
    if (length(date) != length(mask)) then
        return false;
    end if;
    -- output must have same size as mask
    if (length(output) != length(mask)) then
        return false;
    end if;
    -- return
    return true;
exception when others then
    return false;
end;
$function$;

/*
Sset value between single quote
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
target: 
*/
drop function if exists sql_column;
create or replace function sql_column(field_name text, field_type integer)
returns text
language plpgsql
as $function$
declare
    output text := '';
begin
    output = concat(output , ' (data->', qt('field'), '->>', qt(field_name), ' ');
    if (field_type = 1) then
        output = concat(output, ')::int');
    elsif (field_type = 2) then
        output = concat(output, ')::float');
    elsif (field_type = 3) then
        output = concat(output, ')::text');
    elsif (field_type = 4) then
        output = concat(output, ')::date');
    end if;
    output = concat(output, ' as ', field_name);

    return output;
end;
$function$;

/*
target: 
*/
drop function if exists sql_condition;
create or replace function sql_condition(field_name text, field_type integer, field_operator text, field_value text)
returns text
language plpgsql
as $function$
declare
    output text := '';
begin
    output = concat(output , ' (data->', qt('field'), '->>', qt(field_name));
    if (field_type = 1) then
        output = concat(output, ')::int');
    elsif (field_type = 2) then
        output = concat(output, ')::float');
    elsif (field_type = 3) then
        output = concat(output, ')::text');
        field_value := qt(field_value);
    elsif (field_type = 4) then
        output = concat(output, ')::date');
        field_value := qt(field_value);
    end if;
    output = concat(output, ' ', field_operator);
    output = concat(output, ' ', field_value);
    output = concat(output, ' ');
    return output;
end;
$function$;