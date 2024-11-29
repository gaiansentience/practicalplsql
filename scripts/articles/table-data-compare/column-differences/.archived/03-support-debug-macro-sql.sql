
create table debug_macro(generated_sql varchar2(4000), created timestamp default localtimestamp);

create or replace procedure debug_macro_sql(p_sql in varchar2)
is
pragma autonomous_transaction;
begin

insert into debug_macro(generated_sql) values(p_sql);
commit;
exception
when others then rollback;
end debug_macro_sql;
/

select * from debug_macro order by created desc;

truncate table debug_macro;