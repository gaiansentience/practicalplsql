
prompt sql calculations only
select sum(n * n) as n2sum
from (
    select level as n 
    from dual 
    connect by level <= 1e6
)
/

prompt sql calling plsql for calculations
create or replace function f(n in number) return number
is
begin
    return n * n;
end;
/

select sum(f(n)) as n2sum
from (
    select level as n 
    from dual 
    connect by level <= 1e6
)
/
