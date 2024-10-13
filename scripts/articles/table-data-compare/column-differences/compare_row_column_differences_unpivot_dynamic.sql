with source_columns as (
select u.*
from
    (
        select json{*} as jdoc 
        from products_source 
    ) s,
    dynamic_json.unpivot_json_array(s.jdoc,'PRODUCT_ID') u
), target_columns as (
select u.*
from
    (
        select json{*} as jdoc 
        from products_target
    ) s,
    dynamic_json.unpivot_json_array(s.jdoc,'PRODUCT_ID') u
)
select 
    c."ROW#ID"
    , c."COLUMN#KEY"
    , c.row_source
    , json_value(c.jdoc,'$.COLUMN#VALUE.string()') as value
from 
    row_compare(source_columns, target_columns, columns("ROW#ID","COLUMN#KEY")) c
/

select * from column_compare(products_source, products_target, columns(PRODUCT_ID,CODE))
/




with source_json as (
    select 
        'src' as src_tbl
        , product_id as id
        , json_object(* returning json) as jdoc 
    from products_source
), target_json as (
    select 
        'tgt' as src_tbl
        , product_id as id
        , json_object(* returning json) as jdoc 
    from products_target
), compare_rows as (
    select 
        coalesce(s.id, t.id) as id,
        coalesce(s.src_tbl, t.src_tbl) as src_tbl, 
        coalesce(s.jdoc, t.jdoc) as jdoc
    from   
        source_json s
        full outer join target_json t
            on s.id = t.id
            and json_equal(s.jdoc, t.jdoc)
    where  
        s.id is null or t.id is null
), columns_base as (
    select 
        c.src_tbl
        , u."ROW#ID" as "id"
        , u."COLUMN#KEY" as "key"
        , json_object(u.*) as jdoc
    from 
        compare_rows c,
        table(dynamic_json.unpivot_json_array(c.jdoc,'PRODUCT_ID')) u
), source_columns as (
    select b.* from columns_base b where b.src_tbl = 'src'
), target_columns as (
    select b.* from columns_base b where b.src_tbl = 'tgt'
)
select 
    coalesce(s."id", t."id") as id,
    coalesce(s."key", t."key") as key,
    coalesce(s.src_tbl, t.src_tbl) as src_tbl,
    json_value(coalesce(s.jdoc, t.jdoc), '$.COLUMN#VALUE.string()') as value
from 
    source_columns s
    full outer join target_columns t
        on s."id" = t."id"
        and s."key" = t."key"
        and json_equal(s.jdoc, t.jdoc)
where
    s."id" is null or t."id" is null
order by
    id, key, src_tbl
/