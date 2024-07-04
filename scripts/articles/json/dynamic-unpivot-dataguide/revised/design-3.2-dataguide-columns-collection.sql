prompt design-3.2-dataguide-columns-collection.sql

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
        
begin

    l_json := dynamic_json#test.test_jdoc();
    debug_dataguide_columns(l_json);
            
    l_json := dynamic_json#test.test_jdoc('nested');
    debug_dataguide_columns(l_json, '.my_shapes');

end;
/

/*
design-3.2-dataguide-columns-collection.sql
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
--Column definitions from document dataguide. array_path => .my_shapes
----------------------------------------------------------------------------------------------------
column_name => "name", column_type => string, column_path => $.name
column_name => "side", column_type => number, column_path => $.side
column_name => "color", column_type => string, column_path => $.color
column_name => "width", column_type => number, column_path => $.width
column_name => "height", column_type => number, column_path => $.height
column_name => "length", column_type => number, column_path => $.length
column_name => "radius", column_type => number, column_path => $.radius


PL/SQL procedure successfully completed.


*/