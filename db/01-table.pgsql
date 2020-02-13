
-- ALTER ROLE qqbzxiqr IN DATABASE qqbzxiqr SET search_path TO system;

-- -----------------------------------------------------
-- table tb_company
-- -----------------------------------------------------
drop table if exists tb_company;
create table if not exists tb_company 
(
  id serial,
  name varchar(50) not null,
  expire_date date not null,
  price float not null
);


-- -----------------------------------------------------
-- table tb_system
-- -----------------------------------------------------
drop table if exists tb_system;
create table if not exists tb_system 
(
    id serial,
    id_company int not null,
    name varchar(50) not null
);


-- -----------------------------------------------------
-- table tb_table
-- -----------------------------------------------------
drop table if exists tb_table;
create table if not exists tb_table 
(
    id serial,
    id_company int null,
    id_system int not null,
    name varchar(50) not null,
    url varchar(50) null,
    table_name varchar(50) null
);


-- -----------------------------------------------------
-- table tb_field_type
-- -----------------------------------------------------
drop table if exists tb_field_type ;
create table if not exists tb_field_type 
(
    id serial,
    name varchar(50) not null
);


-- -----------------------------------------------------
-- table tb_field
-- -----------------------------------------------------
drop table if exists tb_field;
create table if not exists tb_field 
(
    id serial,
    id_company int,
    id_system  int,
    id_table int,
    label varchar(50),
    name varchar(50),
    id_type int,
    size int,
    mask varchar(50),
    id_mandatory int,
    id_unique int,
    id_fk int,
    domain varchar(50)
);
