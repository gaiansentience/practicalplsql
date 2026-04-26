--create.assertion.limit_two_chairs.aggregate.sql

drop assertion if exists limit_two_chairs;

create assertion if not exists limit_two_chairs check (
    not exists (
        select 'a department with more than 2 chairs'
        from univ_dept_roles r
        where r.role_name = 'chair'
        group by r.dept_name
        having count(*) > 2
    )
)
/

--Error report -
--ORA-08689: CREATE ASSERTION failed
--ORA-08661: Aggregates are not supported.