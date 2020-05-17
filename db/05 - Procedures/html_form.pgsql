/*
-- filtering
call html_form('{"session":{"id_system":1,"id_table":1,"id":0,"id_event":1,"page_offset":0,"id_language":2}}')
*/

drop procedure if exists html_form;
create or replace procedure html_form(inout data text)
language plpgsql
as $procedure$
declare
    id text := '';
    systemId text := '';
    languageId text := '';
    tableId text := '';
    eventId text := '';
    fieldFK text := '';
    sql1 text := '';
    sql2 text := '';
    tableName text := '';
    tableFk text := '';
    fieldName text := '';
    fieldValue text := '';
    fieldLabel text := '';
    fieldType text := '';
    fieldMask text := '';
    domainName text := '';
    target text = '2'; -- form
    recordCount float := 0;
    checked text := '';
    disabled text := '';
    events text := '';    
    html text := '';
    item1 record;
    item2 record;
    resultset jsonb;
    SUCCESS text := '1';
    FAIL text := '';
    TB_DOMAIN int := 5;
begin
    ---
    --- Start processing
    ---
	execute trace('Begin Form(): ', data::text);

    ---
    --- Session related information
    ---
    id := data::jsonb->'field'->>'id'::text;
    systemId := data::jsonb->'session'->>'id_system'::text;
    languageId := (data::jsonb->'session'->>'id_language')::text;
    tableId := data::jsonb->'session'->>'id_table'::text;
    eventId := data::jsonb->'session'->>'id_event'::text;
    tableName := get_table(systemId, tableId);

    ---
    --- Get table structure
    ---
    sql1 := get_struct(systemId, tableId);

    ---
    --- Page title
    ---
    html := concat(html, '<h3>', get_title(systemId, tableId, languageId), '</h3>');
    html := concat(html, '<br>');    

    ---
    --- Get the record
    ---
    if (id <> '0') then
        sql2 := '';
        sql2 := concat(sql2, ' select field');
        sql2 := concat(sql2, sql_from(tableName));
        sql2 := concat(sql2, sql_where(tableName, systemId));
        sql2 := concat(sql2, sql_and(tableName, 'id', id));
        execute trace('SQL2: ', sql2);
        for item2 in execute sql2 loop
            resultset := item2.field;
        end loop;
    end if;    

    ---
    --- Create the form
    ---
    for item1 in execute sql1 loop        
        recordCount = recordCount + 1;
        fieldLabel = trim(item1.field_label);
        fieldName = trim(lower(item1.field_name));
        fieldType = trim(item1.field_type);
        fieldMask = trim(item1.field_mask);
        fieldFK = item1.field_fk::text;
        domainName := trim(item1.domain_name);
        fieldValue := '';
        disabled := '';

        -- Filter must allow users enter the ID, cannot disable
        if (fieldName = 'id') then
            if (eventId = '1') then
                -- NEW: set zero and disable
                fieldValue := '';
                disabled := ' disabled ';
            elsif (eventId = '5') then
                -- FILTER: set empty and allow enter data
                fieldValue := '';
            else
                -- All other situation just disable
                fieldValue := (resultset->>fieldName)::text;
                disabled := ' disabled ';
            end if;
        else
            fieldValue := (resultset->>fieldName)::text;
        end if;

        --html := concat(html, '<div class="w3-half">');
        html := concat(html, '<div class="">');
        html := concat(html, '<label>', fieldLabel, '</label>');
        -- Write the form
        if (fieldFK = '0') then
            -- event:filter | type:int/dec/dat enable checkbox to pick operator
            if (eventId = '5' and (fieldType = 'integer' or fieldType = 'decimal' or fieldType = 'date')) then 
                html := concat(html, html_dropdown(systemId, concat(fieldName, '_operator'), TB_DOMAIN::text, fieldValue, 'tb_operator'));
                html := concat (html, '</p>');
                html := concat (html, html_input('text', fieldName, fieldValue, disabled, checked, events));
            else
                if (fieldType = 'text') then
                    html := concat (html, '</p>');
                    html := concat (html, html_textarea(fieldName, fieldValue));
                else    
                    html := concat (html, html_input('text', fieldName, fieldValue, disabled, checked, events));
                end if;
            end if;
        else
            html := concat(html, html_dropdown(systemId, fieldName, fieldFK, fieldValue, domainName));
        end if;
        html := concat(html, '<br>');
        html := concat(html, '</div>');

    end loop;

    ---
    --- Actions (Buttons)
    ---
    html := concat(html, get_event(systemId, tableId, target, eventId, recordCount::text, languageId));

    ---
    --- Javascript
    ---
    html :=concat(html, get_js(systemId, tableId));

    ---
    --- Return data (success)
    ---
    data := html;

    ---
    --- Finish with success
    ---
	execute trace('End Query(): ', 'Success');

exception when others then

    ---
    --- Return data (fail)
    ---
    data := SQLERRM::text;

    ---
    --- Finish no success
    ---
    execute trace('End Query() -> exception: ', SQLERRM);
end;

$procedure$
