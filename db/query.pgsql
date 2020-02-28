truncate table tb_company;
truncate table tb_system;

select * from tb_company;
select * from tb_system;

select table_name, field_name from vw_table where id_fk = 1


call persist('{"session":{"id_company":1,"id_system":1,"id_table":1,"action":"U"},"field":{"id":1,"name":"Lancioni IT","expire_date":"2021-01-02","price":1200}}'); 