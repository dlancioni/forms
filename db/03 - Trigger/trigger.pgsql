/*
 Create, change or delete records on tb_system when tb_company is touched
 call persist('{"session":{"id_system":1,"id_table":2,"id_action":1, "id_user":1},"field":{"id":0,"id_system":1,"name":"tb_1","url":"index.php?id_layout=1&id_table=33&page_offset=0","table_name":"tb_1"}}');
*/
create or replace function fn_ai_table() returns trigger as $$
declare
    tableEventId jsonb;
    systemId jsonb := (new.session->>'id_system')::int;
    tableId jsonb := (new.session->>'id_table')::int;
    userId jsonb := (new.session->>'id_user')::int;
    actionId jsonb := (new.session->>'id_action')::int;

    TABLE_EVENT jsonb = 5;
    json jsonb;
    jsons jsonb;
    jsonf jsonb;

begin

    -- Once a table is created, default events are create too
    if (tg_op = 'INSERT') then

        -- ID create in tb_table for current record
        tableEventId := currval(pg_get_serial_sequence('tb_table', 'id'));

        -- Delete existing events
        delete from tb_event
        where (session->>'id_system')::int = systemId::int
        and (field->>'id_table')::int = tableEventId::int;

        -- Define the Session
        jsons := '{}';        
        jsons := jsonb_set(jsons, '{"id_system"}', systemId);
        jsons := jsonb_set(jsons, '{"id_table"}', TABLE_EVENT);
        jsons := jsonb_set(jsons, '{"id_user"}', userId);
        jsons := jsonb_set(jsons, '{"id_action"}', actionId);

        -- Define the field with new button [New]
        jsonf := '{}';
        jsonf := jsonb_set(jsonf, '{"id"}', systemId);
        jsonf := jsonb_set(jsonf, '{"id_target"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_table"}', tableEventId);
        jsonf := jsonb_set(jsonf, '{"id_field"}', '0');
        jsonf := jsonb_set(jsonf, '{"id_event"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_event_type"}', '2');
        jsonf := jsonb_set(jsonf, '{"display"}', dbqt('New')::jsonb);
        jsonf := jsonb_set(jsonf, '{"code"}', dbqt('go(getTarget(), getTable(), getId(), 1);')::jsonb);
        insert into tb_event (session, field) values (jsons, jsonf);

        -- Define the field with new button [Edit]
        jsonf := '{}';
        jsonf := jsonb_set(jsonf, '{"id"}', '2');
        jsonf := jsonb_set(jsonf, '{"id_target"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_table"}', tableEventId);
        jsonf := jsonb_set(jsonf, '{"id_field"}', '0');                
        jsonf := jsonb_set(jsonf, '{"id_event"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_event_type"}', '2');
        jsonf := jsonb_set(jsonf, '{"display"}', dbqt('Edit')::jsonb);
        jsonf := jsonb_set(jsonf, '{"code"}', dbqt('go(getTarget(), getTable(), getId(), 2);')::jsonb);
        insert into tb_event (session, field) values (jsons, jsonf);

        -- Define the field with new button [Delete]
        jsonf := '{}';
        jsonf := jsonb_set(jsonf, '{"id"}', '3');
        jsonf := jsonb_set(jsonf, '{"id_target"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_table"}', tableEventId);
        jsonf := jsonb_set(jsonf, '{"id_field"}', '0');                
        jsonf := jsonb_set(jsonf, '{"id_event"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_event_type"}', '2');
        jsonf := jsonb_set(jsonf, '{"display"}', dbqt('Delete')::jsonb);
        jsonf := jsonb_set(jsonf, '{"code"}', dbqt('go(getTarget(), getTable(), getId(), 3);')::jsonb);
        insert into tb_event (session, field) values (jsons, jsonf);

        -- Define the field with new button [Save]
        jsonf := '{}';
        jsonf := jsonb_set(jsonf, '{"id"}', '4');
        jsonf := jsonb_set(jsonf, '{"id_target"}', '2');
        jsonf := jsonb_set(jsonf, '{"id_table"}', tableEventId);
        jsonf := jsonb_set(jsonf, '{"id_field"}', '0');                
        jsonf := jsonb_set(jsonf, '{"id_event"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_event_type"}', '2');
        jsonf := jsonb_set(jsonf, '{"display"}', dbqt('Save')::jsonb);
        jsonf := jsonb_set(jsonf, '{"code"}', dbqt('execute();')::jsonb);
        insert into tb_event (session, field) values (jsons, jsonf); 

        -- Define the field with new button [Filter]
        jsonf := '{}';
        jsonf := jsonb_set(jsonf, '{"id"}', '5');
        jsonf := jsonb_set(jsonf, '{"id_target"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_table"}', tableEventId);
        jsonf := jsonb_set(jsonf, '{"id_field"}', '0');                
        jsonf := jsonb_set(jsonf, '{"id_event"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_event_type"}', '2');
        jsonf := jsonb_set(jsonf, '{"display"}', dbqt('Filter')::jsonb);
        jsonf := jsonb_set(jsonf, '{"code"}', dbqt('go(getTarget(), getTable(), getId(), 5);')::jsonb);
        insert into tb_event (session, field) values (jsons, jsonf);

        -- Define the field with new button [Filter]
        jsonf := '{}';
        jsonf := jsonb_set(jsonf, '{"id"}', '6');
        jsonf := jsonb_set(jsonf, '{"id_target"}', '2');
        jsonf := jsonb_set(jsonf, '{"id_table"}', tableEventId);
        jsonf := jsonb_set(jsonf, '{"id_field"}', '0');                
        jsonf := jsonb_set(jsonf, '{"id_event"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_event_type"}', '2');
        jsonf := jsonb_set(jsonf, '{"display"}', dbqt('Filter')::jsonb);
        jsonf := jsonb_set(jsonf, '{"code"}', dbqt('go(getTarget(), getTable(), getId(), 6);')::jsonb);
        insert into tb_event (session, field) values (jsons, jsonf);        

        -- Define the field with new button [Back]
        jsonf := '{}';
        jsonf := jsonb_set(jsonf, '{"id"}', '7');
        jsonf := jsonb_set(jsonf, '{"id_target"}', '2');
        jsonf := jsonb_set(jsonf, '{"id_table"}', tableEventId);
        jsonf := jsonb_set(jsonf, '{"id_field"}', '0');                
        jsonf := jsonb_set(jsonf, '{"id_event"}', '1');
        jsonf := jsonb_set(jsonf, '{"id_event_type"}', '2');
        jsonf := jsonb_set(jsonf, '{"display"}', dbqt('Back')::jsonb);
        jsonf := jsonb_set(jsonf, '{"code"}', dbqt('go(getTarget(), getTable(), getId(), 7);')::jsonb);
        insert into tb_event (session, field) values (jsons, jsonf);  

        -- Finish
        return new;
    end if;

end;
$$ language plpgsql;

drop trigger if exists tg_ai_table on tb_table;
create trigger tg_ai_table after insert on tb_table
for each row execute procedure fn_ai_table();