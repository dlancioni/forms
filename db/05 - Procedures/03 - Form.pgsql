/*
-- filtering
call form('{"session":{"id_system":1,"id_table":2,"id":1}}')
*/

drop procedure if exists form;
create or replace procedure form(inout data jsonb)
language plpgsql
as $procedure$
declare
    id int := 0;
    systemId int := 0;
    tableId int := 0;
    eventId int := 0;
    fieldFK int := 0;
    sql1 text := '';
    sql2 text := '';
    sql3 text := '';
    sql4 text := '';
    sql5 text := '';
    tableName text := '';
    tableFk text := '';
    fieldName text := '';
    fieldLabel text := '';
    fieldType int := 0;
    fieldMask text := '';
    domainName text := '';
    html text := '';
    item1 record;
    item2 record;
    item3 record;
    item4 record;    
    resultset jsonb;
    SUCCESS int := 1;
    FAIL int := 0;

begin
    ---
    --- Start processing
    ---
	execute trace('Begin Form(): ', data::text);

    ---
    --- Session related information
    ---
    id := data::jsonb->'session'->>'id';
    systemId := data::jsonb->'session'->>'id_system';
    tableId := data::jsonb->'session'->>'id_table';
    eventId := data::jsonb->'session'->>'id_event';
    tableName := get_table(systemId, tableId);

    ---
    --- Get table structure
    ---
    sql1 := concat(sql1, ' select * from vw_table');
    sql1 := concat(sql1, ' where id_system = ', systemId);
    sql1 := concat(sql1, ' and id_table = ', tableId);
	execute trace('SQL1: ', sql1);

    ---
    --- Get the record
    ---
    if (id > 0) then
        sql2 := concat(sql2, ' select field from ', tableName);
        sql2 := concat(sql2, ' where (session->>', qt('id_system'), ')::int = ', systemId);
        sql2 := concat(sql2, ' and (field->>', qt('id'), ')::int = ', id);
        execute trace('SQL2: ', sql2);
        for item2 in execute sql2 loop
            resultset := item2.field;
        end loop;
    end if;    

    ---
    --- Create the form
    ---
    for item1 in execute sql1 loop

        fieldLabel = trim(item1.field_label);
        fieldName = trim(lower(item1.field_name));
        fieldType = item1.id_type;
        fieldMask = trim(item1.field_mask);
        fieldFK = item1.id_fk;
        domainName := trim(item1.domain_name);

        --html := concat(html, '<div class="w3-half">');
        html := concat(html, '<div class="">');
        html := concat(html, '<label>', fieldLabel, '</label>');        

        if (fieldFK = 0) then
            html := concat(html, ' <input ');
            html := concat(html, ' class=', dbqt('w3-input w3-border'));
            html := concat(html, ' id=', dbqt(fieldName));
            html := concat(html, ' name=', dbqt(fieldName));            
            html := concat(html, ' type=', dbqt('text'));

            -- Filter must allow users enter the ID, cannot disable
            if (fieldName = 'id') then

                if (eventId = 1) then
                    -- NEW: set zero and disable
                    html := concat(html, ' value=', dbqt('0'));
                    html := concat(html, ' disabled ');
                elsif (eventId = 5) then
                    -- FILTER: set empty and allow enter data
                    html := concat(html, ' value=', dbqt(''));
                else
                    -- All other situation just disable
                    html := concat(html, ' value=', dbqt(resultset->>fieldName));                    
                    html := concat(html, ' disabled ');
                end if;

            else
                html := concat(html, ' value=', dbqt(resultset->>fieldName));
            end if;

            html := concat(html, ' >');
        else
            html := concat(html, ' <select ');
            html := concat(html, ' class=', dbqt('w3-input w3-border'));
            html := concat(html, ' id=', dbqt(fieldName));
            html := concat(html, ' name=', dbqt(fieldName));            
            html := concat(html, ' >');

            -- Empty item    
            html := concat(html, '<option value="0">');
            html := concat(html, 'Selecionar');
            html := concat(html, '</option>');            

            -- Figure out ID and DS to populate dropdown
            execute trace('fieldFK: ', fieldFK::text);
            if (fieldFK = 4) then
                -- Domain table
                sql4 := 'select ';
                sql4 := concat(sql4, 'field->>', qt('id_domain'), ' as id');
                sql4 := concat(sql4, ', ');
                sql4 := concat(sql4, 'field->>', qt('value'), ' as ds');
                sql4 := concat(sql4, ' from tb_domain');
                sql4 := concat(sql4, ' where (session->>', qt('id_system'), ')::int = ', systemId);
                sql4 := concat(sql4, ' and (field->>', qt('domain'), ')::text = ', qt(domainName));
            else
                -- Other tables
                sql4 := 'select ';
                sql3 := concat('select field_name from vw_table where id_system = ', systemId, ' and id_type = ', 1, ' limit 1 ');
                for item3 in execute sql3 loop
                    sql4 := concat(sql4, 'field->>', qt(item3.field_name), ' as id', ',');
                end loop;
                sql3 := concat('select field_name from vw_table where id_system = ', systemId, ' and id_type = ', 3, ' limit 1 ');        
                for item3 in execute sql3 loop
                    sql4 := concat(sql4, 'field->>', qt(item3.field_name), ' as ds');
                end loop;
                sql4 := concat(sql4, ' from ', get_table(systemId, fieldFK));
            end if;
            execute trace('SQL4: ', sql4);            

            -- Populate the dropdown
            for item4 in execute sql4 loop
                html := concat(html, '<option value=', dbqt(item4.id));

                if (resultset->>fieldName = item4.id) then
                    html := concat(html, ' selected ');
                end if;

                html := concat(html, '>');
                html := concat(html, item4.ds);
                html := concat(html, '</option>');
            end loop;

            html := concat(html, '</select>');            
        end if;

        html := concat(html, '<br>');
        html := concat(html, '</div>');

    end loop;

    ---
    --- Actions (Buttons)
    ---
    html :=concat(html, get_event(systemId, tableId, 2));

    ---
    --- Javascript
    ---
    sql5 := concat(sql5, ' select');
    sql5 := concat(sql5, ' field->>', qt('id'), ' id');
    sql5 := concat(sql5, ' ,field->>', qt('code'), ' code');
    sql5 := concat(sql5, ' from tb_code');
    sql5 := concat(sql5, ' where (session->', qt('id_system'), ')::int = ', systemId);
	execute trace('SQL5: ', sql5);

    html := concat(html, '<script langauage="JavaScript">');    
    for item4 in execute sql5 loop
        html := concat(html, item4.code);
    end loop;
    html := concat(html, '</script>');    

    ---
    --- Prepare HTML to return as JSON
    ---
    html := replace(html, '"', '|');
    html := concat('{', dbqt('html'), ':', dbqt(html), '}');
    execute trace('Form: ', html);

    ---
    --- Return data (success)
    ---
    data := get_output(SUCCESS, 0, 0, '', '', html);

    ---
    --- Finish with success
    ---
	execute trace('End Query(): ', 'Success');

exception when others then
    ---
    --- Return data (fail)
    ---
    data := get_output(FAIL, 0, 0, SQLERRM, '', '[]');
    ---
    --- Finish no success
    ---
    execute trace('End Query() -> exception: ', SQLERRM);    
end;

$procedure$
