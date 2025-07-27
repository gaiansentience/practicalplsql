
--use examples/simple-hr

--title-code.sql

select * from employees;


insert into employees
set first_name = 'ALbert', last_name = 'Einstein', email = 'Albert.Einstein@Futureco.Com', job_id = 5
/


insert into employees(first_name, email, job_id)
by name
select 
    case level when 1 then 'Larry' when 2 then 'Curly' when 3 then 'Moe' end as first_name
    , level as job_id
    , case level when 1 then 'Larry' when 2 then 'Curly' when 3 then 'Moe' end || '@3Stooges.Com' as email
connect by level <= 3
/