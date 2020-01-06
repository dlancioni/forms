
drop table if exists tb_company;
create table tb_company (
    id int not null primary key,
    name varchar(50) not null
);
insert into tb_company values (1, 'Forms Company');

drop table if exists tb_menu;
create table tb_menu (
    id int not null primary key,
    id_company int not null,
    name varchar(50) not null,
    id_parent int not null
);
insert into tb_menu values (1, 1, 'Cadastros', 0);
insert into tb_menu values (2, 1, 'Relatorios', 0);
insert into tb_menu values (3, 1, 'Form 1', 1); -- Auto gen when create form

drop table if exists tb_form;
create table tb_form (
    id int not null primary key,
    id_company int not null,
    name varchar(50) not null,
    link varchar(200),
    id_menu int not null,
    table_name varchar(50) not null 
);
insert into tb_form values (1, 1, 'Form1', 'form1.php', 3, 'tb_1');

drop table if exists tb_field_type;
create table tb_field_type (
    id int not null primary key,
    name varchar(50) not null
);
insert into tb_field_type values (1, 'Inteiro');
insert into tb_field_type values (2, 'Decimal');
insert into tb_field_type values (3, 'Texto');
insert into tb_field_type values (4, 'Data');

drop table if exists tb_field;
create table tb_field (
    id int not null primary key,
    id_company int not null,
    id_form int not null,
    name varchar(50) not null,
    label varchar(50) not null,
    id_field_type int not null,
    size int not null,
    mask varchar(50),
    pk int not null,
    id_fk int not null,
    is_nullable int not null,
    is_unique int not null
);
insert into tb_field values (1, 1, 1, '_int_1', 'Id', 1, 0, null, 1, 0, 0, 0); -- Autogen when create form  
insert into tb_field values (2, 1, 1, 'int_1', 'Código', 1, 0, null, 0, 0, 0, 0);
insert into tb_field values (3, 1, 1, 'tex_1', 'Descrição', 3, 50, null, 0, 0, 0, 0);
insert into tb_field values (4, 1, 1, 'dat_1', 'Data', 4, 0, 'yyyy-MM-dd', 0, 0, 0, 0);
insert into tb_field values (5, 1, 1, 'dec_1', 'Valor', 2, 0, '0.000,00', 0, 0, 0, 0);


drop table if exists tb_event;
create table tb_event (
    id int not null primary key,
    name varchar(50) not null
);
insert into tb_event values (1, 'Click');
insert into tb_event values (2, 'Ganhar foco');
insert into tb_event values (3, 'Perder foco');

drop table if exists tb_event_form;
create table tb_event_form (
    id int not null primary key,
    id_company int not null,
    id_form int not null,
    id_event int not null,
    label varchar(500) not null,
    name varchar(500) not null,
    code text not null
);

drop table if exists tb_event_field;
create table tb_event_field (
    id int not null primary key,
    id_company int not null,
    id_field int not null,
    id_event int not null,    
    name varchar(500) not null,
    code text not null
);