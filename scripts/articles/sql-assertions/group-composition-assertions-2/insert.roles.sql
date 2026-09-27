

insert into university_role_types(role_name, is_required, is_unique, max_paired)
values ('faculty', true, false, false),('chair', false, false, true)
,('admin', true, true, false),('secretary', false, false, false),('assistant', false, false, false)
,('fellow',false,false,false),('intern',false,false,false)
/

commit;

insert into university_cross_role_dependencies(role_name, required_role_name)
values ('admin','assistant'),('intern','fellow')
/

commit;
