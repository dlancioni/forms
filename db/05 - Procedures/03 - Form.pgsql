/*
-- filtering
call form('{"session":{"id_system":1,"id_table":2,"id_action":1},"filter":[{"field_name":"id", "operator":"=", "field_value":"0"}]}')
*/

drop procedure if exists form;
create or replace procedure form(inout data jsonb)
language plpgsql
as $procedure$
declare
    id int := 0;
    systemId int := 0;
    tableId int := 0;
    fieldFK int := 0;
    sql1 text := '';
    sql2 text := '';
    sql3 text := '';
    sql4 text := '';    
    tableName text := '';
    tableFk text := '';
    fieldName text := '';
    fieldLabel text := '';
    fieldType int := 0;
    fieldMask text := '';
    domainName text := '';
    form text := '';
    item1 record;
    item2 record;
    item3 record;
    item4 record;    
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
    systemId := data::jsonb->'session'->>'id_system';
    tableId := data::jsonb->'session'->>'id_table';    
    tableName := get_table(systemId, tableId);

    ---
    --- Get table structure
    ---
    sql1 := concat(sql1, ' select * from vw_table');
    sql1 := concat(sql1, ' where id_system = ', systemId);
    sql1 := concat(sql1, ' and id_table = ', tableId);
	execute trace('SQL1: ', sql1);

    ---
    --- Create the form
    ---
    for item1 in execute sql1 loop

        fieldLabel = trim(item1.field_label);
        fieldName = trim(item1.field_name);
        fieldType = item1.id_type;
        fieldMask = trim(item1.field_mask);
        fieldFK = item1.id_fk;
        domainName := trim(item1.domain_name);

        form := concat(form, '<div class="w3-third">');
        form := concat(form, '<label>', fieldLabel, '</label>');        

        if (fieldFK = 0) then
            form := concat(form, ' <input ');
            form := concat(form, ' class=', dbqt('w3-input w3-border'));
            form := concat(form, ' id=', dbqt(fieldName));
            form := concat(form, ' type=', dbqt('text'));
            form := concat(form, ' value=', dbqt(''));
            form := concat(form, ' >');
        else
            form := concat(form, ' <select ');
            form := concat(form, ' class=', dbqt('w3-input w3-border'));
            form := concat(form, ' id=', dbqt(fieldName));
            form := concat(form, ' >');

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
                form := concat(form, '<option value=', dbqt(item4.id), '>');
                form := concat(form, item4.ds);
                form := concat(form, '</option>');
            end loop;

            form := concat(form, '</select>');            
        end if;

        form := concat(form, '<br>');
        form := concat(form, '</div>');

    end loop;

    ---
    --- Prepare HTML to return as JSON
    ---
    form := replace(form, '"', '|');
    form := concat('{', dbqt('html'), ':', dbqt(form), '}');
    execute trace('Form: ', form);

    ---
    --- Return data (success)
    ---
    data := get_output(SUCCESS, 0, 0, '', '', form);

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
