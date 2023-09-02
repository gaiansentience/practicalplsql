create or replace package hr_api authid current_user 
is
    
    function get_location_id(
        p_code in locations.code%type
    ) return locations.id%type;
    
    procedure insert_location(
        p_code in locations.code%type
        , p_name in locations.name%type
        , p_address in locations.address%type
        , p_city in locations.city%type
    );
    
    function get_department_id(
        p_code in departments.code%type
    ) return departments.id%type;
    
    procedure insert_department(
        p_code in departments.code%type, 
        p_name in departments.name%type, 
        p_description in departments.description%type
    );
    
    function get_job_id(
        p_code in jobs.code%type
    ) return jobs.id%type;
    
    procedure insert_job(
        p_code in jobs.code%type
        , p_name in jobs.name%type
        , p_description in jobs.description%type default null
    );
    
    function get_employee_id(
        p_email in employees.email%type
    ) return employees.id%type;
    
    procedure insert_employee(
        p_first_name in employees.first_name%type
        , p_last_name in employees.last_name%type
        , p_salary in employees.salary%type
        , p_hire_date in employees.hire_date%type    
        , p_job_code in jobs.code%type
        , p_department_code in departments.code%type
        , p_location_code in locations.code%type
        , p_manager_email in employees.email%type default null
    );    
    
end hr_api;
/