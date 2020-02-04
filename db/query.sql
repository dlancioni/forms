select
t1.id,
t1.label,
t3.name form_name,
t4.name event_name,
t5.id id_event_for,
t6.name function_name,
t6.code function_code
from tb_event t1
inner join tb_company t2 on t1.id_company = t2.id
inner join tb_form t3 on t1.id_form = t3.id
inner join tb_event_name t4 on t1.id_event = t4.id
inner join tb_event_for t5 on t1.id_event_for = t5.id
inner join tb_function t6 on t1.id_function = t6.id