with 
function columns_to_varchar(
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
    --dbms_output.put_line(l_sql);
     debug_macro_sql(l_sql);
    return l_sql;
end columns_to_varchar;


function dynamic_unpivot(
    data in dbms_tf.table_t, 
    exclude_cols in dbms_tf.columns_t
    ) return varchar2 
    sql_macro(table)
is
    l_column varchar2(128);
    l_sql varchar2(4000);
    l_unpivot_columns varchar2(4000);
    l_exclude varchar2(4000);
begin
    select listagg(column_value, ',') into l_exclude 
    from table(exclude_cols);
    
    for i in 1..data.column.count loop
        l_column := data.column(i).description.name;
        if l_column not member of exclude_cols then
            l_unpivot_columns := l_unpivot_columns || ',' || l_column;
        end if;
    end loop;
    l_unpivot_columns := trim(leading ',' from l_unpivot_columns);
    
    l_sql := q'[
    select ##EXCLUDE_COLS##, col#name, col#value
    from 
        ( select * from columns_to_varchar(data, columns(##EXCLUDE_COLS##))) 
        unpivot include nulls(col#value for col#name in (##UNPIVOT_COLS##))
    ]';
    l_sql := replace(l_sql, '##EXCLUDE_COLS##', l_exclude);
    l_sql := replace(l_sql, '##UNPIVOT_COLS##', l_unpivot_columns);
    --dbms_output.put_line(l_sql);
    debug_macro_sql(l_sql);
    return l_sql;
end dynamic_unpivot;


source as (
    select 1 as id, 'AAA' as code, 'Cellphone' as name, 'Black' as color, 'XTech' as brand, 234 as msrp from dual union all
    select 2, 'BBB', 'USB Charger', 'Black' , 'WallTek', 555 from dual union all
    select 3, 'CCC', 'Case', 'Blue', null, 543 from dual
), target as (
    select 1 as id, 'AAA' as code, 'Cellphone' as name, 'Black' as color, 'XTech' as brand, 234 as msrp from dual union all
    select 2, 'BBB', 'USB Charger', 'Black' , 'WallTek', 555 from dual union all
    select 3, 'CCC', 'Case', 'Blue', null, 543 from dual
)
select u.id, u.code, u.col#name, u.col#value
from
--    columns_to_varchar(
--        data => target
--        , exclude_cols => columns(id,code)
--        ) u 
    dynamic_unpivot(
        data => source
        , exclude_cols => columns(id,code)
        ) u 
/



      
