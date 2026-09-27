

-- from jonathan lewis on ora_hash-function:  https://jonathanlewis.wordpress.com/2009/11/21/ora_hash-function/

--dbms_utility.get_hash_value(string, 1, N) = 1 + ora_hash(string, N – 1, 0)


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
)
select
    s, dbms_utility.get_hash_value(s, 1, power(2,30)) as utility_hash
    , 1 + ora_hash(s, power(2,30) - 1, 0) equiv_ora_hash
    , standard_hash(s) as std_hash
    , dbms_crypto.hash(to_clob(s), get_package_constant('dbms_crypto.hash_sh256')) as crypto_hash
from base
/

select * from all_source
where name = 'DBMS_CRYPTO'
/