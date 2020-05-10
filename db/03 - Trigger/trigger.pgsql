/*
 Create, change or delete records on tb_system when tb_company is touched
 call persist('{"session":{"id_system":1,"id_table":2,"id_action":1, "id_user":1},"field":{"id":0,"id_system":1,"name":"tb_1","url":"index.php?id_layout=1&id_table=33&page_offset=0","table_name":"tb_1"}}');
*/
create or replace function fn_ai_table() returns trigger as $$
declare
    id int := 0;
    tableEventId text;
    systemId jsonb;
    tableName text := '';
    jsons jsonb;
    jsonf jsonb;
    TB_FIELD text := '3';
    TB_EVENT text = '5';
begin

    -- Get jey values
    systemId := new.session->>'id_system';
    tableName := new.field->>'table_name';
    
    -- Get current session
    jsons := new.session;

    -- Once a table is created, default events are create too
    if (tg_op = 'INSERT') then

        -- ID create in tb_table for current record
        tableEventId := currval(pg_get_serial_sequence('tb_table', 'id'));

        -- Create physical table
        execute concat('create table if not exists ', tableName, ' (id serial, session jsonb, field jsonb)');

        -- Delete existing events
        delete from tb_event
        where (session->>'id_system')::int = systemId::int
        and (field->>'id_table')::int = tableEventId::int;

        -- Create mandatory field ID
        jsons := json_set(jsons, 'id_table', TB_FIELD);
        jsonf := json_set('{"id":0,"id_system":1,"id_table":1,"label":"Id","name":"id","field_type":"integer","size":0,"mask":"","id_mandatory":"Y","id_unique":"Y","id_fk":0,"domain":""}', 'id_table', tableEventId);
        id := insert('tb_field', jsons, jsonf);

        -- Create standard buttons for current form [New, Edit, Delete, Save, Filter, Filter, Back]
        jsons := json_set(jsons, 'id_table', TB_EVENT);
        jsonf := json_set('{"id":1,"name":"new","id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"New","code":"go(getTarget(), getTable(), getId(), 1);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":2,"name":"edit","id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Edit","code":"go(getTarget(), getTable(), getId(), 2);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":3,"name":"delete","id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Delete","code":"go(getTarget(), getTable(), getId(), 3);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":4,"name":"save","id_target":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Save","code":"execute();"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":5,"name":"filter1","id_target":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Filter","code":"go(getTarget(), getTable(), getId(), 5);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":6,"name":"filter2","id_target":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Filter","code":"go(getTarget(), getTable(), getId(), 6);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":7,"name":"back","id_target":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Back","code":"go(getTarget(), getTable(), getId(), 7);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);

        -- Finish
        return new;
    end if;

end;
$$ language plpgsql;

create trigger tg_ai_table after insert on tb_table
for each row execute procedure fn_ai_table();