select banner_full from v$version
/


--"Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.25.0.1.0"

--synatx for table macros originally ported in 19.7


with function exp_generator_macro(base_in in number, max_exp_in in number) return varchar2 sql_macro(table)
is
begin
    return '
        select base_in as base, level as exponent, power(base_in, level) as n
        from dual connect by level <= max_exp_in
        ';
end exp_generator_macro;
select *
from exp_generator_macro(5, 10)
/


--21c syntax for table macros works now in 19.25
with 
    function row_generator_macro(p_rows in number
    )return varchar2 sql_macro(table)
    is
    begin
    
        return '
            select n
            from
                (
                select level as n 
                from dual 
                connect by level <= p_rows
                )
            where n <= p_rows
            ';    
            
    end row_generator_macro;
select n from row_generator_macro(6)
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
            from dual 
            connect by level <= p_rows
            )
            where n <= p_rows
            ';
            
    end row_generator_macro;

    select a.n, mod(a.n,4) as mod_4_n, b.m
    from
        (
        select n from row_generator_macro(10) 
        ) a
        left outer join lateral
        (
        select n as m from row_generator_macro(mod(a.n,4))
        ) b on 1 = 1
/

select level from dual connect by level <= 0
/


with 
function display_interval(i in interval day to second) return varchar2 sql_macro(scalar)
is
begin
    return q'[
    trim(
        case when extract(day from i) > 0 then extract(day from i) || case when extract(day from i) = 1 then ' day ' else ' days ' end end 
        || case when extract(hour from i) > 0 then extract(hour from i) || case when extract(hour from i) = 1 then ' hour ' else ' hours ' end end
        || case when extract(minute from i) > 0 then extract(minute from i) || case when extract(minute from i) = 1 then ' minute ' else ' minutes ' end end
        || case when extract(second from i) > 0 then extract(second from i) || case when extract(second from i) = 1 then ' second' else ' seconds' end end
        )
        ]';
end display_interval;

select i, display_interval(i) as fmt_i
from 
(
select numtodsinterval(mod(level,3), 'day') + numtodsinterval(mod(level,3), 'hour') + numtodsinterval(level/5, 'minute') + numtodsinterval(level/5, 'second') as i
from dual
connect by level <= 10
)
/

select numtodsinterval(mod(level,3), 'day') + numtodsinterval(mod(level,3), 'hour') + numtodsinterval(level/5, 'minute') + numtodsinterval(level/5, 'second') as i
from dual
connect by level <= 10
/



with
function random_value(p_from in number default 0, p_to in number default 1, p_scale in number default 4)
return varchar2 sql_macro(scalar)
is
begin
    return 'round(dbms_random.value(p_from, p_to), p_scale)';
end random_value;

function row_generator_random(p_rows in number, p_range_from in number default 0, p_range_to in number default 1, p_scale in number default 4
) return varchar2 sql_macro(table)
is
begin
    return '
    select level as id, random_value(p_range_from, p_range_to, p_scale) as n --round(dbms_random.value(p_range_from,p_range_to), p_scale) as n
    from dual connect by level <= p_rows
    ';
end row_generator_random;

products (id, code) as (
    select level as id, lpad(chr(level + 64),4,chr(level+64)) as code
    from dual connect by level <= 26
)

select a.id as order_id, a.n as dtl_count, b.dtl_id, b.qty, random_value(1,26,0) as product_id
from row_generator_random(5, 1, 10, 0) a
outer apply
(select id as dtl_id, n as qty
from row_generator_random(a.n, 1, 20, 0) 
) b
/


with 
function invoice_date_format_macro(p_date in date) return varchar2 sql_macro(scalar)
is
begin
    return q'[
        to_char(p_date, 'yyyy.mm.dd')
        ]';
end invoice_date_format_macro;

function annual_calendar_macro(
    p_years in number default 1
    , p_start_year in number default null
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
                start_date
                , start_date + numtoyminterval(p_years, 'year') - interval '1' day as end_date
            from
                (
                select 
                    trunc(to_date(nvl(p_start_year, extract(year from sysdate)), 'yyyy'), 'yyyy') as start_date
                from dual
                )
            ) a
            cross apply
            (
            select level - 1 as n 
            from dual 
            connect by level <= a.end_date - a.start_date + 1
            ) b
    ]';
    
end annual_calendar_macro;

select calendar_date, invoice_date_format_macro(calendar_date) as invoice_date
from annual_calendar_macro(2)
/

with 
function days_until(holiday_mm_dd in varchar2) return varchar2 sql_macro(scalar)
is
begin
    return q'[
    case sign(trunc(sysdate) - to_date(holiday_mm_dd, 'mm-dd')) 
        when 1 then add_months(to_date(holiday_mm_dd,'mm-dd'), 12) 
        else to_date(holiday_mm_dd,'mm-dd') 
    end - trunc(sysdate)
    ]';
end days_until;

select days_until('10-31') as til_halloween, days_until('12-25') as til_christmas, days_until('12-25') + trunc(sysdate) as xmas --case sign(trunc(sysdate) - to_date('10-31', 'mm-dd')) when 1 then add_months(to_date('10-31','mm-dd'),12) else to_date('10-31','mm-dd') end - trunc(sysdate) as til_halloween, to_date('12-25','mm-dd') as til_xmas
from dual
/

with
function simple_math_macro(x in number, y in number, operation_constant in number default 1) return varchar2 sql_macro(scalar)
is
begin
    return
        case operation_constant
        when 1 then 'x + y'
        when 2 then 'x - y'
        when 3 then 'x * y'
        when 4 then 'x/y'
        when 5 then 'power(x,y)'
        else 'null'
        end;
end simple_math_macro;
select simple_math_macro(1,2,3) as z
/

with
function split_string_macro(p_delimited_string in varchar2) return varchar2 sql_macro(table)
is
begin 
    return q'[
        select regexp_substring(
        ]';
end split_string_macro;

select * from split_string_macro('xxx,yy,zzz')
/

with base as (select 1 as id, 'xxx,yy,zzz' as delim from dual union all select 2, 'aaa,bbb,c,d' from dual)
select b.id, regexp_substr(b.delim, '[^,]+', 1, p.position) as val
from base b
cross apply (select level as position from dual connect by level <= length(regexp_replace(b.delim,'[^,]'))+1) p
/


with 
function round5(n in number, scale in number default 0) return number
is
begin
    return round(n/5,scale)*5;
end round5;

function round5_macro(n in number, scale in number default 0) return varchar2 sql_macro(scalar)
is
begin
    return 'round(n/5,scale)*5';
end round5_macro;

function round_multiples(n in number, m in number, scale in number default 0) return number
is
begin
    return round(n/m,scale)*m;
end round_multiples;

function round_multiples_macro(n in number, m in number, scale in number default 0) return varchar2 sql_macro(scalar)
is
begin
    return 'round(n/m, scale) * m';
end round_multiples_macro;

base(n) as (
select level/10 as n
from dual
connect by level <= 20
)
select n, round(n/5,1)*5 as n_round5, round5(n, 1) as f_round5, round5_macro(n, 1) as m_round5, round_multiples_macro(n, 5, 1) round_m
from base
/

with base(n) as (
select level as n
from dual
connect by level <= 200
)
select n, floor(n/30)* 30 as aging_category
from base
/

with 
function round_seconds(p_date in date, p_multiple in number default 1) return varchar2 sql_macro(scalar)
is
begin
    return q'[trunc(p_date, 'mi') + numtodsinterval(round((p_date - trunc(p_date, 'mi'))*24*60*60/p_multiple)*p_multiple,'second')]';
end round_seconds;

function round_minutes(p_date in date, p_multiple in number default 1) return varchar2 sql_macro(scalar)
is
begin
    return q'[trunc(p_date, 'hh') + numtodsinterval(round((p_date - trunc(p_date, 'hh'))*24*60/p_multiple)*p_multiple,'minute')]';
end round_minutes;
select sysdate
, round(sysdate,'mi') as r1
--, sysdate - trunc(sysdate, 'mi') as s
--, trunc(sysdate, 'mi') + numtodsinterval(round((sysdate - trunc(sysdate, 'mi'))*24*60*60/5)*5,'second') as ms
, round_minutes(sysdate, 5) as r_5
, round_seconds(sysdate, 15) as r6
--extract(second from cast(sysdate as timestamp)) as r2
from dual
/