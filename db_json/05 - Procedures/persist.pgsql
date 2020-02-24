/* 
Success
call persist('{"session":{"id_table":"2", "action":"I"}, "data": {"id_company":1, "id":1, "name":"System 1"}}'); 
Name is Mandatory
call persist('{"session":{"id_table":"2", "action":"I"}, "data": {"id_company":1, "id":1, "name":""}}'); 
Name is Unique
call persist('{"session":{"id_table":"2", "action":"I"}, "data": {"id_company":1, "id":1, "name":"System 1"}}'); 
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

	/* 
    call persist('{"session":{"id_table":"2", "action":"I"}, "data": {"id_company":1, "id":1, "name":"System 1"}}');
    */


	-- Keep key parameters
	id = json->'data'->>'id';
	id_table_ := json->'session'->>'id_table';    
	action = json->'session'->>'action';

	-- Validate input
	if (position(action in 'IUD') = 0) then
	    raise exception 'Action is invalid or missing: %', action;	
	end if;

	-- Must figure out table name
    select data->>'table_name' into table_name from tb_table t where t.id = id_table_;
	if not found then
	    raise exception 'Table name not found for table id %', id_table_;	
    end if;

	-- Valiadte the json and persist it
    for item in
	select * from vw_table v
	where v.id_table = id_table loop

	    -- Keep key information
        id_company := json->'session'->>'id_company';
        id_system := json->'session'->>'id_system';
		field_name = trim(item.field_name);
        field_type = item.id_type;
		field_value = trim(json->'data'->>field_name);

            select trace(id_company);
            select trace(id_system);
            select trace(table_name);
            select trace(field_name);
            select trace(field_value);        

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
			if (is_fk(id_table_) = true) then
				 raise exception 'Valor % ja existe na tabela % campo %', field_value, table_name, field_name;
			end if;		
		end if;
    end loop;
    -- Persist data
	if (action = 'C') then
		execute concat('insert into ', table_name, ' (data) values (', set_quote(json::jsonb),')');
    elsif (action = 'U') then
		execute concat('update ', table_name, ' set data = ', set_quote(json::jsonb), ' where id = ', id);
    elsif (action = 'D') then
		execute concat('delete from ', table_name, ' where id = ', id);
	end if;
-- Error handling
exception when others then 
    -- raise exception '% %', SQLERRM, SQLSTATE;
    raise exception '%', SQLERRM;
end;
$procedure$
