create or replace directive new_employees_minimum_salary
    for employees_dv
    validate
    on INSERT
    before object
    validate enable
    using employee_api.validate_new_employee
/


--05/03/2026 OCI ADB
--ORA-57306: Cannot create validation directive 'NEW_EMPLOYEES_MINIMUM_SALARY': The ORACLE RAC Two-Stage Rolling Update 37684877 is not yet enabled
