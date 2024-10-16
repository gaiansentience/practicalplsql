prompt design-9.8-pipelined-macro.sql


column Year format 9999
column Month format a10
column Volume format 999999

set pagesize 100
/*
--all the unpivot queries have the same pattern
select u.row#id as "Year", u.column#key as "Month", to_number(u.column#value) as "Volume"
from
    (
    select json_arrayagg( json{ * } ) as jdoc
    from monthly_sales_v
    ) j,
    dynamic_json.unpivot_json_array(j.jdoc, 'Year') u
*/


create or replace function unpivot_results(
    source_data in dbms_tf.table_t, 
    alias_list in dbms_tf.columns_t,
    value_as_number in number default 1
) return varchar2
sql_macro  $if dbms_db_version.version >= 21 $then (table) $end
is
    l_sql varchar2(4000);
    l_json_data varchar2(100);
    l_value_expression varchar2(100);
begin

$if dbms_db_version.version >= 21 $then
        l_json_data := 'json_arrayagg( json{ * } )';
$else
        l_json_data := 'json_arrayagg( json_object( * ) returning clob) returning clob)'; 
$end

l_sql := q'[
select 
    u.row#id as ##ROW_IDENTIFIER##, 
    u.column#key as ##COLUMN_KEY##, 
    ##VALUE_EXPRESSION## as ##COLUMN_VALUE##
from
    (
    select ##JSON_DATA## as jdoc
    from source_data 
    ) j,
    dynamic_json.unpivot_json_array(j.jdoc, '##ROW_IDENTIFIER_PARAMETER##') u
]';    

    l_sql := replace(l_sql, '##JSON_DATA##', l_json_data);
    l_sql := replace(l_sql, '##ROW_IDENTIFIER_PARAMETER##', trim(both '"' from alias_list(1)));
    l_sql := replace(l_sql, '##ROW_IDENTIFIER##', alias_list(1));
    l_sql := replace(l_sql, '##COLUMN_KEY##', alias_list(2));
    l_sql := replace(l_sql, '##COLUMN_VALUE##', alias_list(3));
    
    l_value_expression := case when value_as_number = 1 then 'to_number(u.column#value)' else 'u.column#value' end;
    
    l_sql := replace(l_sql, '##VALUE_EXPRESSION##', l_value_expression);
    
    --enable this to check the macro output
    --dbms_output.put_line(l_sql);
    
    return l_sql;

end unpivot_results;
/
/*
prompt check the macro sql statement with the dbms_output statement enabled
set serveroutput on;
declare
i number;
begin

    select count(1) into i
    from unpivot_results(monthly_sales_v, columns("Year", "Month", "Volume"));

end;
/
*/


prompt test the macro
select *
from unpivot_results(monthly_sales_v, columns("Year", "Month", "Volume"));


--On Oracle19c VirtualBox DeveloperDays this macro wont compile:
--SQL Error: ORA-62556: Incorrect use of COLUMNS operator.
--62556. 00000 -  "Incorrect use of COLUMNS operator."
--*Cause:    COLUMNS function was used outside a POLYMORPHIC TABLE FUNCTION.