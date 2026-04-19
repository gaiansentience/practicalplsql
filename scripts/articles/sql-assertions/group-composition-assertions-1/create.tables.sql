--create.tables.sql

create domain if not exists domain_entity_name as 
    varchar2(50) not null
/

create table if not exists univ_depts (
    dept_name domain_entity_name,
    constraint univ_depts_pk 
        primary key (dept_name)
)
/

create table if not exists univ_roles(
    role_name domain_entity_name,
    constraint univ_roles_pk
        primary key (role_name)
)
/

create table if not exists univ_staff(
    staff_name domain_entity_name,
    constraint univ_staff_pk
        primary key (staff_name)
)
/

create table if not exists univ_dept_roles(
    dept_name domain_entity_name,
    role_name domain_entity_name,
    staff_name domain_entity_name,
    constraint univ_dept_roles_fk_univ_depts
        foreign key (dept_name)
        references univ_depts (dept_name),
    constraint univ_dept_roles_fk_univ_roles
        foreign key (role_name)
        references univ_roles (role_name),
    constraint univ_dept_roles_staff_name
        foreign key (staff_name)
        references univ_staff (staff_name),
    constraint univ_dept_roles_pk
        primary key (dept_name, role_name, staff_name)
)
/

prompt tables created for university department roles example