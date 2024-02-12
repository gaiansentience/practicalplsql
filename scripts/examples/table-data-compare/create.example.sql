prompt creating example tables for table compare
set serveroutput on;
set feedback off;

@@drop.example.sql;

@@create.table.products.sql;

@@load.products.sql

@@create.table.products_source.sql;

@@create.table.products_target.sql;

@@create_table_data_differences.sql;

prompt example tables created for table compare