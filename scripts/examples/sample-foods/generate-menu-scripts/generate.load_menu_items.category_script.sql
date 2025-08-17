set echo off;
set feedback off;

set heading off;
set pagesize 0;
set linesize 4000;
set termout off;
set serveroutput on;
variable bvFileName varchar2(100);
variable bvCategoryName varchar2(100);
column proc_call format a4000;

begin
    :bvFileName := './load.table.menu_items.by_category.&1..sql';
    :bvFileName := lower(translate(:bvFileName, ' -','__'));
    :bvCategoryName := '&1.';
end;
/

column fn new_value filename noprint;
select :bvFileName as fn;

spool &filename;


begin

dbms_output.put_line('prompt loading menu items for category: ' || :bvCategoryName);

dbms_output.put_line('prompt script generated: ' || to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'));

dbms_output.put_line(q'#
set feedback on;
set serveroutput on;

declare

    l_count number;
    c menu_categories.category_name%type;

    type t_category_ids is table of integer index by varchar2(100);
    l_categories t_category_ids;
    
    procedure load_categories_array
    is
    begin
        l_categories := t_category_ids(for r in (select category_name, category_id from menu_categories) index r.category_name => r.category_id);
    end load_categories_array;
    
     procedure create_item(
        p_category_name in varchar2, 
        p_item_name in varchar2, 
        p_description in varchar2, 
        p_created_by in varchar2 default 'sample')
     is
        l_category_id integer := l_categories(p_category_name);
     begin     
        savepoint new_menu_item;

        insert into menu_items (item_name, category_id, item_description, created_by)
        values (p_item_name, l_category_id, p_description, p_created_by);
    exception
        when others then
            rollback to new_menu_item;
            dbms_output.put_line('Error inserting item: ' || p_item_name || ' SQLERRM: ' || sqlerrm);            
     end create_item;
     
begin

    load_categories_array;
 #');
 
 dbms_output.put_line('
    c := ''' || :bvCategoryName || ''';
    delete menu_items 
    where category_id = l_categories(c);
 
    dbms_output.put_line(''Deleted '' || sql%rowcount || '' existing menu items for category: '' || c);

 ');
 
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
select 'create_item(c, ' || fmt_string(i.item_name) || ', ' || fmt_string(i.item_description) || ');' as proc_call
from menu_items i
join menu_categories c on i.category_id = c.category_id
where 
c.category_name = :bvCategoryName
order by i.item_name
/


begin

    dbms_output.put_line(q'#
    
    select count(*) into l_count 
    from menu_items
    where category_id = l_categories(c);

    dbms_output.put_line('Created ' || l_count || ' menu items for category: ' || c);    

    commit;


exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
    
    
    #');
end;
/


spool off;
