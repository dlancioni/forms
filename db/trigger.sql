create definer = current_user trigger`admin`.`tg_insert_system` after insert on `tb_company` for each row
begin

    set @id_company = new.id;

    -- tb_company
    insert into tb_company (data) values (json_replace('{"data": {"id": 0, "name": "Lancioni Cons.", "type": 1, "expire_date": "2020-12-31T00:00:00", "price": "0.00"}}', '$.data.id_company', @id_company));
    -- tb_system
    insert into tb_system (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "name": "Forms Inc"}}', '$.data.id_company', @id_company));
    -- tb_table
    insert into tb_table (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Company", "name": "tb_company"}}', '$.data.id_company', @id_company));
    insert into tb_table (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "System", "name": "tb_system"}}', '$.data.id_company', @id_company));
    insert into tb_table (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Table", "name": "tb_table"}}', '$.data.id_company', @id_company));
    insert into tb_table (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Field", "name": "tb_field"}}', '$.data.id_company', @id_company));
    insert into tb_table (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "alias": "Domain", "name": "tb_domain"}}', '$.data.id_company', @id_company));
    -- tb_field
        -- tb_company
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Name", "name": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Type", "type": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 5, "domain": "tb_company_type"}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Expire Date", "name": "expire_date", "id_type": 4, "size": 0, "mask": "dd/MM/yyyy", "mandatory": 1, "unique": 0, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Price", "name": "price", "id_type": 2, "size": 0, "mask": "1.000,00", "mandatory": 1, "unique": 0, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
        -- tb_system
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Company", "name": "id_company", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 1, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Name", "name": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
        -- tb_table
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "System", "name": "id_system", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 2, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Name", "name": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Url", "name": "url", "id_type": 3, "size": 500, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Table Name", "name": "table", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
        -- tb_field
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Table", "name": "id_table", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 3, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Label", "name": "label", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Name", "name": "name", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Type", "name": "id_type", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 5, "domain": "tb_field_type"}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Size", "name": "size", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Mask", "name": "mask", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Mandatory", "name": "id_mandatory", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 5, "domain": "tb_bool"}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Unique", "name": "id_unique", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 5, "domain": "tb_bool"}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "FK", "name": "id_fk", "id_type": 1, "size": 0, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 3, "domain": ""}}', '$.data.id_company', @id_company));
    insert into tb_field (data) values (json_replace('{"data": {"id": 0, "id_company": 1, "id_system": 1, "label": "Domain", "name": "domain", "id_type": 3, "size": 50, "mask": "", "mandatory": 1, "unique": 1, "id_fk": 0, "domain": ""}}', '$.data.id_company', @id_company));

	if (new.id > 1) then
		insert into tb_system (id_company, name) values (new.id, 'System 1');
	end if;
end