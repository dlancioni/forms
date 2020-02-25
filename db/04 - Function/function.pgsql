/*
author: david lancioni
target: crop data from string 
select crop('id,name, ', ',' );
*/
drop function if exists crop;
create or replace function crop(text text, value text)
returns character varying
language plpgsql
as $function$
begin
    return btrim(trim(text), value);
end;
$function$;

/*
author: david lancioni
target: set value between double quote
select dbqt('david');
select dbqt('');
*/
drop function if exists dbqt;
create or replace function dbqt(value text)
returns character varying
language plpgsql
as $function$
begin
    if (value != '') then
        value = concat('"', value, '"');
    else
        value = concat('"', '"');    
    end if;

    return value;
end;
$function$;

/*
author: david lancioni
target: avoid delete records while there are dependencies (fks)
select is_fk(1,1,1,1)
*/
drop function if exists is_fk;
create or replace function is_fk(id_company integer, id_system integer, id_table integer, id integer)
returns boolean
language plpgsql
as $function$
declare
    sql varchar;
    item1 record;
    item2 record;    
begin
    sql = '';
    sql = sql || ' select';
    sql = sql || ' table_name,';
    sql = sql || ' field_name';
    sql = sql || ' from vw_table';
    sql = sql || ' where id_company = ' || id_company;
    sql = sql || ' and id_system = ' || id_system;
    sql = sql || ' and id_fk = ' || id_table;
    for item1 in execute sql loop
        sql = '';
        sql = sql || ' select id';
        sql = sql || ' from ' || item1.table_name;
        sql = sql || ' where (data->' || qt('session') || '->>' || qt('id_company') || ')::int = ' || id_company;
        sql = sql || ' and (data->' || qt('session') || '->>' || qt('id_system') || ')::int = ' || id_system;
        sql = sql || ' and (data->' || qt('data') || '->>' || qt(item1.field_name) || ')::int = ' || id;
        for item2 in execute sql loop
            return true;    	    
        end loop;
    end loop;

    return false;
end;
$function$;

/*
author: david lancioni
target: check if the record is unique at the table
select is_unique(1,1,'tb_system', 'name', 'formsss') -- true, dont exists
select is_unique(1,1,'tb_system', 'name', 'forms') -- false, already exists 
*/
drop function if exists is_unique;
create or replace function is_unique(id_company integer, id_system integer, table_name character varying, field_name character varying, field_value character varying)
returns boolean
language plpgsql
as $function$
declare
    sql varchar;
    item record;    
begin
    sql = '';
    sql = sql || ' select * from ' || table_name;
    sql = sql || ' where (data->' || qt('session') || '->>' || qt('id_company') || ')::int = ' || id_company;
    sql = sql || ' and (data->' || qt('session') || '->>' || qt('id_system') || ')::int = ' || id_system;
    sql = sql || ' and data->' || qt('data') || '->>' || qt(field_name) || ' = ' || qt(field_value);
    for item in execute sql loop
        return false;    
    end loop;
    return true;
end;
$function$;

/*
author: david lancioni
target: set value between single quote
select qt('david');
*/
drop function if exists qt;
create or replace function qt(value character varying)
returns character varying
language plpgsql
as $function$
begin
    return '''' || value || '''';    
end;
$function$;

/*
author: david lancioni
target: just output values for debug porpouse
select trace('david');
*/
drop function if exists trace;
create or replace function trace(value text)
returns void
language plpgsql
as $function$
begin
    raise notice '%', value;
end;
$function$;

/*
author: david lancioni
target: check if the record is unique at the table
select table_json(1,1,1,'I')
select * from tb_system
*/
drop function if exists table_json;
create or replace function table_json(id_company int, id_system int, id_table int, action char(1))
returns jsonb
language plpgsql
as $function$
declare
    sql text := '';
    session text := '';
    record text := '';
    item record;   
begin

    -- Create session
    session = concat(session, dbqt('session'), ':', '{');
    session = concat(session, dbqt('id_company'), ':', id_company, ',');
    session = concat(session, dbqt('id_system'), ':', id_system, ',');
    session = concat(session, dbqt('id_table'), ':', id_table, ',');
    session = concat(session, dbqt('action'), ':', dbqt(action));
    session = concat(session, '}');

    -- Create record
    record = concat(record, dbqt('record'), ':', '{');
    sql := concat(sql, ' select field_name from vw_table');
    sql := concat(sql, ' where id_company = ', id_company);
    sql := concat(sql, ' and id_system = ', id_system);
    sql := concat(sql, ' and id_table = ', id_table);
    for item in execute sql loop        
        record = concat(record, dbqt(item.field_name), ':', dbqt(''), ',');        
    end loop;
    record := concat(crop(record, ','), '}');

    -- Create final JSONB
    return concat('{', session, ',', record, '}');

end;
$function$;
