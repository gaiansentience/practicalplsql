--Running DBMS_CLOUD.VALIDATE_EXTERNAL_TABLE will leave a table called VALIDATE$n_LOG and VALIDATE$n_BAD with each run
--If you had to work with the table definition there may be many of these validation tables


declare
    cursor c is
    select table_name 
    from user_tables 
    where table_name like 'VALIDATE$%';
begin

    for r in c loop
        execute immediate 'drop table ' || r.table_name || ' purge';
    end loop;

end;
/