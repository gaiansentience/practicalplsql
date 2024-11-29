with source_columns as (
    select
        'source' as row_source
        , product_id as "id"
        , code
        , "key"
        , "value"
    from (
        select 
            product_id
            , code
            , name
            , description
            , style
            , to_char(msrp) as msrp
        from products_source
        )
    unpivot include nulls ("value" for "key" in (
        --code,
        name,
        description,
        style,
        msrp
        )
    )
), target_columns as (
    select
        'target' as row_source
        , product_id as "id"
        , code
        , "key"
        , "value"
    from (
        select 
            product_id
            , code
            , name
            , description
            , style
            , to_char(msrp) as msrp
        from products_target
        )
    unpivot include nulls ("value" for "key" in (
--        code,
        name,
        description,
        style,
        msrp
        )
    )
)
select
    coalesce(s.row_source, t.row_source) as row_source
    , coalesce(s."id", t."id") as "id"
    , coalesce(s.code, t.code) as code
    , coalesce(s."key", t."key") as "key"
    , coalesce(s."value", t."value") as "value"
from 
    source_columns s
    full outer join target_columns t 
        on s."id" = t."id" 
        and s.code = t.code
        and s."key" = t."key" 
        and decode(s."value", t."value", 1, 0) = 1
where s."id" is null or t."id" is null
order by 
    "id", "key", row_source
/





with source_columns as (
select u.*
from
    (
        select json_object(*) as jdoc 
        from products_source 
    ) s,
    table(dynamic_json.unpivot_json_array(s.jdoc,'PRODUCT_ID')) u
), target_columns as (
select u.*
from
    (
        select json_object(*) as jdoc 
        from products_target
    ) s,
    table(dynamic_json.unpivot_json_array(s.jdoc,'PRODUCT_ID')) u
)
select 
    c."id"
    , c."key"
    , c.src_tbl
    , json_value(c.jdoc,'$.value.string()') as value
from 
    get_row_compare_alt(source_columns, target_columns, columns("id","key")) c
/

select * from get_column_compare(products_source, products_target, columns(PRODUCT_ID,CODE))
/




with source_json as (
    select 
        'src' as src_tbl
        , product_id as id
        , json_object(*) as jdoc 
    from products_source
), target_json as (
    select 
        'tgt' as src_tbl
        , product_id as id
        , json_object(*) as jdoc 
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
        , u."id"
        , u."key"
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
    json_value(coalesce(s.jdoc, t.jdoc), '$.value.string()') as value
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