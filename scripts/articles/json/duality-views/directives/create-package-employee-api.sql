create or replace package employee_api as

    function validate_new_employee(
        old_data in json,
        new_data in json
    ) return boolean;

    function validate_new_employee_salary(
        p_starting_salary in employees.salary%type,
        p_job_role in employees.job_role%type
    ) return boolean;

end employee_api;
/

create or replace package body employee_api as

    function validate_new_employee_salary(
        p_starting_salary in employees.salary%type,
        p_job_role in employees.job_role%type
    ) return boolean
    is
        r_job_role job_roles%rowtype;
        l_max_starting_salary employees.salary%type;
    begin
        select *
        into r_job_role
        from job_roles
        where job_role = p_job_role;
        
        l_max_starting_salary := r_job_role.min_salary+(r_job_role.max_salary - r_job_role.min_salary)/2;
        
        return case when p_starting_salary between r_job_role.min_salary and l_max_starting_salary then true else false end;
    
    end validate_new_employee_salary;
    
    function validate_new_employee(
        old_data in json,
        new_data in json
    ) return boolean
    is
        l_job_role employees.job_role%type;
        l_salary employees.salary%type;
        l_max_starting employees.salary%type;
    begin
        l_job_role := json_value(new_data, '$.job_role');
        l_salary := json_value(new_data, '$.salary');
        l_max_starting := json_value(new_data, '$.max_starting_salary');
        return (l_salary <= l_max_starting);

        return validate_new_employee_salary(l_salary, l_job_role);
        --return true;
        
    end validate_new_employee;
    
end employee_api;
/

create or replace     function validate_new_employee(
        old_data in json,
        new_data in json
    ) return boolean
    is
        l_job_role employees.job_role%type;
        l_salary employees.salary%type;
        l_max_starting employees.salary%type;
    begin
        l_job_role := json_value(new_data, '$.job_role');
        l_salary := json_value(new_data, '$.salary');
        l_max_starting := json_value(new_data, '$.max_starting_salary');
        return (l_salary <= l_max_starting);
        
        --error about database state, directive wont compile
        --dbms_output.put_line(json_serialize(old_data));
        --dbms_output.put_line(json_serialize(new_data));

        --return true;
        --return employee_api.validate_new_employee(old_data, new_data);
        --return employee_api.validate_new_employee_salary(l_salary, l_job_role);
        
    end validate_new_employee;
/