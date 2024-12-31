--table-macro-05-calendar-generator.sql

alter session set nls_date_format='fmMonth dd, yyyy';
column calendar_date format a20

with

    function calendar_generator(
        p_start_year in number default null
        , p_years in number default 1
    ) return varchar2 
    sql_macro(table)
    is
    begin
        return q'[
            select 
                a.start_date + b.n as calendar_date
            from
                (
                select 
                    s.start_date
                    , s.start_date 
                        + numtoyminterval(p_years, 'year') 
                        - interval '1' day 
                    as end_date
                from
                    (
                    select 
                        trunc(
                            to_date(
                                nvl(p_start_year, extract(year from sysdate))
                                , 'yyyy')
                            , 'yyyy') 
                        as start_date
                    from dual
                    ) s
                ) a
                cross apply
                (
                select level - 1 as n 
                from dual 
                connect by level <= (a.end_date - a.start_date + 1)
                ) b
            order by calendar_date
        ]';
        
    end calendar_generator;

select *
from calendar_generator(2025)
/

/*
CALENDAR_DATE       
--------------------
January 1, 2025
January 2, 2025
January 3, 2025
January 4, 2025
...(rows elided)...
December 29, 2025
December 30, 2025
December 31, 2025

365 rows selected. 
*/