select banner_full from v$version
/


--"Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.25.0.1.0"

--synatx for table macros originally ported in 19.7

with
    function row_generator_macro(p_rows in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return '
            select level as n 
            from dual 
            connect by level <= p_rows
            ';    
            
    end row_generator_macro;
    
    function clone_rows_macro(
        p_table in dbms_tf.table_t
        , p_copies in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return '
            select x.clone_copy_id, t.*
            from p_table t
            cross join (
                select n as clone_copy_id
                from row_generator_macro(p_copies)
            ) x
        ';
    end clone_rows_macro;

select * from clone_rows_macro(products,3)
/

--21c syntax for table macros works now in 19.25
--simple row generator
with 
    function row_generator_macro(p_rows in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return '
            select level as n 
            from dual 
            connect by level <= p_rows
            ';    
            
    end row_generator_macro;
    
select n 
from row_generator_macro(6)
/



with 
    function row_generator_macro(p_rows in number
    )return varchar2 sql_macro(table)
    is
    begin
        return '
            select level as n 
            from dual 
            connect by level <= p_rows
            ';    
            
    end row_generator_macro;

    function exponent_generator_macro(
        p_base in number
        , p_max_exponent in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return q'~
            select 
                p_base as base
                , n - 1 as exponent
                , power(p_base, n - 1) as result
                , p_base || '^' || (n - 1) || ' = ' || power(p_base, n - 1) as equation
            from row_generator_macro(p_max_exponent + 1) 
            ~';
    end exponent_generator_macro;

select *
from exponent_generator_macro(2, 8)
/

with 
    function exponent_generator_macro(
        p_base in number
        , p_max_exponent in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return q'~
            select 
                p_base as base
                , level as exponent
                , power(p_base, level) as result
                , p_base || '^' || level || ' = ' || power(p_base, level) as equation
            from dual 
            connect by level <= p_max_exponent
            ~';
    end exponent_generator_macro;

select *
from exponent_generator_macro(2, 8)
/



with 
    function row_generator_macro(
        p_rows in number
    )return varchar2 
    sql_macro(table)
    is
    begin
        
        return '
            select level as n 
            from dual 
            connect by level <= p_rows
            ';
            
    end row_generator_macro;

    select 
        a.n
        , round(exp(sum(ln(b.m)))) as factorial_result
        , a.n || '! = ' || listagg(b.m, ' x ') within group (order by b.m desc) 
            || ' = ' || round(exp(sum(ln(b.m)))) as factorial_equation
    from
        (
        select n from row_generator_macro(5) 
        ) a
        cross apply
        (
        select n as m from row_generator_macro(a.n)
        ) b
    group by a.n
/


with     
    function factorial_generator_macro(p_max_factorial in integer)
    return varchar2 sql_macro(table)
    is
    begin
        return q'~
            select 
                a.n
                , round(exp(sum(ln(b.m)))) as factorial_result
                , a.n || '! = ' || listagg(b.m, ' x ') within group (order by b.m desc) 
                    || ' = ' || round(exp(sum(ln(b.m)))) as factorial_equation
            from
                (
                select level as n 
                from dual 
                connect by level <= p_max_factorial
                ) a
                cross apply
                (
                select level as m 
                from dual 
                connect by level <= a.n
                ) b
            group by a.n
        ~';
    
    end factorial_generator_macro;
    
select * 
from factorial_generator_macro(5)
/

with     
    function row_generator_macro(
        p_rows in number
    )return varchar2 
    sql_macro(table)
    is
    begin
        
        return '
            select level as n 
            from dual 
            connect by level <= p_rows
            ';
            
    end row_generator_macro;

    function factorial_generator_macro(p_max_factorial in integer)
    return varchar2 sql_macro(table)
    is
    begin
        return q'~
            select 
                a.n
                , round(exp(sum(ln(b.m)))) as factorial_result
                , a.n || '! = ' || listagg(b.m, ' x ') within group (order by b.m desc) 
                    || ' = ' || round(exp(sum(ln(b.m)))) as factorial_equation
            from
                (
                select n 
                from row_generator_macro(p_max_factorial)
                ) a
                cross apply
                (
                select n as m 
                from row_generator_macro(a.n)
                ) b
            group by a.n
        ~';
    
    end factorial_generator_macro;
    
select * 
from factorial_generator_macro(5)
/


with 
function display_interval(i in dsinterval_unconstrained)
--i in interval day to second) 
return varchar2 sql_macro(scalar)
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

base (interval_value) as (
    select numtodsinterval(dbms_random.value(0, 1) * 100000, 'second')
    from dual
    connect by level <= 10
)
select interval_value, display_interval(interval_value) as fmt_interval, display_interval(interval_value/2) as fmt_half_interval
from base
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

select a.id as order_id, a.n as dtl_count, b.dtl_id, b.qty, b.product_id, p.code--random_value(1,26,0) as product_id
from row_generator_random(5, 1, 10, 0) a
outer apply
(select id as dtl_id, n as qty, random_value(1,26,0) as product_id
from row_generator_random(a.n, 1, 20, 0) 
) b
left join products p on b.product_id = p.id
order by order_id, dtl_id
/


with
    function histogram_macro(p_table in dbms_tf.table_t, p_columns in dbms_tf.columns_t)
    return varchar2 sql_macro(table)
    is
        type t_sql is table of varchar2(4000) index by pls_integer;
        l_all_sql varchar2(4000);
        l_sql t_sql;
    begin
        for i in 1..p_columns.count loop        
            l_sql(i) := q'~
                select 
                    count(*) as table_rows
                    , '##COLUMN##' as column_name
                    , count(distinct ##COLUMN##) as distinct_value_count
                    , count(case when ##COLUMN## is null then 'y' end) as null_value_count
                    , min(length(##COLUMN##)) as min_value_length
                    , max(length(##COLUMN##)) as max_value_length
                    , min(##COLUMN##) as min_value
                    , max(##COLUMN##) as max_value
                from p_table
            ~';
            l_sql(i) := replace(l_sql(i), '##COLUMN##', p_columns(i));
            l_all_sql := l_all_sql || case when i > 1 then ' union all ' end || l_sql(i);
        end loop;
        
        return l_all_sql;
    end histogram_macro;
    
select * from histogram_macro(products, columns(description, code, name, style))
/

select to_date('2022','yyyy')
/

with 
function annual_calendar_macro(
    p_years in number default 1
    , p_start_year in number default null
) return varchar2 
sql_macro(table)
is
begin
    return q'[
        select 
            a.start_date + b.n as calendar_date, extract(year from (a.start_date + b.n)) as year, extract(month from (a.start_date + b.n)) as month, extract(day from (a.start_date + b.n)) as day
            , to_char(a.start_date + b.n, 'fmDay') as day_of_week
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
            connect by level <= (a.end_date - a.start_date + 1)
            ) b
        order by calendar_date
    ]';
    
end annual_calendar_macro;

select c.*, c.calendar_date + interval '1' day - interval '1' second as day_ends
from annual_calendar_macro(5) c
/

with 
    function days_until(holiday_mm_dd in varchar2
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
        case sign(trunc(sysdate) - to_date(holiday_mm_dd, 'mm-dd')) 
            when 1 then add_months(to_date(holiday_mm_dd,'mm-dd'), 12) 
            else to_date(holiday_mm_dd,'mm-dd') 
        end - trunc(sysdate)
        ]';
    end days_until;

special_days(mm_dd, reason) as (
select '12-31', 'new year''s eve' from dual union all
select '10-31', 'halloween' from dual union all
select '12-25', 'christmas' from dual union all
select '02-14', 'valentine''s' from dual union all
select '12-21', 'winter solstice (approx)' from dual union all
select '6-21', 'summer solstice (approx)' from dual
)

select 
    days_until(mm_dd) as days_to_wait
    , reason
    , days_until(mm_dd) + trunc(sysdate) as wait_is_over
from special_days
order by days_to_wait
/

with
    function row_generator_macro(p_rows in number
    )return varchar2 sql_macro(table)
    is
    begin
        return '
            select level as n 
            from dual 
            connect by level <= p_rows
            ';    
            
    end row_generator_macro;
    
function simple_math_macro(
    x in number
    , y in number
    , operation_constant in number default 1
) return varchar2 sql_macro(scalar)
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

select b_x.x, b_y.y
    , simple_math_macro(b_x.x, b_y.y, 1) as x_add_y
    , simple_math_macro(b_x.x, b_y.y, 2) as x_subtract_y
    , simple_math_macro(b_x.x, b_y.y, 3) as x_multiply_y
    , simple_math_macro(b_x.x, b_y.y, 4) as x_divide_y
    , simple_math_macro(b_x.x, b_y.y, 5) as x_to_y_power
from 
(select n as x from row_generator_macro(10) ) b_x
cross join
(select n as y from row_generator_macro(10) ) b_y
where b_x.x in (2,3) and b_y.y in (2, 3, 4)
/

with
function split_string_macro(p_delimited_string in varchar2) return varchar2 sql_macro(table)
is
begin 
    return q'!
        select regexp_substr(p_delimited_string, '[^,]+', 1, p.position) as str
        from (select level as position from dual connect by level <= length(regexp_replace(p_delimited_string,'[^,]')) + 1) p
        !';
end split_string_macro;
base (id, listing) as (
    select 1, 'xxx,yy,zzz' from dual union all 
    select 2, 'aaa,bbb,c,d' from dual
)
select b.id, s.str
from 
base b
cross apply (select * from split_string_macro(b.listing)) s
/



with 
    function row_generator_macro(p_rows in number
    ) return varchar2 sql_macro(table)
    is
    begin
        return '
            select level as n 
            from dual 
            connect by level <= p_rows
            ';    
            
    end row_generator_macro;
    
    function round_increments_macro(
        n in number
        , i in number
        , scale in number default 0
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return 'round(n/i, scale) * i';
    end round_increments_macro;

select r.n, round_increments_macro(r.n, 5, 1) round_n_to_half, r.m, round_increments_macro(r.m, 5) as round_m_to_5
from 
    (
    select n/10 as n, n as m
    from row_generator_macro(20)
    ) r
/

with
    function balance_aging_macro(p_days in number) return varchar2 sql_macro(scalar)
    is
    begin
        return q'~
            case 
            when p_days <= 10 then 'net 10 discount'
            when p_days between 11 and 30 then 'current'
            when p_days between 31 and 90 then '31 to 90'
            when p_days between 91 and 179 then '91 to 180'
            else 'over 180'
            end || ' (' || p_days || ' days)'
        ~';
    end balance_aging_macro;
    
base(invoice_date) as (
    select sysdate - level
    from dual
    connect by level <= 200
)
select sysdate, invoice_date, balance_aging_macro(sysdate - invoice_date) as aging_category 
from base
/

with 
    function round_up_seconds(
        p_date in date
        , p_increment in number
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            trunc(p_date, 'mi') 
            + numtodsinterval(
                ceil(
                    (p_date - trunc(p_date, 'mi') ) * 24 * 60 * 60/p_increment
                    ) * p_increment
                , 'second')
        ]';
    end round_up_seconds;
base as (
    select sysdate + numtodsinterval(level - 1, 'second') as dt
    from dual
    connect by level <= 61
)
select 
    dt
    , round_up_seconds(dt, 5) as round_5_seconds
    , round_up_seconds(dt, 10) as round_10_seconds
    , round_up_seconds(dt, 15) as round_15_seconds
    , round_up_seconds(dt, 30) as round_30_seconds
from base
/

with 

    function round_minutes(
        p_date in date
        , p_increment in number
    ) return varchar2 sql_macro(scalar)
    is
    begin
        return q'[
            trunc(p_date, 'hh') 
            + numtodsinterval(
                round(
                    (p_date - trunc(p_date, 'hh') ) * 24 * 60/p_increment
                    ) * p_increment
                , 'minute')
        ]';
    end round_minutes;

base(dt) as (
select sysdate + numtodsinterval(level - 1, 'minute')
from dual connect by level <= 61
)
select 
    dt
    , round_minutes(dt, 5) as round_5_minutes
    , round_minutes(dt, 15) as round_15_minutes
    , round_minutes(dt, 30) as round_30_minutes
from base
/


--normalize vector
with base(vec) as (
select to_vector('[2,3,4,5]',4,int8)
)
select b.vec, vector_norm(b.vec) as vec_norm, (select json_arrayagg(j.dim * vector_norm(b.vec)) from json_table(from_vector(b.vec), '$[*]' columns (dim number path '$')) j) as vec_normalized
from base b
/

