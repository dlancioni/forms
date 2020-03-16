drop procedure if exists query;
create or replace procedure query(inout data jsonb)
language plpgsql
as $procedure$
declare
    systemId int := 0;
    tableId int := 0;
    sql1 text := '' ;
    sql2 text := 'select';
    rows text := '';
    output text := '';
    json text := '';
    item record;
    x jsonb;

    SUCCESS int := 1;
    FAIL int := 0;

begin

	-- Start processing
	execute trace('Begin Persist(): ', data::text);

    systemId := data::jsonb->'session'->>'id_system';
    tableId := data::jsonb->'session'->>'id_table';

    /*
     -- no condition
    call query('{"session":{"id_system":1,"id_table":2,"id_action":1},"filter":[]}')
    
     -- filtering
    call query('{"session":{"id_system":1,"id_table":2,"id_action":1},"filter":[{"field_name":"id", "operator":"=", "field_value":"1"}]}')
    */

    -- prepare sql on view table
    sql1 = concat('select * from vw_table where id_system = ', systemId, ' and id_table = ', tableId);
    for item in execute sql1 loop
        sql2 := concat(sql2, sql_column(item.field_name, item.id_type, item.field_mask), ',');
    end loop;    
    sql2 := crop(sql2, ',');
    sql2 := concat(sql2, ' from ', get_table(systemId, tableId));
    sql2 := concat(sql2, ' where 1 = 1');
    sql2 := concat(sql2, get_condition(data::jsonb));
    sql2 := concat('select to_jsonb(r)::text as record from (', sql2, ') r');

    -- get data and return json
    for item in execute sql2 loop
        rows := concat(rows, item.record::text, ',');
    end loop;
    rows := concat('[', crop(rows, ','), ']');

    -- Return data
    data := get_output(SUCCESS, 0, 0, '', '', rows);

	-- Finish
	execute trace('End Query(): ', 'Success');    

exception when others then

    -- Return json with error (0 Fail)
    data := get_output(FAIL, 0, 0, SQLERRM, '', '[]');

    -- Finish
    execute trace('End Query() -> exception: ', SQLERRM);    

end;

$procedure$
