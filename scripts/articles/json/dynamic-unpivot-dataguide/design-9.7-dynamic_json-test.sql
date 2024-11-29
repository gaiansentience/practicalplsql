prompt design--9.7-dynamic_json-test.sql

spool ./design-9.7-dynamic_json_test.txt
prompt design-9.7-dynamic_json_test.txt

set feedback on


--regional monthly final unpivot query went over 4000 characters
--ORA-06502: PL/SQL: value or conversion error: character string buffer too small
--ORA-06512: at "CLOUD_PRACTICALPLSQL.DYNAMIC_JSON", line 176
--create a subtype for sql_text varchar2(32000) and use it for any sql

prompt debug the the sales data queries
set serveroutput on
declare 
    jdoc dynamic_json.json_document_type;
    procedure print_debug(datasource in varchar2)
    is
        c_stars constant varchar2(100) := lpad('*',90,'*');
    begin
        dbms_output.put_line(c_stars);
        dbms_output.put_line(c_stars);

        dbms_output.put_line(datasource);

        dynamic_json.debug_unpivot_json_array(
            jdoc => jdoc,
            row_identifier => 'Year',      
            array_path => '.jSales',
            dataguide_columns => false,
            json_table_expression => false,
            unpivot_expression => true
        );
        
        dbms_output.put_line(c_stars);
        dbms_output.put_line(c_stars);
    
    end print_debug;
begin
-----------------------------------------------------------------------------------------
    select
$if dbms_db_version.version >= 21 $then
        json{ 'jSales' value json_arrayagg( json{ s.* } ) }
$else
        json_object('jSales' value json_arrayagg( json_object( s.* ) returning clob) returning clob) 
$end
        as jdoc
    into jdoc
    from quarterly_sales_v s;

    print_debug('Quarterly Sales');
-----------------------------------------------------------------------------------------
    select
$if dbms_db_version.version >= 21 $then
        json{ 'jSales' value json_arrayagg( json{ s.* } ) }
$else
        json_object('jSales' value json_arrayagg( json_object( s.* ) returning clob) returning clob) 
$end
        as jdoc
    into jdoc
    from regional_sales_v s;

    print_debug('Regional Sales');
-----------------------------------------------------------------------------------------
    select
$if dbms_db_version.version >= 21 $then
        json{ 'jSales' value json_arrayagg( json{ s.* } ) }
$else
        json_object('jSales' value json_arrayagg( json_object( s.* ) returning clob) returning clob) 
$end
        as jdoc
    into jdoc
    from regional_quarterly_sales_v s;

    print_debug('Regional Quarterly Sales');
-----------------------------------------------------------------------------------------
    select
$if dbms_db_version.version >= 21 $then
        json{ 'jSales' value json_arrayagg( json{ s.* } ) }
$else
        json_object('jSales' value json_arrayagg( json_object( s.* ) returning clob) returning clob) 
$end
        as jdoc
    into jdoc
    from monthly_sales_v s;

    print_debug('Monthly Sales');
-----------------------------------------------------------------------------------------
    select
$if dbms_db_version.version >= 21 $then
        json{ 'jSales' value json_arrayagg( json{ s.* } ) }
$else
        json_object('jSales' value json_arrayagg( json_object( s.* ) returning clob) returning clob) 
$end
        as jdoc
    into jdoc
    from regional_monthly_sales_v s;

    print_debug('Regional Monthly Sales');
-----------------------------------------------------------------------------------------


end;
/

spool off