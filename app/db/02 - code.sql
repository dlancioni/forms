/*
 * TB_EVENT
 */
drop table if exists tb_event_name;
create table tb_event_name (
    id int not null primary key,
    name varchar(50) not null
);
insert into tb_event_name values (1, 'OnLoad()');
insert into tb_event_name values (2, 'OnClick()');
insert into tb_event_name values (3, 'OnFocus()');
insert into tb_event_name values (4, 'OnBlur()');

/*
 * TB_EVENT_TYPE
 */
drop table if exists tb_event_for;
create table tb_event_for (
    id int not null primary key,
    name varchar(50) not null
);
insert into tb_event_for values (1, 'Relatório');
insert into tb_event_for values (2, 'Formulário');
insert into tb_event_for values (3, 'Gráfico');

/*
 * TB_EVENT_FORM_REPORT
 */
drop table if exists tb_event;
create table tb_event (
    id int not null primary key,
    id_company int not null,
    id_form int not null,
    id_event int not null,
    id_event_type int not null,    
    id_function int not null,
    label varchar(500) not null
);
insert into tb_event values (1, 1, 1, 1, 1, 1, 'Novo');

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