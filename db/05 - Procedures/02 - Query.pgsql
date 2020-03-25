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
    pageOffset int := 0;
    html text := '';
    sql1 text := '';
    sql2 text := '';
    sql3 text := '';    
    tableName text := '';
    fieldName text := '';    
    item1 record;
    item2 record;
    item3 record;    
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
    systemId := data::jsonb->'session'->>'id_system';
    tableId := data::jsonb->'session'->>'id_table';
    pageOffset := data::jsonb->'session'->>'page_offset';
    tableName := get_table(systemId, tableId);

    ---
    --- Prepare query to get data
    ---
    sql1 := 'select count(*) over() as record_count,';
    sql1 := concat(sql1, get_field_list(systemId, tableId));
    sql1 := concat(sql1, ' from ', tableName, ' ');
    sql1 := concat(sql1, get_join(systemId, tableId));
    sql1 := concat(sql1, ' where (', tableName, '.session->', qt('id_system'), ')::int = ', systemId);
    sql1 := concat(sql1, get_condition(data::jsonb));
    sql1 := concat(sql1, ' order by ', tableName, '.id');
    sql1 := concat('select to_jsonb(r)::text as record from (', sql1, ') r');
    sql1 := concat(sql1, ' limit ', PAGE_SIZE);
    sql1 := concat(sql1, ' offset ', pageOffset);
	execute trace('SQL: ', sql1);

    ---
    --- Prepare query to get table structure
    ---
    sql2 := concat(sql2, ' select * from vw_table');
    sql2 := concat(sql2, ' where id_system = ', systemId);
    sql2 := concat(sql2, ' and id_table = ', tableId);
	execute trace('SQL2: ', sql2);

    ---
    --- Prepare query to get actions (buttons)
    ---
    sql3 := concat(sql3, ' select');
    sql3 := concat(sql3, ' tb_action.field->>', qt('id'), ' id');
    sql3 := concat(sql3, ' ,tb_action.field->>', qt('id_table'), ' id_table');
    sql3 := concat(sql3, ' ,tb_action.field->>', qt('id_target'), ' id_target' );
    sql3 := concat(sql3, ' ,tb_action.field->>', qt('label'), ' caption');
    sql3 := concat(sql3, ' ,tb_action.field->>', qt('id_event'), ' id_event');
    sql3 := concat(sql3, ' ,tb_action.field->>', qt('js'), ' js');
    sql3 := concat(sql3, ' ,tb_domain_event.field->>', qt('value'), ' event_name');
    sql3 := concat(sql3, ' from tb_action');
    sql3 := concat(sql3, ' inner join tb_domain tb_domain_event on ');
    sql3 := concat(sql3, ' (tb_action.field->>', qt('id'), ')::int = (tb_domain_event.field->>', qt('id_domain'), ')::int');
    sql3 := concat(sql3, ' and tb_domain_event.field->>', qt('domain'), ' = ', qt('tb_event'));
    sql3 := concat(sql3, ' where (tb_action.session->', qt('id_system'), ')::int = ', systemId);
	execute trace('SQL3: ', sql3);    

    ---
    --- Page title
    ---
    html := concat(html, '<h3>', get_table(systemId, tableId), '</h3>');
    html := concat(html, '<br>');

    ---
    --- Table header
    ---
    html := concat(html, '<table class="w3-table w3-striped w3-hoverable">');
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
                recordCount := resultset->>'record_count';
                fieldName := 'id';
                html := concat(html, '<td><input type="radio" id="', resultset->>fieldName , '" name="selection" value=""></td>');        
                for item2 in execute sql2 loop
                    fieldName := item2.field_name;
                    html := concat(html, '<td>', resultset->>fieldName, '</td>');
                end loop;
            html := concat(html, '</tr>');                
        end loop;
    html := concat(html, '</tbody>');
    html := concat(html, '</table>');    
    
    ---
    --- Paging
    ---
    html := concat(html, '<br>');
    html := concat(html, '<center>');
    pageCount := ceil(recordCount / PAGE_SIZE);
    if (pageCount > 1) then
        for i in 0..pageCount-1 loop
            pageOffset = i * PAGE_SIZE;
            html := concat(html, '<a href="index.php?id_layout=1&id_table=', tableId, '&page_offset=', pageOffset, '"> ', i+1, '</a>');
        end loop;
    end if;
    html := concat(html, '</center>');
    html := concat(html, '<br>');
    ---
    --- Actions
    ---
    for item3 in execute sql3 loop
        html := concat(html, ' <input "');
        html := concat(html, ' type="button"');
        html := concat(html, ' class="w3-button w3-blue"');
        html := concat(html, ' id=', dbqt(item3.id));
        html := concat(html, ' value=', dbqt(item3.caption));
        html := concat(html, ' >');            
    end loop;

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
