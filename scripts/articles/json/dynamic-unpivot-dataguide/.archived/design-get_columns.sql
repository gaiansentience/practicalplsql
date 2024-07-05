prompt design-2-dataguide-columns.sql

--convert dataguide to column definitions
--This will create valid column names and json path arguments for json_table column definitions
with dataguide as (
    select json_dataguide(design#dynamic_json.test_jdoc()) as jdoc_dataguide
    from dual
), dataguide_relational as (
    select 
        '"' || ltrim(replace(j.dg_path, null), '$.') || '"' as col_name,
        j.datatype,
        replace(j.dg_path, null) as column_path
    from 
        dataguide g,
        json_table(g.jdoc_dataguide, '$[*]'
            columns(
                dg_path path '$."o:path".string()',
                datatype path '$.type.string()'
            )
        ) j
)
select col_name, datatype, column_path
from dataguide_relational
where datatype not in ('object', 'array')
/

with dataguide as (
    select json_dataguide(design#dynamic_json.test_jdoc('nested')) as jdoc_dataguide
    from dual
), dataguide_relational as (
    select 
        '"' || ltrim(replace(j.dg_path, '.my_shapes'), '$.') || '"' as col_name,
        j.datatype,
        replace(j.dg_path, '.my_shapes') as column_path
    from 
        dataguide g,
        json_table(g.jdoc_dataguide, '$[*]'
            columns(
                dg_path path '$."o:path".string()',
                datatype path '$.type.string()'
            )
        ) j
)
select col_name, datatype, column_path
from dataguide_relational
where datatype not in ('object', 'array')
/
    
begin

    l_json := design#dynamic_json.test_jdoc('simple');
    local#print_columns(l_json);
            
    l_json := dynamic_json.get_test_json('nested');
    local#print_columns(l_json, '.my_shapes');

end;
/

/*
design.block.json_doc.dataguide_relational.sql

Column definitions from document dataguide.

col_name => "name", datatype => string, column_path => $.name
col_name => "side", datatype => number, column_path => $.side
col_name => "color", datatype => string, column_path => $.color
col_name => "width", datatype => number, column_path => $.width
col_name => "height", datatype => number, column_path => $.height
col_name => "length", datatype => number, column_path => $.length
col_name => "radius", datatype => number, column_path => $.radius

Column definitions from document dataguide. p_array_path => .my_shapes

col_name => "name", datatype => string, column_path => $.name
col_name => "side", datatype => number, column_path => $.side
col_name => "color", datatype => string, column_path => $.color
col_name => "width", datatype => number, column_path => $.width
col_name => "height", datatype => number, column_path => $.height
col_name => "length", datatype => number, column_path => $.length
col_name => "radius", datatype => number, column_path => $.radius


PL/SQL procedure successfully completed.
*/