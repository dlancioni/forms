/* 
call persist('{"session":{"id_system":1,"id_table":1,"id_action":1},"field":{"id":0,"name":"lancioni it","expire_date":"31/12/2021","price":1200}}'); 
call persist('{"session":{"id_system":1,"id_table":1,"id_action":2},"field":{"id":1,"name":"Lancioni IT","expire_date":"31/12/2021","price":1200}}'); 
call persist('{"session":{"id_system":1,"id_table":1,"id_action":3},"field":{"id":1}}'); 
*/
drop procedure if exists persist;
create or replace procedure persist(INOUT data jsonb)
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
	jsone jsonb; -- existing json on database
	jsons jsonb; -- session part
	jsonf jsonb; -- field part

begin
	-- Start processing
	execute trace('Begin Persist(): ', data::text);

	-- Keep key parameters
	jsons := data->'session';
	jsonf := data->'field';	
	
	id = (jsonf->>'id')::int;	
	systemId := (jsons->>'id_system')::int;
	tableId := (jsons->>'id_table')::int;
	actionId = (jsons->>'id_action')::int;

	-- Validate input
	if (position(actionId::text in '123') = 0) then
	    raise exception 'Action is invalid or missing: %', actionId;	
	end if;

	-- Must figure out table name
    select 
	(field->>'table_name')::text into tableName from tb_table
	where (field->>'id_system')::int = systemId and tb_table.id = tableId;	
	if (tableName = null or tableName = '') then
	    raise exception 'Table name not found for table id %', tableId;
    end if;

	execute trace('Current table: ', tableName);
	execute trace('Action ID: ', actionId::text);
	------------------------------------------------
	------------------------------------------------ INSERT
	------------------------------------------------
	if (actionId = 1) then
	
		-- Before insert
		execute trace('Validating before INSERT: ', actionId::text);

		-- Validate input and persist
		for item in execute concat('select * from vw_table where vw_table.id_table = ', tableId) loop
			-- Keep key information
			fieldName = trim(item.field_name);
			fieldType = item.id_type;
			fieldValue = trim(jsonf->>fieldName);
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

		-- Prepare statement
		sql := '';
		sql := concat(sql, 'insert into ', tableName);
		sql := concat(sql, ' (session, field) values (');
		sql := concat(sql, qt(jsons::text), ', ');
		sql := concat(sql, qt(jsonf::text));
		sql := concat(sql, ')');
		execute trace('SQL: ', sql); 
		execute sql;

		-- Get inserted id and stamp in the json
 		select currval(pg_get_serial_sequence(tableName, 'id')) into id;
		-- jsonf := jsonb_set(jsonf, '{id}', dbqt(id::text)::jsonb, false);
		jsonf := jsonb_set(jsonf, '{id}', id::text::jsonb, false);

		-- Save new json
		sql := concat('update ', tableName, ' set field = ', qt(jsonf::text), ' where id = ', id);
		execute trace('SQL: ', sql);
		execute sql;		

	end if;
    
	------------------------------------------------
	------------------------------------------------ UPDATE
	------------------------------------------------
	if (actionId = 2) then

		-- Before UPDATE
		execute trace('Validating before UPDATE: ', actionId::text);

		-- Figure out existing data		
		sql := concat(sql, ' select field jsone from ', tableName);
		sql := concat(sql, ' where (session', '->>', qt('id_system'), ')::int = ', systemId);
		sql := concat(sql, ' and (field', '->>', qt('id'), ')::int = ', id);
		execute trace('Get existing json: ', sql);
		for item in execute sql loop
			jsone := item.jsone;
		end loop;

		-- Are json different
		execute trace('Are json different: ', '');
		execute trace('json old: ', jsone::text);
		execute trace('json new: ', jsonf::text);

		-- validate if json changed
		sql := concat('select * from vw_table where id_table = ', tableId);
		execute trace('Get table structure: ', sql);
		for item in execute sql loop

			-- Collect data
			fieldMandatory = (item.id_mandatory)::int;
			fieldUnique = (item.id_unique)::int;			
			fieldName = trim(item.field_name);			
			fieldType = item.id_type;
			fieldValue = trim(jsonf->>fieldName);
			fieldMask = trim(item.field_mask);

			old := json_extract_path(jsone::json, fieldName)::text;
			new := json_extract_path(jsonf::json, fieldName)::text;

			-- Check for changes
			execute trace('fieldName: ', fieldName);
			execute trace('Old value: ', old);
			execute trace('New value: ', new);

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
						raise exception 'Data inváida [%] no campo %', fieldValue, fieldName;
					end if;
				end if;			
				if (fieldUnique = 1) then
					if (is_unique(systemId, tableName, fieldName, fieldValue) = false) then
						raise exception 'Valor [%] ja existe na tabela % campo %', fieldValue, tableName, fieldName;
					end if;
				end if;
				output := concat(output, ';', item.field_name);
			end if;
		end loop;

		-- Do not update, nothing changed
		if (output = '') then
			raise exception 'Nenhuma mudança foi identificada, alteração não realizada';
		end if;
		
		-- Before insert
		execute trace('Before update: ', jsonf::text);

		-- update the record
		sql := '';
		sql := concat(sql, ' update ', tableName, ' set ');
		sql := concat(sql, ' session = ', qt(jsons::text), ', ');
		sql := concat(sql, ' field = ', qt(jsonf::text));
		sql := concat(sql, ' where id = ', id);
		execute trace('SQL: ', sql);
		execute sql;
	end if;	

	------------------------------------------------
	------------------------------------------------ DELETE
	------------------------------------------------
	if (actionId = 3) then

		-- Before UPDATE
		execute trace('Validating before DELETE: ', actionId::text);

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
			sql = concat(sql, ' where (session->', qt('id_system'), ')::int = ', systemId);
			sql = concat(sql, ' and (field->', '->>', qt(item.field_name), ')::int = ', id);
			for item in execute sql loop
				raise exception 'Registro não pode ser excluído, existem dependencias em %', item.table_name;
			end loop;
		end loop;
		-- Delete the record
		sql := concat('delete from ', tableName, ' where id = ', id);
		execute sql;
	end if;

	-- Return json with success (1 Success)
	data := get_output(1, actionId, id, '', '');

	-- Finish
	execute trace('End Persist(): ', 'Success');

-- Error handling
exception 
	when others then 

		-- Return json with error (0 Fail)
		data := get_output(0, actionId, id, SQLERRM, '');

		-- Finish
		execute trace('End Persist() -> exception: ', SQLERRM);
end;
$$
