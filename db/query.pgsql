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
    sql := concat(sql, ' select field_name, id_type from vw_table');
    sql := concat(sql, ' where id_company = ', id_company);
    sql := concat(sql, ' where id_system = ', id_system);
    sql := concat(sql, ' where id_table = ', id_table);

    --

    for item in execute sql loop        
        record = concat(record, dbqt(item.field_name), ':');        
        if (item.id_type = 1 or item.id_type = 2) then
            record = concat(record, '0', ',');
        else
            record = concat(record, dbqt(''), ',');
        end if;
    end loop;
    record := crop(record, ',');
    record := concat(record, '}');

    -- Create final JSONB
    return concat('{', session, ',', record, '}');

end;
$function$
