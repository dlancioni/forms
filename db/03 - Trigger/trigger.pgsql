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


        -- Create standard buttons for current form [New, Edit, Delete, Save, Filter, Filter, Back]
        jsonf := jsonb_set('{"id":1,"id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"New","code":"go(getTarget(), getTable(), getId(), 1);"}', '{"id_table"}', tableEventId);
        insert into tb_event (session, field) values (jsons, jsonf);
        jsonf := jsonb_set('{"id":2,"id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Edit","code":"go(getTarget(), getTable(), getId(), 2);"}', '{"id_table"}', tableEventId);
        insert into tb_event (session, field) values (jsons, jsonf);
        jsonf := jsonb_set('{"id":3,"id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Delete","code":"go(getTarget(), getTable(), getId(), 3);"}', '{"id_table"}', tableEventId);
        insert into tb_event (session, field) values (jsons, jsonf);
        jsonf := jsonb_set('{"id":4,"id_target":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Save","code":"execute();"}', '{"id_table"}', tableEventId);
        insert into tb_event (session, field) values (jsons, jsonf);
        jsonf := jsonb_set('{"id":5,"id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Filter","code":"go(getTarget(), getTable(), getId(), 5);"}', '{"id_table"}', tableEventId);
        insert into tb_event (session, field) values (jsons, jsonf);
        jsonf := jsonb_set('{"id":6,"id_target":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Filter","code":"go(getTarget(), getTable(), getId(), 6);"}', '{"id_table"}', tableEventId);
        insert into tb_event (session, field) values (jsons, jsonf);
        jsonf := jsonb_set('{"id":7,"id_target":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Back","code":"go(getTarget(), getTable(), getId(), 7);"}', '{"id_table"}', tableEventId);
        insert into tb_event (session, field) values (jsons, jsonf);

        -- Finish
        return new;
    end if;

end;
$$ language plpgsql;

drop trigger if exists tg_ai_table on tb_table;
create trigger tg_ai_table after insert on tb_table
for each row execute procedure fn_ai_table();