/* 
call persist('{"session":{"id_system":1,"id_table":1,"id_action":1},"field":{"id":1,"name":"lancioni it","expire_date":"2021-01-","price":1200}}'); 
call persist('{"session":{"id_system":1,"id_table":1,"id_action":2},"field":{"id":1,"name":"Lancioni IT","expire_date":"2021-01-01","price":1200}}'); 
call persist('{"session":{"id_system":1,"id_table":1,"id_action":3},"field":{"id":1,"name":"Lancioni IT","expire_date":"2021-01-01","price":1200}}'); 
*/
drop procedure if exists persist;
create or replace procedure persist(INOUT json_new jsonb)
language plpgsql
AS $$
declare

	id int := 0;
	tableId int := 0;
	actionId int := 0;	
    systemId int := 0;
    fieldType int := 0;
	fieldUnique int := 0;	
	fieldMandatory int := 0;	

	old text := '';
	new text := '';
	sql varchar := '';
	output text := '';	
	tableName varchar := '';
	fieldName varchar := '';
	fieldValue varchar := '';
	fieldMask varchar := '';

    item record;
	json_old jsonb;

begin

	-- Keep key parameters
	id = (json_new->'field'->>'id')::int;	
	systemId := (json_new->'session'->>'id_system')::int;
	tableId := (json_new->'session'->>'id_table')::int;
	actionId = (json_new->'session'->>'id_action')::int;

	-- Validate input
	if (position(actionId::text in '123') = 0) then
	    raise exception 'Action is invalid or missing: %', actionId;	
	end if;

	-- Must figure out table name
    select 
	(data->'field'->>'table_name')::text into tableName from tb_table
	where (data->'field'->>'id_system')::int = systemId and tb_table.id = tableId;	
	if (tableName = null or tableName = '') then
	    raise exception 'Table name not found for table id %', tableId;
    end if;

	------------------------------------------------
	------------------------------------------------ INSERT
	------------------------------------------------
	if (actionId = 1) then
		-- Validate input and persist
		for item in execute concat('select * from vw_table where vw_table.id_table = ', tableId) loop
			-- Keep key information
			fieldName = trim(item.field_name);
			fieldType = item.id_type;
			fieldValue = trim(json_new->'field'->>field_name);
			fieldMask = trim(item.field_mask);
			fieldMandatory = (item.id_mandatory)::int;
			fieldUnique = (item.id_unique)::int;
			-- Validate mandatory fields
			if (fieldMandatory = 1) then
				if (fieldValue = null or fieldValue = '') then
					raise exception 'Campo [%] é obrigatorio', fieldName;
				end if;
			end if;
			-- Validate unique values
			if (fieldUnique = 1) then
				if (is_unique(systemId, tableName, fieldName, fieldValue) = false) then
					raise exception 'Valor [%] ja existe na tabela % campo %', fieldValue, tableName, fieldName;
				end if;
			end if;
			-- Validate dates
			if (fieldType = 4) then
				if (parse_date(fieldValue, fieldMask) = false) then
					raise exception 'Data inváida [%] no campo %', fieldValue, fieldName;
				end if;
			end if;
		end loop;
		-- Insert the record
		execute concat('insert into ', tableName, ' (data) values (', qt(json_new::text), ')');
	end if;
    
	------------------------------------------------
	------------------------------------------------ UPDATE
	------------------------------------------------
	if (actionId = 2) then
		-- Figure out existing json_new		
		sql := concat(sql, ' select data json_old from ', tableName);
		sql := concat(sql, ' where (data->', qt('session'), '->>', qt('id_system'), ')::int = ', systemId);
		sql := concat(sql, ' and id = ', id);
		for item in execute sql loop
			json_old := item.json_old;
		end loop;
		-- validate if json changed
		sql := concat('select * from vw_table where id_table = ', tableId);
		for item in execute sql loop
			-- Collect data
			fieldMandatory = (item.id_mandatory)::int;
			fieldUnique = (item.id_unique)::int;			
			fieldName = trim(item.field_name);
			fieldType = item.id_type;
			fieldValue = trim(json_new->'field'->>field_name);						
			old := json_extract_path(json_old::json, 'field', item.field_name)::text;
			new := json_extract_path(json_new::json, 'field', item.field_name)::text;
			-- Validate mandatory fields
			if (fieldMandatory = 1) then
				if (fieldValue = null OR fieldValue = '') then
					raise exception 'Campo % é obrigatorio', field_name;
				end if;
			end if;
			-- If changed, validate unique values
			if (trim(old) != trim(new)) then
				-- Validate dates
				if (fieldType = 4) then
					if (parse_date(fieldValue, fieldMask) = false) then
						raise exception 'Data inváida [%] no campo %', fieldValue, field_name;
					end if;
				end if;			
				if (fieldUnique = 1) then
					if (is_unique(systemId, tableName, field_name, fieldValue) = false) then
						raise exception 'Valor % ja existe na tabela % campo %', fieldValue, tableName, field_name;
					end if;
				end if;
				output := concat(output, ';', item.field_name);
			end if;
		end loop;
		-- Do not update, nothing changed
		if (output = '') then
			raise exception 'Nenhuma mudança foi identificada, alteração não realizada';
		end if;		
		-- update the record
		execute concat('update ', tableName, ' set data = ', qt(json_new::text), ' where id = ', id);
	end if;	

	------------------------------------------------
	------------------------------------------------ DELETE
	------------------------------------------------
	if (actionId = 3) then
		raise notice 'Before %', 1;	
		-- Figure out dependency table
		sql = '';
		sql = concat(sql, ' select');
		sql = concat(sql, ' table_name,');
		sql = concat(sql, ' field_name');
		sql = concat(sql, ' from vw_table');
		sql = concat(sql, ' where id_system = ', systemId);
		sql = concat(sql, ' and id_fk = ', tableId);
		for item in execute sql loop
			-- Check if dependency has data
			sql = '';
			sql = concat(sql, ' select id,');
			sql = concat(sql, qt(item.table_name), ' table_name');
			sql = concat(sql, ' from ', item.table_name);
			sql = concat(sql, ' where (data->', qt('session'), '->>', qt('id_system'), ')::int = ', systemId);
			sql = concat(sql, ' and (data->', qt('field'), '->>', qt(item.field_name), ')::int = ', id);
			for item in execute sql loop
				raise exception 'Registro não pode ser excluído, existem dependencias em %', item.table_name;
			end loop;
		end loop;
		-- Delete the record
		sql := concat('delete from ', tableName, ' where id = ', id);
		execute sql;
	end if;

	-- Return json with success (1 Success)
	json_new := json_out(1, actionId, id, '', '');

-- Error handling
exception 
	when others then 
		-- Return json with error (0 Fail)
		json_new := json_out(0, actionId, id, SQLERRM, '');
end;
$$
