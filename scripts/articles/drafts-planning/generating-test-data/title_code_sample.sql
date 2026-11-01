declare
    cursor c_names is
    with base as
    (
        select 'Albert' as f_name, 'Einstein' as l_name from dual 
        union all select 'Marie', 'Curie' from dual
        union all select 'Maya', 'Angelou' from dual
        union all select 'Rosa', 'Parks' from dual
    )
    select f.f_name, l.l_name
    from base f cross join base l;
begin
    for r in c_names loop
        dbms_output.put_line(r.f_name || ' ' || r.l_name);
    end loop;    
end;
/




with names(f,l) as (
values ('Albert','Einstein'),('Marie','Curie'),('Maya','Angelou'),('Rosa','Parks')
)
select f.f, l.l
from 
    names f
    cross join names l
order by l.l, f.f
/