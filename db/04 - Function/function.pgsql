/*
Crop data from string 
select crop('id,name, ', ',' );
*/
drop function if exists crop;
create or replace function crop(text text, value text)
returns text
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
returns text
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
Get join
select get_join(1,1) -- No join
select get_join(1,2) -- Simple join
select get_join(1,3) -- Complex join (domain)
*/
drop function if exists get_join;
create or replace function get_join(systemId int, tableId int)
returns text
language plpgsql
as $function$
declare
    item record;
    sql text := '';
    tableAlias text := '';
    output text := '';
begin
    -- select row_to_json(tb_table)::text from tb_table
    sql := concat(sql, ' select');
    sql := concat(sql, ' t1.table_name base_table,');
    sql := concat(sql, ' t1.field_name,');
    sql := concat(sql, ' t1.id_fk,');
    sql := concat(sql, ' t1.domain_name,');
    sql := concat(sql, sql_column('t2','table_name', 3, '', ''));
    sql := concat(sql, ' from vw_table t1');
    sql := concat(sql, ' inner join tb_table t2 on t1.id_fk = t2.id'); 
    sql := concat(sql, ' where id_system = ', systemId);
    sql := concat(sql, ' and id_table = ', tableId);

    for item in execute sql loop
        if (item.id_fk = 4) then
            -- TB_DOMAIN
            tableAlias = concat('tb_', replace(item.field_name, 'id_', ''));
            output := concat(output, 'inner join ', item.table_name , ' ', tableAlias,  ' on ');
            output := concat(output, '(', item.base_table, '.field->>', qt(item.field_name), ')::int = (', tableAlias, '.field->>', qt('id_domain'), ')::int');
            output := concat(output, ' and (', tableAlias, '.field->>', qt('domain'), ')::text = ', qt(item.domain_name));
        elsif (item.id_fk = 2) then
            -- TB_TABLE
            tableAlias = concat('tb_', replace(item.field_name, 'id_', ''));
            output := concat(output, 'left join ', item.table_name , ' ', tableAlias,  ' on ');
            output := concat(output, '(', item.base_table, '.field->>', qt(item.field_name), ')::int = (', tableAlias, '.field->>', qt('id_domain'), ')::int');        
        else
            -- OTHER TABLES
            output := concat(output, 'inner join ', item.table_name , ' on ');
            output := concat(output, '(', item.base_table, '.field->>', qt(item.field_name), ')::int = ', item.table_name, '.id');
        end if;
        output := concat(output, ' ');
    end loop;
    return output;
end;
$function$;

create or replace function get_json(systemId integer, tableId integer, userId integer, actionId integer)
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
    session = concat(session, dbqt('id_user'), ':', userId, ',');
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

select get_output(0, 2, 23, 'exception goes here', 'warning goes here', '', '')
select get_output(0, 0, 0, 'exception goes here', '', '[]')
select get_output(1, 1, 0, '', '', '[{"id": 1, "url": "-", "name": "system", "id_system": 1, "table_name": "tb_system"}]');
select get_output(0, 0, 0, 'SQLERRM', '', '[]')::jsonb;
*/
drop function if exists get_output;
create or replace function get_output(status integer, actionId integer, id integer, error text, warning text, resultset text)
returns jsonb
language plpgsql
as $function$
declare
    output text := '';
    message text := '';
begin
    if (trim(error) = '') then
        if (actionId = 0) then
            message := ''; -- Query
        elsif if (actionId = 1) then
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
    output := concat(output, '"warning":', dbqt(warning), ',');
    output := concat(output, '"resultset":', resultset);
    output := concat(output, '}');
    raise notice '%', output;
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
    sql = concat(sql, sql_column('tb_table', 'table_name', 3, '', ''));
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
create or replace function is_unique(systemId integer, tableName text, fieldName text, fieldValue text)
returns boolean
language plpgsql
as $function$
declare
    sql varchar := '';
    item record;
begin
    sql = concat(sql, ' select * from ', tableName);
    sql = concat(sql, ' where (session->>', qt('id_system'), ')::int = ', systemId);
    sql = concat(sql, ' and ', sql_condition(fieldName, 3, '=', fieldValue));
    for item in execute sql loop
        return false;
    end loop;
    return true;
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
Set value between single quote
select qt('david');
*/
drop function if exists qt;
create or replace function qt(value text)
returns text
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
select sql_column('tb_system', 'id', '1', '', ''); -- int
select sql_column('tb_system', 'price', '100', '', ''); -- decimal (float)
select sql_column('tb_system', 'name', '3', '', ''); -- text
select sql_column('tb_system', 'expire_date', '4', 'dd/mm/yyyy', ''); -- date
select sql_column('tb_system', 'boolean', '5', '', ''); -- boolean (0/1 int)
*/
drop function if exists sql_column;
create or replace function sql_column(tableName text, fieldName text, fieldType integer, fieldMask text, fieldAlias text)
returns text
language plpgsql
as $function$
declare
    field text := '';
begin

    -- Table + Field Name
    field = concat(field , tableName, '.field', '->>', qt(fieldName));

    -- Field type
    if (fieldType = 1 or fieldType = 5) then
        field = concat('(', field, ')::int');
    elsif (fieldType = 2) then
        field = concat('(', field, ')::text');
    elsif (fieldType = 3) then
        field = concat('(', field, ')::text');
    elsif (fieldType = 4) then
        --field = concat('(', 'to_date(', field, ',', qt(fieldMask), '))::date');
        field = concat('(', field, ')::text');
    end if;

    -- Field alias
    if (fieldAlias = '') then 
        fieldAlias = fieldName;
    end if;
    
    field = concat(field, ' as ', fieldAlias);

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
    output = concat(output , ' (field', '->>', qt(fieldName));

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

/*
Sset value between single quote
select trace('david');
*/
drop function if exists trace;
create or replace function trace(v1 text, v2 text)
returns void
language plpgsql
as $function$
begin
    raise notice '%', concat(v1, ' ', v2);
end;
$function$;



/*
Get table name
select get_field_list(1,1) -- No join
select get_field_list(1,2) -- Join
select get_field_list(1,3) -- Domain
*/
drop function if exists get_field_list;
create or replace function get_field_list(systemId int, tableId int)
returns text
language plpgsql
as $function$
declare
    item1 record;
    item2 record;
    sql1 text := '';
    sql2 text := '';
    tableName text := '';
    fieldName text := '';    
    output text := '';
begin
    sql1 = concat('select * from vw_table where id_system = ', systemId, ' and id_table = ', tableId);
    for item1 in execute sql1 loop
        if (item1.id_fk = 0) then
            -- Same tables
            tableName := get_table(systemId, tableId);
            output := concat(output, sql_column(tableName, item1.field_name, item1.id_type, item1.field_mask, ''), ',');
        else
            -- Other tables, get first text field
            tableName := get_table(systemId, item1.id_fk);
            
            if (item1.id_fk = 4) then
                -- Domain
                tableName = concat('tb_', replace(item1.field_name, 'id_', ''));
                output := concat(output, sql_column(tableName, 'value', 3, item1.field_mask, item1.field_name), ',');                
            else
                -- Other foreign keys
                sql2 := '';
                sql2 := concat(sql2, ' select field_name, id_type, field_mask from vw_table');
                sql2 := concat(sql2, ' where id_system = ', systemId);
                sql2 := concat(sql2, ' and id_table = ', item1.id_fk);
                sql2 := concat(sql2, ' and id_type = ', 3);
                sql2 := concat(sql2, ' limit 1');
                for item2 in execute sql2 loop
                    output := concat(output, sql_column(tableName, item2.field_name, item2.id_type, item2.field_mask, item1.field_name), ',');
                end loop;
            end if;
        end if;
    end loop;
    output := crop(output, ',');
    execute trace('get_field_list: ', output);
    return output;
end;
$function$;

