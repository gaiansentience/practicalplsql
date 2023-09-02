set feedback off;
set serveroutput on;

create table test_emps (
    id         number
    ,name       varchar2(20)
    ,manager_id number
);
/

begin
    insert into test_emps values (1, 'Mike', null);
    insert into test_emps values (2, 'Amy', 1);
    insert into test_emps values (3, 'Edward', 2);
    commit;
end;
/

declare
    procedure show_expansion (
        p_sql in clob
    ) is
        l_sql_exp clob;
    begin
        dbms_utility.expand_sql_text(p_sql,l_sql_exp);
        dbms_output.put_line('--Expanded Sql statement:');
        dbms_output.put_line(l_sql_exp);
    end show_expansion;

begin
    show_expansion(q'[
select e.name, m.name as manager
from 
    test_emps e
    left outer join test_emps m on e.manager_id = m.id
]');
    show_expansion(q'[
select e.name, m.name as manager
from 
    test_emps e, 
    test_emps m
where e.manager_id = m.id (+)
]');
end;
/

drop table test_emps purge;

-- printed output from script (reformatted)

--Expanded Sql statement 
/*
SELECT "A1"."QCSJ_C000000000300002_1" "NAME","A1"."QCSJ_C000000000300003_4" "MANAGER" 
FROM  
    (SELECT 
        "A3"."ID" "QCSJ_C000000000300000","A3"."NAME" "QCSJ_C000000000300002_1","A3"."MANAGER_ID" "QCSJ_C000000000300004",
        "A2"."ID" "QCSJ_C000000000300001","A2"."NAME" "QCSJ_C000000000300003_4","A2"."MANAGER_ID" "QCSJ_C000000000300005" 
    FROM "PRACTICALPLSQL"."TEST_EMPS" "A3","PRACTICALPLSQL"."TEST_EMPS" "A2" 
    WHERE "A3"."MANAGER_ID"="A2"."ID") "A1";

--Expanded Sql statement:
SELECT "A2"."NAME" "NAME","A1"."NAME" "MANAGER" 
FROM "PRACTICALPLSQL"."TEST_EMPS" "A2","PRACTICALPLSQL"."TEST_EMPS" "A1" 
WHERE "A2"."MANAGER_ID"="A1"."ID"(+);
*/