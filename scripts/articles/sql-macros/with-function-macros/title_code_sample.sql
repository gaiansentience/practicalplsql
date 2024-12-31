create or replace function row_generator(
    p_rows in number
) return varchar2 sql_macro(table)
is
begin
    return '
        select level as id 
        from dual 
        connect by level <= p_rows
        ';
end row_generator;
/

with base as (
    select id from row_generator(4)
)
select id
from base
/
        
--ORA-64630: unsupported use of SQL macro: use of SQL macro inside WITH clause is not supported

drop function row_generator;