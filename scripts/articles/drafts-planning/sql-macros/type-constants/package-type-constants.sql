



with function get_package_constant (qualified_name in varchar2) return number
is
l_ret number;
begin

execute immediate '
    begin
        :l_return := ' || qualified_name || ';
    end;
' using out l_ret;
return l_ret;
    
end get_package_constant;

base(s) as (
values ('endangered species increasing'),('luxury furs becoming more popular')
), package_constants as (
select s.*, regexp_substr(text, '([ ]*)([^ ]+)', 1, 1,'i',2) as type_constant
from all_source s
where name in ('DBMS_TYPES', 'DBMS_TF')
and (instr(text, 'CONSTANT') > 0 or instr(text, 'TYPECODE')> 0)
and instr(text, 'PLS_INTEGER') > 0
)
select t.name || '.' || t.type_constant as qualified_constant, get_package_constant(t.name || '.' || t.type_constant) as constant_value
from package_constants t
order by constant_value
/
