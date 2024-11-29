select * from products_target
/


select * from products_source
/

with unpivot_target as (
    select 
        'target' as row_source
        , product_id
        , code
        , column_name
        , column_value
    from
        (
        select product_id, code, name, description, style, to_char(msrp) as msrp
        from products_target
        )
        unpivot include nulls (
            column_value for column_name in (name, description, style, msrp)
        )
), unpivot_source as (
    select 
        'source' as row_source
        , product_id
        , code
        , column_name
        , column_value
    from
        (
        select product_id, code, name, description, style, to_char(msrp) as msrp
        from products_source
        )
        unpivot include nulls (
            column_value for column_name in (name, description, style, msrp)
        )
)
select
    case when s.row_source is not null then 'source' else 'target' end as row_source
    , coalesce(s.product_id, t.product_id) as product_id
    , coalesce(s.code, t.code) as code
    , coalesce(s.column_name, t.column_name) as column_name
    , coalesce(s.column_value, t.column_value) as column_value
from
    unpivot_source s
    full outer join unpivot_target t
        on s.product_id = t.product_id
        and s.code = t.code
        and s.column_name = t.column_name
        and decode(s.column_value, t.column_value, 1, 0) = 1
where s.product_id is null or t.product_id is null
order by product_id, code, column_name, row_source 
/