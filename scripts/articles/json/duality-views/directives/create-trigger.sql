create or replace trigger bi_employees
before insert on employees
for each row
declare
begin
    if not employee_api.validate_new_employee_salary(:new.salary, :new.job_role) then
        raise_application_error(-20911, 'Invalid starting salary for ' || :new.job_role);
    end if;
end;
/