prompt block.json_doc.dynamic_json_table_query.unpivot.sql

prompt convert dataguide to column definitions


set serveroutput on
declare

    type t_column is record (
        col_name varchar2(100), 
        datatype varchar2(20), 
        json_table_path varchar2(100)
        );
        
    type t_columns is table of t_column index by pls_integer;
    
    l_cols t_columns;
    
    l_json clob;
    
    function get_columns(
        p_jdoc in clob, 
        p_array_path in varchar2 default null
    ) return t_columns
    is
        l_column_definitions t_columns;
    begin
    
        with dataguide as (
            select json_dataguide(p_jdoc) as jdoc_dataguide
            from dual
        ), dataguide_relational as (
            select 
                '"' || ltrim(replace(j.dg_path, p_array_path), '$.') || '"' as col_name,
                j.datatype,
                replace(j.dg_path, p_array_path) as json_table_path
            from 
                dataguide g,
                json_table(g.jdoc_dataguide, '$[*]'
                    columns(
                        dg_path path '$."o:path".string()',
                        datatype path '$.type.string()'
                    )
                ) j
        )
        select col_name, datatype, json_table_path
        bulk collect into l_column_definitions
        from dataguide_relational
        where datatype not in ('object', 'array');

        return l_column_definitions;
    
    end get_columns;
    
    function build_json_table_sql(
        p_jdoc in clob, 
        p_json_array_path in varchar2 default null
    ) return varchar2
    is
        l_sql varchar2(32000);
        l_jc varchar2(4000);
        l_uc varchar2(4000);
    begin
        l_cols := get_columns(p_jdoc, p_json_array_path);
    
        --build the json table columns expression
        --since we want to use this with unpivot, set all columns to varchar
        for i in 1..l_cols.count loop
            l_jc := l_jc || '                '
                || ', ' || l_cols(i).col_name 
                || ' varchar2(4000) path ''' 
                || l_cols(i).json_table_path || '''' || chr(10);
        end loop;
        
        --build the unpivot expression using the columns collection
        --this can also be done in the above loop
        for i in 1..l_cols.count loop
            l_uc := l_uc || '                ' 
                || case when i > 1 then ', ' end 
                || l_cols(i).col_name || chr(10);
        end loop;

        l_sql := q'+
with json_document as (
    select
        q'~
##JSON_DOC##
        ~' as jdoc
    from dual
), json_relational as (
    select j.*
    from 
        json_document d,
        json_table(d.jdoc format json, '$##ARRAY_PATH##[*]' 
            columns (
                "id#ordinality" for ordinality
##JSON_TABLE_COLUMNS##
            )
        ) j
    )
    select "id#ordinality", "column#key", "column#value"
    from 
        json_relational 
        unpivot (
            "column#value" for "column#key" in (
##UNPIVOT_COLUMNS##
                )
        ) 
    order by "id#ordinality", "column#key"
/

+';    
    
        l_sql := replace(l_sql, '##JSON_TABLE_COLUMNS##', l_jc);
        l_sql := replace(l_sql, '##ARRAY_PATH##', rtrim(p_json_array_path,'.'));
        l_sql := replace(l_sql, '##UNPIVOT_COLUMNS##', l_uc);
        --for testing output query here, substitute the jsoc document
        l_sql := replace(l_sql, '##JSON_DOC##', p_jdoc);
        
        return l_sql;
    
    end build_json_table_sql;
begin

    dbms_output.put_line('Test these resulting queries to be sure the unpivot syntax is correct');

    l_json := to_clob(
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

    dbms_output.put_line(build_json_table_sql(l_json, '.my_shapes'));
            
    l_json := to_clob(
        q'~
        [
        {"name":"square","side":5,"color":"blue"},
        {"name":"rectangle","length":5,"width":3},  
        {"name":"box","length":5,"width":3,"height":2},  
        {"name":"hexagon","side":3,"color":"red"},
        {"name":"circle","radius":3},
        ]
    ~');

    dbms_output.put_line(build_json_table_sql(l_json, null));

end;
/

/*
Test these resulting queries to be sure the unpivot syntax is correct

with json_document as (
    select
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
    
        ~' as jdoc
    from dual
), json_relational as (
    select j.*
    from 
        json_document d,
        json_table(d.jdoc format json, '$.my_shapes[*]' 
            columns (
                "id#ordinality" for ordinality
                , "name" varchar2(4000) path '$.name'
                , "side" varchar2(4000) path '$.side'
                , "color" varchar2(4000) path '$.color'
                , "width" varchar2(4000) path '$.width'
                , "height" varchar2(4000) path '$.height'
                , "length" varchar2(4000) path '$.length'
                , "radius" varchar2(4000) path '$.radius'

            )
        ) j
    )
    select "id#ordinality", "column#key", "column#value"
    from 
        json_relational 
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
    order by "id#ordinality", "column#key"
/



with json_document as (
    select
        q'~

        [
        {"name":"square","side":5,"color":"blue"},
        {"name":"rectangle","length":5,"width":3},  
        {"name":"box","length":5,"width":3,"height":2},  
        {"name":"hexagon","side":3,"color":"red"},
        {"name":"circle","radius":3},
        ]
    
        ~' as jdoc
    from dual
), json_relational as (
    select j.*
    from 
        json_document d,
        json_table(d.jdoc format json, '$[*]' 
            columns (
                "id#ordinality" for ordinality
                , "name" varchar2(4000) path '$.name'
                , "side" varchar2(4000) path '$.side'
                , "color" varchar2(4000) path '$.color'
                , "width" varchar2(4000) path '$.width'
                , "height" varchar2(4000) path '$.height'
                , "length" varchar2(4000) path '$.length'
                , "radius" varchar2(4000) path '$.radius'

            )
        ) j
    )
    select "id#ordinality", "column#key", "column#value"
    from 
        json_relational 
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
    order by "id#ordinality", "column#key"
/




PL/SQL procedure successfully completed.

*/