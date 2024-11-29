prompt 4.2-nested-macro-row-column-differences.sql
prompt create a nested macro to compare row and column differences
prompt use nested invocations of dynamic_unpivot_columns and row_differences macros
prompt cannot reuse find_row_differences macro
prompt the only option is to reproduce the comparison codefrom find_row_differences

create or replace function find_row_column_differences(
    source_data in dbms_tf.table_t
    , target_data in dbms_tf.table_t
    , id_columns in dbms_tf.columns_t
    ) return varchar2 
    sql_macro(table)
is
    l_sql varchar2(4000);
    l_id_columns varchar2(4000);
    l_coalesce_id_columns varchar2(4000);
    l_join_id_columns varchar2(4000);
    l_column varchar2(128);
begin
    select listagg(column_value,',') 
    into l_id_columns 
    from table(id_columns);
    
    for i in 1..id_columns.count loop
        l_column := id_columns(i);
        
        l_coalesce_id_columns := l_coalesce_id_columns 
            || ', coalesce(s.' || l_column 
            || ', t.' || l_column 
            || ') as ' || l_column;
            
        l_join_id_columns := l_join_id_columns 
            || case when l_join_id_columns is not null then ' and ' end 
            || 's.' || l_column || ' = t.' || l_column;
    end loop;
    
    l_sql := q'!
    select 
        coalesce(s.row#source, t.row#source) as row#source 
        ##COALESCE_ID_COLUMNS##
        , coalesce(s.column#name, t.column#name) as column#name
        , coalesce(s.column#value, t.column#value) as column#value
    from
        (
            select 
                'source' as row#source
                , ##ID_COLUMNS##
                , column#name
                , column#value
                , json_object(column#value) as json#column
            from dynamic_unpivot_columns(source_data, columns(##ID_COLUMNS##))
        ) s full outer join
        (
            select 
                'target' as row#source
                , ##ID_COLUMNS##
                , column#name
                , column#value
                , json_object(column#value) as json#column
            from dynamic_unpivot_columns(target_data, columns(##ID_COLUMNS##))
        ) t 
            on ##JOIN_COLUMNS## 
            and s.column#name = t.column#name 
            and json_equal(s.json#column, t.json#column)
    where 
        s.##FIRST_ID_COLUMN## is null 
        or t.##FIRST_ID_COLUMN## is null
    order by ##ID_COLUMNS##, column#name, row#source
    !';
    
    l_sql := replace(l_sql,'##ID_COLUMNS##', l_id_columns);
    l_sql := replace(l_sql,'##COALESCE_ID_COLUMNS##', l_coalesce_id_columns);
    l_sql := replace(l_sql,'##JOIN_COLUMNS##', l_join_id_columns);
    l_sql := replace(l_sql,'##FIRST_ID_COLUMN##', id_columns(1));
    
    return l_sql;
end find_row_column_differences;
/

column row#source format a10
column product_id format 9
column code format a6
column column#name format a12
column column#value format a30
set null (null)
set pagesize 50

prompt test the macro to show row and column differences
select * from find_row_column_differences(products_source, products_target, columns(product_id, code))
/

/*
4.2-nested-macro-row-column-differences.sql
create a nested macro to compare row and column differences
use nested invocations of dynamic_unpivot_columns and row_differences macros
cannot reuse find_row_differences macro
the only option is to reproduce the comparison codefrom find_row_differences

Function FIND_ROW_COLUMN_DIFFERENCES compiled

test the macro to show row and column differences

ROW#SOURCE PRODUCT_ID CODE   COLUMN#NAME  COLUMN#VALUE                  
---------- ---------- ------ ------------ ------------------------------
source              1 P-ES   DESCRIPTION  Mt. Everest Summit            
target              1 P-ES   DESCRIPTION  Mount Everest Summit          
source              2 P-EB   DESCRIPTION  Mt. Everest Basecamp          
target              2 P-EB   DESCRIPTION  Mount Everest Basecamp        
source              3 P-FD   MSRP         20                            
target              3 P-FD   MSRP         19                            
source              3 P-FD   NAME         Fujiyama Dawn                 
target              3 P-FD   NAME         Fuji Dawn                     
source              4 P-FS   NAME         Fujiyama Sunset               
target              4 P-FS   NAME         Fuji Sunset                   
source              6 PC-ES  DESCRIPTION  Mt. Everest postcards         
target              6 PC-ES  DESCRIPTION  Mount Everest postcards       
source              6 PC-ES  STYLE        5x7                           
target              6 PC-ES  STYLE        Monochrome                    
source              8 PC-K2  STYLE        Color                         
target              8 PC-K2  STYLE        (null)                        
source              9 PC-S   DESCRIPTION  Mount Shasta postcards        
source              9 PC-S   MSRP         9                             
source              9 PC-S   NAME         Shasta Postcards              
source              9 PC-S   STYLE        5x7                           

20 rows selected. 

*/