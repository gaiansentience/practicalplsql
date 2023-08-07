set serveroutput on;
declare

l_rows number := 121;
l_limit number := 100;
l_buckets number := ceil(l_rows/l_limit);

cursor c(b number) is
select id
from
(
select level as id, ntile(l_buckets) over (order by level) as ntile_bucket
from dual 
connect by level <= l_rows
) where ntile_bucket = b;

type t is table of c%rowtype;

l t;
m t := t();
i number := 0;
begin

fetch c bulk collect into m;
dbms_output.put_line('bulk collect in one fetch: ' || m.count);
m.delete;

loop
    fetch c bulk collect into l limit l_limit;
    exit when l.count = 0;
    m := m multiset union l;
end loop;
dbms_output.put_line('bulk collect with limit: ' || m.count);
m.delete;

m := t(for r in c loop

    --open c;
    --for i in 1..10 loop
    --loop
    for i in 1..l_buckets loop
--    i := i + 1;
    l := t(for r in values of c(i) sequence => r);

    exit when l is null or l.count = 0;
    dbms_output.put_line(l.count);

    m := m multiset union l;
    end loop;
--    loop
--        fetch c bulk collect into l limit 10;
--        dbms_output.put_line('rows fetched ' || l.count);
--        m := m multiset union l;
--        exit when l.count = 0;
--    end loop;
    
    dbms_output.put_line('all rows fetched ' || m.count);
    
    --close c;

end;
/