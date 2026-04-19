--create.assertion.support_staff_required.sql

begin
    insert into univ_dept_roles
    set dept_name = 'Philosophy', role_name = 'admin', staff_name = 'Jones';
    
    commit;
end;
/

drop assertion if exists support_staff_required;

create assertion if not exists support_staff_required check (
    all (
        select d.dept_name 
        from univ_depts d
        ) a
    satisfy (
        exists (
            select 'have an admin or secretary'
            from univ_dept_roles p1
            where 
                p1.dept_name = a.dept_name 
                and (
                    p1.role_name = 'admin' 
                    or p1.role_name = 'secretary'
                )
        )
    )
)
deferrable initially deferred
/

