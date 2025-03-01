--method 4 ref cursor (unknown number of bind variables)
create table test_depts (dept_id integer primary key, d_name varchar2(50), location varchar2(50));

create table test_emps (emp_id integer primary key, f_name varchar2(50), l_name varchar2(50), job_code varchar2(20), dept_id references test_depts(dept_id), mgr_id references test_emps(emp_id));

declare
    procedure insert_dept(id in integer, name varchar2, location varchar2)
    is begin
        insert  into test_depts values (id, name, location);
    end insert_dept;
    procedure insert_emp(id in integer, f_name in varchar2, l_name in varchar2, job in varchar2, dept in integer, mgr in integer)
    is begin
        insert  into test_emps values (id, f_name, l_name, job, dept, mgr);
    end insert_emp;
begin
insert_dept (1, 'Admin', 'Toronto');
insert_emp (1, 'Sarah', 'Stein', 'CEO', 1, null);
insert_emp (2, 'Gerald', 'Block', 'VP Sales', 1, 2);
insert_emp (3, 'Lori', 'Johnson', 'VP Research', 1, 2);
insert_emp (4, 'Lewis', 'Webb', 'VP Shipping', 1, 2);

insert_dept (2, 'Sales', 'Chicago');
insert_emp (5, 'Alexis', 'Reynaldo', 'Manager', 2, 2);
insert_emp (6, 'Susan', 'Liles', 'Agent', 2, 5);
insert_emp (7, 'Edgar', 'Simms', 'Agent', 2, 5);

insert_dept (3, 'Research', 'Paris');
insert_emp (8, 'Cindy', 'Robertson', 'Chairperson', 3, 3);
insert_emp (9, 'Joan', 'Arnaud', 'Fellow', 3, 8);
insert_emp (10, 'Edwin', 'Graves', 'Intern', 3, 8);

commit;

end;
/

create or replace view test_emps_info as
select 
    d.dept_id, d_name as dept_name, location
    , e.emp_id, e.f_name || ' ' || e.l_name as emp_name, e.job_code
    , nvl2(e.mgr_id, m.f_name || ' ' || m.l_name, null) as mgr_name
from 
    test_depts d
    join test_emps e on d.dept_id = e.dept_id
    left join test_emps m on e.mgr_id = m.emp_id
/

set serveroutput on;
declare
    l_rc sys_refcursor;

    procedure search_emps(p_emp in varchar2 default null, p_mgr in varchar2 default null, p_dept in varchar2 default null, p_results out sys_refcursor)
    is begin
    
    open p_results for
    select 
        dept_id, dept_name, location
        , emp_id, emp_name, job_code
        , mgr_name
    from test_emps_info
    where
        (p_emp is null or emp_name like '%' || p_emp || '%')
        and
        (p_mgr is null or mgr_name like '%' || p_mgr || '%')
        and
        (p_dept is null or dept_name = p_dept);
        
    end search_emps;
    procedure print_emps(p_cur in out sys_refcursor)
    is
        type t_emps is table of test_emps_info%rowtype;    
        e t_emps;
    begin
        fetch p_cur bulk collect into e;
        close p_cur;
        for i in 1..e.count loop
            dbms_output.put_line(e(i).dept_name || ': ' || e(i).emp_name || ' mgr: ' || e(i).mgr_name);
        end loop;
    end print_emps;
begin

    search_emps(p_dept => 'Research', p_results => l_rc);
    print_emps(l_rc);
    
    search_emps(p_emp => 'Alex', p_results => l_rc);
    print_emps(l_rc);
    
    search_emps(p_emp => 'o', p_dept => 'Admin', p_results => l_rc);
    print_emps(l_rc);    
    
end;
/
  

set serveroutput on;
declare
    l_rc sys_refcursor;

    procedure search_emps(p_emp in varchar2 default null, p_mgr in varchar2 default null, p_dept in varchar2 default null, p_results out sys_refcursor)
    is begin
    
    open p_results for
    select 
        dept_id, dept_name, location
        , emp_id, emp_name, job_code
        , mgr_name
    from test_emps_info
    where
        (p_emp is null or emp_name like '%' || p_emp || '%')
        and
        (p_mgr is null or mgr_name like '%' || p_mgr || '%')
        and
        (p_dept is null or dept_name = p_dept);
        
    end search_emps;
    procedure print_emps(p_cur in out sys_refcursor)
    is
        type t_emps is table of test_emps_info%rowtype;    
        e t_emps;
    begin
        fetch p_cur bulk collect into e;
        close p_cur;
        for i in 1..e.count loop
            dbms_output.put_line(e(i).dept_name || ': ' || e(i).emp_name || ' mgr: ' || e(i).mgr_name);
        end loop;
    end print_emps;
begin

    search_emps(p_dept => 'Research', p_results => l_rc);
    print_emps(l_rc);
    
    search_emps(p_emp => 'Alex', p_results => l_rc);
    print_emps(l_rc);
    
    search_emps(p_emp => 'o', p_dept => 'Admin', p_results => l_rc);
    print_emps(l_rc);    
    
end;
/
    
set serveroutput on;
declare
    l_rc sys_refcursor;

    procedure search_emps(p_emp in varchar2 default null, p_mgr in varchar2 default null, p_dept in varchar2 default null, p_results out sys_refcursor)
    is begin
    
    open p_results for
    q'[
    select 
        dept_id, dept_name, location
        , emp_id, emp_name, job_code
        , mgr_name
    from test_emps_info
    where
        (:p_emp is null or emp_name like '%' || :p_emp || '%')
        and
        (:p_mgr is null or mgr_name like '%' || :p_mgr || '%')
        and
        (:p_dept is null or dept_name = :p_dept)
    ]' using p_emp, p_emp, p_mgr, p_mgr, p_dept, p_dept;
        
    end search_emps;
    procedure print_emps(p_cur in out sys_refcursor)
    is
        type t_emps is table of test_emps_info%rowtype;    
        e t_emps;
    begin
        fetch p_cur bulk collect into e;
        close p_cur;
        for i in 1..e.count loop
            dbms_output.put_line(e(i).dept_name || ': ' || e(i).emp_name || ' mgr: ' || e(i).mgr_name);
        end loop;
    end print_emps;
begin

    search_emps(p_dept => 'Research', p_results => l_rc);
    print_emps(l_rc);
    
    search_emps(p_emp => 'Alex', p_results => l_rc);
    print_emps(l_rc);
    
end;
/

set serveroutput on;
declare
    l_rc sys_refcursor;

    procedure search_emps(p_emp in varchar2 default null, p_mgr in varchar2 default null, p_dept in varchar2 default null, p_results out sys_refcursor)
    is 
    l_sql varchar2(4000);
    l_cursor_id number := dbms_sql.open_cursor;
    l_return number;
    begin
    
    l_sql := 
    q'[
    select 
        dept_id, dept_name, location
        , emp_id, emp_name, job_code
        , mgr_name
    from test_emps_info
    where 1 = 1]';
    
    --add to where clause for each bind variable in use
    if p_emp is not null then
        l_sql := l_sql || q'[ and emp_name like '%' || :p_emp || '%' ]';
    end if;
    if p_mgr is not null then
        l_sql := l_sql || q'[ and mgr_name like '%' || :p_mgr || '%' ]';
    end if;
    if p_dept is not null then
        l_sql := l_sql || q'[ and dept_name = :p_dept ]';
    end if;

    case 
        when p_emp is not null and p_mgr is null and p_dept is null then
            open p_results for l_sql using p_emp;
        when p_mgr is not null and p_emp is null and p_dept is null then
            open p_results for l_sql using p_mgr;
        when p_dept is not null and p_emp is null and p_mgr is null then
            open p_results for l_sql using p_dept;
        when p_emp is not null and p_mgr is not null and p_dept is null then
            open p_results for l_sql using p_emp, p_mgr;
        when p_emp is not null and p_dept is not null and p_mgr is null then
            open p_results for l_sql using p_emp, p_dept;
        when p_emp is not null and p_mgr is not null and p_dept is not null then
            open p_results for l_sql using p_emp, p_mgr, p_dept;
        when p_emp is null and p_mgr is not null and p_dept is not null then
            open p_results for l_sql using p_mgr, p_dept;
        else
            open p_results for l_sql;
    end case;
        
    end search_emps;
    procedure print_emps(p_cur in out sys_refcursor)
    is
        type t_emps is table of test_emps_info%rowtype;    
        e t_emps;
    begin
        fetch p_cur bulk collect into e;
        close p_cur;
        for i in 1..e.count loop
            dbms_output.put_line(e(i).dept_name || ': ' || e(i).emp_name || ' mgr: ' || e(i).mgr_name);
        end loop;
    end print_emps;
begin

    search_emps(p_dept => 'Research', p_results => l_rc);
    print_emps(l_rc);
    
    search_emps(p_emp => 'Alex', p_results => l_rc);
    print_emps(l_rc);
    
end;
/



set serveroutput on;
declare
    l_rc sys_refcursor;

    procedure search_emps(p_emp in varchar2 default null, p_mgr in varchar2 default null, p_dept in varchar2 default null, p_results out sys_refcursor)
    is 
    l_sql varchar2(4000);
    l_cursor_id number := dbms_sql.open_cursor;
    l_return number;
    begin
    
    l_sql := 
    q'[
    select 
        dept_id, dept_name, location
        , emp_id, emp_name, job_code
        , mgr_name
    from test_emps_info
    where 1 = 1]';
    
    --add to where clause for each bind variable to use
    if p_emp is not null then
        l_sql := l_sql || q'[ and emp_name like '%' || :p_emp || '%' ]';
    end if;
    if p_mgr is not null then
        l_sql := l_sql || q'[ and mgr_name like '%' || :p_mgr || '%' ]';
    end if;
    if p_dept is not null then
        l_sql := l_sql || q'[ and dept_name = :p_dept ]';
    end if;
    
    dbms_sql.parse(l_cursor_id, l_sql, dbms_sql.native);
    
    --if parameters are not null, add them as bind variables
    if p_emp is not null then
        dbms_sql.bind_variable(l_cursor_id, 'p_emp', p_emp);
    end if;
    if p_mgr is not null then
        dbms_sql.bind_variable(l_cursor_id, 'p_mgr', p_mgr);
    end if;
    if p_dept is not null then
        dbms_sql.bind_variable(l_cursor_id, 'P_dept', p_dept);
    end if;
    
    l_return := dbms_sql.execute(l_cursor_id);
    
    p_results := dbms_sql.to_refcursor(l_cursor_id);    
        
    end search_emps;
    procedure print_emps(p_cur in out sys_refcursor)
    is
        type t_emps is table of test_emps_info%rowtype;    
        e t_emps;
    begin
        fetch p_cur bulk collect into e;
        close p_cur;
        for i in 1..e.count loop
            dbms_output.put_line(e(i).dept_name || ': ' || e(i).emp_name || ' mgr: ' || e(i).mgr_name);
        end loop;
    end print_emps;
begin

    search_emps(p_dept => 'Research', p_results => l_rc);
    print_emps(l_rc);
    
    search_emps(p_emp => 'Alex', p_results => l_rc);
    print_emps(l_rc);
    
end;
/



