call persist('{"session":{"id_system":1,"id_table":1,"action":"I"},"field":{"id":1,"name":"Lancioni IT","expire_date":"2021-01-01","price":1200}}'); 
call persist('{"session":{"id_system":1,"id_table":1,"action":"U"},"field":{"id":1,"name":"Lancioni IT","expire_date":"2021-01-31","price":3000}}'); 
call persist('{"session":{"id_system":1,"id_table":1,"action":"D"},"field":{"id":4}}'); 



 select * from tb_company;
 select * from tb_system;
 
truncate table tb_company; 
truncate table tb_system;
 