with source_json as (
    select 
        'source' as row_source
        , product_id as id
        , code
        , json_object(*) as jdoc 
    from products_source
), target_json as (
    select 
        'target' as row_source
        , product_id as id
        , code
        , json_object(*) as jdoc 
    from products_target
), compare_rows as (
    select 
        coalesce(s.id, t.id) as id,
        coalesce(s.code, t.code) as code,
        coalesce(s.row_source, t.row_source) as row_source, 
        coalesce(s.jdoc, t.jdoc) as jdoc
    from   
        source_json s
        full outer join target_json t
            on s.id = t.id
            and s.code = t.code
            and json_equal(s.jdoc, t.jdoc)
    where s.id is null or t.id is null
), parse_jdoc as (
    select 
        c.row_source
        , c.id
        , c.code
        , j.name
        , j.description
        , j.style
        , j.unit_msrp
        , j.unit_cost
        , j.unit_qty
    from 
        compare_rows c,
        json_table(c.jdoc, '$' columns(
            name path '$.NAME.string()'
            , description path '$.DESCRIPTION.string()'
            , style path '$.STYLE.string()'
            , unit_msrp path '$.UNIT_MSRP.string()'
            , unit_cost path '$.UNIT_COST.string()'
            , unit_qty path '$.UNIT_QTY.string()'
            )
        ) j
), unpivot_columns as (
select
    row_source
    , id
    , code
    , key
    , value
from
    parse_jdoc 
    unpivot include nulls(value for key in (
        name, description, style, unit_msrp, unit_cost, unit_qty
        )
    )
)
select
    coalesce(s.row_source, t.row_source) as row_source
    , coalesce(s.id, t.id) as id
    , coalesce(s.code, t.code) as code
    , coalesce(s.key, t.key) as key
    , coalesce(s.value, t.value) as value
from
    (select * from unpivot_columns where row_source = 'source') s
    full outer join
    (select * from unpivot_columns where row_source = 'target') t
    on
        s.id = t.id
        and s.key = t.key
        --and s.value = t.value
        and decode(s.value, t.value, 1, 0) = 1
where s.id is null or t.id is null
order by id, key, row_source
/

--select t.*
--from
--(
--select json{*} as jdoc
--from products_source
--) j,
--table(dynamic_json.unpivot_json_array(j.jdoc,'PRODUCT_ID')) t
--/

with source_json as (
    select 
        'source' as row_source
        , product_id as id
        , json_object(* returning json) as jdoc 
    from products_source
), target_json as (
    select 
        'target' as row_source
        , product_id as id
        , json_object(* returning json) as jdoc 
    from products_target
), compare_rows as (
    select 
        coalesce(s.id, t.id) as id,
        coalesce(s.row_source, t.row_source) as row_source, 
        coalesce(s.jdoc, t.jdoc) as jdoc
    from   
        source_json s
        full outer join target_json t
            on s.id = t.id
            and json_equal(s.jdoc, t.jdoc)
    where s.id is null or t.id is null
), columns_base as (
    select 
        c.row_source
        , u.row#id
        , u.column#key
        , json_object(u.*) as jdoc
    from 
        compare_rows c,
        table(dynamic_json.unpivot_json_array(c.jdoc,'PRODUCT_ID')) u
), source_columns as (
    select b.* from columns_base b where b.row_source = 'source'
), target_columns as (
    select b.* from columns_base b where b.row_source = 'target'
)
select 
    coalesce(s.row#id, t.row#id) as id,
    coalesce(s.column#key, t.column#key) as key,
    coalesce(s.row_source, t.row_source) as row_source,
    json_value(coalesce(s.jdoc, t.jdoc), '$.COLUMN#VALUE.string()') as value
from 
    source_columns s
    full outer join target_columns t
        on s.row#id = t.row#id
        and s.column#key = t.column#key
        and json_equal(s.jdoc, t.jdoc)
where
    s.row#id is null or t.row#id is null
order by id, key, row_source
/