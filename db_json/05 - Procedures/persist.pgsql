/* 
call persist('{"data": {"id": 0, "name": "System 1", "id_company": 1}, "session": {"action": "I", "id_table": 2, "id_system": 1, "id_company": 1}}'); 
call persist('{"data": {"id": 4, "name": "System 2", "id_company": 1}, "session": {"action": "U", "id_table": 2, "id_system": 1, "id_company": 1}}'); 
call persist('{"data": {"id": 4, "name": "System 2", "id_company": 1}, "session": {"action": "D", "id_table": 2, "id_system": 1, "id_company": 1}}'); 
*/
drop procedure persist;
CREATE OR REPLACE PROCEDURE system.persist(INOUT json jsonb)
 LANGUAGE plpgsql
AS $procedure$
declare
	id int := 0;
    id_company int := 0;
    id_system int := 0;
	id_table_ int := 0;
	action varchar := '';
	table_name varchar := '';
	sql varchar := '';
	field_name varchar := '';
    field_type int := 0;
	field_value varchar := '';	
    item record;
begin

	-- Keep key parameters
	id = json->'data'->>'id';
	id_table_ := json->'session'->>'id_table';    
	action = json->'session'->>'action';

	-- Validate input
	if (position(action in 'IUD') = 0) then
	    raise exception 'Action is invalid or missing: %', action;	
	end if;

	-- Must figure out table name
    select (data->'data'->>'table_name')::text into table_name from tb_table t where t.id = id_table_;
	if (table_name = null or table_name = '') then
	    raise exception 'Table name not found for table id %', id_table_;	
    end if;
    raise notice '% %', 'table_name before loop: ', table_name;

	-- Valiadte the json and persist it
    for item in
	select * from vw_table v
	where v.id_table = id_table_ loop

	    -- Keep key information
        id_company := json->'session'->>'id_company';
        id_system := json->'session'->>'id_system';
		field_name = trim(item.field_name);
        field_type = item.id_type;
		field_value = trim(json->'data'->>field_name);

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
			execute is_fk(id_company, id_system, id_table_, id);
		end if;
    end loop;

    -- Persist data
	if (action = 'I') then
		execute concat('insert into ', table_name, ' (data) values (', set_quote(json::text),')');
    elsif (action = 'U') then
		execute concat('update ', table_name, ' set data = ', set_quote(json::text), ' where id = ', id);
    elsif (action = 'D') then
		execute concat('delete from ', table_name, ' where id = ', id);
	end if;

-- Error handling
exception when others then 
    -- raise exception '% %', SQLERRM, SQLSTATE;
    raise exception '%', SQLERRM;
end;
$procedure$
