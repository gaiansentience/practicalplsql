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
from row_compare_json_alt_to_columns(products_source, products_target, columns(product_id, code))
]';

    execute immediate l_sql into i;
    dbms_output.put_line('function runs on hard parse, outputting sql statement');

end;
/

/*
Oracle 21
use json_object(* returning json)

select base.row_source, j.*
from
    (
    select 
        coalesce(s.row_source, t.row_source) as row_source
        , coalesce(s.jdoc, t.jdoc) as jdoc
    from   
        (
        select 
            'source' as row_source
            , "PRODUCT_ID"
            , "CODE"
            , json_object(* returning json) as jdoc 
        from p_source    
        ) s
        full outer join 
        (
        select 
            'target' as row_source
            , "PRODUCT_ID"
            , "CODE"
            , json_object(* returning json) as jdoc 
        from p_target    
        ) t 
            on s."PRODUCT_ID" = t."PRODUCT_ID"
            and s."CODE" = t."CODE"
            and json_equal(s.jdoc, t.jdoc)
    where s."PRODUCT_ID" is null or t."PRODUCT_ID" is null
    ) base,
    json_table(base.jdoc
        columns (
            PRODUCT_ID path '$.PRODUCT_ID.number()'
            , CODE path '$.CODE.string()'
            , NAME path '$.NAME.string()'
            , DESCRIPTION path '$.DESCRIPTION.string()'
            , STYLE path '$.STYLE.string()'
            , MSRP path '$.MSRP.number()'
        )
    ) j
order by "PRODUCT_ID", row_source

function runs on hard parse, outputting sql statement


PL/SQL procedure successfully completed.


*/