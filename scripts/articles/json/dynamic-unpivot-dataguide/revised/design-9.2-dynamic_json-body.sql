prompt design-9.2-dynamic_json-body.sql
--Note:  This result in an internal error on XE 21c
--ORA-00600: internal error code, arguments: [kglidinsi1]
    
create or replace package body dynamic_json 
as

    c_lf constant varchar2(1) := chr(10);
    c_indent constant varchar2(100) := lpad(' ', 12, ' ');
    c_max_column_name_length constant number := 64;
    c_unpivot_to_datatype constant varchar2(20) := 'varchar2(4000)';
    c_bulk_limit_rows constant number := 100;

    type column_defnition is record (
        column_name varchar2(64), 
        column_type varchar2(20), 
        column_path varchar2(100));
        
    type column_defnitions is table of column_defnition index by pls_integer;

    function dataguide_columns(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end , 
        row_identifier in varchar2 default null,        
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
        key_columns in column_defnitions,
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
        for i in 1..key_columns.count loop
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
    
    function unpivot_expression(
        key_columns in column_defnitions,        
        json_table_query in varchar2,
        row_identifier in varchar2 default null        
    ) return varchar2
    is
        l_sql varchar2(32000);
        l_unpivot_columns varchar2(4000);
    begin
    
        --build the unpivot expression using the columns collection
        for i in 1..key_columns.count loop
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
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null    
    ) return column_values
    pipelined
    is
        l_key_columns column_defnitions;
        l_json_table_query varchar2(4000);
        l_sql varchar2(4000);
        l_values column_values;
        c sys_refcursor;
    begin
        l_key_columns := dataguide_columns(jdoc, row_identifier, array_path);
        l_json_table_query := json_table_expression(l_key_columns, row_identifier, array_path);
        l_sql := unpivot_expression(l_key_columns, l_json_table_query, row_identifier);
        
        open c for l_sql using jdoc;
        loop
        
            fetch c bulk collect into l_values limit c_bulk_limit_rows;
            exit when l_values.count = 0;
            
            for i in $if dbms_db_version.version >= 21 $then indices of l_values $else 1..l_values.count $end loop
                pipe row (l_values(i));
            end loop;
        
        end loop;
        close c;
            
--        execute immediate l_sql bulk collect into l_values using jdoc;
--        
--        for i in $if dbms_db_version.version >= 21 $then indices of l_values $else 1..l_values.count $end loop
--            pipe row (l_values(i));
--        end loop;
        
        return;

    end unpivot_json_array;

end dynamic_json;
/

