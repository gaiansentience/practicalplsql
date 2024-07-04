prompt design-4.1-json_table_expression.sql

set serveroutput on
declare

    l_json $if dbms_db_version.version >= 21 $then json $else clob $end;
    
    c_lf constant varchar2(1) := chr(10);
    c_indent constant varchar2(100) := lpad(' ', 12, ' ');
    c_max_column_name_length constant number := 10;
    c_unpivot_to_datatype constant varchar2(20) := 'varchar2(4000)';
    
    type column_defnition is record (
        column_name varchar2(64), 
        column_type varchar2(20), 
        column_path varchar2(100));
        
    type column_defnitions is table of column_defnition index by pls_integer;

    function dataguide_columns(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end , 
        array_path in varchar2 default null
    ) return column_defnitions
    is
        l_key_columns column_defnitions;
    begin    
        with dataguide as (
            select json_dataguide(jdoc) as jdoc_dataguide
            from dual
        ), dataguide_relational as (
            select 
                dbms_assert.enquote_name(ltrim(replace(j.dg_path, array_path), '$.'), capitalize => false) as column_name,
                j.column_type,
                replace(j.dg_path, array_path) as column_path
            from 
                dataguide g,
                json_table(g.jdoc_dataguide, '$[*]'
                    columns(
                        dg_path path '$."o:path".string()',
                        column_type path '$.type.string()'
                    )
                ) j
        )
        select column_name, column_type, column_path
        bulk collect into l_key_columns
        from dataguide_relational
        where column_type not in ('object', 'array');
        
        return l_key_columns;
    end dataguide_columns;

    procedure debug_test_output_heading(p_heading in varchar2)
    is
        c_separator constant varchar2(100) := lpad('-', 100, '-');
    begin
        dbms_output.put_line(c_separator);
        dbms_output.put_line('--' || p_heading);
        dbms_output.put_line(c_separator);            
    end debug_test_output_heading;
    
    procedure debug_dataguide_columns(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end, 
        array_path in varchar2 default null)
    is
        l_key_columns column_defnitions;        
    begin
        l_key_columns := dataguide_columns(jdoc, array_path);
        
        debug_test_output_heading('Column definitions from document dataguide.' 
            || case when array_path is null then ' no array path' else ' array_path => ' || array_path end );

        for i in $if dbms_db_version.version >= 21 $then indices of l_key_columns $else 1..l_key_columns.count $end loop
            dbms_output.put_line(
                'column_name => ' || l_key_columns(i).column_name
                || ', column_type => ' || l_key_columns(i).column_type
                || ', column_path => ' || l_key_columns(i).column_path);
        end loop;    
    end debug_dataguide_columns;
    
    function json_table_expression(
        key_columns in column_defnitions,
        array_path in varchar2 default null
    ) return varchar2
    is
        l_sql varchar2(32000);
        l_columns_clause varchar2(4000);
    begin
    
        --build the columns expression
        --since we want to use this with unpivot, set all columns to varchar
        for i in 1..key_columns.count loop
            l_columns_clause := l_columns_clause || c_indent
                || ', ' || rpad(key_columns(i).column_name, c_max_column_name_length + 1, ' ')
                || c_unpivot_to_datatype 
                || ' path ''' || key_columns(i).column_path || '''' 
                || case when i <> key_columns.count then c_lf end;
        end loop;

        l_sql := q'+
select j.*
from 
    json_table(:jdoc, '$##ARRAY_PATH##[*]' 
        columns (
            "row#id" for ordinality
##JSON_TABLE_COLUMNS##
        )
    ) j
+';

        l_sql := replace(l_sql, '##JSON_TABLE_COLUMNS##', l_columns_clause);
        l_sql := replace(l_sql, '##ARRAY_PATH##', rtrim(array_path,'.'));
        return l_sql;
    
    end json_table_expression;

    procedure debug_json_table_expression(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        array_path in varchar2 default null
    )
    is
        l_key_columns column_defnitions;
        l_sql varchar2(4000);
    begin
        l_key_columns := dataguide_columns(jdoc, array_path);
        l_sql := json_table_expression(l_key_columns, array_path);
        
        debug_test_output_heading('JSON_TABLE Expression generated from document dataguide.' 
            || case when array_path is null then ' no array path' else ' array_path => ' || array_path end );

        dbms_output.put_line(l_sql);
    end debug_json_table_expression;
    
begin

    l_json := dynamic_json#test.test_jdoc();
    debug_json_table_expression(l_json);
            
    l_json := dynamic_json#test.test_jdoc('nested');
    debug_json_table_expression(l_json, '.my_shapes');

end;
/

/*
design-4.1-json_table_expression.sql
----------------------------------------------------------------------------------------------------
--JSON_TABLE Expression generated from document dataguide. no array path
----------------------------------------------------------------------------------------------------

select j.*
from 
    json_table(:jdoc, '$[*]' 
        columns (
            "row#id" for ordinality
            , "name"     varchar2(4000) path '$.name'
            , "side"     varchar2(4000) path '$.side'
            , "color"    varchar2(4000) path '$.color'
            , "width"    varchar2(4000) path '$.width'
            , "height"   varchar2(4000) path '$.height'
            , "length"   varchar2(4000) path '$.length'
            , "radius"   varchar2(4000) path '$.radius'
        )
    ) j

----------------------------------------------------------------------------------------------------
--JSON_TABLE Expression generated from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------

select j.*
from 
    json_table(:jdoc, '$.my_shapes[*]' 
        columns (
            "row#id" for ordinality
            , "name"     varchar2(4000) path '$.name'
            , "side"     varchar2(4000) path '$.side'
            , "color"    varchar2(4000) path '$.color'
            , "width"    varchar2(4000) path '$.width'
            , "height"   varchar2(4000) path '$.height'
            , "length"   varchar2(4000) path '$.length'
            , "radius"   varchar2(4000) path '$.radius'
        )
    ) j



PL/SQL procedure successfully completed.


*/