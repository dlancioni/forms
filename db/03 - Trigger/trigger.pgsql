/*
author: David Lancioni - 02-2020
target: Create, change or delete records on tb_system when tb_company is touched
*/
create or replace function fn_company_system() returns trigger as $$
declare
    json jsonb;
    id_company int := new.data->'session'->>'id_company';
    id_system int := new.data->'session'->>'id_system';
    id_table int := new.data->'session'->>'id_table';
    action text := new.data->'session'->>'action';
    name text := new.data->'field'->>'name';
begin
    -- Get tb_system in json format
    json := table_json(id_company, id_system, id_table, action);
    -- Set target table to 2 (tb_system)
    json := jsonb_set(json, '{"session", "id_table"}', dbqt('2')::jsonb);
    -- Set new values
    json := jsonb_set(json, '{"field", "name"}', dbqt(name)::jsonb);

    -- Update table according to the action
    if (tg_op = 'INSERT') then
        call persist(json);
        return new;
    elsif (tg_op = 'UPDATE') then
        call persist(json);
        return new;
    elsif (tg_op = 'DELETE') then
        call persist(json);
        return old;
    end if;

end;
$$ language plpgsql;

drop trigger if exists tg_company_system on tb_company;
create trigger tg_company_system after insert or update or delete on tb_company
for each row execute procedure fn_company_system();

