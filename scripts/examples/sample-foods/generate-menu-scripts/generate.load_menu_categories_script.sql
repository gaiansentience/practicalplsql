set echo off;
set feedback off;

set heading off;
set pagesize 0;
set linesize 4000;
set termout off;
set serveroutput on;
variable bvFileName varchar2(100);
column proc_call format a4000;

begin
    :bvFileName := './load.table.menu_categories.sql';
end;
/

column fn new_value filename noprint;
select :bvFileName as fn;

spool &filename;


begin

dbms_output.put_line('prompt loading menu categories');

dbms_output.put_line('prompt script generated: ' || to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'));

dbms_output.put_line(q'#
set feedback on;
set serveroutput on;

declare
    l_count number;
    
    procedure create_category(
        p_name in menu_categories.category_name%type, 
        p_desc in menu_categories.category_description%type, 
        p_user in varchar2 default 'sample') 
    is
    begin
        insert into menu_categories(
            category_name, category_description, created_by
        ) values (
            p_name, p_desc, p_user);
    end create_category;
begin


    delete menu_items;
    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items');
    
    delete menu_categories;  
    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu categories');
 #');
 
 end;
 /
 
 


with 
function fmt_string(s in varchar2) return varchar2 sql_macro(scalar)
is
begin
    return q'^'q' || '''~' 
        || replace(s, chr(38), '~''' || ' || chr(38) || q' || '''' || '~')
        || '~' || ''''^';
end fmt_string;
select 'create_category(' || fmt_string(c.category_name) || ', ' || fmt_string(c.category_description) || ');' as proc_call
from menu_categories c
order by c.category_name
/


begin

    dbms_output.put_line(q'#
    
    select count(*) into l_count 
    from menu_categories;

    dbms_output.put_line('Created ' || l_count || ' menu categories');

    commit;

exception
    when others then
        dbms_output.put_line('Error creating categories: ' || sqlerrm);
        rollback;
end;
/
    
    
    #');
end;
/


spool off;
