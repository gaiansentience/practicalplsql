column row_source format a10
column code format a10
column key_column format a20
column key_value format a50
set null (null)
set long 200
set pagesize 50

--ideally, we want to use json_table and unpivot on the results of the comparison macro to get the row differences
--then we could use the comparison macro again to compare the column differences
with compare_rows_relational as (
    select 
        b.row_source, b.code, j.name, j.description, j.style, j.msrp
    from 
        row_compare_json_alt(products_source, products_target, columns(code)) b,
        json_table(b.jdoc, '$' 
            columns (
                name varchar2(4000) path '$.NAME',
                description varchar2(4000) path '$.DESCRIPTION',
                style varchar2(4000) path '$.STYLE',
                msrp varchar2(4000) path '$.MSRP'
            )
        ) j
), compare_cols_base as (
    select row_source, code, key_column, key_value
    from 
        compare_rows_relational
        unpivot include nulls (
            key_value for key_column in (name, description, style, msrp)    
        )
), compare_cols_source as (
    select code, key_column, key_value
    from compare_cols_base where row_source = 'source'
), compare_cols_target as (
    select code, key_column, key_value
    from compare_cols_base where row_source = 'target'
)
select
    b.row_source, b.code, j.key_column, j.key_value
from 
    (
    select row_source, code, jdoc
    from row_compare_json_alt(compare_cols_source, compare_cols_target, columns(code))
    ) b,
    json_table(b.jdoc, '$'
        columns(
                key_column varchar2(4000) path '$.KEY_COLUMN',
                key_value varchar2(4000) path '$.KEY_VALUE'
        )
    ) j
order by b.code, j.key_column, b.row_source
/    
--ORA-64630: unsupported use of SQL macro: use of SQL macro inside WITH clause is not supported

