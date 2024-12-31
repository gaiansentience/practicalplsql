select 
    r.*
   -- , value(r) as v_r  --ORA-00902: invalid datatype
    --, r.object_value as ov_r   --ORA-00902: invalid datatype
from package_types.get_rows_nt(7) r
/

select
*
from package_types.chain_rows_rec_id(cursor(select * from package_types.get_rows_nt(5)))
/

select 
    r.*
    , value(r) as v_r
    , r.object_value as ov_r
from package_types.get_rows_pudt(9) r
/

select 
    r.*
    , value(r) as v_r
    , r.object_value as ov_r
from package_types.get_rows_udt(5) r
/


select t.id as base_id, u.id, v.id
from package_types.get_rows_nt(7) t
cross apply (select id from package_types.get_rows_udt(t.id)) u
cross apply (select id from package_types.get_rows_udt(u.id)) v
/


with function get_rows(p_rows in number) return varchar2 sql_macro(table)
is
begin
    return q'[
    select level as n
    --from dual
    connect by level <= p_rows
    ]';
end get_rows;

    select a.n, mod(a.n,4) as mod_4_n, b.m, c.o
    from
        (select i.n from get_rows(10) i ) a
        -- left outer join lateral(select n as m from row_generator_macro(mod(a.n,4)) ) b on 1 = 1
        cross apply (select ii.n as m from get_rows(a.n) ii ) b
        cross apply (select iii.n as o from get_rows(b.m) iii ) c
/

with 
    function row_generator_macro(
        p_rows in number
    )return varchar2 
    sql_macro(table)
    is
    begin
        
        return 
            '
            select n
            from
            (
            select level as n 
            --from dual 
            connect by level <= p_rows
            )
            where n <= p_rows
            ';
            
    end row_generator_macro;

    select a.n, mod(a.n,4) as mod_4_n, b.m
    from
        (select n from row_generator_macro(10) ) a
        -- left outer join lateral(select n as m from row_generator_macro(mod(a.n,4)) ) b on 1 = 1
        cross apply (select n as m from row_generator_macro(a.n) ) b
/