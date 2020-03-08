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
    systemId int := 0;
    tableId int := 0;
    sql text := '';
    output text := '';
    item record;
    data text;
begin
    /*
    select get_condition('{"session":{"id_system":1,"id_table":1,"id_action":1},"filter":[{"field_name":"name", "operator":"=", "field_value":"1"}]}')
    */
    systemId := json->'session'->>'id_system';
    tableId := json->'session'->>'id_table';
    data := qt(json_extract_path(json::json, 'filter')::text);
        raise notice '%', json::json;
    sql := concat(sql, ' select x.field_name, x.operator, x.field_value::text, v.id_type field_type');
    sql := concat(sql, ' from json_to_recordset(', data, ') as x(field_name text, operator text, field_value text)');
    sql := concat(sql, ' inner join vw_table v on x.field_name = v.field_name');
    sql := concat(sql, ' where v.id_system = ', systemId);
    sql := concat(sql, ' and v.id_table = ', tableId);

    for item in execute sql
    loop
        output := concat(output, sql_condition(item.field_name, item.field_type, item.operator, item.field_value), ' and');
    end loop;
    if (trim(output) != '') then
        output := ' and ' || crop(output, ' and');
    end if;
    return output;
end;
$function$;

/*
Get table name
select get_join(1,1) -- success
select get_join(1,9) -- fail
*/
create or replace function get_join(json text)
returns text
language plpgsql
as $function$
declare
    item record;
    sql text := '';
    output text := '';
begin
    -- select row_to_json(tb_table)::text from tb_table
    sql := concat(sql, ' select');
    sql := concat(sql, ' t1.table_name base_table,');
    sql := concat(sql, ' t1.field_name,');
    sql := concat(sql, ' t1.id_fk,');
    sql := concat(sql, sql_column('table_name', 3, ''));
    sql := concat(sql, ' from vw_table t1');
    sql := concat(sql, ' inner join tb_table t2 on t1.id_fk = t2.id'); 
    sql := concat(sql, ' where id_table = 3');
    for item in execute sql loop
        output := concat(output, 'inner join ', item.table_name , ' on ');
        output := concat(output, item.base_table, '.', item.field_name, ' = ', item.table_name, '.id');
        output := concat(output, ' ');
    end loop;
    return output;
end;
$function$;

/*
Get table name
select get_table(1,1) -- success
select get_table(1,9) -- fail
*/
drop function if exists get_table;
create or replace function get_table(systemId integer, tableId integer)
returns text
language plpgsql
as $function$
declare
    sql text;
    item record;
begin
    sql = concat(sql, 'select');
    sql = concat(sql, sql_column('table_name', 3, ''));
    sql = concat(sql, ' from tb_table');
    sql = concat(sql, ' where id = ', tableId);
    sql = concat(sql, ' and ', sql_condition('id_system', 1, '=', systemId::text));
    for item in execute sql loop
    return item.table_name;
    end loop;
    raise exception 'tabela nao encontrada para codigo de sistema (%) e tabela (%)', systemId, tableId;
end;
$function$;

/*
Check if the record is unique at the table
select is_unique(1,'tb_system', 'name', 'formsss') -- true, dont exists
select is_unique(1,'tb_system', 'name', 'forms') -- false, already exists 
*/
drop function if exists is_unique;
create or replace function is_unique(systemId integer, tableName character varying, fieldName character varying, fieldValue character varying)
returns boolean
language plpgsql
as $function$
declare
    sql varchar := '';
    item record;    
begin
    sql = concat(sql, ' select * from ', tableName);
    sql = concat(sql, ' where (data->', qt('session'), '->>', qt('id_system'), ')::int = ', systemId);
    sql = concat(sql, ' and data->', qt('field'), '->>', qt(fieldName), ' = ', qt(fieldValue));
    for item in execute sql loop
        return false;    
    end loop;
    return true;
end;
$function$;

/*
Check if the record is unique at the table
select json_in(1,1,1)
*/
drop function if exists json_in;
create or replace function json_in(systemId int, tableId int, actionId int)
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
    session = concat(session, dbqt('id_system'), ':', systemId, ',');
    session = concat(session, dbqt('id_table'), ':', tableId, ',');
    session = concat(session, dbqt('id_action'), ':', actionId);
    session = concat(session, '}');

    -- Create record
    field = concat(field, dbqt('field'), ':', '{');
    sql := concat(sql, ' select field_name from vw_table');
    sql := concat(sql, ' where id_system = ', systemId);
    sql := concat(sql, ' and id_table = ', tableId);
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
select json_out(1, 1, 23, '', '')
select json_out(0, 2, 23, 'exception goes here', 'warning goes here')
*/
drop function if exists json_out;
create or replace function json_out(status int, actionId int, id int, error text, warning text)
returns jsonb
language plpgsql
as $function$
declare 
    output text := '';
    message text := '';
begin

    if (trim(error) = '') then
        if (actionId = 1) then 
            message := 'Registro INCLUÍDO com sucesso' || '. id: ' || id::text;
        elsif (actionId = 2) then
            message := 'Registro ALTERADO com sucesso' || '. id: ' || id::text;
        elsif (actionId = 3) then
            message := 'Registro EXCLUÍDO com sucesso' || '. id: ' || id::text;
        else
            message := 'Invalid action';    
        end if;
    else
        message := error;
    end if;

    output := concat(output, '{');
    output := concat(output, '"status":', status, ',');
    output := concat(output, '"id":', id, ',');
    output := concat(output, '"action":', actionId, ',');
    output := concat(output, '"message":', dbqt(message), ',');
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
select parse_date('25/12/2021', 'dd/mm/yyyy') -- true
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
create or replace function qt(value text)
returns character varying
language plpgsql
as $function$
begin
    return '''' || value || '''';    
end;
$function$;

/*
author: david lancioni
target: Return sql for select clause in json format
Tests:
select sql_column('id', '1', ''); -- int
select sql_column('price', '2', ''); -- decimal (float)
select sql_column('name', '3', ''); -- text
select sql_column('expire_date', '4', 'dd/mm/yyyy'); -- date
select sql_column('boolean', '5', ''); -- boolean (0/1 int)
*/
drop function if exists sql_column;
create or replace function sql_column(fieldName text, fieldType integer, fieldMask text)
returns text
language plpgsql
as $function$
declare
    field text := '';
begin
    field = concat(field , 'data->', qt('field'), '->>', qt(fieldName), ' ');
    if (fieldType = 1 or fieldType = 5) then
        field = concat('(', field, ')::int');
    elsif (fieldType = 2) then
        field = concat('(', field, ')::float');
    elsif (fieldType = 3) then
        field = concat('(', field, ')::text');
    elsif (fieldType = 4) then
        field = concat('(', 'to_date(', field, ',', qt(fieldMask), '))::date');
    end if;
    field = concat(field, ' as ', fieldName);
    return field;
end;
$function$;

/*
target: 
*/
drop function if exists sql_condition;
create or replace function sql_condition(fieldName text, fieldType integer, fieldOperator text, fieldValue text)
returns text
language plpgsql
as $function$
declare
    output text := '';
begin
    -- Note: apply single quote on data and string
    output = concat(output , ' (data->', qt('field'), '->>', qt(fieldName));
    if (fieldType = 1) then
        output = concat(output, ')::int');
    elsif (fieldType = 2) then
        output = concat(output, ')::float');
    elsif (fieldType = 3) then
        output = concat(output, ')::text');
        fieldValue := qt(fieldValue);
    elsif (fieldType = 4) then
        output = concat(output, ')::date');
        fieldValue := qt(fieldValue);
    end if;
    output = concat(output, ' ', fieldOperator);
    output = concat(output, ' ', fieldValue);
    output = concat(output, ' ');
    return output;
end;
$function$;