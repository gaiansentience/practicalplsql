prompt 1.3-macro-row-differences.sql
prompt create a macro to find row differences using full outer join and json_equal
prompt don't include the json rows in the results

create or replace function find_row_differences(
    source_data in dbms_tf.table_t, 
    target_data in dbms_tf.table_t, 
    id_columns in dbms_tf.columns_t
    ) return varchar2 
    sql_macro(table)
is
    l_sql varchar2(4000);
    l_id_columns varchar2(4000);
    l_coalesce varchar2(4000);
    l_all_columns varchar2(4000);
    l_join_cols varchar2(4000);
    l_column varchar2(128);
begin
    select listagg(column_value,',') 
    into l_id_columns 
    from table(id_columns);
    
    for c in 1..source_data.column.count loop
        l_column := source_data.column(c).description.name;
        l_coalesce := l_coalesce 
            || ', coalesce(s.' || l_column 
            || ', t.' || l_column 
            || ') as ' || l_column;
        l_all_columns := l_all_columns || ', ' || l_column;
    end loop;
    
    for i in 1..id_columns.count loop
        l_join_cols := l_join_cols 
            || case when l_join_cols is not null then ' and ' end 
            || 's.' || id_columns(i) || ' = t.' || id_columns(i);
    end loop;
    
    l_sql := q'!
    select 
        coalesce(s.row_source, t.row_source) as row_source 
        ##COALESCE_COLUMNS##
    from
        (
        select 
            'source' as row_source
            ##ALL_COLUMNS##
            , json_object(*) as jdoc
        from source_data 
        ) s full outer join
        (
        select 
            'target' as row_source
            ##ALL_COLUMNS##
            , json_object(*) as jdoc
        from target_data
        ) t 
            on ##JOIN_ID_COLUMNS## 
            and json_equal(s.jdoc, t.jdoc) 
    where 
        s.##FIRST_ID_COLUMN## is null 
        or t.##FIRST_ID_COLUMN## is null
    order by ##ID_COLUMNS##, row_source
    !';
    l_sql := replace(l_sql,'##ALL_COLUMNS##', l_all_columns);
    l_sql := replace(l_sql,'##ID_COLUMNS##', l_id_columns);
    l_sql := replace(l_sql,'##COALESCE_COLUMNS##', l_coalesce);
    l_sql := replace(l_sql,'##JOIN_ID_COLUMNS##', l_join_cols);
    l_sql := replace(l_sql,'##FIRST_ID_COLUMN##', id_columns(1));
    
    return l_sql;
end find_row_differences;
/

column row_source format a10
column product_id format 99
column code format a6
column name format a20
column description format a25
column style format a10
set pagesize 50


Prompt Test the macro, returns 13 rows with differences:
with source_rows as (
    select product_id, code, name, description, style
    from products_source
), target_rows as (
    select product_id, code, name, description, style
    from products_target
)
select 
    row_source
    , product_id
    , code
    , name
    , description
    , style
from 
    find_row_differences(
        source_rows
        , target_rows
        , columns(product_id, code))
/

/*

1.3-macro-row-differences
create a macro to find row differences using full outer join and json_equal
don't include the json rows in the results

Function FIND_ROW_DIFFERENCES compiled

Test the macro, returns 13 rows with differences:

ROW_SOURCE PRODUCT_ID CODE   NAME                 DESCRIPTION               STYLE     
---------- ---------- ------ -------------------- ------------------------- ----------
source              1 P-ES   Everest Summit       Mt. Everest Summit        18x20     
target              1 P-ES   Everest Summit       Mount Everest Summit      18x20     
source              2 P-EB   Everest Basecamp     Mt. Everest Basecamp      18x20     
target              2 P-EB   Everest Basecamp     Mount Everest Basecamp    18x20     
source              3 P-FD   Fujiyama Dawn        Mount Fuji at dawn        11x17     
target              3 P-FD   Fuji Dawn            Mount Fuji at dawn        11x17     
source              4 P-FS   Fujiyama Sunset      Mount Fuji at sunset      11x17     
target              4 P-FS   Fuji Sunset          Mount Fuji at sunset      11x17     
source              6 PC-ES  Everest Postcards    Mt. Everest postcards     5x7       
target              6 PC-ES  Everest Postcards    Mount Everest postcards   Monochrome
source              8 PC-K2  K2 Postcards         K2 postcards              Color     
target              8 PC-K2  K2 Postcards         K2 postcards              (null)    
source              9 PC-S   Shasta Postcards     Mount Shasta postcards    5x7       

13 rows selected. 


*/