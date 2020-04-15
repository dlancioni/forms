/*
 Create, change or delete records on tb_system when tb_company is touched
 call persist('{"session":{"id_system":1,"id_table":2,"id_action":1, "id_user":1},"field":{"id":0,"id_system":1,"name":"tb_1","url":"index.php?id_layout=1&id_table=33&page_offset=0","table_name":"tb_1"}}');
*/
create or replace function fn_ai_table() returns trigger as $$
declare
    systemId int := (new.session->>'id_system')::int;
    tableId int := (new.field->>'id_table')::int;
    userId int := (new.session->>'id_user')::int;
    actionId int := (new.session->>'id_action')::int;
    TABLE_EVENT int = 5;
    json jsonb;    
    jsons jsonb;
    jsonf jsonb;
begin

    -- Once a table is created, default events are create too
    if (tg_op = 'INSERT') then

        -- Template for TB_EVENT
        json := get_json(systemId, TABLE_EVENT, userId, actionId)::jsonb;

        -- Get session
        jsons := json->'session';
        jsonf := json->'field';

        -- Create button [New]
        jsonf := jsonb_set(jsonf, '{"id"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_target"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_table"}', '1');        
        jsonf := jsonb_set(jsonf, '{"id_event"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_event_type"}', '2');
        jsonf := jsonb_set(jsonf, '{"display"}', dbqt('New')::jsonb);
        jsonf := jsonb_set(jsonf, '{"field", "code"}', dbqt('go(getTarget(), getTable(), getId(), 1);')::jsonb);
        insert into tb_event (session, field) values (jsons, jsonf);

        -- Finish
        return new;
    end if;

end;
$$ language plpgsql;

drop trigger if exists tg_ai_table on tb_table;
create trigger tg_ai_table after insert on tb_table
for each row execute procedure fn_ai_table();