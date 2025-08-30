set feedback off;
set echo off;
set heading off;
set pagesize 0;
set linesize 4000;
set termout off;
set serveroutput on;


prompt generating primary script for generating menu items by category scripts

spool ./generate.load_menu_items.all_category_scripts.sql

prompt set echo off;
prompt set feedback off;
exec dbms_output.put_line('prompt script generated ' || to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'));

select '@generate.load_menu_items.category_script.sql "' || category_name || '";'
from menu_categories;

spool off;

prompt generating all scripts 
@generate.load_menu_categories_script.sql
@generate.load_menu_items.all_category_scripts.sql;

prompt generating primary load scripts
spool ./load.all.menu_items_example.sql;

prompt prompt loading menu items example

prompt @load.table.menu_categories.sql;
prompt @load.table.menu_items.all_categories.sql;

spool off;

spool ./load.table.menu_items.all_categories.sql;

prompt set echo off;
prompt set feedback off;
exec dbms_output.put_line('prompt script generated ' || to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'));

select '@load.table.menu_items.by_category.' || lower(translate(category_name,' -','__')) || '.sql;'
from menu_categories;

prompt @load.all.menu_items_example.results.sql;

spool off;


