/*
Set value between single quote
*/
drop function if exists return;
create or replace function return(status text, message text, warning text default '', action text default '', id text default '0', resultset text default '')
returns jsonb
language plpgsql
as $function$
declare
    output jsonb := '{}'; 
begin

    -- Set values
    output := json_set(output, 'status', status, 'I');
    output := json_set(output, 'message', message, 'I');
    output := json_set(output, 'warning', warning, 'I');
    output := json_set(output, 'action', action, 'I');
    output := json_set(output, 'id', id, 'I');
    output := json_set(output, 'resultset', resultset, 'I');

    -- Return output
    return output;

end;
$function$;

/*
Sset value between single quote
select trace('Error code: ', '255');
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

-----------------------------------------------------------------
-- FUNCTION TO MANIPULATE STRINGS
-----------------------------------------------------------------
/*
Parse string in a valid date
select is_date('', 'yyyy/MM/dd') -- true (nothing to parse)
select is_date('2020/12/31', 'yyyy/MM/dd') -- true
select is_date('', 'dd/mm/yyyy') -- false
select is_date('25/12/2021', 'dd/mm/yyyy') -- true
*/
drop function if exists is_date;
create or replace function is_date(date text, mask text)
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
Check if the record is unique at the table
select is_decimal('1'); -- true
select is_decimal('d'); -- false
select is_decimal('10,2'); -- false
select is_decimal('10.2'); -- false
*/
drop function if exists is_decimal;
create or replace function is_decimal(value text)
returns boolean
language plpgsql
as $function$
declare 
    x numeric;
begin
    x = value::numeric;
    return true;
exception when others then
    return false;
end;
$function$;

/*
Check if the record is unique at the table
select is_integer('1'); -- true
select is_integer('d'); -- false
select is_integer('10,2'); -- false
select is_integer('10.2'); -- false
*/
drop function if exists is_integer;
create or replace function is_integer(value text)
returns boolean
language plpgsql
as $function$
declare 
    x int;
begin
    x = value::int;
    return true;
exception when others then
    return false;
end;
$function$;

/*
Crop data from string 
select crop('id,name, ', ',');
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

-----------------------------------------------------------------
-- FUNCTION TO MANIPULATE SQL
-----------------------------------------------------------------
/*
Return sql code to select fields
select sql_field('tb_client', 'name', 'client_name')
select sql_field('tb_client', 'name')
select sql_field('tb_client', 'field')
select sql_field('tb_client', 'session')
 */
drop function if exists sql_field;
create or replace function sql_field(tableName text, fieldName text, fieldAlias text default '')
returns text
language plpgsql
as $function$
declare
    sql text := '';
begin
    -- No alias, repeat field name
    if (fieldAlias = '') then
        fieldAlias = fieldName;
    end if;

    -- Entire field
    if (fieldName = 'field') then
        sql := concat(sql, tableName, '.field', ' ', fieldAlias);
    -- Entire field
    elsif (fieldName = 'session') then
        sql := concat(sql, tableName, '.session', ' ', fieldAlias);
    -- Specific column
    else
        sql := concat(sql, tableName, '.field->>', qt(fieldName), ' ', fieldAlias);
    end if;

    return sql;
end;
$function$;

/*
Return sql from and remove last comma
select sql_from('tb_rel_event')
 */
drop function if exists sql_from;
create or replace function sql_from(tableName text)
returns text
language plpgsql
as $function$
declare
    sql text := '';
begin
    sql := concat(sql, ' from ', tableName); 
    return sql;
end;
$function$;

/*
Mandatory condition for all queries
select sql_where('tb', '1')
 */
drop function if exists sql_where;
create or replace function sql_where(tableName text, systemId text)
returns text
language plpgsql
as $function$
declare
    sql text := '';
begin
    sql = concat(sql, ' where (', tableName, '.session->>', qt('id_system'), ')::int = ', systemId);
    return sql;
end;
$function$;

/*
Mandatory condition for all queries
select sql_and('tb_rel_event', 'key', '1')
select sql_and('tb_rel_event', 'key', 'new')
 */
drop function if exists sql_and;
create or replace function sql_and(tableName text, fieldName text, fieldValue text)
returns text
language plpgsql
as $function$
declare
    sql text := '';
begin
    if (is_decimal(fieldValue)) then
        sql := concat(sql, ' and (', tableName, '.field->>', qt(fieldName), ')::int = ', fieldValue);            
    else    
        sql := concat(sql, ' and (', tableName, '.field->>', qt(fieldName), ')::text = ', qt(fieldValue));
    end if;    

    return sql;
end;
$function$;

/*
Return sql that creates dynamic conditions
select sql_condition('tb1', 'id', 'integer', '=', '1');
select sql_condition('tb1', 'amount', 'decimal', '>', '10.99');
select sql_condition('tb1', 'name', 'string', '=', 'David');
select sql_condition('tb1', 'expire_date', 'date', '=', '31/12/2014', 'dd/mm/yyyy');
select sql_condition('tb1', 'id_mandatory', 'boolean', '=', '1');
*/
drop function if exists sql_condition;
create or replace function sql_condition(tableName text, fieldName text, fieldType text, fieldOperator text, fieldValue text, fieldMask text default '')
returns text
language plpgsql
as $function$
declare
    output text := ' and ';
begin

    -- Handle default operator
    if (trim(fieldOperator) = '') then
        fieldOperator = '=';
    end if;

    -- Note: apply single quote on data and string
    if (fieldType = 'date') then
        output = concat(output , ' (to_date(', tableName, '.field', '->>', qt(fieldName), ', ', fieldMask, ')');
    else
        output = concat(output , ' (', tableName, '.field', '->>', qt(fieldName));
    end if;

    if (fieldType = 'integer') then
        output = concat(output, ')::int');
    elsif (fieldType = 'decimal') then
        output = concat(output, ')::float');
    elsif (fieldType = 'string') then
        output = concat(output, ')::text');
        fieldValue := qt(fieldValue);
    elsif (fieldType = 'date') then
        output = concat(output, ')::date');
        fieldValue := concat('to_date(', qt(fieldValue), ', ', qt(fieldMask), ')');
    elsif (fieldType = 'boolean') then
        output = concat(output, ')::text');
    else
        raise exception 'Invalid data type %', fieldType;
    end if;

    output = concat(output, ' ', fieldOperator);
    output = concat(output, ' ', fieldValue);
    output = concat(output, ' ');

    return output;
end;
$function$;

/*
author: david lancioni
target: Return sql for select clause in json format
Tests:
select sql_column('tb_system', 'id', 'integer');
select sql_column('tb_system', 'price', 'decimal');
select sql_column('tb_system', 'name', 'string');
select sql_column('tb_system', 'name', 'text');
select sql_column('tb_system', 'exp_dt', 'date', 'dd/mm/yyyy', 'expire_date');
select sql_column('tb_system', 'boolean', 'boolean', '', 'flag_confirm');
*/
drop function if exists sql_column;
create or replace function sql_column(tableName text, fieldName text, fieldType text, fieldMask text default '', fieldAlias text default '')
returns text
language plpgsql
as $function$
declare
    field text := '';
begin

    -- Table + Field Name
    field = concat(field , tableName, '.field', '->>', qt(fieldName));

    -- Field type
    if (fieldType = 'integer') then
        field = concat('(', field, ')::int');
    elsif (fieldType = 'decimal') then
        field = concat('(', field, ')::float');        
    elsif (fieldType = 'boolean') then
        field = concat('(', field, ')::int');
    elsif (fieldType = 'string') then
        field = concat('(', field, ')::text');
    elsif (fieldType = 'text') then
        field = concat('(', field, ')::text');
    elsif (fieldType = 'date') then
        field = concat('(', field, ')::text');
    else
        raise exception 'Invalid data type %', fieldType;        
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
Return sql code to join tables
select sql_join('tb_client', 'id_address', 'tb_address', 'address', 'id')
select sql_join('tb_client', 'id_address', 'tb_domain', 'tb_domain_event', 'key', 'tb_event')
 */
drop function if exists sql_join;
create or replace function sql_join(baseTable text, baseField text, joinTable text, joinTableAlias text, joinField text, domainName text default '')
returns text
language plpgsql
as $function$
declare
    sql text := '';
begin
    if (domainName != '')  then
        sql := concat(sql, ' inner join ', joinTable, ' ', joinTableAlias, ' on');
        sql := concat(sql, ' (', baseTable, '.field->>', qt(baseField), ')::text = (', joinTableAlias, '.field->>', qt(joinField), ')::text');
        sql := concat(sql, ' and ', joinTableAlias, '.field->>', qt('domain'), ' = ', qt(domainName));
    else
        sql := concat(sql, ' left join ', joinTable, ' ', joinTableAlias, ' on');
        sql := concat(sql, ' (', baseTable, '.field->>', qt(baseField), ')::int = (', joinTableAlias, '.field->>', qt(joinField), ')::int');
    end if;

    return sql;
end;
$function$;

/*
Get join
select get_join('1','1') -- No join
select get_join('1','2') -- Simple join
select get_join('1','3') -- Complex join (domain)
*/
drop function if exists get_join;
create or replace function get_join(systemId text, tableId text)
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
    sql := concat(sql, ' t1.field_fk,');
    sql := concat(sql, ' t1.domain_name,');
    sql := concat(sql, sql_column('t2','table_name', 'string', '', ''));
    sql := concat(sql, ' from vw_table t1');
    sql := concat(sql, ' inner join tb_table t2 on t1.field_fk = t2.id'); 
    sql := concat(sql, ' where id_system = ', systemId);
    sql := concat(sql, ' and id_table = ', tableId);

    for item in execute sql loop
        -- Domain
        if (item.field_fk = 4) then
            tableAlias = concat('tb_', replace(item.field_name, 'id_', 'fk_'));
            output := concat(output, sql_join(item.base_table, item.field_name, item.table_name, tableAlias, 'key', item.domain_name));
        else
            -- FKs
            tableAlias = concat('tb_', replace(item.field_name, 'id_', 'fk_')); 
            output := concat(output, sql_join(item.base_table, item.field_name, item.table_name, tableAlias, 'id'));
        end if;
        output := concat(output, ' ');
    end loop;
    return output;
end;
$function$;

/*
Get table structure
select get_struct('1','1');
*/
drop function if exists get_struct;
create or replace function get_struct(systemId text, tableId text)
returns text
language plpgsql
as $function$
declare sql text := '';
begin
	sql := '';		
	sql := concat(sql, ' select * from vw_table');
	sql := concat(sql, ' where id_system = ', systemId);
	sql := concat(sql, ' and id_table = ', tableId);
	execute trace('SQL: ', sql);
    return sql;
end;
$function$;

/*
Get dynamic and condition
select get_condition('{"session":{"id_system":1,"id_table":2,"id":0,"id_event":6,"page_offset":0},"filter":[{"field_name":"id_system","operator":"","field_value":"1"}]}')
*/
drop function if exists get_condition;
create or replace function get_condition(json jsonb)
returns text
language plpgsql
as $function$
declare
    systemId text := 0;
    tableId text := 0;
    sql text := '';
    output text := '';
    item record;
    data text;
begin

    -- Mandatory input parameter
    systemId := json->'session'->>'id_system';
    tableId := json->'session'->>'id_table';
    data := qt(json_extract_path(json::json, 'filter')::text);
    execute trace('Data: ', data::text);

    if (data != '') then

        -- Discard fields not related to current table
        sql := concat(sql, ' select');
        sql := concat(sql, ' v.table_name,');
        sql := concat(sql, ' x.field_name,');
        sql := concat(sql, ' x.operator,');
        sql := concat(sql, ' x.field_value::text,');
        sql := concat(sql, ' v.field_type,');
        sql := concat(sql, ' v.field_mask');
        sql := concat(sql, ' from json_to_recordset(', data, ') as x(field_name text, operator text, field_value text)');
        sql := concat(sql, ' inner join vw_table v on x.field_name = v.field_name');
        sql := concat(sql, ' where v.id_system = ', systemId);
        sql := concat(sql, ' and v.id_table = ', tableId);
        execute trace('SQL: ', sql);

        -- Concatenate output conditions
        for item in execute sql loop
            output := concat(output, sql_condition(item.table_name, item.field_name, item.field_type, item.operator, item.field_value, item.field_mask));
        end loop;

        -- Crop last and
        if (trim(output) != '') then
            output := ' and ' || crop(output, ' and');
        end if;

    end if;

    -- Return final condition
    return output;
end;
$function$;

/*
Get table name
select get_table('1','1') -- success
select get_table('1','9') -- fail
*/
drop function if exists get_table;
create or replace function get_table(systemId text, tableId text)
returns text
language plpgsql
as $function$
declare
    sql text;
    item record;
begin

    sql := concat(sql, 'select ');
    sql := concat(sql, sql_field('tb_table', 'table_name'));
    sql := concat(sql, sql_from('tb_table'));
    sql := concat(sql, sql_where('tb_table', systemId));
    sql := concat(sql, sql_and('tb_table', 'id', tableId));

    for item in execute sql loop
        return item.table_name;
    end loop;
    raise exception 'tabela nao encontrada para codigo de sistema (%) e tabela (%)', systemId, tableId;
end;
$function$;

/*
Get table name
select get_title('1','1') -- success
select get_title('1','9') -- fail
*/
drop function if exists get_title;
create or replace function get_title(systemId text, tableId text)
returns text
language plpgsql
as $function$
declare
    sql text;
    item record;
begin

    sql := concat(sql, 'select ');
    sql := concat(sql, sql_field('tb_table', 'caption'));
    sql := concat(sql, sql_from('tb_table'));
    sql := concat(sql, sql_where('tb_table', systemId));
    sql := concat(sql, sql_and('tb_table', 'id', tableId));

    for item in execute sql loop
        return item.caption;
    end loop;
    raise exception 'tabela nao encontrada para codigo de sistema (%) e tabela (%)', systemId, tableId;
end;
$function$;

/*
Check if the record is unique at the table
select is_unique('1', 'tb_system', 'name', 'formsss') -- true, dont exists
select is_unique('1', 'tb_system', 'name', 'Forms') -- false, already exists 
select is_unique('1', 'tb_field', 'domain', '') -- false, already exists 
*/
drop function if exists is_unique;
create or replace function is_unique(systemId text, tableName text, fieldName text, fieldValue text)
returns boolean
language plpgsql
as $function$
declare
    fieldType text = 'string';
    sql text := '';
    item record;
begin

    if (trim(fieldValue) != '' and fieldName <> 'id') then
        sql := concat(sql, 'select ');
        sql := concat(sql, sql_field(tableName, 'id'));
        sql := concat(sql, sql_from(tableName));
        sql := concat(sql, sql_where(tableName, systemId));
        sql := concat(sql, sql_condition(tableName, fieldName, fieldType, '=', fieldValue, ''));

        for item in execute sql loop
            return false;
        end loop;
    end if;

    return true;
end;
$function$;

/*
Get table name
select get_field_list('1','1') -- No join
select get_field_list('1','2') -- Join
select get_field_list('1','3') -- Domain
*/
drop function if exists get_field_list;
create or replace function get_field_list(systemId text, tableId text)
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
    fieldType text := 'string';
    output text := '';
begin
    sql1 := get_struct(systemId, tableId);

    for item1 in execute sql1 loop
        if (item1.field_fk = 0) then
            -- Same tables
            tableName := get_table(systemId, tableId);
            output := concat(output, sql_column(tableName, item1.field_name, item1.field_type, item1.field_mask, ''), ',');
        else
            -- Other tables, get first text field
            tableName := get_table(systemId, item1.field_fk::text);
            
            if (item1.field_fk = 4) then
                -- Domain
                tableName = concat('tb_', replace(item1.field_name, 'id_', 'fk_'));
                output := concat(output, sql_column(tableName, 'value', fieldType, item1.field_mask, item1.field_name), ',');
            else
                -- Other foreign keys
                tableName = concat('tb_', replace(item1.field_name, 'id_', 'fk_'));                
                sql2 := '';               
                sql2 = get_struct(systemId, item1.field_fk::text);
                sql2 := concat(sql2, ' and field_type = ', qt('string'));
                sql2 := concat(sql2, ' limit 1');

                for item2 in execute sql2 loop
                    output := concat(output, sql_column(tableName, item2.field_name, item2.field_type, item2.field_mask, item1.field_name), ',');
                end loop;

            end if;
        end if;
    end loop;
    output := crop(output, ',');
    execute trace('get_field_list: ', output);
    return output;
end;
$function$;

/*
Set value between double quote
select get_event('1', '1', '1', 'not used', '1');
select get_event('1', '1', '2', '1', '1');
select get_event('1', '1', '2', '2', '1');
select get_event('1', '1', '2', '3', '1');
select get_event('1', '1', '2', '5', '1');
*/
drop function if exists get_event;
create or replace function get_event(systemId text, tableId text, targetId text, eventId text, recordCount text)
returns text
language plpgsql
as $function$
declare
    sql text := '';
    html text := '';  
    eventName text := '';  
    item record;  
begin

    -- Get event name
    sql := '';
    sql := concat(sql, ' select ');    
    sql := concat(sql, sql_field('tb_event', 'name', 'event_name'));
    sql := concat(sql, sql_from('tb_event'));    
    sql := concat(sql, sql_where('tb_event', systemId));    
    sql := concat(sql, sql_and('tb_event', 'id', eventId));
    execute trace('sql: ', sql);
    for item in execute sql loop
        eventName := item.event_name;
    end loop;

    -- Prepare query to get actions (buttons)
    sql := '';
    sql := concat(sql, ' select ');
    sql := concat(sql, sql_field('tb_event', 'id'), ',');
    sql := concat(sql, sql_field('tb_event', 'id_table'), ',');
    sql := concat(sql, sql_field('tb_event', 'id_target'), ',');
    sql := concat(sql, sql_field('tb_event', 'display'), ',');
    sql := concat(sql, sql_field('tb_event', 'id_event'), ',');
    sql := concat(sql, sql_field('tb_event', 'code'), ',');
    sql := concat(sql, sql_field('tb_domain_event', 'value', 'event_name'));
    sql := concat(sql, sql_from('tb_event'));
    sql := concat(sql, sql_join('tb_event', 'id_event', 'tb_domain', 'tb_domain_event', 'key', 'tb_event'));   

    -- Handle related events (report/filter cannot present form/save)
    if (targetId = '2') then
        sql := concat(sql, sql_join('tb_event', 'name', 'tb_domain', 'tb_rel_event', 'value', 'tb_rel_event'));
        sql := concat(sql, sql_and('tb_rel_event', 'key', eventName));
    end if;    

    -- Get events for specific screen (form or report)
    sql := concat(sql, sql_where('tb_event', systemId));    
    sql := concat(sql, sql_and('tb_event', 'id_table', tableId));
    sql := concat(sql, sql_and('tb_event', 'id_target', targetId));

    -- On report when no data, only [New] is presented
    if (targetId = 'report' and (recordCount)::int = 0) then
        sql := concat(sql, sql_and('tb_event', 'id', '1'));
    end if;
	execute trace('sql: ', sql);

    ---
    --- Actions (Buttons)
    ---
    html := concat(html, '<center>');
    for item in execute sql loop
        html := concat(html, '<input');
        html := concat(html, ' type=', dbqt('button'));
        html := concat(html, ' class=', dbqt('w3-button w3-blue'));
        html := concat(html, ' id=', dbqt(item.id));
        html := concat(html, ' value=', dbqt(item.display));
        html := concat(html, ' ', item.event_name, ' = ', dbqt(item.code));
        html := concat(html, ' >');            
        html := concat(html, ' &nbsp;');  
    end loop;    
    html := concat(html, '</center>');

    ---
    --- return buttons as html
    ---
    return html;

end;
$function$;

/*
Get existing js code for current module
select get_js('1', '1');
*/
drop function if exists get_js;
create or replace function get_js(systemId text, tableId text)
returns text
language plpgsql
as $function$
declare
    sql text := '';
    html text := '';  
    item record;  
begin
    sql := concat(sql, ' select');
    sql := concat(sql, ' field->>', qt('id'), ' id');
    sql := concat(sql, ' ,field->>', qt('code'), ' code');
    sql := concat(sql, ' from tb_code');
    sql := concat(sql, ' where (session->', qt('id_system'), ')::int = ', systemId);
	execute trace('sql: ', sql);

    html := concat(html, '<script langauage="JavaScript">');    
    for item in execute sql loop
        html := concat(html, item.code);
    end loop;
    html := concat(html, '</script>');

    return html;
end;
$function$;

---------------------------------------------------------------------------------
-- HTML function
---------------------------------------------------------------------------------
/*
Get an html input element (hidden, text, select)
select html_input('text', 'ir_order', '123456', '', '', 'onclick=alert(123)');
 */
drop function if exists html_input;
create or replace function html_input(htmlType text, fieldName text, fieldValue text, disabled text, checked text, events text)
returns text
language plpgsql
as $function$
declare
    html text := '';
begin

    html := concat(html, ' <input ');
    html := concat(html, ' type=', dbqt(htmlType));    
    html := concat(html, ' id=', dbqt(fieldName));
    html := concat(html, ' name=', dbqt(fieldName));
    html := concat(html, ' value=', dbqt(fieldValue));
    html := concat(html, ' ', disabled);
    html := concat(html, ' ', events);

    if (htmlType = 'text') then
        html := concat(html, ' class=', dbqt('w3-input w3-border'));
    end if;    
    if (htmlType = 'radio') then
        html := concat(html, ' ', checked);
    end if;
    html := concat(html, '>');

    return html;
end;
$function$;

/*
Generate HTML option list for dropdown
select html_option('1', '3', '2');
select html_option('1', '4', '2', 'tb_operator');
*/
drop function if exists html_option;
create or replace function html_option(systemId text, fieldFk text, selectedValue text, domainName text default '')
returns text
language plpgsql
as $function$
declare
    html text := '';
    sql1 text := '';
    sql2 text := '';    
    item1 record;
    item2 record;
begin

    -- Empty item    
    html := concat(html, '<option value="0">');
    html := concat(html, 'Selecionar');
    html := concat(html, '</option>');            

    -- Figure out ID and DS to populate dropdown
    execute trace('fieldFk: ', fieldFk::text);

    -- Generate query selecting first Int and first String (ID, DS) from each table            
    if (fieldFk = '4') then
        -- Domain table
        sql2 := 'select ';
        sql2 := concat(sql2, sql_field('tb_domain', 'key', 'id'), ',');
        sql2 := concat(sql2, sql_field('tb_domain', 'value', 'ds'));
        sql2 := concat(sql2, sql_from('tb_domain'));
        sql2 := concat(sql2, sql_where('tb_domain', systemId));
        sql2 := concat(sql2, sql_condition('tb_domain', 'domain', 'string', '=', domainName));
    else
        -- Other tables
        sql2 := 'select ';
        
        sql1 := concat('select field_name from vw_table where id_system = ', systemId, ' and field_type = ', qt('integer'), ' limit 1 ');
        for item1 in execute sql1 loop
            sql2 := concat(sql2, 'field->>', qt(item1.field_name), ' as id', ',');
        end loop;

        sql1 := concat('select field_name from vw_table where id_system = ', systemId, ' and field_type = ', qt('string'), ' limit 1 ');        
        for item1 in execute sql1 loop
            sql2 := concat(sql2, 'field->>', qt(item1.field_name), ' as ds');
        end loop;              

        sql2 := concat(sql2, ' from ', get_table(systemId, fieldFk));
    end if;
    execute trace('sql2: ', sql2);            

    -- Populate the dropdown
    for item2 in execute sql2 loop
        html := concat(html, '<option value=', dbqt(item2.id));
        if (trim(selectedValue::text) = (item2.id::text)) then
            html := concat(html, ' selected ');
        end if;
        html := concat(html, '>');
        html := concat(html, item2.ds);
        html := concat(html, '</option>');
    end loop;

    return html;

end;
$function$;

/*
Return sql code to select fields
Note: html_option is able to figure out ID and DS
select html_dropdown('1', 'id_system', '2', '1')
select html_dropdown('1', 'id_system', '4', '1', 'tb_operator')
 */
drop function if exists html_dropdown;
create or replace function html_dropdown(systemId text, fieldName text, fieldFk text, fieldValue text, domainName text default '')
returns text
language plpgsql
as $function$
declare
    html text := '';
begin
    html := concat(html, ' <select ');
    html := concat(html, ' class=', dbqt('w3-input w3-border'));
    html := concat(html, ' id=', dbqt(fieldName));
    html := concat(html, ' name=', dbqt(fieldName));            
    html := concat(html, ' >');
    html := concat(html, html_option(systemId, fieldFk, fieldValue, domainName));
    html := concat(html, '</select>');

    return html;
end;
$function$;

/*
Return html code to drow text area
select html_textarea('code', 'abcdef')
select html_textarea('code', 'abcdef', 5, 30)
 */
drop function if exists html_textarea;
create or replace function html_textarea(fieldName text, fieldValue text, rows text default 20, cols text default 135)
returns text
language plpgsql
as $function$
declare
    html text := '';
begin
    html := concat(html, ' <textarea ');
    html := concat(html, ' id=', dbqt(fieldName));
    html := concat(html, ' name=', dbqt(fieldName));
    html := concat(html, ' rows=', dbqt(rows));
    html := concat(html, ' cols=', dbqt(cols));
    html := concat(html, ' >');
    html := concat(html, fieldValue);
    html := concat(html, '</textarea>');

    return html;
end;
$function$;

/*
Manipulate json based on based on simple
Note that we must work with single level json (DO NOT COMPLICATE THINGS ANYMORE)
select json_set('{"id_system":1,"id_table":1}', 'id_language', '99', 'I')
select json_set('{"id_system":1,"id_table":1}', 'id_user', '99')
select json_set('{"id_system":1,"id_table":1}', 'id_user', 'blabla', 'D')
 */
drop function if exists json_set;
create or replace function json_set(json jsonb, fieldName text, fieldValue text default '', action text default 'U')
returns jsonb
language plpgsql
as $function$
declare
    field text[2];
begin

    action := upper(action);
    field[1] = fieldName;

    -- If value is numeric
    if (is_decimal(fieldValue)) then 
        if (fieldValue = '') then
            fieldValue = '0';
        end if;
    else
        fieldValue := dbqt(fieldValue);
    end if;

    -- Create new element
    if (action = 'I') then
        json:= jsonb_set(json, field, fieldValue::jsonb, true);
    end if;

    -- Update value on existing element (default action)
    if (action = 'U') then
        json:= jsonb_set(json, field, fieldValue::jsonb, false);
    end if;

    -- Remove existing element
    if (action = 'D') then
        json:= json - fieldName;
    end if;    

    return json;

end;
$function$;

/*
Create valid json based on input data
select parse_json('{"session":{"id_system":1,"id_table":1,"id_user":1, "id_action":1}}')
select parse_json('{"session":{"id_system":1,"id_table":2,"id_user":1, "id_action":4,"page_limit":5,"page_offset":0},"filter":[]}')
select parse_json('{"session":{"id_system":1,"id_table":1,"id_action":1,"id_user":1},"field":{"id":0,"name_":"lancioni it","expire_date":"31/12/2021","price":1200}}') -- IUD
select parse_json('{"session":{"id_system":1,"id_table":6,"id_user":1,"id_action":2},"field":{"id":1,"__id__":"1","code":"function helloWorld() {alert(''''Hello World'''');}"}}'); 
select persist('{"session":{"id_system":1,"id_table":6,"id_user":1,"id_action":2},"field":{"id":1,"__id__":"1","code":"function helloWorld() {alert(''''Hello World'''');}"}}'); 
 */
drop function if exists parse_json;
create or replace function parse_json(json jsonb)
returns jsonb
language plpgsql
as $function$
declare
    json2 jsonb;
    sql1 text := '';
    sql2 text := '';
    jsons jsonb;
    jsonf jsonb;
    item1 record;
    item2 record;
    fieldList text := '';

begin

	-- Keep key parameters
	jsons := json->'session';
	jsonf := json->'field';	

    -- Validate base elements (session and field)
    if (jsons is null) then
        raise exception 'Invalid json, session data is missing';
    end if;

    -- Validate missing session elements
    if (jsons->>'id_system' is null) then
        raise exception 'Invalid session, % is missing', 'id_system';
    end if;

    if (jsons->>'id_table' is null) then
        raise exception 'Invalid session, % is missing', 'id_table';
    end if;

    if (jsons->>'id_user' is null) then
        raise exception 'Invalid session, % is missing', 'id_user';
    end if;

    if (jsons->>'id_action' is null) then
        raise exception 'Invalid session, % is missing', 'id_action';
    end if;

    -- Validate actions
	if (position(jsons->>'id_action'::text in '1234') = 0) then
	    raise exception 'Action is invalid or missing: %', jsons->>'id_action';
    else
        if (jsons->>'id_action'::text = '4') then
            if (jsons->>'page_limit' is null) then
                raise exception 'Invalid session, % is missing', 'page_limit';
            end if;
            if (jsons->>'page_offset' is null) then
                raise exception 'Invalid session, % is missing', 'page_offset';
            end if;
        end if;
	end if;

    if (position(jsons->>'id_action'::text in '123') > 0) then
        if (json->'field' is null) then
            raise exception 'Invalid json, field data is missing';
        end if;
    end if;

    -- Keep fields related to current transaction
    sql1 := get_struct((jsons->>'id_system')::text, (jsons->>'id_table')::text);
    for item1 in execute sql1 loop
        fieldList := concat(fieldList, item1.field_name::text, '|');
    end loop;

    -- Remove invalid elements
    sql2 := concat('select * from json_each(', qt((json->'field')::text), ')');
    execute trace('json query: ', sql2);
    for item2 in execute sql2 loop        
        if (position(item2.key in fieldList) = 0) then
            jsonf := json_set(jsonf, item2.key::text, '', 'D');
        end if;
    end loop;

    -- Set fields back to main json
    json := jsonb_set(json, '{field}', jsonf);

    -- Finish it
    return json;

end;
$function$;

/*
Insert json into table and stamp generate id
select stamp('tb_code', '{"id":0}', '{"name":"0"}')
select stamp('tb_code', '{"id_system":1,"id_table":2,"id_user":1,"id_action":1}', '{"id":0,"__id__":"1","id_system":"1","name":"Customer","caption":"system_999","table_name":"tb_customer"}')
*/

drop function if exists stamp;
create or replace function stamp(tableName text, jsons jsonb, jsonf jsonb)
returns text
language plpgsql
as $function$
declare
	id text := '0';
    sql text := '';
begin

    -- Prepare statement
    sql := concat(sql, 'insert into ', tableName, ' (session, field) values (', qt(jsonf::text), ',', qt(jsonf::text) ,')');
    execute sql;

    -- Get inserted id and stamp in the json
    select currval(pg_get_serial_sequence(tableName, 'id')) into id;

    -- jsonf := jsonb_set(jsonf, '{id}', dbqt(id::text)::jsonb, false);
    jsonf := json_set(jsonf, 'id', id::text);

    -- Save new json
    sql := '';
    sql := concat(sql, ' update ', tableName, ' set');
    sql := concat(sql, ' session = ', qt(jsons::text), ','); 
    sql := concat(sql, ' field = ', qt(jsonf::text)); 
    sql := concat(sql, ' where id = ', id);
    execute sql;

    -- Trace new record
    execute trace('sql: ', sql); 

    -- Return generated id
    return id;

end;
$function$;


/* 
select persist('{"session":{"id_system":1,"id_table":6,"id_user":1,"id_action":1},"field":{"id":1,"__id__":"1","code":"function helloWorld() {alert(''''Hello World'''');}"}}'); 
select persist('{"session":{"id_system":1,"id_table":6,"id_user":1,"id_action":2},"field":{"id":1,"__id__":"1","code":"function helloWorld() {alert(''''Hello World'''');}"}}'); 
select persist('{"session":{"id_system":1,"id_table":6,"id_action":3,"id_user":1},"field":{"id":7}}'); 

*/
drop function if exists persist;
create or replace function persist(data jsonb)
returns jsonb
language plpgsql
as $function$
declare

	id text := '';
	tableId text := '';
	actionId text := '';
    systemId text := '';
    fieldType text := '';
	fieldUnique text := '';	
	fieldMandatory text := '';

	old text := '';
	new text := '';
	sql text := '';
	output text := '';	
	tableName text := '';
	fieldName text := '';
	fieldValue text := '';
	fieldMask text := '';
    message text := '';
    warning text := '';
    item record;
	jsone jsonb; -- existing json on database
	jsons jsonb; -- session part
	jsonf jsonb; -- field part

    ACTION_INSERT text := '1';
    ACTION_UPDATE text := '2';
    ACTION_DELETE text := '3';

    SUCCESS text := '1';
    FAIL text := '1';

begin
	-- Start processing
	execute trace('Begin Persist(): ', data::text);

	-- Validate inputed data
	data := parse_json(data);

	-- Separate session and field to let things simple
	jsons := data->'session';
	jsonf := data->'field';	

    -- Keep key parameters
	id = jsonf->>'id';
	systemId := jsons->>'id_system';
	tableId := jsons->>'id_table';
	actionId = jsons->>'id_action';

	-- Must figure out table name
	sql := get_struct(systemId, tableId);
	for item in execute sql loop
		tableName = item.table_name;
	end loop;

	------------------------------------------------
	------------------------------------------------ INSERT
	------------------------------------------------
	if (actionId = ACTION_INSERT) then

		-- Before insert
		execute trace('Validating before INSERT: ', actionId::text);

		-- Validate input and persist
		sql := get_struct(systemId, tableId);

		for item in execute sql loop

			-- Keep key information
			fieldName = trim(item.field_name);
			fieldType = trim(item.field_type);
			fieldValue = trim(jsonf->>fieldName);
			fieldMask = trim(item.field_mask);
			fieldMandatory = trim(item.id_mandatory);
			fieldUnique = trim(item.id_unique);

			-- Validate mandatory fields
			if (fieldMandatory = 'Y') then
				if (fieldValue = null or fieldValue = '') then
					raise exception 'Campo [%] é obrigatorio', fieldName;
				end if;
			end if;

			-- Validate unique values
			if (fieldUnique = 'Y') then
				if (is_unique(systemId, tableName, fieldName, fieldValue) = false) then
					raise exception 'Valor [%] ja existe na tabela % campo %', fieldValue, tableName, fieldName;
				end if;
			end if;

			-- Validate int
			if (fieldType = 'integer') then
				if (is_integer(fieldValue) = false) then
					raise exception 'Valor inválido [%] no campo %, esperado numerico inteiro', fieldValue, fieldName;
				end if;
			end if;

			-- Validate dec
			if (fieldType = 'decimal') then
				if (is_decimal(fieldValue) = false) then
					raise exception 'Valor inválido [%] no campo %, esperado numerico', fieldValue, fieldName;
				end if;
			end if;

			-- Validate dates
			if (fieldType = 'date') then
				if (is_date(fieldValue, fieldMask) = false) then
					raise exception 'Data inváida [%] no campo %', fieldValue, fieldName;
				end if;
			end if;
					
		end loop;

		-- Prepare statement
		id := stamp(tableName, jsons, jsonf);

	end if;
    
	------------------------------------------------
	------------------------------------------------ UPDATE
	------------------------------------------------
	if (actionId = ACTION_UPDATE) then

		-- Before UPDATE
		execute trace('Validating before UPDATE: ', actionId);

		-- Figure out existing data		
		sql := '';
		sql := concat(sql, 'select ');
		sql := concat(sql, tableName, '.id', ','); -- need ID not field->>'id'
		sql := concat(sql, sql_field(tableName, 'field', 'jsone'));
		sql := concat(sql, sql_from(tableName));
		sql := concat(sql, sql_where(tableName, systemId));
		sql := concat(sql, sql_and(tableName, 'id', id));
		execute trace('Get existing json: ', sql);

		for item in execute sql loop
			-- Keep current field			
			jsone := item.jsone::jsonb;
			-- Validate IDs are consistent
			if (item.id::text <> jsone->>'id'::text) then
				raise exception 'Field ID [%] is different from field->>ID [%], record corrupted!!!', item.id::text, jsone->>'id'::text;
			end if;
		end loop;

		-- Are json different
		execute trace('Are json different: ', '');
		execute trace('json old: ', jsone::text);
		execute trace('json new: ', jsonf::text);

		-- validate if json changed
		sql := get_struct(systemId, tableId);
		for item in execute sql loop

			-- Collect data
			fieldMandatory = trim(item.id_mandatory);
			fieldUnique = trim(item.id_unique);
			fieldName = trim(item.field_name);			
			fieldType = trim(item.field_type);
			fieldValue = trim(jsonf->>fieldName);
			fieldMask = trim(item.field_mask);

			old := json_extract_path(jsone::json, fieldName)::text;
			new := json_extract_path(jsonf::json, fieldName)::text;

			-- Check for changes
			execute trace('fieldName: ', fieldName);
			execute trace('Old value: ', old);
			execute trace('New value: ', new);

			-- Validate mandatory fields
			if (fieldMandatory = 'Y') then
				if (fieldValue = null OR fieldValue = '') then
					raise exception 'Campo % é obrigatorio', field_name;
				end if;
			end if;

			-- Validate unique values
			if (fieldUnique = 'Y') then
				if (is_unique(systemId, tableName, fieldName, fieldValue) = false) then
					raise exception 'Valor [%] ja existe na tabela % campo %', fieldValue, tableName, fieldName;
				end if;
			end if;

			-- Validate int
			if (fieldType = 'integer') then
				if (is_integer(fieldValue) = false) then
					raise exception 'Valor inválido [%] no campo %, esperado numerico inteiro', fieldValue, fieldName;
				end if;
			end if;

			-- Validate dec
			if (fieldType = 'decimal') then
				if (is_decimal(fieldValue) = false) then
					raise exception 'Valor inválido [%] no campo %, esperado numerico', fieldValue, fieldName;
				end if;
			end if;

			-- Validate dates
			if (fieldType = 'date') then
				if (is_date(fieldValue, fieldMask) = false) then
					raise exception 'Data inváida [%] no campo %', fieldValue, fieldName;
				end if;
			end if;			

			-- If changed, validate unique values
			if (trim(old) != trim(new)) then
				-- Validate dates
				if (fieldType = 'date') then
					if (is_date(fieldValue, fieldMask) = false) then
						raise exception 'Data inváida [%] no campo %', fieldValue, fieldName;
					end if;
				end if;			
				if (fieldUnique = 'Y') then
					if (is_unique(systemId, tableName, fieldName, fieldValue) = false) then
						raise exception 'Valor [%] ja existe na tabela % campo %', fieldValue, tableName, fieldName;
					end if;
				end if;
				output := concat(output, ';', item.field_name);
			end if;
		end loop;

		-- Do not update, nothing changed
		if (output = '') then
			raise exception 'Nenhuma mudança foi identificada, alteração não realizada';
		end if;
		
		-- Before insert
		execute trace('Before update: ', jsonf::text);

		-- update the record
		sql := '';
		sql := concat(sql, ' update ', tableName, ' set ');
		sql := concat(sql, ' session = ', qt(jsons::text), ', ');
		sql := concat(sql, ' field = ', qt(jsonf::text));
		sql := concat(sql, ' where id = ', id);
		execute trace('SQL: ', sql);
		execute sql;
	end if;	

	------------------------------------------------
	------------------------------------------------ DELETE
	------------------------------------------------
	if (actionId = ACTION_DELETE) then

		-- Before UPDATE
		execute trace('Validating before DELETE: ', actionId::text);

		-- Figure out dependency table
		sql = '';
		sql = concat(sql, ' select');
		sql = concat(sql, ' table_name,');
		sql = concat(sql, ' field_name');
		sql = concat(sql, ' from vw_table');
		sql = concat(sql, ' where id_system = ', systemId);
		sql = concat(sql, ' and field_fk = ', tableId);
		execute trace('SQL: ', sql);
		
		for item in execute sql loop
			-- Check if dependency has data
			sql = '';
			sql = concat(sql, ' select id,');
			sql = concat(sql, qt(item.table_name), ' table_name');
			sql = concat(sql, ' from ', item.table_name);
			sql = concat(sql, ' where (session->', qt('id_system'), ')::int = ', systemId);
			sql = concat(sql, ' and (field->>', qt(item.field_name), ')::int = ', id);
			execute trace('SQL: ', sql);			
			for item in execute sql loop
				raise exception 'Registro não pode ser excluído, existem dependencias em %', item.table_name;
			end loop;
		end loop;
		-- Delete the record
		sql := concat('delete from ', tableName, ' where id = ', id);
		execute sql;
	end if;

    -- Output message
    if actionId = '0' then
        message := '';
    elsif (actionId = '1') then
        message := concat('Registro INCLUÍDO com sucesso', ' [', id, ']');
    elsif (actionId = '2') then
        message := concat('Registro ALTERADO com sucesso', ' [', id, ']');
    elsif (actionId = '3') then
        message := concat('Registro EXCLUÍDO com sucesso', ' [', id, ']');
    end if;

	-- Return json with success (1 Success)
    return return(SUCCESS, message, warning, actionId, id);

	-- Finish
	execute trace('End Persist(): ', 'Success');

-- Error handling
exception 
	when others then 

		-- Return json with error (0 Fail)
        message := (SQLERRM)::text;
        return return(FAIL, message, warning, actionId, id);        

		-- Finish
		execute trace('End Persist() -> exception: ', SQLERRM);
end;
$function$;
