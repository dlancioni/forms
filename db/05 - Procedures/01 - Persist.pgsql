/* 
call persist('{"session":{"id_company":1,"id_system":1,"id_table":1,"action":"I"},"field":{"id":1,"name":"lancioni it","expire_date":"2021-01-01","price":1200}}'); 
call persist('{"session":{"id_company":1,"id_system":1,"id_table":1,"action":"U"},"field":{"id":1,"name":"Lancioni IT","expire_date":"2021-01-01","price":1200}}'); 
call persist('{"session":{"id_company":1,"id_system":1,"id_table":1,"action":"D"},"field":{"id":1,"name":"Lancioni IT","expire_date":"2021-01-01","price":1200}}'); 
*/
drop procedure if exists persist;
create or replace procedure persist(INOUT json_new jsonb)
language plpgsql
AS $$
declare
	id int := 0;
    field_type int := 0;
    id_company int := 0;
    id_system int := 0;
	id_table int := 0;
	old text := '';
	new text := '';
	output text := '';
	sql varchar := '';
	action varchar := '';
	table_name varchar := '';
	field_name varchar := '';
	field_value varchar := '';	
    item record;
	json_old jsonb;

begin

	-- Keep key parameters
	id = (json_new->'field'->>'id')::int;	
	id_company := (json_new->'session'->>'id_company')::int;
	id_system := (json_new->'session'->>'id_system')::int;
	id_table := (json_new->'session'->>'id_table')::int;
	action = json_new->'session'->>'action';

	-- Validate input
	if (position(action in 'IUD') = 0) then
	    raise exception 'Action is invalid or missing: %', action;	
	end if;

	-- Must figure out table name
    select 
	(data->'field'->>'table_name')::text
	into table_name 
	from tb_table
	where (data->'field'->>'id_system')::int = id_system
	and tb_table.id = id_table;
	
	if (table_name = null or table_name = '') then
	    raise exception 'Table name not found for table id %', id_table;
    end if;

	-- Validate if json changed
	if (action = 'U') then
		-- Figure out existing json_new		
		sql := concat(sql, ' select data json_old from ', table_name);
		sql := concat(sql, ' where (data->', qt('session'), '->>', qt('id_system'), ')::int = ', id_system);
		sql := concat(sql, ' and id = ', id);
		for item in execute sql loop
			json_old := item.json_old;
		end loop;
		-- validate if json changed
		sql := concat('select field_name from vw_table where id_table = ', id_table);
		for item in execute sql loop
			old := json_extract_path(json_old::json, 'field', item.field_name)::text;
			new := json_extract_path(json_new::json, 'field', item.field_name)::text;
			if (trim(old) != trim(new)) then
				output := concat(output, ';', item.field_name);
			end if;
		end loop;
		-- Do not update, nothing changed
		if (output = '') then
			raise exception 'Nenhuma mudança foi identificada, alteração não realizada';
		end if;			
	end if;	
    
	-- Validate json_new field by field
    for item in execute concat('select * from vw_table where vw_table.id_table = ', id_table) loop

	    -- Keep key information
		field_name = trim(item.field_name);
        field_type = item.id_type;
		field_value = trim(json_new->'field'->>field_name);

		-- Validations on insert and update
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
		end if;

		-- Validations on delete only
		if (action = 'D') then
			execute is_fk(id_company, id_system, id_table, id);
		end if;

    end loop;

    -- Persist data, on insert generate id and stamp as new element
	if (action = 'I') then
		execute concat('insert into ', table_name, ' (data) values (', qt(json_new::text), ')');
    elsif (action = 'U') then
		execute concat('update ', table_name, ' set data = ', qt(json_new::text), ' where id = ', id);
    elsif (action = 'D') then
		execute concat('delete from ', table_name, ' where id = ', id);
	end if;

-- Error handling
exception when others then 
    raise exception '%', SQLERRM;
end;
$$
