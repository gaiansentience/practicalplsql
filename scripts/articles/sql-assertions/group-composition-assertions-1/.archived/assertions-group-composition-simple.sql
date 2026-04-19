alter session disable parallel dml;

select user, banner_full from v$version;

/*
department composition rules:
departments must have faculty members
departments must have an administrator or assistant
departments can have only one administrator
departments can have at most two chairs
staff can only have two roles in a department
departments with interns must have research fellows
*/


drop assertion if exists faculty_required;
drop assertion if exists support_staff_required;
drop assertion if exists limit_one_admin;
drop assertion if exists limit_two_chairs;
drop assertion if exists limit_two_roles;
drop assertion if exists interns_require_fellow;

drop table if exists univ_dept_roles purge;
drop table if exists univ_roles purge;
drop table if exists univ_staff purge;
drop table if exists univ_depts purge;
drop usecase domain if exists domain_entity_name;

create usecase domain if not exists domain_entity_name as varchar2(50) not null;


create table if not exists univ_depts (
    dept_name domain_entity_name primary key
)
/

create table if not exists univ_roles(
    role_name domain_entity_name primary key
)
/

create table if not exists univ_staff(
    staff_name domain_entity_name primary key
)
/

create table if not exists univ_dept_roles(
    dept_name domain_entity_name references univ_depts,
    role_name domain_entity_name references univ_roles,
    staff_name domain_entity_name references univ_staff,
    constraint univ_dept_roles_pk
        primary key (dept_name, role_name, staff_name)
)
/

begin
    insert into univ_roles (role_name)
    values ('admin'),('assistant'),('chair'),('faculty'),('fellow'),('intern');
    
    insert into univ_staff (staff_name)
    values ('J Kirk'), ('B Pascale'), ('L Wittgenstein'), ('R Descartes'), ('J Joyce'), ('P Picasso'), ('G Jones');
    
    commit;
end;
/

--departments:  Philosophy, Mathematics, Literature


insert into univ_depts (dept_name) values ('Philosophy');

insert into univ_dept_roles(dept_name, role_name, staff_name)
values ('Philosophy', 'chair', 'Wittgenstein'), ('Philosophy', 'chair', 'Descartes'),('Philosophy','chair','Joyce');

--simple composition: at least one
--assertion, univ_depts must have at least one faculty member
--for all univ_depts exists one faculty member
--use universal assertion:
--all (univ_depts)
--satisfy (exists one faculty member)
--must be deferrable or univ_depts cannot be created
create assertion if not exists departments_have_faculty check (
all (select dept_name from univ_depts) a
satisfy (
    exists (
        select 'has faculty'
        from univ_dept_roles f
        where f.dept_name = a.dept_name and f.role_name = 'faculty'
    )
)
) deferrable initially deferred
/

drop assertion if exists departments_have_faculty;

--simple composition: at least one
--assertion, univ_depts must have at least one faculty member
--for all univ_depts exists one faculty member
--use existential assertion:
--there is not a department 
--which does not have faculty
create assertion if not exists departments_have_faculty check (
not exists (
    select 'a department' from univ_depts d
    where not exists (
        select 'has faculty'
        from univ_dept_roles f
        where f.dept_name = d.dept_name and f.role_name = 'faculty'
    )
)
) deferrable initially deferred
/

--simple composition: at most one
--assertion, univ_depts with administrators can only have one
create assertion if not exists only_one_dept_admin check (
    not exists (
        select 'a department'
        from univ_depts d
        where exists (
            select 'an admin'
            from univ_dept_roles a1
            where a1.dept_name = d.dept_name and a1.role_name = 'admin'
            and exists (
                select 'another admin'
                from univ_dept_roles a2
                where 
                    a2.dept_name = a1.dept_name 
                    and a2.role_name = a1.role_name 
                    and a2.staff_name > a1.staff_name
            )
        )    
    )
)
/

drop assertion if exists only_one_dept_admin;

--this assertion doesnt really need to use the department table at all
create assertion if not exists only_one_dept_admin check (
    not exists (
        select 'an admin'
        from univ_dept_roles a1
        where 
            a1.role_name = 'admin'
            and exists (
                select 'another admin'
                from univ_dept_roles a2
                where 
                    a1.dept_name = a2.dept_name 
                    and a1.role_name = a2.role_name 
                    and a1.staff_name > a2.staff_name
            )
    )
)
/

--simple composition: at most two allowed
--univ_depts can have at most two chairpersons
--4 levels of not exists exceeds max levels
create assertion if not exists not_more_than_two_chairpersons check (
    not exists (
        select 'a department with three chairs'
        from univ_depts d
        where exists (
            select 'a chair'
            from univ_dept_roles c1
            where 
                c1.dept_name = d.dept_name 
                and c1.role_name = 'chair'
                and exists (
                select 'a second chair'
                from univ_dept_roles c2
                where 
                    c2.dept_name = c1.dept_name 
                    and c2.role_name = 'chair' 
                    and c2.staff_name > c1.staff_name
                    and exists (
                        select 'a third chairperson'
                        from univ_dept_roles c3
                        where 
                            c3.dept_name = c2.dept_name 
                            and c3.role_name = 'chair' 
                            and c3.staff_name > c2.staff_name 
                        )
                )
        )
    )
)
/

select * from univ_dept_roles;

delete univ_dept_roles where staff_name = 'Joyce';


create assertion if not exists not_more_than_two_chairpersons check (
not exists (
    select p1.staff_name, p2.staff_name, p3.staff_name
--        'a department with three chairpersons'
    from 
        univ_dept_roles p1,
        univ_dept_roles p2,
        univ_dept_roles p3
    where 
    p1.dept_name = p2.dept_name
    and p2.dept_name = p3.dept_name
    and p1.role_name = 'chair' and p1.role_name = p2.role_name and p1.role_name = p3.role_name
    and p1.staff_name < p2.staff_name and p2.staff_name < p3.staff_name
    )
)
/
    
--relative composition
--univ_depts without administrators must have an assistant
---must be deferrable.. creating an initial department wont have an admin, so it must have an assistant

create assertion if not exists administrator_or_assistant_required check (
all (select d.dept_id from univ_depts d
    where not exists (
        select 'has admin' from univ_dept_roles p 
        where p.dept_id is not null and p.dept_id = d.dept_id and p.role_name = 'admin')
    ) a
satisfy (
    exists (select 'have an assistant'
    from univ_dept_roles p1
    where p1.dept_id is not null and p1.dept_id = a.dept_id and p1.role_name = 'assistant')
)
)
deferrable initially deferred
/



--relative composition
--univ_depts with interns must have a research fellow
create assertion if not exists univ_depts_with_interns_must_have_research_fellows check (
not exists (
    select 'a department'
    from univ_depts d
    where 
    exists (
        select 'department has interns'
        from univ_dept_roles i
        where i.dept_id = d.dept_id and i.role_name = 'intern'
        and not exists (
            select 'department has research fellow'
            from univ_dept_roles f
            where f.dept_id = i.dept_id and f.role_name = 'fellow'
            )
        )
    )
)
/
    
