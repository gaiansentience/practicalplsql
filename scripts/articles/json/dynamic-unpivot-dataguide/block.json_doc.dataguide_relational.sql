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

    procedure print_columns(
        p_jdoc in clob, 
        p_json_structure in varchar2,
        p_json_array_path in varchar2 default null)
    is
    begin
        l_cols := get_columns(p_jdoc, p_json_array_path);
        dbms_output.put_line(lpad('*', 40, '*'));
        dbms_output.put_line(p_json_structure);
        dbms_output.put_line(lpad('*', 40, '*'));
        for i in 1..l_cols.count loop
            dbms_output.put_line(l_cols(i).col_name || ' ' || l_cols(i).datatype || ' ' || l_cols(i).json_table_path);
        end loop;    
    end print_columns;
begin

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

    print_columns(l_json, 'json object with array of json objects', '.my_shapes');
            
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

    print_columns(l_json, 'array of json objects', null);

end;
/

/*
This will create valid column names and json path arguments for json_table column definitions
Keep the datatype value to support generating a json_table expression with typed columns
This can be used for a function to create a json_table query from any json_document

****************************************
json object with array of json objects
****************************************
"name" string $.name
"side" number $.side
"color" string $.color
"width" number $.width
"height" number $.height
"length" number $.length
"radius" number $.radius
****************************************
array of json objects
****************************************
"name" string $.name
"side" number $.side
"color" string $.color
"width" number $.width
"height" number $.height
"length" number $.length
"radius" number $.radius


PL/SQL procedure successfully completed.
*/