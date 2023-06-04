create table pp_employees (
    name varchar2(50)
    , job varchar2(50)
    , constraint pp_employees_pk primary key (name, job)
);
/

Prompt Load Employees Table
declare
    procedure insert_employee(p_name in varchar2, p_job in varchar2)
    is
    begin
        insert into pp_employees (name, job)
        values(p_name, p_job);
    end insert_employee;
begin
    insert_employee('Gina', 'SALES_EXEC');
    insert_employee('Ann', 'SALES_MGR');
    insert_employee('Tobias', 'SALES_MGR');
    insert_employee('John', 'SALES_REP');
    insert_employee('Jane', 'SALES_REP');
    insert_employee('Julie', 'SALES_REP');
    insert_employee('Alex', 'SALES_REP');
    insert_employee('Sarah', 'SALES_REP');
    insert_employee('Thomas', 'SALES_REP');
    insert_employee('George', 'SALES_SUPPORT');
    insert_employee('Martin', 'SALES_SUPPORT');
    
    commit;
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
        raise;
end;
/

prompt create procedure to print boolean values
@@print_boolean.pls;