--create.assertion.limit_two_chairs.too_deep.sql

drop assertion if exists limit_two_chairs;

create assertion if not exists limit_two_chairs check (
    not exists (
        select 'a department'
        from univ_depts d
        where exists (
            select 'a chair'
            from univ_dept_roles c1
            where 
                c1.dept_name = d.dept_name 
                and c1.role_name = 'chair'
                and exists (
                    select 'a co-chair'
                    from univ_dept_roles c2
                    where 
                        c2.dept_name = c1.dept_name 
                        and c2.role_name = c1.role_name
                        and c2.staff_name > c1.staff_name
                        and exists (
                            select 'another co-chair'
                            from univ_dept_roles c3
                            where 
                                c3.dept_name = c2.dept_name 
                                and c3.role_name = c2.role_name
                                and c3.staff_name > c2.staff_name 
                            )
                )
        )
    )
)
/

--Error report -
--ORA-08689: CREATE ASSERTION failed
--ORA-08712: Query block nesting limit exceeded (maximum allowed level of nesting = 3).
