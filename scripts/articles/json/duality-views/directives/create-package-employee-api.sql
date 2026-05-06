create or replace package employee_api as

    function validate_new_employee(
        old_data in json,
        new_data in json
    ) return boolean;
    
end employee_api;
/

create or replace package body employee_api as

    function validate_new_employee(
        old_data in json,
        new_data in json
    ) return boolean
    is
        l_return boolean;
        l_job_role employees.job_role%type;
        l_salary employees.salary%type;
        r_job_role job_roles%rowtype;
        l_min_salary employees.salary%type;
    begin
        l_job_role := json_value(new_data, '$.salary');
        l_salary := json_value(new_data, '$.salary');

        select *
        into r_job_role
        from job_roles
        where job_role = l_job_role;
        
        l_min_salary := r_job_role.min_salary * 1.25;
        
        return case when l_salary < l_min_salary then false else true end;
        
    end validate_new_employee;
    
end employee_api;
/
