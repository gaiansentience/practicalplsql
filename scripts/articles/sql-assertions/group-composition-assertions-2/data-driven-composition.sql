select user;

select user, banner_full from v$version;

drop assertion if exists department_type_has_all_active_roles;
drop table if exists department_positions purge;
drop table if exists departments purge;
drop table if exists department_type_roles purge;
drop table if exists role_types purge;
drop table if exists department_types purge;

create table if not exists department_types (
department_type_id integer generated always as identity primary key,
department_type_name varchar2(30) unique not null,
is_active boolean default false
)
/

create table if not exists role_types (
role_id integer generated always as identity primary key,
role_name varchar2(50) unique not null,
is_active boolean default false
)
/

create table if not exists department_type_roles(
department_type_id references department_types(department_type_id),
role_id references role_types(role_id),
is_required boolean default false, --at least one
is_unique boolean default false,  --only one
is_paired boolean default false, --requires two only
is_multiple boolean default false, --requires more than one
constraint department_type_roles_pk primary key (department_type_id, role_id)
)
/



create table if not exists departments (
department_id integer generated always as identity primary key,
college varchar2(50) default 'Liberal Arts' not null,
department_name varchar2(50) not null,
department_type_id references department_types (department_type_id),
is_active boolean default false
)
/


create table if not exists department_positions(
position_id integer generated always as identity primary key,
department_id references departments,
role_id references role_types,
full_name varchar2(50)
)
/

insert into department_types(department_type_name, is_active)
values ('proposed',true), ('small', true), ('regular', true),('research',true),('deprecated',false)
/

insert into role_types(role_name, is_active)
values ('chair', true),('admin', true),('assistant', false),('fellow', false),('faculty', true),('intern', false)
/

declare

type id_lookup is table of number index by varchar2(100);
l_dept_types id_lookup;
l_role_types id_lookup;

procedure initialize_lookups
is
    cursor c_roles is
    select role_name as n, role_id as i from roles;
    cursor c_dtypes is
    select department_type_name as n, department_type_id as i from department_types;
begin
    --pre21
--    for r in (select department_type_name, department_type_id from department_types) loop
--        l_dept_types(r.department_type_name) := r.department_type_id;
--    end loop;
    --implicit cursor
--    l_dept_types := id_lookup(for r in (
--        select department_type_name, department_type_id 
--        from department_types) 
--        index r.department_type_name => r.department_type_id);
    if l_dept_types.count = 0 or l_role_types.count = 0 then
    l_dept_types := id_lookup(for r in values of c_dtypes index r.n => r.i);
    
    l_role_types := id_lookup(for r in values of c_roles index r.n => r.i);
    end if;
    
end initialize_lookups;

procedure insert_dept_type_role(p_dept_type in varchar2, p_role in varchar2
    , p_required in boolean default false
    , p_unique in boolean default false
    , p_paired in boolean default false
    , p_multiple in boolean default false)
is
    l_dept_type_id number;
    l_role_id number;
begin
    initialize_lookups;
    
--    select department_type_id into l_dept_type_id
--    from department_types where department_type_name = p_dept_type;
--    
--    select role_id into l_role_id from role_types where role_name = p_role;
    l_dept_type_id := l_dept_types(p_dept_type);
    l_role_id := l_role_types(p_role);
    
    insert into department_type_roles(department_type_id, role_id, is_required, is_unique, is_paired, is_multiple)
    values (l_dept_type_id, l_role_id, p_required, p_unique, p_paired, p_multiple);

end insert_dept_type_role;

begin    
    --proposed departments may have a chair, may have one admin, must have at least one faculty member
    insert_dept_type_role('proposed','chair', p_unique => true);
    insert_dept_type_role('proposed','admin', p_unique => true);
    insert_dept_type_role('proposed','faculty', p_required => true);


    --small departments may have only one chair, only one admin, and must have at least one faculty member
    insert_dept_type_role('small','chair', p_unique => true);
    insert_dept_type_role('small','admin', p_unique => true);
    insert_dept_type_role('small','faculty', p_required => true);
    
    --regular departments must have one chair, one admin and multiple faculty members
    insert_dept_type_role('regular','chair', p_required => true, p_unique => true);
    insert_dept_type_role('regular','admin', p_required => true, p_unique => true);
    insert_dept_type_role('regular','faculty', p_required => true, p_multiple => true);

    --research department may have a chair, a pair of admins and multiple fellows
    insert_dept_type_role('research','chair', p_unique => true);
    insert_dept_type_role('research','admin', p_required => true, p_paired => true);
    insert_dept_type_role('research','fellow', p_required => true, p_multiple => true);

    commit;


end;
/


--create departments
select * from role_types;
update role_types set is_active = true where role_name = 'assistant';
commit;

update department_types set is_active = true where department_type_name = 'research';
commit;

--show department types missing configured
select dt.*
    , (select listagg(role_name,',') 
        from role_types rr where rr.is_active) as all_active_roles
    , (select listagg(role_name, ',') 
        from role_types rr join department_type_roles dtr on rr.role_id = dtr.role_id 
        where dtr.department_type_id = dt.department_type_id and rr.is_active) as dept_type_roles
    from department_types dt
    where dt.is_active and exists (
            select 'a role'
            from role_types r
            where r.is_active and not exists(
                select 'the role is configured for dept type'
                from department_type_roles dtr
                where dtr.department_type_id = dt.department_type_id 
                and dtr.role_id = r.role_id))
/

--assertion, all department types must define all roles (completeness of department type composition rules)
create assertion if not exists department_type_has_all_active_roles check (
    not exists (
        select 'active department type' 
        from department_types dt
        where dt.is_active and exists (
            select 'active role'
            from role_types r
            where r.is_active and not exists(
                select 'role is configured'
                from department_type_roles dtr
                where dtr.department_type_id = dt.department_type_id 
                and dtr.role_id = r.role_id))
        )
) novalidate deferrable initially deferred
/

--rewritten, for all  department_types join department_type_roles not exists (role that is not configured)
--all(roles)
--satisfy ( exists (dept type join dept type roles where role = 
create assertion if not exists test_satisfy check (
all (
select d.department_type_id
from department_types d
where d.is_active
) a
satisfy(
    not exists (select 'active role'
            from role_types r
            where r.is_active
            and not exists (
                select 'is configured'
                from department_type_roles dr
                where dr.role_id = r.role_id and dr.department_type_id = a.department_type_id))
)
) novalidate deferrable initially deferred
/

--assertion, all required roles in a department must have positions

--assertion, all unique roles can only have one position

--assertion, all paired roles must have exactly two positions

--assertion, all multiple roles must have more than one positions
