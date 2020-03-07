drop procedure query
create or replace procedure query(inout json_new text)
language plpgsql
as $procedure$
declare
    id_system int := 0;
    id_table int := 0;
    sql1 text := '' ;
    sql2 text := 'select';
    rows text := '';
    output text := '';
    json text := '';
    item record;
    x jsonb;
begin

    id_system := json_new::jsonb->'session'->>'id_system';
    id_table := json_new::jsonb->'session'->>'id_table';

    /*
    call query('{"session":{"id_system":1,"id_table":1,"id_action":1},"criteria":[{"field_name":"name", "operator":"=", "field_value":"1"}]}')
    */

    -- prepare sql on view table
    sql1 = concat('select * from vw_table where id_system = ', id_system, ' and id_table = ', id_table);
    for item in execute sql1 loop
    sql2 := concat(sql2, sql_column(item.field_name, item.id_type, item.field_mask), ',');
    end loop;    
    sql2 := crop(sql2, ',');
    sql2 := concat(sql2, ' from ', get_table(id_system, id_table));
    sql2 := concat(sql2, ' where 1 = 1');
    sql2 := concat(sql2, get_condition(json_new::jsonb));
    sql2 := concat('select to_jsonb(r)::text as record from (', sql2, ') r');
raise exception '%', sql2;
    -- get data and return json
    for item in execute sql2 loop
    rows := concat(rows, item.record::text, ',');
    end loop;

    -- format final result
    json := '{"statement":"sql","resultset":[contents]}';
    json := replace(json, 'sql', sql2);
    json := replace(json, 'contents', crop(rows, ','));

    -- return data
    json_new := json;
    -- error handling

exception when others then
    json_new := sqlerrm;
end;
$procedure$
