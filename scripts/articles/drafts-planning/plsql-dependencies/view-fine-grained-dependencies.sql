select * from dba_dependencies where owner = user and referenced_owner = user;

purge recyclebin;

select * from sys.dependency$;  --includes recyclebin objects

select * from dba_objects where owner = user;

--grant select on sys.dependency$ to public;
--grant select on sys.dba_dependencies to public;

select ccc.owner, ccc.object_id,ccc.name, ccc.type, ccc.referenced_owner, ccc.referenced_name, ccc.referenced_type, c.column_name as referenced_column, ccc.d_attrs_cols, ccc.byte#, ccc.col_id
from (
select b.*, x.byte#, bx.*, (x.byte# - 1) * 8 + bx.bit# as col_id
, to_number(substr(b.d_attrs_cols, (x.byte# - 1) * 2 + 1, 2),'XX') as attr_decimal
, bitand(to_number(substr(b.d_attrs_cols, (x.byte# - 1) * 2 + 1, 2),'XX'),bx.bit#value) as col_referenced
from 
(
select d.owner, d.object_id, d.object_name as name,  d.object_type as type, r.owner as referenced_owner, r.object_name as referenced_name, r.object_type as referenced_type
    , substr(dd.d_attrs, 9) as d_attrs_cols
    ,((length(dd.d_attrs) - 8)/2 ) as bytes
from sys.dependency$ dd
join dba_objects d on dd.d_obj# = d.object_id
join dba_objects r on dd.p_obj# = r.object_id
where d.owner = user and r.owner = user --and d.object_name in ('P_FGD_0001','P_FGD_0002')
) b
outer apply (
select level as byte# from dual connect by level <= b.bytes
) x
cross apply (select level - 1 as bit#, power(2, level - 1) as bit#value from dual connect by level <= 8) bx
) ccc
left join dba_tab_cols c on ccc.referenced_owner = c.owner and ccc.referenced_name = c.table_name and ccc.col_id = c.column_id
where ccc.col_referenced <> 0
order by name, referenced_name, byte#, col_id
/

with dependency_columns as (
select
    d.owner, d.object_id, d.object_name as name, d.object_type as type
    , r.owner as referenced_owner, r.object_id as referenced_object_id, r.object_name as referenced_name, r.object_type as referenced_type
    , c.column_id, c.column_name
from 
    (
        select base.d_obj#, base.p_obj#, base.c_id#
        from
        (
            select d$.d_obj#, d$.p_obj#, (by$.byte# - 1) * 8 + b$.bit# as c_id#
                , bitand(to_number(substr(d$.d_attrs, 8 + (by$.byte# - 1) * 2 + 1, 2), 'XX'), b$.bit#value) col_has_ref
            from sys.dependency$ d$
            outer apply (select level as byte# from dual connect by level <= (length(d$.d_attrs) - 8)/2) by$
            cross apply (select level- 1 as bit#, power(2, level - 1) as bit#value from dual connect by level <= 8) b$
        ) base
        where base.col_has_ref <> 0
    ) dc
    join dba_objects d on dc.d_obj# = d.object_id
    join dba_objects r on dc.p_obj# = r.object_id
    left outer join dba_tab_cols c on r.owner = c.owner and r.object_name = c.table_name and dc.c_id# = c.column_id
where d.owner <> 'SYS' and r.owner <> 'SYS' and d.owner = user --and d.object_name = 'P_FGD_0001'
order by r.owner, r.object_name, c.column_id
), dependency_hierarchy as (
select owner, name, type, referenced_owner, referenced_name, referenced_type
from dba_dependencies
where owner <> 'SYS' and referenced_owner <> 'SYS' and owner = user --and name = 'P_FGD_0001'
)
select * from 
dependency_columns 
--dependency_hierarchy
;


create or replace package pkg_fgd as

    procedure p_fgd_0002(p in number); --TEST_FGD.c_0002%type);
    
    procedure p_fgd_0001(p in number);
    
    procedure p_get_0001(p in number, p_cur out sys_refcursor);

end pkg_fgd;
/
create or replace package body pkg_fgd as

    procedure p_fgd_0002(p in number) --TEST_FGD.c_0002%type)
    is 
    begin
        update test_fgd set c_0002 = p;
    end p_fgd_0002;
        
    procedure p_fgd_0001(p in number)
    is 
    begin
    
        update test_fgd set 
            c_0001 = p
            , c_0003 = p
            , c_0011 = p
            , c_0016 = p
            ;
    
        p_fgd_0002(777);
    
    end p_fgd_0001;

    procedure p_get_0001(p in number, p_cur out sys_refcursor)
    is
    begin
        open p_cur for
        select c_0001, c_0002 as aliasd_c_0002, c_0003
        from test_fgd 
        where c_0001 = p;
    end p_get_0001;
    
end pkg_fgd;
/




select * from dba_tab_cols;

set serveroutput on;

declare
    c# number := 16;
    lf constant string(1) := chr(10);
    s string(4000);
begin
    execute immediate 'drop table if exists test_fgd purge';
    
    s := 'create table test_fgd (' || lf;
    for i  in 1..c# loop
        s := s || case when i > 1 then ', ' end
            || 'c_' || to_char(i,'fm0999') || ' number' || lf;
    end loop;
    s := s || ')';
    dbms_output.put_line(s);
    execute immediate s;
    
    for i  in 1..c# loop
        s := replace('
        create or replace procedure p_fgd_##i##(p in number)
        is 
        begin
            update test_fgd set c_##i## = p;
        end p_fgd_##i##;
                ', '##i##', to_char(i,'fm0999') );
        dbms_output.put_line(s);
--        execute immediate s;
    end loop;
    
end;
/

begin
    for i in 1..10 loop
        dbms_output.put_line(to_char(i,'09') );
    end loop;
end;
/