/*
 Create, change or delete records on tb_system when tb_company is touched
*/
create or replace function fn_company_system() returns trigger as $$
declare
    json jsonb;
    systemId int := new.session->>'id_system';
    tableId int := new.field->>'id_table';
    userId int := new.session->>'id_user';
    actionid text := new.session->>'id_action';
begin

    -- Get tb_system in json format
    json := get_json(id_system, tableId, userId, id_action);
    json := jsonb_set(json, '{"field", "name"}', dbqt(name)::jsonb);

    json := jsonb_set(json, '{"field", "id_target"}', '1'::jsonb);
    json := jsonb_set(json, '{"field", "label"}', dbqt(name)::jsonb);
    json := jsonb_set(json, '{"field", "id_event"}', dbqt(name)::jsonb);
    json := jsonb_set(json, '{"field", "code"}', dbqt('go(document.getElementById(''id_table'').value)')::jsonb);

    insert into tb_action (field) values ('{"id":1,"id_table":1,"id_target":1,"label":"Novo","id_event":1,"code":"go(document.getElementById(''id_table'').value)"}');
    insert into tb_action (field) values ('{"id":2,"id_table":1,"id_target":2,"label":"Voltar","id_event":1,"code":"back(document.getElementById(''id_table'').value)"}');

    -- Update table according to the action
    if (tg_op = 'INSERT') then
        execute concat('insert into tb_system (data) values (', qt(json::text), ')');
        return new;
    elsif (tg_op = 'UPDATE') then
        -- cannot update on this trigger
        return new;
    elsif (tg_op = 'DELETE') then
        -- cannot delete on this trigger
        return old;
    end if;

end;
$$ language plpgsql;

-- drop trigger if exists tg_company_system on tb_company;
-- create trigger tg_company_system after insert or update on tb_company
-- for each row execute procedure fn_company_system();

