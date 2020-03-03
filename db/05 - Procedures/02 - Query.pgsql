create or replace procedure query(inout json_new jsonb)
language plpgsql
as $procedure$
declare
    sql1 text := '' ;
    sql2 text := 'select';
    rows text := '';
    output text := '';
    json text := '';
    item record;
    x jsonb;
begin
    -- call query('{"id_system":1, "id_table":1, "id_action":4, "filter":{"id":2}}');
    -- prepare sql on view table
    sql1 = concat('select * from vw_table where id_system = 1 and id_table = 3');
    for item in execute sql1 loop    
        sql2 := concat(sql2, sql_column(item.field_name, item.id_type), ',');
    end loop;
    sql2 := crop(sql2, ',');
    sql2 := concat(sql2, ' from ', get_table(1, 2));
    sql2 := concat(sql2, ' where 1 = 1');
    sql2 := concat('select to_jsonb(r)::text as record from (', sql2, ') r');
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
exception
    when others then
    -- return json with error (0 fail)
    json_new := json_out(0, 4, 0, sqlerrm, '');
end;
$procedure$
