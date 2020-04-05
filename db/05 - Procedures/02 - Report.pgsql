/*
-- no condition
call report('{"session":{"id_system":1,"id_table":2,"page_limit":5,"page_offset":0},"filter":[]}')

-- filtering
call report('{"session":{"id_system":1,"id_table":2,"id_action":1},"filter":[{"field_name":"id", "operator":"=", "field_value":"1"}]}')
*/

drop procedure if exists report;
create or replace procedure report(inout data jsonb)
language plpgsql
as $procedure$
declare
    systemId int := 0;
    tableId int := 0;
    id int := 0;
    pageOffset int := 0;
    html text := '';
    sql1 text := '';
    sql2 text := '';
    sql3 text := '';
    sql4 text := '';        
    tableName text := '';
    fieldName text := '';    
    item1 record;
    item2 record;
    item3 record;    
    item4 record;    
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
    systemId := (data::jsonb->'session'->>'id_system')::int;
    tableId := (data::jsonb->'session'->>'id_table')::int;
    id := (data::jsonb->'session'->>'id')::int;
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
    --- Page title
    ---
    html := concat(html, '<h3>', get_table(systemId, tableId), '</h3>');
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

                html := concat(html, '<td>');                
                html := concat(html, '<input ');
                html := concat(html, ' type=', dbqt('radio'));
                html := concat(html, ' value=', resultset->>fieldName);
                html := concat(html, ' name=', dbqt('selection'));
                html := concat(html, ' onClick=', dbqt('setValue(''id_record'', this.value)'));

                if (id = 0) then
                    html := concat(html, ' checked '); id = -1;
                else                    
                    if ((resultset->>fieldName)::int = id) then
                        html := concat(html, ' checked ');
                    end if;
                end if;

                html := concat(html, '>');
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
            html := concat(html, '<a href="index.php?id_target=1&id_table=', tableId, '&page_offset=', pageOffset, '&id_record=0"> ', i+1, '</a>');
        end loop;
    end if;
    html := concat(html, '</center>');
    html := concat(html, '<br>');

    ---
    --- Actions (Buttons)
    ---
    html :=concat(html, get_event(systemId, tableId, 1));

    ---
    --- Javascript
    ---
    sql4 := concat(sql4, ' select');
    sql4 := concat(sql4, ' field->>', qt('id'), ' id');
    sql4 := concat(sql4, ' ,field->>', qt('code'), ' code');
    sql4 := concat(sql4, ' from tb_code');
    sql4 := concat(sql4, ' where (session->', qt('id_system'), ')::int = ', systemId);
	execute trace('SQL4: ', sql4);

    html := concat(html, '<script langauage="JavaScript">');    
    for item4 in execute sql4 loop
        html := concat(html, item4.code);
    end loop;
    html := concat(html, '</script>');

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
