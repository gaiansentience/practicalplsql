prompt 3.1-simple-unpivot-macro.sql
prompt create a simple macro to dynamically unpivot columns
prompt don't convert datatypes before unpivoting

create or replace function dynamic_unpivot_columns(
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
    select ##EXCLUDE_COLS##, column#name, column#value
    from 
        data
        unpivot include nulls(column#value for column#name in (##UNPIVOT_COLS##))
    ]';
    l_sql := replace(l_sql, '##EXCLUDE_COLS##', l_exclude);
    l_sql := replace(l_sql, '##UNPIVOT_COLS##', l_unpivot_columns);

    return l_sql;
end dynamic_unpivot_columns;
/

column product_id format 9
column code format a6
column column#name format a15
column column#value format a20
prompt test the simple unpivot macro 

with base as (
    select product_id, code, name, description
    from products_source
    order by product_id
    fetch first 2 rows only
)
select * 
from dynamic_unpivot_columns(base, columns(product_id, code))
/

/*
3.1-simple-unpivot-macro.sql
create a simple macro to dynamically unpivot columns
don't convert datatypes before unpivoting

Function DYNAMIC_UNPIVOT_COLUMNS compiled

test the simple unpivot macro

PRODUCT_ID CODE   COLUMN#NAME     COLUMN#VALUE        
---------- ------ --------------- --------------------
         1 P-ES   NAME            Everest Summit      
         1 P-ES   DESCRIPTION     Mt. Everest Summit  
         2 P-EB   NAME            Everest Basecamp    
         2 P-EB   DESCRIPTION     Mt. Everest Basecamp
*/