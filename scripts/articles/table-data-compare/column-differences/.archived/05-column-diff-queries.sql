set serveroutput on;

--find row differences
with source as (
    select 1 as id, 'AAA' as code, 'Cellphone' as name, 'Black' as color, 'XTech' as brand from dual union all
    select 2, 'BBB', 'Charger', 'Black' , null from dual union all
    select 3, 'CCC', 'Case', 'Pink', null from dual
), target as (
    select 1 as id, 'AAA' as code, 'Cellphone' as name, 'Black' as color, 'XTech' as brand from dual union all
    select 2, 'BBB', 'USB Charger', 'Black' , 'WallTek' from dual union all
    select 3, 'CCC', 'Case', 'Blue', null from dual
), row_differences as (
select
    coalesce(src.row_origin, tgt.row_origin) as row_origin
    , coalesce(src.id, tgt.id) as id
    , coalesce(src.jdoc, tgt.jdoc) as jdoc
from 
    (select 'source' as row_origin, s.id, json_object(s.*) as jdoc from source s) src
    full outer join
    (select 'target' as row_origin, t.id, json_object(t.*) as jdoc from target t) tgt
    on src.id = tgt.id and json_equal(src.jdoc, tgt.jdoc)
where src.id is null or tgt.id is null
)
select b.row_origin, b.id, j.code, j.name, j.color, j.brand 
from 
    row_differences b
    cross apply json_table(b.jdoc, '$' 
        columns(code path '$.CODE.string()', name path '$.NAME.string()', color path '$.COLOR.string()', brand path '$.BRAND.string()')) j
order by b.id, b.row_origin
/

--find column differences
with source as (
    select 1 as id, 'AAA' as code, 'Cellphone' as name, 'Black' as color, 'XTech' as brand from dual union all
    select 2, 'BBB', 'Charger', 'Black' , null from dual union all
    select 3, 'CCC', 'Case', 'Pink', null from dual
), target as (
    select 1 as id, 'AAA' as code, 'Cellphone' as name, 'Black' as color, 'XTech' as brand from dual union all
    select 2, 'BBB', 'USB Charger', 'Black' , 'WallTek' from dual union all
    select 3, 'CCC', 'Case', 'Blue', null from dual
), unpivot_source as (
    select id, col#name, col#value
    from
    source 
    unpivot include nulls (col#value for col#name in (code, name, color, brand))
), unpivot_target as (
    select id, col#name, col#value
    from
    target 
    unpivot include nulls (col#value for col#name in (code, name, color, brand))
), column_differences as (
select
    coalesce(src.row_origin, tgt.row_origin) as row_origin
    , coalesce(src.id, tgt.id) as id
    , coalesce(src.jdoc, tgt.jdoc) as jdoc
from 
    (select 'source' as row_origin, s.id, json_object(s.*) as jdoc from unpivot_source s) src
    full outer join
    (select 'target' as row_origin, t.id, json_object(t.*) as jdoc from unpivot_target t) tgt
    on src.id = tgt.id and json_equal(src.jdoc, tgt.jdoc)
where src.id is null or tgt.id is null
)
select b.row_origin, b.id, j.col#name, j.col#value 
from 
    column_differences b
    cross apply json_table (b.jdoc, '$' columns (col#name path '$.COL#NAME.string()', col#value path '$.COL#VALUE.string()')) j
order by id, col#name, row_origin
/


with 
function dynamic_unpivot(data in dbms_tf.table_t, id_cols in dbms_tf.columns_t) return varchar2 sql_macro(table)
is
    l_cols varchar2(4000);
    l_cname varchar2(128);
    l_unpivot_cols varchar2(4000);
    l_sql varchar2(4000);
begin
    for i in 1..id_cols.count loop
        l_cols := l_cols || ','||id_cols(i);
    end loop;
    l_cols := trim(leading ',' from l_cols);
    for i in 1..data.column.count loop
        l_cname := data.column(i).description.name;
        if l_cname not member of id_cols then
            l_unpivot_cols := l_unpivot_cols || ',' || l_cname;
        end if;
    end loop;
    l_unpivot_cols := trim(leading ',' from l_unpivot_cols);
    l_sql := q'[
    select ##ID_COLS##, col#name, col#value
    from 
        data 
        unpivot include nulls(col#value for col#name in (##UNPIVOT_COLS##))
    ]';
    l_sql := replace(l_sql, '##ID_COLS##', l_cols);
    l_sql := replace(l_sql, '##UNPIVOT_COLS##', l_unpivot_cols);
    dbms_output.put_line(l_sql);
    return l_sql;
end dynamic_unpivot;

target as (
    select 1 as id, 'AAA' as code, 'Cellphone' as name, 'Black' as color, 'XTech' as brand from dual union all
    select 2, 'BBB', 'USB Charger', 'Black' , 'WallTek' from dual union all
    select 3, 'CCC', 'Case', 'Blue', null from dual
)
select u.*
from
    dynamic_unpivot(target, columns(id,code)) u 
/


