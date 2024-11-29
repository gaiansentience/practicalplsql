prompt 2.1-macro-convert-column-datatypes.sql
prompt create a macro to coerce datatypes for unpivot

create or replace function convert_columns_to_varchar(
    data in dbms_tf.table_t, 
    exclude_cols in dbms_tf.columns_t
    ) return varchar2 
    sql_macro(table)
is
    l_column varchar2(128);
    l_all_columns varchar2(4000);
    l_sql varchar2(4000);
begin
    
    for i in 1..data.column.count loop
        l_column := data.column(i).description.name;
        if l_column not member of exclude_cols then
            l_all_columns := l_all_columns || ','
                || 'to_char(' || l_column || ') as ' || l_column;
        else
            l_all_columns := l_all_columns || ','
                || l_column;
        end if;
    end loop;
    l_all_columns := trim(leading ',' from l_all_columns);
    
    l_sql := q'[
         select ##ALL_COLUMNS## from data 
    ]';
    l_sql := replace(l_sql, '##ALL_COLUMNS##', l_all_columns);

    return l_sql;
end convert_columns_to_varchar;
/

column id format 99
column str format a3
column num format a3
column dt format a10

alter session set nls_date_format = 'YYYY-MM-DD';

prompt Test the macro with different data types
prompt using a simple to_char for conversion makes datetime conversions dependent on nls settings
with base (id, str, num, dt) as (
    select 
        level
        , chr(level + 64)
        , level + 64
        , sysdate + level
    from dual
    connect by level <= 5
)
select id, str, num, dt
from convert_columns_to_varchar(base, columns(id))
/

/*

2.1-macro-convert-column-datatypes.sql
create a macro to coerce datatypes for unpivot

Function CONVERT_COLUMNS_TO_VARCHAR compiled


Session altered.

Test the macro with different data types
using a simple to_char for conversion makes datetime conversions dependent on nls settings

 ID STR NUM DT        
--- --- --- ----------
  1 A   65  2024-11-30
  2 B   66  2024-12-01
  3 C   67  2024-12-02
  4 D   68  2024-12-03
  5 E   69  2024-12-04 

*/