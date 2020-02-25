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
$function$

/*
author: david lancioni
target: set value between double quote
select dbqt('david');
*/
drop function if exists dbqt;
create or replace function dbqt(value character varying)
returns character varying
language plpgsql
as $function$
begin
    return '"' || value || '"';
end;
$function$

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
    raise notice '%', sql;
    for item1 in execute sql loop
        sql = '';
        sql = sql || ' select id';
        sql = sql || ' from ' || item1.table_name;
        sql = sql || ' where (data->' || qt('session') || '->>' || qt('id_company') || ')::int = ' || id_company;
        sql = sql || ' and (data->' || qt('session') || '->>' || qt('id_system') || ')::int = ' || id_system;
        sql = sql || ' and (data->' || qt('data') || '->>' || qt(item1.field_name) || ')::int = ' || id;
        raise notice '%', sql;        
        for item2 in execute sql loop
            return true;    	    
        end loop;
    end loop;

    return false;
end;
$function$

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
$function$

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
$function$

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
$function$
