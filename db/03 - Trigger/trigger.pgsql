/*
author: David Lancioni - 02-2020
target: Create, change or delete records on tb_system when tb_company is touched
*/
create or replace function fn_company_system() returns trigger as $$
declare
    json jsonb;
    id_system int := new.data->'session'->>'id_system';
    id_table int := new.data->'session'->>'id_table';
    id_action text := new.data->'session'->>'id_action';
    name text := new.data->'field'->>'name';
    id text := new.data->'field'->>'id';
begin

    -- Get tb_system in json format
    json := table_json(id_system, 2, id_action);
    json := jsonb_set(json, '{"field", "name"}', dbqt(name)::jsonb);

    -- Update table according to the action
    if (tg_op = 'INSERT') then
        execute concat('insert into tb_system (data) values (', qt(json::text), ')');
        return new;
    elsif (tg_op = 'UPDATE') then
        execute concat('update tb_system set data = ', qt(json::text), ' where id = ', id);
        return new;
    elsif (tg_op = 'DELETE') then
        -- cannot delete on trigger
        return old;
    end if;

end;
$$ language plpgsql;

drop trigger if exists tg_company_system on tb_company;
create trigger tg_company_system after insert or update on tb_company
for each row execute procedure fn_company_system();

