set serveroutput on;
declare
    procedure drop_if_exists(p_table in varchar2)
    is
        i number;
    begin
        select count(*) into i
        from user_tables
        where table_name = upper(p_table);
        
        if i = 1 then
            execute immediate 'drop table ' || p_table || ' purge';
            dbms_output.put_line('dropped ' || p_table);
        end if;
    end drop_if_exists;
begin
    drop_if_exists('products');
    drop_if_exists('products_source');
    drop_if_exists('products_target');
end;
/
