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
    sql varchar := '';
begin
    if (fieldAlias = '') then
        fieldAlias = fieldName;
    end if;

    if (fieldName = 'field') then
        sql := concat(sql, tableName, '.field', ' ', fieldAlias);
    elsif (fieldName = 'session') then
        sql := concat(sql, tableName, '.session', ' ', fieldAlias);           
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
    sql varchar := '';
begin
    sql := concat(sql, ' from ', tableName); 
    return sql;
end;
$function$;

/*
Mandatory condition for all queries
select sql_where(1)
 */
drop function if exists sql_where;
create or replace function sql_where(tableName text, systemId integer)
returns text
language plpgsql
as $function$
declare
    sql varchar := '';
begin
    sql = concat(sql, ' where (', tableName, '.session->>', qt('id_system'), ')::int = ', systemId);
    return sql;
end;
$function$;

/*
Mandatory condition for all queries
select sql_and('tb_rel_event', 'key', 1)
 */
drop function if exists sql_and;
create or replace function sql_and(tableName text, fieldName text, fieldValue int)
returns text
language plpgsql
as $function$
declare
    sql varchar := '';
begin
    sql := concat(sql, ' and (', tableName, '.field->>', qt(fieldName), ')::int = ', fieldValue);    
    return sql;
end;
$function$;

/*
Return sql that creates dynamic conditions
select sql_condition('tb1', 'id', 1, '=', '1');
select sql_condition('tb1', 'amount', 2, '>', '10.99');
select sql_condition('tb1', 'name', 3, '=', 'David');
select sql_condition('tb1', 'expire_date', 4, '=', '31/12/2014', 'dd/mm/yyyy');

select sql_condition('tb1', 'id_mandatory', 1, '=', '1');
*/
drop function if exists sql_condition;
create or replace function sql_condition(tableName text, fieldName text, fieldType integer, fieldOperator text, fieldValue text, fieldMask text default '')
returns text
language plpgsql
as $function$
declare
    output text := ' and ';
begin
    -- Note: apply single quote on data and string
    if (fieldType = 4) then
        output = concat(output , ' (to_date(', tableName, '.field', '->>', qt(fieldName), ', ', fieldMask, ')');
    else
        output = concat(output , ' (', tableName, '.field', '->>', qt(fieldName));
    end if;

    if (fieldType = 1) then
        output = concat(output, ')::int');
    elsif (fieldType = 2) then
        output = concat(output, ')::float');
    elsif (fieldType = 3) then
        output = concat(output, ')::text');
        fieldValue := qt(fieldValue);
    elsif (fieldType = 4) then
        output = concat(output, ')::date');
        fieldValue := concat('to_date(', qt(fieldValue), ', ', qt(fieldMask), ')');
    elsif (fieldType = 5) then -- bool
        output = concat(output, ')::int');
    end if;

    output = concat(output, ' ', fieldOperator);
    output = concat(output, ' ', fieldValue);
    output = concat(output, ' ');

    return output;
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
    sql varchar := '';
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


-----------------------------------------------------------------
-- OTHER FUNCTIONS
-----------------------------------------------------------------
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
select get_struct(1,1);
*/
drop function if exists get_struct;
create or replace function get_struct(systemId int, tableId int)
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
Get dynamic and condition
select get_condition('{"session":{"id_system":1,"id_table":1,"id_action":1},"filter":[{"field_name":"name", "operator":"=", "field_value":"1"}]}')
select get_condition('{"session":{"id_system":1,"id_table":1,"id_action":1}}')
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
        sql := concat(sql, ' v.id_type field_type,');
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
Format numbers based on mask
select get_output(0, 1, 23, 'exception goes here', 'warning goes here', '')
select get_output(0, 0, 0, 'exception goes here', '', '')
select get_output(1, 1, 0, '', '', '[{"id": 1, "url": "-", "name": "system", "id_system": 1, "table_name": "tb_system"}]');
select get_output(0, 0, 0, 'SQLERRM', '', '[]');
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

    if (resultset = '') then
        resultset = '[]';
    end if;    

    if (trim(error) = '') then
        if actionId = 0 then
            message := ''; -- Query
        elsif (actionId = 1) then
            message := concat('Registro INCLUÍDO com sucesso', ' [', id::text, ']');
        elsif (actionId = 2) then
            message := concat('Registro ALTERADO com sucesso', ' [', id::text, ']');
        elsif (actionId = 3) then
            message := concat('Registro EXCLUÍDO com sucesso', ' [', id::text, ']');
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
select get_title(1,1) -- success
select get_title(1,9) -- fail
*/
drop function if exists get_title;
create or replace function get_title(systemId integer, tableId integer)
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
select parse_int('1'); -- true
select parse_int('d'); -- false
select parse_int('10,2'); -- false
select parse_int('10.2'); -- false
*/
drop function if exists parse_int;
create or replace function parse_int(value text)
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
Check if the record is unique at the table
select parse_dec('1'); -- true
select parse_dec('d'); -- false
select parse_dec('10,2'); -- false
select parse_dec('10.2'); -- false
*/
drop function if exists parse_dec;
create or replace function parse_dec(value text)
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
select is_unique(1, 'tb_system', 'name', 'formsss') -- true, dont exists
select is_unique(1, 'tb_system', 'name', 'forms') -- false, already exists 

select is_unique(1, 'tb_field', 'domain', '') -- false, already exists 
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

    if (trim(fieldValue) != '' and fieldName <> 'id') then
        sql := concat(sql, 'select ');
        sql := concat(sql, sql_field(tableName, 'id'));
        sql := concat(sql, sql_from(tableName));
        sql := concat(sql, sql_where(tableName, systemId));
        sql := concat(sql, sql_condition(tableName, fieldName, 3, '=', fieldValue, ''));

        for item in execute sql loop
            return false;
        end loop;
    end if;

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
    sql1 := get_struct(systemId, tableId);

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
                tableName = concat('tb_', replace(item1.field_name, 'id_', 'fk_'));
                output := concat(output, sql_column(tableName, 'value', 3, item1.field_mask, item1.field_name), ',');                
            else
                -- Other foreign keys
                tableName = concat('tb_', replace(item1.field_name, 'id_', 'fk_'));                
                sql2 := '';               
                sql2 = get_struct(systemId, item1.id_fk);
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

/*
Set value between double quote
select get_event(1, 1, 1, 2, 1);
*/
drop function if exists get_event;
create or replace function get_event(systemId int, tableId int, eventId int, targetId int, recordCount int)
returns text
language plpgsql
as $function$
declare
    sql text := '';
    html text := '';  
    item1 record;  
begin
    ---
    --- Prepare query to get actions (buttons)
    ---
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

    if (targetId = 2) then
        --sql := concat(sql, sql_join('tb_event', 'id', 'tb_domain', 'tb_rel_event', 'value', 'tb_rel_event'));
        --sql := concat(sql, sql_and('tb_rel_event', 'key', eventId));  
    end if;    

    sql := concat(sql, sql_where('tb_event', systemId));    
    sql := concat(sql, sql_and('tb_event', 'id_table', tableId));
    sql := concat(sql, sql_and('tb_event', 'id_target', targetId));    

    -- No records, only [New] is presented
    if (targetId = 1 and recordCount = 0) then
        sql := concat(sql, sql_and('tb_event', 'id', 1));
    end if;
	execute trace('sql: ', sql);

    ---
    --- Actions (Buttons)
    ---
    html := concat(html, '<center>');
    for item1 in execute sql loop
        html := concat(html, '<input');
        html := concat(html, ' type=', dbqt('button'));
        html := concat(html, ' class=', dbqt('w3-button w3-blue'));
        html := concat(html, ' id=', dbqt(item1.id));
        html := concat(html, ' value=', dbqt(item1.display));
        html := concat(html, ' ', item1.event_name, ' = ', dbqt(item1.code));
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
select get_js(1, 1);
*/
drop function if exists get_js;
create or replace function get_js(systemId int, tableId int)
returns text
language plpgsql
as $function$
declare
    sql text := '';
    html text := '';  
    item record;  
begin

    ---
    --- Javascript
    ---
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

    ---
    --- return buttons as html
    ---
    return html;

end;
$function$;

---------------------------------------------------------------------------------
-- HTML function
---------------------------------------------------------------------------------
/*
Get an html input element (hidden, text, select)
select html_input('text', 'id_order', 'ir_order', '123456', '', '', 'onclick=alert(123)');
 */
drop function if exists html_input;
create or replace function html_input(htmlType text, fieldName text, fieldValue text, disabled text, checked text, events text)
returns text
language plpgsql
as $function$
declare
    html varchar := '';
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
select html_option(1, 3, '2');
select html_option(1, 4, '2', 'tb_operator');
*/
drop function if exists html_option;
create or replace function html_option(systemId integer, fkId int, selectedValue text, domainName text default '')
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
    execute trace('fkId: ', fkId::text);
    -- Generate query selecting first Int and first String (ID, DS) from each table            
    if (fkId = 4) then
        -- Domain table
        sql2 := 'select ';
        sql2 := concat(sql2, sql_field('tb_domain', 'key', 'id'), ',');
        sql2 := concat(sql2, sql_field('tb_domain', 'value', 'ds'));
        sql2 := concat(sql2, sql_from('tb_domain'));
        sql2 := concat(sql2, sql_where('tb_domain', systemId));
        sql2 := concat(sql2, sql_condition('tb_domain', 'domain', 3, '=', domainName));
    else
        -- Other tables
        sql2 := 'select ';
        
        sql1 := concat('select field_name from vw_table where id_system = ', systemId, ' and id_type = ', 1, ' limit 1 ');
        for item1 in execute sql1 loop
            sql2 := concat(sql2, 'field->>', qt(item1.field_name), ' as id', ',');
        end loop;

        sql1 := concat('select field_name from vw_table where id_system = ', systemId, ' and id_type = ', 3, ' limit 1 ');        
        for item1 in execute sql1 loop
            sql2 := concat(sql2, 'field->>', qt(item1.field_name), ' as ds');
        end loop;              

        sql2 := concat(sql2, ' from ', get_table(systemId, fkId));
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
select html_dropdown(1, 'id_system', 2, '1')
select html_dropdown(1, 'id_system', 4, '1', 'tb_operator')
 */
drop function if exists html_dropdown;
create or replace function html_dropdown(systemId int, fieldName text, fkId int, fieldValue text, domainName text default '')
returns text
language plpgsql
as $function$
declare
    html varchar := '';
begin
    html := concat(html, ' <select ');
    html := concat(html, ' class=', dbqt('w3-input w3-border'));
    html := concat(html, ' id=', dbqt(fieldName));
    html := concat(html, ' name=', dbqt(fieldName));            
    html := concat(html, ' >');
    html := concat(html, html_option(systemId, fkId, fieldValue, domainName));
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
create or replace function html_textarea(fieldName text, fieldValue text, rows int default 20, cols int default 135)
returns text
language plpgsql
as $function$
declare
    html varchar := '';
begin
    html := concat(html, ' <textarea ');
    html := concat(html, ' id=', dbqt(fieldName));
    html := concat(html, ' name=', dbqt(fieldName));
    html := concat(html, ' rows=', dbqt(rows::text));
    html := concat(html, ' cols=', dbqt(cols::text));
    html := concat(html, ' >');
    html := concat(html, fieldValue);
    html := concat(html, '</textarea>');

    return html;
end;
$function$;

/*
Manipulate json based on based on simple
Note that we must work with single level json (DO NOT COMPLICATE THINGS ANYMORE)
select json_set('{"id_system":1,"id_table":1,"id_action":1,"id_user":1}', 'I', 'id_language', 1, '99')
select json_set('{"id_system":1,"id_table":1,"id_action":1,"id_user":1}', 'U', 'id_user', 1, '99')
select json_set('{"id_system":1,"id_table":1,"id_action":1,"id_user":1}', 'D', 'id_system')
 */
drop function if exists json_set;
create or replace function json_set(json jsonb, action text, fieldName text, fieldType int default 0, fieldValue text default '')
returns jsonb
language plpgsql
as $function$
declare
    field text[2];
begin

    action := upper(action);

    field[1] = fieldName;
    if (fieldType = 1 or fieldType = 2) then
        if (fieldValue = '') then
            fieldValue = '0';
        end if;
    else
        fieldValue := dbqt(fieldValue);
    end if;

    if (action = 'I') then
        json:= jsonb_set(json, field, fieldValue::jsonb, true);
    end if;

    if (action = 'U') then
        json:= jsonb_set(json, field, fieldValue::jsonb, false);
    end if;

    if (action = 'D') then
        json:= json - fieldName;
    end if;    

    return json;

end;
$function$;

/*
Create valid json based on input data
select parse_json('{"session":{"id_system":1,"id_table":1,"id_user":1, "id_action":1}}')
select parse_json('{"session":{"id_system":1,"id_table":2,"id_user":1, "id_action":4,"page_limit":5,"page_offset":0},"filter":[]}') -- Q
select parse_json('{"session":{"id_system":1,"id_table":1,"id_action":1,"id_user":1},"field":{"id":0,"name_":"lancioni it","expire_date":"31/12/2021","price":1200}}') -- IUD

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
    sql1 := get_struct((jsons->>'id_system')::int, (jsons->>'id_table')::int);
    for item1 in execute sql1 loop
        fieldList := concat(fieldList, item1.field_name::text, '|');
    end loop;

    -- Remove invalid elements
    sql2 := concat('select * from json_each(', qt((json->'field')::text), ')');
    execute trace('json query: ', sql2);
    for item2 in execute sql2 loop        
        if (position(item2.key in fieldList) = 0) then
            jsonf := json_set(jsonf, 'D', item2.key::text);
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
 */
drop function if exists stamp;
create or replace function stamp(tableName text, jsons jsonb, jsonf jsonb)
returns int
language plpgsql
as $function$
declare
	id int := 0;
    sql text := '';
begin

    -- Prepare statement
    sql := concat(sql, 'insert into ', tableName, ' (session) values (', qt('{"id":0}') ,')');
    execute sql;

    -- Get inserted id and stamp in the json
    select currval(pg_get_serial_sequence(tableName, 'id')) into id;

    -- jsonf := jsonb_set(jsonf, '{id}', dbqt(id::text)::jsonb, false);
    jsonf := json_set(jsonf, 'U', 'id', 1, id::text);

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