/*
 Create, change or delete records on tb_system when tb_company is touched
 call persist('{"session":{"id_system":1,"id_table":2,"id_action":1, "id_user":1},"field":{"id":0,"id_system":1,"name":"tb_1","url":"index.php?id_layout=1&id_table=33&page_offset=0","table_name":"tb_1"}}');
*/
create or replace function fn_ai_table() returns trigger as $$
declare
    id text := '';
    sql text = '';
    tableEventId text;
    systemId jsonb;
    jsons jsonb;
    jsonf jsonb;

    TB_FIELD text := '4';
    TB_EVENT text = '6';

begin

    -- Get jey values
    systemId := new.session->>'id_system';
    
    -- Get current session
    jsons := new.session;

    -- Once a table is created, default events are create too
    if (tg_op = 'INSERT') then

        -- ID create in tb_table for current record
        tableEventId := currval(pg_get_serial_sequence('tb_table', 'id'));

        -- Create physical table
        execute concat('create table if not exists ', trim(new.field->>'table_name'), ' (id serial, session jsonb, field jsonb)');

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
        jsonf := json_set('{"id":1,"name":"new","id_page":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"New","code":"go(getPage(), getTable(), getId(), 1);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":2,"name":"edit","id_page":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Edit","code":"go(getPage(), getTable(), getId(), 2);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":3,"name":"delete","id_page":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Delete","code":"go(getPage(), getTable(), getId(), 3);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":4,"name":"save","id_page":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Save","code":"execute();"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":5,"name":"filter1","id_page":1,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Filter","code":"go(getPage(), getTable(), getId(), 5);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":6,"name":"filter2","id_page":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Filter","code":"go(getPage(), getTable(), getId(), 6);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);
        jsonf := json_set('{"id":7,"name":"back","id_page":2,"id_table":0,"id_field":0,"id_event":1,"id_event_type":2,"display":"Back","code":"go(getPage(), getTable(), getId(), 7);"}', 'id_table', tableEventId);
        id := insert('tb_event', jsons, jsonf);

        -- Finish
        return new;

    elsif (tg_op = 'UPDATE') then

        -- Rename physical table
        if (trim(new.field->>'table_name') <> trim(old.field->>'table_name')) then
            execute concat('alter table ', trim(old.field->>'table_name'), ' rename to ', trim(new.field->>'table_name'));
        end if;

        -- Finish
        return new;        

    elsif (tg_op = 'DELETE') then        

        -- Cannot delete system table
        if ((old.field->>'id_type')::int = 1) then
            raise exception 'Cannot DELETE system tables';
        end if;

        -- Delete physical table
        sql := '';
        sql := concat(sql, 'drop table ', trim(old.field->>'table_name'));
        execute trace('sql: ', sql);
        execute sql;

        -- Finish
        return new;

    end if;

end;
$$ language plpgsql;

drop trigger if exists tg_ai_table on tb_table;
create trigger tg_ai_table after insert or update or delete on tb_table
for each row execute procedure fn_ai_table();