
create table if not exists test_depts(dept_id number, d_name varchar2(20), location varchar2(20));
create table if not exists test_emps(emp_id number, f_name varchar2(20), l_name varchar2(20), job_code varchar2(20), dept_id number, mgr_id number);

select * from user_tables;

select * from test_emps;

select d.*, cursor(select e.* from test_emps e where e.dept_id = d.dept_id) as emp_cur
from test_depts d;

declare
cv sys_refcursor;
procedure p(s in varchar2) is begin dbms_output.put_line(s); end p;
begin


for r1 in (
select d.*, cursor(select e.* from test_emps e where e.dept_id = d.dept_id) as emp_cur
from test_depts d
) loop

    cv := r1.emp_cur;
        
end loop;

end;
/




with emp_base as (
select
    d.dept_id, d.d_name, d.location
    , e.emp_id, e.f_name, e.l_name, e.job_code, e.mgr_id
from 
    test_emps e
    join test_depts d on e.dept_id = d.dept_id
), jbase as (
    select 
        json_serialize(
            json_arrayagg(
                json_object(dept_id, d_name, location, 'deptEmps' value
                    json_arrayagg(
                        json_object(emp_id, f_name, l_name, job_code, mgr_id)
                    )
                )
            )
        returning clob) as jdoc
    from emp_base
    group by dept_id, d_name, location
)
select * 
from jbase b
/

set serveroutput on;
declare

jDoc json;

procedure p(s in varchar2)
is
begin
    dbms_output.put_line(s);
end p;
begin


jDoc := json(q'!
[
    {"dept_id":1,"d_name":"Admin","location":"Toronto","deptEmps":[
        {"emp_id":1,"f_name":"Sarah","l_name":"Stein","job_code":"CEO","mgr_id":null},
        {"emp_id":4,"f_name":"Lewis","l_name":"Webb","job_code":"VP","mgr_id":2},
        {"emp_id":3,"f_name":"Lori","l_name":"Johnson","job_code":"VP","mgr_id":2},
        {"emp_id":2,"f_name":"Gerald","l_name":"Block","job_code":"COO","mgr_id":1}
        ]},
    {"dept_id":2,"d_name":"Sales","location":"Chicago","deptEmps":[
        {"emp_id":5,"f_name":"Alexis","l_name":"Reynaldo","job_code":"Coordinator","mgr_id":2},
        {"emp_id":7,"f_name":"Edgar","l_name":"Simms","job_code":"Representative","mgr_id":5},
        {"emp_id":6,"f_name":"Susan","l_name":"Liles","job_code":"Representative","mgr_id":5}
        ]},
    {"dept_id":3,"d_name":"Research","location":"Paris","deptEmps":[
        {"emp_id":8,"f_name":"Cindy","l_name":"Robertson","job_code":"Architect","mgr_id":3},
        {"emp_id":10,"f_name":"Edwin","l_name":"Graves","job_code":"Engineer","mgr_id":8},
        {"emp_id":9,"f_name":"Joan","l_name":"Arnaud","job_code":"Engineer","mgr_id":8}
        ]}
]
!');

p(json_serialize(jdoc));


for r in (
    with base as (
    select j.dept_id, j.d_name, j.location
        , j.emp_id, j.f_name, j.l_name, j.job_code, j.mgr_id, j.f_name || ' ' || j.l_name as e_name 
    from 
    json_table(jdoc format json, '$[*]' 
        columns (
        jDept json path '$', dept_id path '$.dept_id.number()', d_name path '$.d_name', location path '$.location',
        nested path '$.deptEmps[*]' columns (
            jEmp json path '$', emp_id path '$.emp_id', f_name path '$.f_name', l_name path '$.l_name', job_code path '$.job_code', mgr_id path '$.mgr_id'
            )
        ))j
    )
    select dept_id, d_name, location, count(*) as d_emp_count, listagg(e_name, ', ') as d_emp_names
    from base
    group by all
) loop
        p(r.d_name || ', ' || r.location || ', ' || r.d_emp_count || ' employees: ' || r.d_emp_names);
end loop;

--use separate cursors to list employees, summarize job codes



--then use a single cursor that outputs multiple results (try using cursors)
declare

cursor c is
    with base as (
    select j.dept_id, j.d_name, j.location
        , j.emp_id, j.f_name, j.l_name, j.job_code, j.mgr_id, j.f_name || ' ' || j.l_name as e_name 
    from 
    json_table(jdoc format json, '$[*]' 
        columns (
        jDept json path '$', dept_id path '$.dept_id.number()', d_name path '$.d_name', location path '$.location',
        nested path '$.deptEmps[*]' columns (
            jEmp json path '$', emp_id path '$.emp_id', f_name path '$.f_name', l_name path '$.l_name', job_code path '$.job_code', mgr_id path '$.mgr_id'
            )
        ))j
    )
    select
    cursor (
    select dept_id, d_name, location, count(*) as d_emp_count, listagg(e_name, ', ') as d_emp_names
    from base
    group by all
    ) as dept_summary
    , cursor (
        select
        count(*) as e_count, listagg(distinct location, ', ') as l_list, listagg(distinct d_name, ', ') as d_list
        from base
    ) as company_summary
    from dual;

ce sys_refcursor;
cc sys_refcursor;
dept_id number;
d_name varchar2(20);
location varchar2(20);
e_count number;
e_names varchar2(1000);
l_list varchar2(1000);
d_list varchar2(1000);
begin
open c;

--cannot use a cursor loop because record variable cant contain cursors
loop
fetch c into ce, cc;
exit when c%notfound;
    --ce, cc is already opened on fetch from c
    loop
    fetch ce into dept_id, d_name, location, e_count, e_names;
    exit when ce%notfound;
    p(e_names);
    end loop;
    
    loop
        fetch cc into e_count, l_list, d_list;
        exit when cc%notFound;
        p(d_list);
    end loop;
    
    --optional, these will get closed
    close cc;
    close ce;
end loop;


end;


end;
/

