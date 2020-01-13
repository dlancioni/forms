/*
 * TB_EVENT
 */
drop table if exists tb_event;
create table tb_event (
    id int not null primary key,
    name varchar(50) not null
);
insert into tb_event values (1, 'OnLoad()');
insert into tb_event values (2, 'OnClick()');
insert into tb_event values (3, 'OnFocus()');
insert into tb_event values (4, 'OnBlur()');

/*
 * TB_EVENT_TYPE
 */
drop table if exists tb_event_type;
create table tb_event_type (
    id int not null primary key,
    name varchar(50) not null
);
insert into tb_event_type values (1, 'Relatório');
insert into tb_event_type values (2, 'Formulário');
insert into tb_event_type values (3, 'Gráfico');

/*
 * TB_EVENT_FORM_REPORT
 */
drop table if exists tb_event_form_report;
create table tb_event_form_report (
    id int not null primary key,
    id_company int not null,
    id_form int not null,
    id_event int not null,
    id_event_type int not null,    
    id_function int not null,
    label varchar(500) not null
);
insert into tb_event_form_report values (1, 1, 1, 1, 1, 1, 'Novo');

/*
 * TB_FUNCTION
 */
drop table if exists tb_function;
create table tb_function (
    id int not null primary key,
    name varchar(500),
    signature varchar(500) not null,
    code text not null
);
insert into tb_function values (1, 'Novo', 'new()', 
'function New() {
    $("#button").click(function() {
        $("#Table").submit();
    });
}');




select
t1.id,
t3.name form_name,
t4.name event_name,
t6.name function_name,
t6.code function_code
from tb_event_form_report t1
inner join tb_company t2 on t1.id_company = t2.id
inner join tb_form t3 on t1.id_form = t3.id
inner join tb_event t4 on t1.id_event = t4.id
inner join tb_event_type t5 on t1.id_event_type = t5.id
inner join tb_function t6 on t1.id_function = t6.id
where t1.id_company = 1