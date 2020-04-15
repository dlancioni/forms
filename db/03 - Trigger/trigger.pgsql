/*
 Create, change or delete records on tb_system when tb_company is touched
 call persist('{"session":{"id_system":1,"id_table":2,"id_action":1, "id_user":1},"field":{"id":0,"id_system":1,"name":"tb_1","url":"index.php?id_layout=1&id_table=33&page_offset=0","table_name":"tb_1"}}');
*/
create or replace function fn_ai_table() returns trigger as $$
declare
    json jsonb;
    systemId int := (new.session->>'id_system')::int;
    tableId int := (new.field->>'id_table')::int;
    userId int := (new.session->>'id_user')::int;
    actionId int := (new.session->>'id_action')::int;

declare
    TABLE_EVENT int = 5;

begin

    -- Update table according to the action
    if (tg_op = 'INSERT') then

        -- Get template for event table
        json := get_json(systemId, TABLE_EVENT, userId, actionId);
        execute trace('Empty json: ', json::text);

        -- Create button [New]
        json := jsonb_set(json, '{"field", "id_target"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_table"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_field"}', '0'::jsonb);
        json := jsonb_set(json, '{"field", "id_event"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_event_type"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "display"}', dbqt('New')::jsonb);
        json := jsonb_set(json, '{"field", "code"}', dbqt('go(getTarget(), getTable(), getId(), 1);')::jsonb);
        execute trace('Next json: ', json::text);
        call persist(json); 

        -- Create button [Edit]
        json := jsonb_set(json, '{"field", "id_target"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_table"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_field"}', '0'::jsonb);
        json := jsonb_set(json, '{"field", "id_event"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_event_type"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "display"}', dbqt('Edit')::jsonb);
        json := jsonb_set(json, '{"field", "code"}', dbqt('go(getTarget(), getTable(), getId(), 1);')::jsonb);
        execute trace('Next json: ', json::text);
        call persist(json); 
 
         -- Create button [Delete]
        json := jsonb_set(json, '{"field", "id_target"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_table"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_field"}', '0'::jsonb);
        json := jsonb_set(json, '{"field", "id_event"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_event_type"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "display"}', dbqt('Delete')::jsonb);
        json := jsonb_set(json, '{"field", "code"}', dbqt('go(getTarget(), getTable(), getId(), 1);')::jsonb);
        execute trace('Next json: ', json::text);
        call persist(json); 

         -- Create button [Save]
        json := jsonb_set(json, '{"field", "id_target"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "id_table"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_field"}', '0'::jsonb);
        json := jsonb_set(json, '{"field", "id_event"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_event_type"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "display"}', dbqt('Save')::jsonb);
        json := jsonb_set(json, '{"field", "code"}', dbqt('execute()')::jsonb);
        execute trace('Next json: ', json::text);
        call persist(json);

         -- Create button [Filter]
        json := jsonb_set(json, '{"field", "id_target"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_table"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_field"}', '0'::jsonb);
        json := jsonb_set(json, '{"field", "id_event"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_event_type"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "display"}', dbqt('Filter')::jsonb);
        json := jsonb_set(json, '{"field", "code"}', dbqt('go(getTarget(), getTable(), getId(), 1);')::jsonb);
        execute trace('Next json: ', json::text);
        call persist(json);   

         -- Create button [Filter]
        json := jsonb_set(json, '{"field", "id_target"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "id_table"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_field"}', '0'::jsonb);
        json := jsonb_set(json, '{"field", "id_event"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_event_type"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "display"}', dbqt('Filter')::jsonb);
        json := jsonb_set(json, '{"field", "code"}', dbqt('go(getTarget(), getTable(), getId(), 1);')::jsonb);
        execute trace('Next json: ', json::text);
        call persist(json);

         -- Create button [Back]
        json := jsonb_set(json, '{"field", "id_target"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "id_table"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_field"}', '0'::jsonb);
        json := jsonb_set(json, '{"field", "id_event"}', '1'::jsonb);
        json := jsonb_set(json, '{"field", "id_event_type"}', '2'::jsonb);
        json := jsonb_set(json, '{"field", "display"}', dbqt('Back')::jsonb);
        json := jsonb_set(json, '{"field", "code"}', dbqt('go(getTarget(), getTable(), getId(), 1);')::jsonb);
        execute trace('Next json: ', json::text);
        call persist(json);

        -- Finish
        return new;
    end if;

end;
$$ language plpgsql;

drop trigger if exists tg_ai_table on tb_table;
create trigger tg_ai_table after insert on tb_table
for each row execute procedure fn_ai_table();

