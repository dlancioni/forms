drop schema if exists admin;
create schema admin;
use admin;

-- {"session": {"id_company": 1, "id_system": 1, "id_user": 1, "id_table": 1}}

create table tb_company (id serial, data json);
create table tb_system (id serial, data json);
create table tb_table (id serial, data json);
create table tb_field (id serial, data json);
