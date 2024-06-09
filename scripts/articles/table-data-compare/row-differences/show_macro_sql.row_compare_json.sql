set serveroutput on;
declare
    l_sql varchar2(4000);
    i number;
begin
    dbms_output.put_line('Oracle ' || dbms_db_version.version);
$if dbms_db_version.version = 19 $then
    dbms_output.put_line('use json_object(* returning clob)');
$else
    dbms_output.put_line('use json_object(* returning json)');
$end

    l_sql := 
q'[
select count(*) as row_differences 
from row_compare_json(products_source, products_target, columns(product_id))
]';

    execute immediate l_sql into i;
    dbms_output.put_line('function runs on hard parse, outputting sql statement');

end;
/

/*

Oracle 19
use json_object(* returning clob)

select 
    coalesce(s.row_source, t.row_source) as row_source, 
    --coalesce(s."PRODUCT_ID", t."PRODUCT_ID") as "PRODUCT_ID",
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , "PRODUCT_ID"
            , json_object(* returning clob) as jdoc 
        from p_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , "PRODUCT_ID"
            , json_object(* returning clob) as jdoc 
        from p_target    
    ) t
        on s."PRODUCT_ID" = t."PRODUCT_ID"
        and json_equal(s.jdoc, t.jdoc)
where s."PRODUCT_ID" is null or t."PRODUCT_ID" is null
order by coalesce(s."PRODUCT_ID", t."PRODUCT_ID"), row_source

function runs on hard parse, outputting sql statement


PL/SQL procedure successfully completed.


*/

/*
Oracle 21
use json_object(* returning json)

select 
    coalesce(s.row_source, t.row_source) as row_source, 
    --coalesce(s."PRODUCT_ID", t."PRODUCT_ID") as "PRODUCT_ID",
    coalesce(s.jdoc, t.jdoc) as jdoc
from   
    (
        select 
            'source' as row_source
            , "PRODUCT_ID"
            , json_object(* returning json) as jdoc 
        from p_source    
    ) s
    full outer join (
        select 
            'target' as row_source
            , "PRODUCT_ID"
            , json_object(* returning json) as jdoc 
        from p_target    
    ) t
        on s."PRODUCT_ID" = t."PRODUCT_ID"
        and json_equal(s.jdoc, t.jdoc)
where s."PRODUCT_ID" is null or t."PRODUCT_ID" is null
order by coalesce(s."PRODUCT_ID", t."PRODUCT_ID"), row_source

function runs on hard parse, outputting sql statement


PL/SQL procedure successfully completed.

*/