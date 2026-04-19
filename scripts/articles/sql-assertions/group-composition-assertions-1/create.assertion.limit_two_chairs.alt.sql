--create.assertion.limit_two_chairs.alt.sql

drop assertion if exists limit_two_chairs;

create assertion if not exists limit_two_chairs check (
    not exists (
        select 'a department with three co-chairs'
        from 
            univ_dept_roles c1,
            univ_dept_roles c2,
            univ_dept_roles c3
        where 
            c1.dept_name = c2.dept_name
            and c2.dept_name = c3.dept_name
            and c1.role_name = 'chair' 
            and c1.role_name = c2.role_name 
            and c1.role_name = c3.role_name
            and c2.staff_name > c1.staff_name 
            and c3.staff_name > c2.staff_name
    )
)
/
