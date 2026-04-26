set serveroutput on;
declare
    cursor c is
    with staff(name, role) as (
        values 
            ('Newton', 'chair'), ('James', 'chair')
            , ('Edwards', 'chair'), ('Teller', 'chair')
            , ('Smith', 'intern'), ('Green', 'intern')
    )
    select role, listagg(name, ', ') as role_staff
    from staff
    group by role;
    l_staff_composition varchar2(20) := 'unbalanced';
begin    
    for r in c loop
        dbms_output.put_line(r.role || ': ' || r.role_staff);
    end loop;
    if l_staff_composition = 'unbalanced' then
        dbms_output.put_line('database assertions can help');
    end if;
end;
/
