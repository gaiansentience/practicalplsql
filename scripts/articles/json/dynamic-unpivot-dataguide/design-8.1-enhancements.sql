prompt design-8.1-enhancements.sql
--Note:  This result in an internal error on XE 21c
--ORA-00600: internal error code, arguments: [kglidinsi1]

prompt add support for a row identifier in the json object
prompt add a row_identifier parameter to all modules
prompt filter the row identifier from dataguide_columns results
prompt replace the ordinality value with row identifier in json_table_expression
    
create or replace package dynamic_json#beta
authid current_user
as
    
    c_lf constant varchar2(1) := chr(10);
    c_indent constant varchar2(100) := lpad(' ', 12, ' ');
    c_max_column_name_length constant number := 10;
    c_unpivot_to_datatype constant varchar2(20) := 'varchar2(4000)';
    
    type column_value is record(
        row#id number,
        column#key varchar2(64),
        column#value varchar2(4000));
    
    type column_values is table of column_value;

    type column_definition is record (
        column_name varchar2(64), 
        column_type varchar2(20), 
        column_path varchar2(100));
        
    type column_definitions is table of column_definition index by pls_integer;

    function dataguide_columns(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end , 
        row_identifier in varchar2 default null,
        array_path in varchar2 default null
    ) return column_definitions;

    procedure debug_dataguide_columns(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end, 
        row_identifier in varchar2 default null,
        array_path in varchar2 default null
    );

    function json_table_expression(
        key_columns in column_definitions,
        row_identifier in varchar2 default null,
        array_path in varchar2 default null
    ) return varchar2;

    procedure debug_json_table_expression(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,
        array_path in varchar2 default null
    );

    function unpivot_expression(
        key_columns in column_definitions,
        json_table_query in varchar2
    ) return varchar2;

    procedure debug_unpivot_expression(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null
    );

    function unpivot_collection(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null    
    ) return column_values;

    procedure debug_unpivot_collection(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null        
    );

    function unpivot_json_array(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null    
    ) return column_values 
    pipelined;

end dynamic_json#beta;
/

create or replace package body dynamic_json#beta 
as

    function dataguide_columns(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end , 
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null
    ) return column_definitions
    is
        l_key_columns column_definitions;
    begin    
        with dataguide as (
            select json_dataguide(jdoc) as jdoc_dataguide
            from dual
        ), dataguide_relational as (
            select 
$if dbms_db_version.version >= 23 $then
                dbms_assert.enquote_name(ltrim(replace(j.dg_path, array_path), '$.'), capitalize => false) as column_name,
$else
                '"' || ltrim(replace(j.dg_path, array_path), '$.') || '"' as column_name,
$end
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
        where 
            column_type not in ('object', 'array')
$if dbms_db_version.version >= 23 $then
            and column_name <> dbms_assert.enquote_name(nvl(row_identifier,'~#~#~'), capitalize => false)
$else
            and column_name <> '"' || nvl(row_identifier,'~#~#~') || '"'
$end
        ;
        
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
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null
    )
    is
        l_key_columns column_definitions;        
    begin
        l_key_columns := dataguide_columns(jdoc, row_identifier, array_path);
        
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
        key_columns in column_definitions,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null
    ) return varchar2
    is
        l_sql varchar2(32000);
        l_columns_clause varchar2(4000);
        l_row_identifier varchar2(1000) := '"row#id" for ordinality';
    begin
    
        --build the columns expression
        --since we want to use this with unpivot, set all columns to varchar
        for i in $if dbms_db_version.version >= 21 $then indices of key_columns $else 1..key_columns.count $end loop
            l_columns_clause := l_columns_clause || c_indent
                || ', ' || rpad(key_columns(i).column_name, c_max_column_name_length + 1, ' ')
                || c_unpivot_to_datatype 
                || ' path ''' || key_columns(i).column_path || '''' 
                || case when i <> key_columns.count then c_lf end;
        end loop;

        --if row identifier has been passed, substitute it for ordinality value using local path        
        if row_identifier is not null then
            l_row_identifier := '"row#id" number path ''$.' || row_identifier || '''';
        end if;

        l_sql := q'+
select j.*
from 
    json_table(:jdoc, '$##ARRAY_PATH##[*]' 
        columns (
            ##ROW_IDENTIFIER##
##JSON_TABLE_COLUMNS##
        )
    ) j
+';

        l_sql := replace(l_sql, '##JSON_TABLE_COLUMNS##', l_columns_clause);
        l_sql := replace(l_sql, '##ARRAY_PATH##', rtrim(array_path,'.'));
        l_sql := replace(l_sql, '##ROW_IDENTIFIER##', l_row_identifier);
        return l_sql;
    
    end json_table_expression;

    procedure debug_json_table_expression(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null
    )
    is
        l_key_columns column_definitions;
        l_sql varchar2(4000);
    begin
        l_key_columns := dataguide_columns(jdoc, row_identifier, array_path);
        l_sql := json_table_expression(l_key_columns, row_identifier, array_path);
        
        debug_test_output_heading('JSON_TABLE Expression generated from document dataguide.' 
            || case when array_path is null then ' no array path' else ' array_path => ' || array_path end );

        dbms_output.put_line(l_sql);
    end debug_json_table_expression;
    
    function unpivot_expression(
        key_columns in column_definitions,        
        json_table_query in varchar2
    ) return varchar2
    is
        l_sql varchar2(32000);
        l_unpivot_columns varchar2(4000);
    begin
    
        --build the unpivot expression using the columns collection
        for i in $if dbms_db_version.version >= 21 $then indices of key_columns $else 1..key_columns.count $end loop
            l_unpivot_columns := l_unpivot_columns || c_indent
                || case when i > 1 then ', ' end 
                || key_columns(i).column_name 
                || case when i <> key_columns.count then c_lf end;
        end loop;

        l_sql := q'+
with json_to_relational as (
##JSON_TABLE_EXPRESSION##
)
select "row#id", "column#key", "column#value"
from 
    json_to_relational 
    unpivot (
        "column#value" for "column#key" in (
##UNPIVOT_COLUMNS##
            )
    ) 
order by "row#id", "column#key"
+';

        l_sql := replace(l_sql, '##JSON_TABLE_EXPRESSION##', json_table_query);
        l_sql := replace(l_sql, '##UNPIVOT_COLUMNS##', l_unpivot_columns);
        return l_sql;
    
    end unpivot_expression;

    procedure debug_unpivot_expression(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null
    )
    is
        l_key_columns column_definitions;
        l_json_table_query varchar2(4000);
        l_sql varchar2(4000);
    begin
        l_key_columns := dataguide_columns(jdoc, row_identifier, array_path);
        l_json_table_query := json_table_expression(l_key_columns, row_identifier, array_path);
        l_sql := unpivot_expression(l_key_columns, l_json_table_query);
        
        debug_test_output_heading('UNPIVOT Query generated from document dataguide.' 
            || case when array_path is null then ' no array path' else ' array_path => ' || array_path end );
        
        dbms_output.put_line(l_sql);
    end debug_unpivot_expression;

    function unpivot_collection(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null    
    ) return column_values
    is
        l_key_columns column_definitions;
        l_json_table_query varchar2(4000);
        l_sql varchar2(4000);
        l_values column_values;
    begin
        l_key_columns := dataguide_columns(jdoc, row_identifier, array_path);
        l_json_table_query := json_table_expression(l_key_columns, row_identifier, array_path);
        l_sql := unpivot_expression(l_key_columns, l_json_table_query);
    
        execute immediate l_sql bulk collect into l_values using jdoc;
        return l_values;
    end unpivot_collection;
    
    procedure debug_unpivot_collection(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null        
    )
    is
        l_values column_values;    
    begin
        l_values := unpivot_collection(jdoc, row_identifier, array_path);
        
        debug_test_output_heading('unpivoted column values generated dynamically from json document.' 
            || case when array_path is null then ' no array path' else ' array_path => ' || array_path end );
        
        for i in $if dbms_db_version.version >= 21 $then indices of l_values $else 1..l_values.count $end loop
            dbms_output.put_line(
                'row#id => ' || l_values(i).row#id 
                || ', column#key => ' || l_values(i).column#key 
                || ', column#value => ' || l_values(i).column#value);
        end loop;
    end debug_unpivot_collection;

    function unpivot_json_array(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null    
    ) return column_values
    pipelined
    is
        l_key_columns column_definitions;
        l_json_table_query varchar2(4000);
        l_sql varchar2(4000);
        l_values column_values;
    begin
        l_key_columns := dataguide_columns(jdoc, row_identifier, array_path);
        l_json_table_query := json_table_expression(l_key_columns, row_identifier, array_path);
        l_sql := unpivot_expression(l_key_columns, l_json_table_query);
    
        execute immediate l_sql bulk collect into l_values using jdoc;
        
        for i in $if dbms_db_version.version >= 21 $then indices of l_values $else 1..l_values.count $end loop
            pipe row (l_values(i));
        end loop;
        
        return;

    end unpivot_json_array;

end dynamic_json#beta;
/

set serveroutput on;
declare
    l_json $if dbms_db_version.version >= 21 $then json $else clob $end ;
begin

    l_json := dynamic_json#test.test_jdoc(dynamic_json#test.c_array_simple_id);
    dynamic_json#beta.debug_dataguide_columns(l_json, 'shape_id');
    dynamic_json#beta.debug_json_table_expression(l_json, 'shape_id');
    dynamic_json#beta.debug_unpivot_expression(l_json, 'shape_id');
    
end;
/

/*
design-8.1-enhancements.sql
add support for a row identifier in the json object
add a row_identifier parameter to all modules
filter the row identifier from dataguide_columns results
replace the ordinality value with row identifier in json_table_expression

Package DYNAMIC_JSON#BETA compiled


Package Body DYNAMIC_JSON#BETA compiled

----------------------------------------------------------------------------------------------------
--Column definitions from document dataguide. no array path
----------------------------------------------------------------------------------------------------
column_name => "name", column_type => string, column_path => $.name
column_name => "side", column_type => number, column_path => $.side
column_name => "color", column_type => string, column_path => $.color
column_name => "width", column_type => number, column_path => $.width
column_name => "height", column_type => number, column_path => $.height
column_name => "length", column_type => number, column_path => $.length
column_name => "radius", column_type => number, column_path => $.radius
----------------------------------------------------------------------------------------------------
--JSON_TABLE Expression generated from document dataguide. no array path
----------------------------------------------------------------------------------------------------

select j.*
from 
    json_table(:jdoc, '$[*]' 
        columns (
            "row#id" number path '$.shape_id'
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
--UNPIVOT Query generated from document dataguide. no array path
----------------------------------------------------------------------------------------------------

with json_to_relational as (

select j.*
from 
    json_table(:jdoc, '$[*]' 
        columns (
            "row#id" number path '$.shape_id'
            , "name"     varchar2(4000) path '$.name'
            , "side"     varchar2(4000) path '$.side'
            , "color"    varchar2(4000) path '$.color'
            , "width"    varchar2(4000) path '$.width'
            , "height"   varchar2(4000) path '$.height'
            , "length"   varchar2(4000) path '$.length'
            , "radius"   varchar2(4000) path '$.radius'
        )
    ) j

)
select "row#id", "column#key", "column#value"
from 
    json_to_relational 
    unpivot (
        "column#value" for "column#key" in (
            "name"
            , "side"
            , "color"
            , "width"
            , "height"
            , "length"
            , "radius"
            )
    ) 
order by "row#id", "column#key"



PL/SQL procedure successfully completed.


*/