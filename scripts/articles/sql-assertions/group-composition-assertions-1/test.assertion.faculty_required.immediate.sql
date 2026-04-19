--test.assertion.faculty_required.immediate.sql

set serveroutput on;

prompt cannot create department with immediate assertion
declare
    l_action varchar2(1000) := 'Create Philosophy dept with no faculty';
begin
    insert into univ_depts
    set dept_name = 'Philosophy';
    
    commit;  
    dbms_output.put_line('Success - ' || l_action);
exception
    when others then
        rollback;
        dbms_output.put_line('Error - ' || l_action);
        dbms_output.put_line(sqlerrm);
end;
/

--ORA-08601: SQL assertion (PRACTICALPLSQL.FACULTY_REQUIRED) violated.