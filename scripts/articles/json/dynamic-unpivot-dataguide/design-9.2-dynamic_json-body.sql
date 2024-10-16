prompt design-9.2-dynamic_json-body.sql
--Note:  This result in an internal error on XE 21c
--ORA-00600: internal error code, arguments: [kglidinsi1]
    
create or replace package body dynamic_json 
as

    c_lf constant varchar2(1) := chr(10);
    c_indent constant varchar2(100) := lpad(' ', 12, ' ');
    c_max_column_name_length constant number := 64;
    
    subtype sql_text is varchar2(32000);
    
    g_unpivot_to_datatype unpivot_datatype := c_varchar2_4000;
    g_bulk_limit_rows positiven := 100;
    
    type column_definition is record (
        column_name varchar2(64), 
        column_type varchar2(20), 
        column_path varchar2(100));
        
    type column_definitions is table of column_definition index by pls_integer;
    
    procedure set_bulk_limit_rows( 
        bulk_limit_rows in positiven default 100
    )
    is 
    begin
        g_bulk_limit_rows := bulk_limit_rows;
    end set_bulk_limit_rows;
    
    procedure set_unpivot_to_datatype(unpivot_to_datatype in unpivot_datatype default c_varchar2_4000)
    is
    begin
        if unpivot_to_datatype not in (c_varchar2_100, c_varchar2_1000, c_varchar2_4000, c_clob, c_number) then
            raise_application_error(-20100, unpivot_to_datatype || ' is not supported for dynamic unpivot');
        end if;
        g_unpivot_to_datatype := unpivot_to_datatype;
    end set_unpivot_to_datatype;    

    function dataguide_columns(
        jdoc in json_document_type, 
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
        
    function json_table_expression(
        key_columns in column_definitions,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null
    ) return varchar2
    is
        l_sql sql_text;
        l_columns_clause sql_text;
        l_row_identifier varchar2(1000) := '"row#id" for ordinality';
    begin
    
        --build the columns expression
        for i in $if dbms_db_version.version >= 21 $then indices of key_columns $else 1..key_columns.count $end loop
            l_columns_clause := l_columns_clause || c_indent
                || ', ' || key_columns(i).column_name
                || ' ' || g_unpivot_to_datatype 
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
    
    function unpivot_expression(
        key_columns in column_definitions,        
        json_table_query in varchar2,
        row_identifier in varchar2 default null        
    ) return varchar2
    is
        l_sql sql_text;
        l_unpivot_columns sql_text;
    begin
    
        --build the unpivot expression
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

    function unpivot_json_array(
        jdoc in json_document_type,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null    
    ) return column_values pipelined
    is
        l_key_columns column_definitions;
        l_json_table_query sql_text;
        l_sql sql_text;
        l_values column_values;
        c sys_refcursor;
    begin
        l_key_columns := dataguide_columns(jdoc, row_identifier, array_path);
        l_json_table_query := json_table_expression(l_key_columns, row_identifier, array_path);
        l_sql := unpivot_expression(l_key_columns, l_json_table_query, row_identifier);
        
        open c for l_sql using jdoc;
        loop
        
            fetch c bulk collect into l_values limit g_bulk_limit_rows;
            exit when l_values.count = 0;
            
            for i in $if dbms_db_version.version >= 21 $then indices of l_values $else 1..l_values.count $end loop
                pipe row (l_values(i));
            end loop;
        
        end loop;
        close c;
        
        return;

    end unpivot_json_array;
    
    procedure debug_test_output_heading(p_heading in varchar2)
    is
        c_separator constant varchar2(100) := lpad('-', 100, '-');
    begin
        dbms_output.put_line(c_separator);
        dbms_output.put_line('--' || p_heading);
        dbms_output.put_line(c_separator);            
    end debug_test_output_heading;
    
    procedure debug_dataguide_columns(
        jdoc in json_document_type, 
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

    procedure debug_json_table_expression(
        jdoc in json_document_type,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null
    )
    is
        l_key_columns column_definitions;
        l_sql sql_text;
    begin
        l_key_columns := dataguide_columns(jdoc, row_identifier, array_path);
        l_sql := json_table_expression(l_key_columns, row_identifier, array_path);
        
        debug_test_output_heading('JSON_TABLE Expression generated from document dataguide.' 
            || case when array_path is null then ' no array path' else ' array_path => ' || array_path end );

        dbms_output.put_line(l_sql);
    end debug_json_table_expression;

    procedure debug_unpivot_expression(
        jdoc in json_document_type,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null
    )
    is
        l_key_columns column_definitions;
        l_json_table_query sql_text;
        l_sql sql_text;
    begin
        l_key_columns := dataguide_columns(jdoc, row_identifier, array_path);
        l_json_table_query := json_table_expression(l_key_columns, row_identifier, array_path);
        l_sql := unpivot_expression(l_key_columns, l_json_table_query);
        
        debug_test_output_heading('UNPIVOT Query generated from document dataguide.' 
            || case when array_path is null then ' no array path' else ' array_path => ' || array_path end );
        
        dbms_output.put_line(l_sql);
    end debug_unpivot_expression;

    procedure debug_unpivot_json_array(
        jdoc in json_document_type,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null,
        dataguide_columns in boolean default true,
        json_table_expression in boolean default true,
        unpivot_expression in boolean default true
    )
    is
    begin
    
        if dataguide_columns then
            debug_dataguide_columns(jdoc, row_identifier, array_path);
        end if;
        
        if json_table_expression then
            debug_json_table_expression(jdoc, row_identifier, array_path);
        end if;
        
        if unpivot_expression then
            debug_unpivot_expression(jdoc, row_identifier, array_path);
        end if;
        
    end debug_unpivot_json_array;
    
    function test_jdoc(
        format_option in json_format default c_array_simple
    ) return json_document_type
    is
        l_json_text clob;
    begin
        case format_option 
            when c_array_simple then
                l_json_text := to_clob(
                    q'~
                    [
                    {"name":"square","side":5,"color":"blue"},
                    {"name":"rectangle","length":5,"width":3},  
                    {"name":"box","length":5,"width":3,"height":2},  
                    {"name":"hexagon","side":3,"color":"red"},
                    {"name":"circle","radius":3},
                    ]
                ~');
            when c_array_nested then
                l_json_text := to_clob(
                    q'~
                    {"my_shapes":
                        [
                        {"name":"square","side":5,"color":"blue"},
                        {"name":"rectangle","length":5,"width":3},  
                        {"name":"box","length":5,"width":3,"height":2},  
                        {"name":"hexagon","side":3,"color":"red"},
                        {"name":"circle","radius":3},
                        ]
                    }
                ~');
            when c_array_simple_id then
                l_json_text := to_clob(
                    q'~
                    [
                    {"shape_id":101,"name":"square","side":5,"color":"blue"},
                    {"shape_id":102,"name":"rectangle","length":5,"width":3},  
                    {"shape_id":103,"name":"box","length":5,"width":3,"height":2},  
                    {"shape_id":104,"name":"hexagon","side":3,"color":"red"},
                    {"shape_id":105,"name":"circle","radius":3},
                    ]
                ~');
            when c_array_nested_id then
                l_json_text := to_clob(
                    q'~
                    {"my_shapes":
                        [
                        {"shape_id":101,"name":"square","side":5,"color":"blue"},
                        {"shape_id":102,"name":"rectangle","length":5,"width":3},  
                        {"shape_id":103,"name":"box","length":5,"width":3,"height":2},  
                        {"shape_id":104,"name":"hexagon","side":3,"color":"red"},
                        {"shape_id":105,"name":"circle","radius":3},
                        ]
                    }
                ~');
            else
                raise_application_error(-20100, format_option || ' is an undefined test document type');
        end case;
        
        return $if dbms_db_version.version < 21 $then l_json_text $else json(l_json_text) $end ;

    end test_jdoc;
            
end dynamic_json;
/

