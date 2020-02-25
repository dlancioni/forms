/* 
call persist('{"field": {"name": "reports", "id_company": 1}, "session": {"action": "I", "id_table": 2, "id_system": 1, "id_company": 1}}'); 
call persist('{"field": {"id": 5, "name": "System 2", "id_company": 1}, "session": {"action": "U", "id_table": 2, "id_system": 1, "id_company": 1}}'); 
call persist('{"field": {"id": 5, "name": "System 2", "id_company": 1}, "session": {"action": "D", "id_table": 2, "id_system": 1, "id_company": 1}}'); 
*/
drop procedure if exists persist;
create or replace procedure system.persist(INOUT json jsonb)
language plpgsql
AS $$
declare
	id int := 0;
    id_company int := 0;
    id_system int := 0;
	id_table int := 0;
	action varchar := '';
	table_name varchar := '';
	sql varchar := '';
	field_name varchar := '';
    field_type int := 0;
	field_value varchar := '';	
    item record;
begin

	-- Keep key parameters
	id = json->'field'->>'id';	
	id_company := (json->'session'->>'id_company')::int;
	id_system := (json->'session'->>'id_system')::int;
	id_table := (json->'session'->>'id_table')::int;
	action = json->'session'->>'action';

	-- Validate input
	if (position(action in 'IUD') = 0) then
	    raise exception 'Action is invalid or missing: %', action;	
	end if;

	-- Must figure out table name
    select (data->'field'->>'table_name')::text into table_name from tb_table
	where (data->'field'->>'id_company')::int = id_company
	and (data->'field'->>'id_system')::int = id_system
	and tb_table.id = id_table;
	if (table_name = null or table_name = '') then
	    raise exception 'Table name not found for table id %', id_table;
    end if;
    
	-- Valiadte the json and persist it
    for item in execute 'select * from vw_table where vw_table.id_table = ' || id_table loop
	    -- Keep key information
		field_name = trim(item.field_name);
        field_type = item.id_type;
		field_value = trim(json->'field'->>field_name);

        -- validate data
		if (action = 'I' or action = 'U') then
			-- Validate mandatory fields
			if ((item.id_mandatory)::int = 1) then
				if (field_value = null OR field_value = '') then
					 raise exception 'Campo % é obrigatorio', field_name;
				end if;
			end if;
			-- Validate unique values
			if ((item.id_unique)::int = 1) then
				if (is_unique(id_company, id_system, table_name, field_name, field_value) = false) then
					 raise exception 'Valor % ja existe na tabela % campo %', field_value, table_name, field_name;
				end if;
			end if;
		elsif (action = 'D') then        
			if (is_fk(id_company, id_system, id_table, id) = true) then
				raise exception 'Registro não pode ser excluído, existem dependencias em %', table_name;
			end if;
		end if;
    end loop;

    -- Persist data, on insert generate id and stamp as new element
	if (action = 'I') then
		execute concat('insert into ', table_name, ' (id) values (default)');
		id := (select currval(concat(table_name, '_id_seq')));
		json := jsonb_set(json, '{"field", "id"}', dbqt(id::text)::jsonb);
		execute concat('update ', table_name, ' set data = ', qt(json::text), ' where id = ', id);
    elsif (action = 'U') then
		execute concat('update ', table_name, ' set data = ', qt(json::text), ' where id = ', id);
    elsif (action = 'D') then
		execute concat('delete from ', table_name, ' where id = ', id);
	end if;

-- Error handling
exception when others then 
    raise exception '%', SQLERRM;
end;
$$
