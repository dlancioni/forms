/*
-- no condition
call report('{"session":{"id_system":1,"id_table":2,"page_limit":5,"page_offset":0},"filter":[]}')

-- filtering
call report('{"session":{"id_system":1,"id_table":2,"id_action":1, "page_limit":5,"page_offset":0},"filter":[{"field_name":"id", "operator":"=", "field_value":"1"}]}')
*/

drop procedure if exists report;
create or replace procedure report(inout data text)
language plpgsql
as $procedure$
declare
    systemId int := 0;
    tableId int := 0;
    eventId int := 0;
    id int := 0;
    targetId int := 1;
    pageOffset int := 0;
    html text := '';
    sql1 text := '';
    sql2 text := '';
    tableName text := '';
    fieldName text := '';    
    checked text := '';
    disabled text := '';
    events text := '';
    item1 record;
    item2 record;
    resultset jsonb;
    SUCCESS int := 1;
    FAIL int := 0;
    -- Paging
    PAGE_SIZE float := 10;
    recordCount float := 0;
    pageCount float := 0;

begin

    ---
    --- Start processing
    ---
	execute trace('Begin Query(): ', data::text);

    ---
    --- Session related information
    ---
    id := (data::jsonb->'session'->>'id')::int;    
    systemId := (data::jsonb->'session'->>'id_system')::int;
    tableId := (data::jsonb->'session'->>'id_table')::int;
    pageOffset := data::jsonb->'session'->>'page_offset';
    tableName := get_table(systemId, tableId);

    ---
    --- Prepare query to get data
    ---
    sql1 := 'select count(*) over() as record_count,';
    sql1 := concat(sql1, get_field_list(systemId, tableId));
    sql1 := concat(sql1, ' from ', tableName, ' ');
    sql1 := concat(sql1, get_join(systemId, tableId));
    sql1 := concat(sql1, sql_where(tableName, systemId));
    sql1 := concat(sql1, get_condition(data::jsonb));
    sql1 := concat(sql1, ' order by ', tableName, '.id');
    sql1 := concat('select to_jsonb(r)::text as record from (', sql1, ') r');
    sql1 := concat(sql1, ' limit ', PAGE_SIZE);
    sql1 := concat(sql1, ' offset ', pageOffset);
	execute trace('SQL1: ', sql1);

    ---
    --- Prepare query to get table structure
    ---
    sql2 := get_struct(systemId, tableId);

    ---
    --- Page title
    ---
    html := concat(html, '<h3>', get_title(systemId, tableId), '</h3>');
    html := concat(html, '<br>');

    ---
    --- Table header
    ---
    html := concat(html, '<div class="w3-responsive">');
    html := concat(html, '<table class="w3-table w3-striped w3-hoverable">');
    html := concat(html, '<thead>');
        html := concat(html, '<tr>');
            html := concat(html, '<td>');
            -- radio button for header - nothing
            html := concat(html, '</td>');
            for item2 in execute sql2 loop
                html := concat(html, '<td><b>', item2.field_label, '</b></td>');
            end loop;
        html := concat(html, '</tr>');
    html := concat(html, '</thead>');

    ---
    --- Table body
    ---
    html := concat(html, '<tbody>');
    for item1 in execute sql1 loop
        fieldName := 'id';
        resultset := item1.record;
        recordCount := resultset->>'record_count';
        events = 'onClick="setValue(''__id__'', this.value);"';

        checked := '';
        if (id = 0) then
            checked := ' checked '; 
            id = -1;
        else                    
            if ((resultset->>fieldName)::int = id) then
                checked := ' checked '; 
            end if;
        end if;

        html := concat(html, '<tr>');

            html := concat(html, '<td>');
            html := concat (html, html_input('radio', 'selection', resultset->>fieldName, disabled, checked, events));
            html := concat(html, '</td>');

            for item2 in execute sql2 loop
                fieldName := item2.field_name;
                html := concat(html, '<td>', resultset->>fieldName, '</td>');
            end loop;  

        html := concat(html, '</tr>');

    end loop;

    html := concat(html, '</tbody>');
    html := concat(html, '</table>');
    html := concat(html, '</div">');    
    
    ---
    --- Paging
    ---
    html := concat(html, '<br>');
    html := concat(html, '<center>');
    pageCount := ceil(recordCount / PAGE_SIZE);
    if (pageCount > 1) then
        for i in 0..pageCount-1 loop
            pageOffset = i * PAGE_SIZE;
            html := concat(html, '<a onClick="page(', pageOffset, ')">', i+1, '</a>&nbsp;&nbsp;');
        end loop;
    end if;
    html := concat(html, '</center>');
    html := concat(html, '<br>');

    ---
    --- Actions (Buttons)
    ---
    html :=concat(html, get_event(systemId, tableId, 1, targetId, recordCount::int));

    ---
    --- Javascript
    ---
    html :=concat(html, get_js(systemId, tableId));

    ---
    --- Return data (success)
    ---
    data := html;

    ---
    --- Return data (success)
    ---
	execute trace('End Query(): ', 'Success');

exception when others then

    ---
    --- Return data (fail)
    ---
    data := 'Deu pau';

    ---
    --- Return data (fail)
    ---
    execute trace('End Query() -> exception: ', SQLERRM);    
end;

$procedure$
