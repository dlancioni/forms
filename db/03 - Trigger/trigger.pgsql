/*
 Create, change or delete records on tb_system when tb_company is touched
 call persist('{"session":{"id_system":1,"id_table":2,"id_action":1, "id_user":1},"field":{"id":0,"id_system":1,"name":"tb_1","url":"index.php?id_layout=1&id_table=33&page_offset=0","table_name":"tb_1"}}');
*/
create or replace function fn_ai_table() returns trigger as $$
declare
    id int := 0;
    tableEventId text;
    systemId jsonb := (new.session->>'id_system')::int;
    tableName text := (new.field->>'table_name')::text;    
    jsons jsonb;
    jsonf jsonb;
    TB_EVENT jsonb = 5;
begin

    -- Once a table is created, default events are create too
    if (tg_op = 'INSERT') then

        -- ID create in tb_table for current record
        tableEventId := currval(pg_get_serial_sequence('tb_table', 'id'));

        -- Create physical table
        if not exists (
            select from information_schema.tables 
            where table_schema = 'system'
            and table_name = tableName
        ) then
            execute concat('create table ', tableName, ' (like tb_table)');
        end if;

        -- Delete existing events
        delete from tb_event
        where (session->>'id_system')::int = systemId::int
        and (field->>'id_table')::int = tableEventId::int;

        -- Define the Session
        jsons := json_set(new.session, 'id_table', TB_EVENT::text);

        -- Create standard buttons for current form [New, Edit, Delete, Save, Filter, Filter, Back]        
        jsonf := json_set('{"id":1,"name":"new","id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"New","code":"go(getTarget(), getTable(), getId(), 1);"}', 'id_table', tableEventId);
        id := stamp('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":2,"name":"edit","id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Edit","code":"go(getTarget(), getTable(), getId(), 2);"}', 'id_table', tableEventId);
        id := stamp('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":3,"name":"delete","id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Delete","code":"go(getTarget(), getTable(), getId(), 3);"}', 'id_table', tableEventId);
        id := stamp('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":4,"name":"save","id_target":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Save","code":"execute();"}', 'id_table', tableEventId);
        id := stamp('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":5,"name":"filter1","id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Filter","code":"go(getTarget(), getTable(), getId(), 5);"}', 'id_table', tableEventId);
        id := stamp('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":6,"name":"filter2","id_target":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Filter","code":"go(getTarget(), getTable(), getId(), 6);"}', 'id_table', tableEventId);
        id := stamp('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":7,"name":"back","id_target":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Back","code":"go(getTarget(), getTable(), getId(), 7);"}', 'id_table', tableEventId);
        id := stamp('tb_event', jsons, jsonf);

        -- Finish
        return new;
    end if;

end;
$$ language plpgsql;

drop trigger if exists tg_ai_table on tb_table;
create trigger tg_ai_table after insert on tb_table
for each row execute procedure fn_ai_table();