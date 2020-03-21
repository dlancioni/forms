/*
-- no condition
call query('{"session":{"id_system":1,"id_table":2,"page_limit":5,"page_offset":0},"filter":[]}')

-- filtering
call query('{"session":{"id_system":1,"id_table":2,"id_action":1},"filter":[{"field_name":"id", "operator":"=", "field_value":"1"}]}')
*/

drop procedure if exists query;
create or replace procedure query(inout data jsonb)
language plpgsql
as $procedure$
declare
    systemId int := 0;
    tableId int := 0;
    pageLimit int := 0;
    pageOffset int := 0;
    sql1 text := '';
    tableName text := '';
    item1 record;
    rows text := '';
    SUCCESS int := 1;
    FAIL int := 0;

begin

    ---
    --- Start processing
    ---
	execute trace('Begin Query(): ', data::text);

    ---
    --- Session related information
    ---
    systemId := data::jsonb->'session'->>'id_system';
    tableId := data::jsonb->'session'->>'id_table';
    pageLimit := data::jsonb->'session'->>'page_limit';
    pageOffset := data::jsonb->'session'->>'page_offset';
    tableName := get_table(systemId, tableId);

    ---
    --- Prepare main query
    ---
    --sql1 := 'select count(', tableName, '.id) over() as record_count,';
    sql1 := 'select count(*) over() as record_count,';

    ---
    --- Prepare field list 
    ---
    sql1 := concat(sql1, get_field_list(systemId, tableId));

    ---
    --- From clause
    ---
    sql1 := concat(sql1, ' from ', tableName, ' ');

    ---
    --- Join
    ---
    sql1 := concat(sql1, get_join(systemId, tableId));

    ---
    --- Condition (where)
    ---
    sql1 := concat(sql1, ' where (', tableName, '.session->', qt('id_system'), ')::int = ', systemId);

    ---
    --- Condition (and)
    ---    
    sql1 := concat(sql1, get_condition(data::jsonb));

    ---
    --- Ordering
    ---    
    sql1 := concat(sql1, ' order by ', tableName, '.id');

    ---
    --- Json transformation
    ---    
    sql1 := concat('select to_jsonb(r)::text as record from (', sql1, ') r');

    ---
    --- Paging
    ---
    sql1 := concat(sql1, ' limit ', pageLimit);
    sql1 := concat(sql1, ' offset ', pageOffset);
	execute trace('SQL: ', sql1);

    ---
    --- Final json
    ---
    for item1 in execute sql1 loop
        rows := concat(rows, item1.record::text, ',');
    end loop;
    rows := concat('[', crop(rows, ','), ']');

    ---
    --- Return data (success)
    ---
    data := get_output(SUCCESS, 0, 0, '', '', rows);

    ---
    --- Finish with success
    ---
	execute trace('End Query(): ', 'Success');

exception when others then
    ---
    --- Return data (fail)
    ---
    data := get_output(FAIL, 0, 0, SQLERRM, '', '[]');
    ---
    --- Finish no success
    ---
    execute trace('End Query() -> exception: ', SQLERRM);    
end;

$procedure$
