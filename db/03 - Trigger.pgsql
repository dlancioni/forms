-- -----------------------------------------------------
-- table tb_company
-- -----------------------------------------------------
create or replace function fn_company_system() returns trigger as $tg1$
begin	  
    -- execute format('insert into ' || new.name || ' (id) values (123)');
    if (tg_op = 'insert') then
        insert into tb_system (id_company, name) values (new.id, new.name);
        return new;
    elsif (tg_op = 'update') then
        return new;
    elsif (tg_op = 'delete') then
      delete from tb_system where id = old.id;
      return old;
    end if;

end;
$tg1$ language plpgsql;

create trigger tg_company_system after insert, update, delete on tb_company
for each row execute procedure fn_company_system();

