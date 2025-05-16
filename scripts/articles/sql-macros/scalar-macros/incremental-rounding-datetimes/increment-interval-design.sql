with 
    
    function increment_interval(
        p_value in interval day to second
        , p_increment in number
        , p_unit in varchar2 default 'second'
        , p_mode in varchar2 default 'round'
    ) return varchar2 sql_macro(scalar)
    is
    l_VALUE_SS varchar2(1000);
    l_INCREMENT_SS varchar2(1000);
    l_template varchar2(4000);
    l_expression varchar2(32000);
    begin
    
        l_VALUE_SS := q'~
            extract(day from p_value) * 24 * 60 * 60 
            + extract(hour from p_value) * 60 * 60 
            + extract(minute from p_value) * 60 
            + extract(second from p_value)   
        ~';    
        
        l_INCREMENT_SS := q'~
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        ~';
    
        l_template := q'~
        numtodsinterval(
            (  ##MODE##( (##VALUE_SS##) / (##INCREMENT_SS##) ) * (##INCREMENT_SS##)  )
            , 'second'
        )
        ~';
            

        l_expression := q'~
            case p_mode
                when 'ceil' then ##CEIL##
                when 'floor' then ##FLOOR##
                when 'trunc' then ##TRUNC##
                when 'round_ties_to_even' then ##TIES##
                else ##ROUND##
            end
        ~';
        
        l_expression := replace(l_expression, '##CEIL##', replace(l_template,'##MODE##','ceil'));
        l_expression := replace(l_expression, '##FLOOR##', replace(l_template,'##MODE##','floor'));
        l_expression := replace(l_expression, '##TRUNC##', replace(l_template,'##MODE##','trunc'));
        l_expression := replace(l_expression, '##TIES##', replace(l_template,'##MODE##','round_ties_to_even'));
        l_expression := replace(l_expression, '##ROUND##', replace(l_template,'##MODE##','round'));
        
--        l_expression := q'~
--        numtodsinterval(
--            case p_mode
--                when 'ceil'          then ceil( ##VALUE_SS## / ##INCREMENT_SS## ) 
--                when 'floor'         then floor( ##VALUE_SS## / ##INCREMENT_SS## )
--                when 'trunc'         then trunc( ##VALUE_SS## / ##INCREMENT_SS## )
--                when 'round_ties_to_even' then round_ties_to_even( ##VALUE_SS## / ##INCREMENT_SS## )
--                else                      round( ##VALUE_SS## / ##INCREMENT_SS## )
--            end                    
--            * ##INCREMENT_SS##
--            , 'second'
--        )
--        ~';

--        l_expression := q'~
--            case p_mode
--                when 'ceil' then 
--                    numtodsinterval(ceil( ##VALUE_SS## / ##INCREMENT_SS## ) * ##INCREMENT_SS##, 'second')
--                when 'floor' then 
--                    numtodsinterval(floor( ##VALUE_SS## / ##INCREMENT_SS## ) * ##INCREMENT_SS##, 'second')
--                when 'trunc' then 
--                    numtodsinterval(trunc( ##VALUE_SS## / ##INCREMENT_SS## ) * ##INCREMENT_SS##, 'second')
--                when 'round_ties_to_even' then 
--                    numtodsinterval(round_ties_to_even( ##VALUE_SS## / ##INCREMENT_SS## ) * ##INCREMENT_SS##, 'second')
--                else 
--                    numtodsinterval(round( ##VALUE_SS## / ##INCREMENT_SS## ) * ##INCREMENT_SS##, 'second')
--            end                    
--        ~';

        
        l_expression := replace(l_expression, '##VALUE_SS##', l_VALUE_SS);
        l_expression := replace(l_expression, '##INCREMENT_SS##', l_INCREMENT_SS);
        return l_expression;
        
    end increment_interval;    
    

    
base as (
    select 
        numtodsinterval(level/100000 + level/1000 + level/100 + level/10 + level + level * 100, 'second')  as interval_value
        , interval '03:17.987654321' minute to second(9) as i1
    from dual
    connect by level <= 600
)
select 
    interval_value, i1
    , increment_interval( i1, .000000025, p_mode=>'ceil') five_millionth_seconds
    , increment_interval(interval_value, 5, p_mode=>'floor') as to_5_seconds
    , increment_interval(interval_value, 10) as to_10_seconds
    , increment_interval(interval_value, 15) as to_15_seconds
    , increment_interval(interval_value, 30) as to_30_seconds
from base
--where mod(extract(second from cast(interval_value as timestamp)),7) = 0
/



--comment out sql_macro clause and run query to debug sql syntax
with base as (
select  interval '03:17.987654321' minute to second(9) as p_value, 5 as p_increment, 'second' as p_unit, 'ceil' as p_mode
)
select


            case p_mode
                when 'ceil' then numtodsinterval(
            (  ceil( (
            extract(day from p_value) * 24 * 60 * 60 
            + extract(hour from p_value) * 60 * 60 
            + extract(minute from p_value) * 60 
            + extract(second from p_value)   
        ) / (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        ) ) * (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        )  )
            , 'second'
        )
                when 'floor' then numtodsinterval(
            (  floor( (
            extract(day from p_value) * 24 * 60 * 60 
            + extract(hour from p_value) * 60 * 60 
            + extract(minute from p_value) * 60 
            + extract(second from p_value)   
        ) / (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        ) ) * (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        )  )
            , 'second'
        )
                when 'trunc' then numtodsinterval(
            (  trunc( (
            extract(day from p_value) * 24 * 60 * 60 
            + extract(hour from p_value) * 60 * 60 
            + extract(minute from p_value) * 60 
            + extract(second from p_value)   
        ) / (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        ) ) * (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        )  )
            , 'second'
        )
                when 'round_ties_to_even' then numtodsinterval(
            (  round_ties_to_even( (
            extract(day from p_value) * 24 * 60 * 60 
            + extract(hour from p_value) * 60 * 60 
            + extract(minute from p_value) * 60 
            + extract(second from p_value)   
        ) / (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        ) ) * (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        )  )
            , 'second'
        )
                else numtodsinterval(
            (  round( (
            extract(day from p_value) * 24 * 60 * 60 
            + extract(hour from p_value) * 60 * 60 
            + extract(minute from p_value) * 60 
            + extract(second from p_value)   
        ) / (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        ) ) * (
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
                when 'day' then 60 * 60 * 24 
            end
        )  )
            , 'second'
        )
            end
                            
                    as round_increment_result
from base
/