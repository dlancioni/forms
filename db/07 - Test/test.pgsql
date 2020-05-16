/*
call test('a')
*/

drop procedure if exists test;
create or replace procedure test(inout data text)
language plpgsql
as $procedure$
declare
    
begin
    data := '{"session":{"id_system":1,"id_language":1,"id_table":4,"id":0,"id_event":6,"page_offset":0},"filter":[{"field_name":"size","operator":"=","field_value":"50"}]}';
    call html_table(data);   

end;

$procedure$
