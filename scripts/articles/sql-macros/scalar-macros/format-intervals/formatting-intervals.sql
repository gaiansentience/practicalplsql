with
    function fmt_interval(p_value in interval day to second) return varchar2 sql_macro(scalar)
    is
    l_template varchar2(1000);
    l_expression varchar2(4000);
    begin
        l_template := q'~
            case when extract(##UNIT## from p_value) <> 0 then 
                extract(##UNIT## from p_value) || ' ##UNIT##' 
                || case when extract(##UNIT## from p_value) > 1 then 's' || ' ' end 
            end~';
        
        l_expression := q'~trim(##DD## || ##HH## || ##MI## || ##SS##)~';
        
        l_expression := replace(l_expression, '##DD##', replace(l_template, '##UNIT##', 'day'));
        l_expression := replace(l_expression, '##HH##', replace(l_template, '##UNIT##', 'hour'));
        l_expression := replace(l_expression, '##MI##', replace(l_template, '##UNIT##', 'minute'));
        l_expression := replace(l_expression, '##SS##', replace(l_template, '##UNIT##', 'second'));
        return l_expression;
        
        l_expression := q'~
        trim(case when extract(day from p_value) <> 0 then extract(day from p_value) || ' day(s) ' end
            || case when extract(hour from p_value) > 0 then extract(hour from p_value) || ' hour(s) ' end
            || case when extract(minute from p_value) > 0 then extract(minute from p_value) || ' minute(s) ' end
            || case when extract(second from p_value) > 0 then extract(second from p_value) || ' second(s)' end
            )
            ~';
    end fmt_interval;
    
base as (
    select 
        numtodsinterval(level/100000 + level/1000 + level/100 + level/10 + level + level * 100, 'second')  as interval_value
        , interval '03:17.987654321' minute to second(9) as i1
    from dual
    connect by level <= 600
)
select 
    interval_value, i1
    , fmt_interval(i1) as fmt_i1
    --, fmt_interval(interval '3' second) as fmt_interval_literal
/


with
    function fmt_interval(p_value in interval day to second) return varchar2 
    is
        l_template varchar2(1000);
        l_expression varchar2(4000);
    begin

        
        return trim(case when extract(day from p_value) <> 0 then extract(day from p_value) || ' day(s) ' end
            || case when extract(hour from p_value) > 0 then extract(hour from p_value) || ' hour(s) ' end
            || case when extract(minute from p_value) > 0 then extract(minute from p_value) || ' minute(s) ' end
            || case when extract(second from p_value) > 0 then extract(second from p_value) || ' second(s)' end
            );
    end fmt_interval;
    
base as (
    select 
        numtodsinterval(level/1000000 + level/100000 + level/1000 + level/10 + level + level * 100 + level * 3333, 'second')  as interval_value
        , interval '03:17.987654321' minute to second(9) as i1
    from dual
    connect by level <= 600
)
select 
    interval_value, i1
    , fmt_interval(i1) as fmt_i1
    , fmt_interval(interval '3' minute) as fmt_interval_literal
    , fmt_interval(interval_value) as fmt_int
from base
/