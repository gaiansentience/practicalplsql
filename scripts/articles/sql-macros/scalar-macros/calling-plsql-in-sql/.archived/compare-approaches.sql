select banner_full from v$version;

prompt create function variants:
create or replace function f_macro(n in number) return varchar2 sql_macro(scalar)
is
begin 
return 'n * n'; 
end f_macro;
/
create or replace function f_basic(n in number) return number
is
begin 
return n * n; 
end f_basic;
/

create or replace function f_deterministic(n in number) return number
deterministic
is
begin 
return n * n; 
end f_deterministic;
/

create or replace function f_udf(n in number) return number
is
pragma udf;
begin 
return n * n; 
end f_udf;
/

set timing on

set autotrace traceonly


prompt inline with function 
with function wf_basic(n in number) return number
is
begin return n * n; end wf_basic;
select sum(n_sq)
from (
select wf_basic(level) as n_sq
from dual
connect by level <= 1000000
)
/


prompt plsql function 
select sum(n_sq2)
from (
select f_basic(level) as n_sq2
from dual
connect by level <= 1000000
)
/


prompt inline with function IS using pragma udf
with function wf_udf(n in number) return number
is
pragma udf;
begin return n * n; end wf_udf;
select sum(n_sq)
from (
select wf_udf(level) as n_sq
from dual
connect by level <= 1000000
)
/


prompt plsql function IS using pragma udf
select sum(n_sq2)
from (
select f_udf(level) as n_sq2
from dual
connect by level <= 1000000
)
/

prompt inline with deterministic function 
with function wf_deterministic(n in number) return number
deterministic
is
begin 
return n * n; 
end wf_deterministic;
select sum(n_sq)
from (
select wf_deterministic(level) as n_sq
from dual
connect by level <= 1000000
)
/

prompt deterministic
select sum(n_sq2)
from (
select f_deterministic(level) as n_sq2
from dual
connect by level <= 1000000
)
/


prompt using inline with macro function
with
function wf_macro(n in number) return varchar2 sql_macro(scalar)
is
begin 
return 'n * n'; 
end wf_macro;
select sum(n_sq2)
from (
select wf_macro(level) as n_sq2
from dual
connect by level <= 1000000
)
/

prompt using scalar MACRO function
select sum(n_sq2)
from (
select f_macro(level) as n_sq2
from dual
connect by level <= 1000000
)
/

