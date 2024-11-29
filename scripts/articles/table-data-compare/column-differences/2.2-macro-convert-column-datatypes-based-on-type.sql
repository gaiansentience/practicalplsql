prompt 2.2-macro-convert-column-datatypes-based-on-type.sql
prompt create a macro to coerce datatypes for unpivot
prompt customize conversion for source datatypes

create or replace function convert_columns_to_varchar(
    data in dbms_tf.table_t, 
    exclude_cols in dbms_tf.columns_t
    ) return varchar2 
    sql_macro(table)
is
    l_column varchar2(128);
    l_all_columns varchar2(4000);
    l_sql varchar2(4000);
    l_type_name varchar2(100);
    c_fmt_number varchar2(100) := '''tm9''';
    c_fmt_date   varchar2(100) := '''yyyy-mm-dd hh24:mi:ss''';
    c_fmt_ts varchar2(50) := '''yyyy-mm-dd hh24:mi:ss.ff9''';
    c_fmt_tstz varchar2(50) := '''yyyy-mm-dd hh24:mi:ss.ff9 tzh:tzm''';
    c_fmt_tsltz varchar2(50) := '''yyyy-mm-dd hh24:mi:ss.ff9 tzr''';
begin
    
    for i in 1..data.column.count loop
        l_column := data.column(i).description.name;
        if l_column not member of exclude_cols then
            l_type_name := dbms_tf.column_type_name(data.column(i).description);
            l_all_columns := l_all_columns || ','
                || case
                    when l_type_name = 'NUMBER' 
                        then 'to_char(' || l_column || ',' || c_fmt_number || ')'
                    when l_type_name in ('DATE','TYPE-CODE: 13') 
                        then 'to_char(' || l_column || ',' || c_fmt_date || ')'
                    when l_type_name in ('TIMESTAMP') 
                        then 'to_char(' || l_column || ',' || c_fmt_ts || ')'
                    when l_type_name in ('TIMESTAMP WITH TIMEZONE', 'TYPE-CODE: 188') 
                        then 'to_char(' || l_column || ',' || c_fmt_tstz || ')'
                    when l_type_name in ('TIMESTAMP WITH LOCAL TIMEZONE') 
                        then 'to_char(' || l_column || ',' || c_fmt_tsltz || ')'
                    when l_type_name in ('INTERVAL DAY TO SECOND','INTERVAL YEAR TO MONTH') 
                        then 'to_char(' || l_column || ')'
                    when l_type_name in ('CLOB') 
                        then 'to_char(' || l_column || ')'
                    else l_column
                end
                || ' as ' || l_column;
        else 
            l_all_columns := l_all_columns || ',' || l_column;
        end if;
    end loop;
    l_all_columns := trim(leading ',' from l_all_columns);
    
    l_sql := q'[
         select ##ALL_COLS## from data 
    ]';
    l_sql := replace(l_sql, '##ALL_COLS##', l_all_columns);
    
    return l_sql;
end convert_columns_to_varchar;
/

column id format 99
column str format a3
column num format a3
column dt format a20

alter session set nls_date_format = 'YYYY-MM-DD';

prompt Test the macro with different data types
prompt use explicit datetime formats to preserve detail
with base (id, str, num, dt) as (
    select 
        level
        , chr(level + 64)
        , level + 64
        , sysdate + level + power(level,level)/(24*60*60)
    from dual
    connect by level <= 5
)
select id, str, num, dt
from convert_columns_to_varchar(base, columns(id))
/

/*

2.2-macro-convert-column-datatypes-based-on-type.sql
create a macro to coerce datatypes for unpivot
customize conversion for source datatypes

Function CONVERT_COLUMNS_TO_VARCHAR compiled


Session altered.

Test the macro with different data types
use explicit datetime formats to preserve detail

 ID STR NUM DT                  
--- --- --- --------------------
  1 A   65  2024-11-30 15:01:36 
  2 B   66  2024-12-01 15:01:39 
  3 C   67  2024-12-02 15:02:02 
  4 D   68  2024-12-03 15:05:51 
  5 E   69  2024-12-04 15:53:40 

*/