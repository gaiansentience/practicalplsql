prompt dropping pp_employees table and print_boolean procedure

--should work in 23c cf: https://oracle-base.com/articles/23c/if-not-exists-ddl-clause-23c#the-solution
--drop table if exists pp_employees;
--drop procedure if exists print_boolean;

declare
    function object_exists(p_object in varchar2, p_type in varchar2) return boolean
    is
        i number;
    begin
        select count(*) into i 
        from user_objects
        where object_name = upper(p_object) and object_type = upper(p_type);
        return (i > 0);
    end object_exists;
begin
    if object_exists('pp_employees', 'table') then
        execute immediate 'drop table pp_employees purge';
        dbms_output.put_line('dropped pp_employees table');
    end if;
    if object_exists('print_boolean', 'procedure') then
        execute immediate 'drop procedure print_boolean';
        dbms_output.put_line('dropped print_boolean procedure');
    end if;
end;
/