/*
-- no condition
call query('{"session":{"id_system":1,"id_table":2,"page_limit":5,"page_offset":0},"filter":[]}')

-- filtering
call query('{"session":{"id_system":1,"id_table":2,"id_action":1},"filter":[{"field_name":"id", "operator":"=", "field_value":"1"}]}')
*/

drop procedure if exists query;
create or replace procedure query(inout data jsonb)
language plpgsql
as $procedure$
declare
    systemId int := 0;
    tableId int := 0;
    pageLimit int := 0;
    pageOffset int := 0;
    html text := '';
    sql1 text := '';
    sql2 text := '';    
    tableName text := '';
    fieldName text := '';    
    item1 record;
    item2 record;    
    resultset jsonb;
    SUCCESS int := 1;
    FAIL int := 0;

begin

    ---
    --- Start processing
    ---
	execute trace('Begin Query(): ', data::text);

    ---
    --- Session related information
    ---
    systemId := data::jsonb->'session'->>'id_system';
    tableId := data::jsonb->'session'->>'id_table';
    pageLimit := data::jsonb->'session'->>'page_limit';
    pageOffset := data::jsonb->'session'->>'page_offset';
    tableName := get_table(systemId, tableId);

    ---
    --- Prepare main query
    ---
    sql1 := 'select count(*) over() as record_count,';
    sql1 := concat(sql1, get_field_list(systemId, tableId));
    sql1 := concat(sql1, ' from ', tableName, ' ');
    sql1 := concat(sql1, get_join(systemId, tableId));
    sql1 := concat(sql1, ' where (', tableName, '.session->', qt('id_system'), ')::int = ', systemId);
    sql1 := concat(sql1, get_condition(data::jsonb));
    sql1 := concat(sql1, ' order by ', tableName, '.id');
    sql1 := concat('select to_jsonb(r)::text as record from (', sql1, ') r');
    sql1 := concat(sql1, ' limit ', pageLimit);
    sql1 := concat(sql1, ' offset ', pageOffset);
	execute trace('SQL: ', sql1);

    ---
    --- Get table structure
    ---
    sql2 := concat(sql2, ' select * from vw_table');
    sql2 := concat(sql2, ' where id_system = ', systemId);
    sql2 := concat(sql2, ' and id_table = ', tableId);
	execute trace('SQL2: ', sql2);

    ---
    --- Page title
    ---
    html := concat(html, '<h3>', get_table(systemId, tableId), '</h3><p>');

    ---
    --- Table header
    ---
    html := concat(html, '<thead>');
        html := concat(html, '<tr>');
            html := concat(html, '<td></td>');               
            for item2 in execute sql2 loop
                html := concat(html, '<td>', item2.field_label, '</td>');
            end loop;
        html := concat(html, '</tr>');
    html := concat(html, '</thead>');

    ---
    --- Table body
    ---
    html := concat(html, '<tbody>');    
        for item1 in execute sql1 loop
            html := concat(html, '<tr>');            
                resultset := item1.record;           
                fieldName := 'idi';
                html := concat(html, '<td><input type="radio" id="', resultset->>fieldName , '" name="selection" value=""></td>');        
                for item2 in execute sql2 loop
                    fieldName := item2.field_name;
                    html := concat(html, '<td>', resultset->>fieldName, '</td>');
                end loop;
            html := concat(html, '</tr>');                
        end loop;
    html := concat(html, '</tbody>');    

    ---
    --- Prepare HTML to return as JSON
    ---
    html := replace(html, '"', '|');
    html := concat('{', dbqt('html'), ':', dbqt(html), '}');
    execute trace('html: ', html);

    ---
    --- Return data (success)
    ---
    data := get_output(SUCCESS, 0, 0, '', '', html);
	execute trace('End Query(): ', 'Success');

exception when others then
    ---
    --- Return data (fail)
    ---
    data := get_output(FAIL, 0, 0, SQLERRM, '', '[]');
    execute trace('End Query() -> exception: ', SQLERRM);    
end;

$procedure$
