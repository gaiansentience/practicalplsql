create or replace directive new_employees_minimum_salary
    for employees_dv
    validate
    on insert
    on commit
    using validate_new_employee;
--    using employee_api.validate_new_employee;
/


--05/03/2026 OCI ADB
--ORA-57306: Cannot create validation directive 'NEW_EMPLOYEES_MINIMUM_SALARY': The ORACLE RAC Two-Stage Rolling Update 37684877 is not yet enabled

--6/1 gvenzl 26.2 always free
--ORA-43594: Invalid validation function 'EMPLOYEE_API.VALIDATE_NEW_EMPLOYEE'
--select banner_full from v$version;