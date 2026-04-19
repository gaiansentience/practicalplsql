@drop.assertions.sql

drop table if exists univ_dept_roles purge;
drop table if exists univ_roles purge;
drop table if exists univ_staff purge;
drop table if exists univ_depts purge;
drop usecase domain if exists domain_entity_name;

prompt table dropped