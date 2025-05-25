with 
    
    function increment_timestamp(
        p_value in timestamp
        , p_increment in number
        , p_unit in varchar2 default 'second'
        , p_mode in varchar2 default 'round'
    ) return varchar2 sql_macro(scalar)
    is
        l_expression varchar2(32000);
        l_INCREMENT_SS varchar2(4000);
        l_VALUE_SS varchar2(4000);
        l_template varchar2(4000);
    begin
    
        l_VALUE_SS := q'~
            extract(hour from p_value) * 60 * 60 
            + extract(minute from p_value) * 60 
            + extract(second from p_value)   
        ~';    
        
        l_INCREMENT_SS := q'~
            p_increment * 
            case p_unit 
                when 'second' then 1 
                when 'minute' then 60 
                when 'hour' then 60 * 60 
            end
        ~';
    
        l_template := q'~
        numtodsinterval(
            (  ##MODE##( (##VALUE_SS##) / (##INCREMENT_SS##) ) * (##INCREMENT_SS##)  )
            , 'second'
        )
        ~';    
        
        l_expression := q'~
            p_value - numtodsinterval( (##VALUE_SS##), 'second')
            + case p_mode
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
        
        l_expression := replace(l_expression, '##VALUE_SS##', l_VALUE_SS);
        l_expression := replace(l_expression, '##INCREMENT_SS##', l_INCREMENT_SS);
        return l_expression;
    
        l_expression := q'[
            p_value 
            - numtodsinterval(
                extract(hour from p_value) * 60 * 60
                + extract(minute from p_value) * 60
                + extract(second from p_value)
                , 'second'
            )
            + numtodsinterval(
                case p_mode
                when 'ceil' then
                ceil(
                    ( extract(hour from p_value) * 60 * 60 + extract(minute from p_value) * 60 + extract(second from p_value) )
                    / (p_increment * case p_unit when 'second' then 1  when 'minute' then 60 when 'hour' then 60 * 60 end)
                    ) 
                when 'floor' then
                floor(
                    ( (extract(hour from p_value) * 60 * 60) + (extract(minute from p_value) * 60) + extract(second from p_value) )
                    / p_increment * case p_unit when 'second' then 1  when 'minute' then 60 when 'hour' then 60 * 60 end
                    ) 
                else
                round(
                    ( (extract(hour from p_value) * 60 * 60) + (extract(minute from p_value) * 60) + extract(second from p_value) )
                    / (p_increment * case p_unit when 'second' then 1  when 'minute' then 60 when 'hour' then 60 * 60 end)
                    ) 
                end                    
                * (p_increment * case p_unit when 'second' then 1  when 'minute' then 60 when 'hour' then 60 * 60 end)
                , 'second')
        ]';
        
        return l_expression;
        
    end increment_timestamp;    
    
base as (
    select localtimestamp + numtodsinterval(level/100, 'second') as dt
    from dual
    connect by level <= 600
)
select 
    dt
    , increment_timestamp(dt, 5) as to_5_seconds
    , increment_timestamp(dt, 10) as to_10_seconds
    , increment_timestamp(dt, 15) as to_15_seconds
    , increment_timestamp(dt, 30) as to_30_seconds

from base
--where mod(extract(second from cast(dt as timestamp)),7) = 0
/




select extract(hour from cast(sysdate as timestamp)),localtimestamp, current_timestamp, systimestamp, sysdate
/