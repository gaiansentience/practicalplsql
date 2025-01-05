set pagesize 25
   
create or replace function m_increment_value(
    n in number
    , p_increment in number
    , p_mode in number default 1
) return varchar2 sql_macro(scalar)
is
begin
    return '
        case p_mode 
            when 1 then ceil(n/p_increment) 
            when -1 then floor(n/p_increment) 
            else round(n/p_increment) 
        end * p_increment
        ';
end m_increment_value;
/

select 
    r.n
    , m_increment_value(r.n, 1/2, 0) as round_n_by_halves
    , m_increment_value(r.n, 1/4, 0) round_n_by_quarters 
    , m_increment_value(r.n, 1/8, 0) round_n_by_eighths 
from 
    (
    select n/10 as n
    from row_generator(10, columns(n))
    ) r
/

select 
    r.n
    , m_increment_value(r.n, 2, -1) as floor_n_by_2 
    , m_increment_value(r.n, 5, -1) as floor_n_by_5 
    , m_increment_value(r.n, 12, -1) as floor_n_by_12 
from 
    (
    select range_value as n
    from range_generator(10, 7, 21/4)
    ) r
/


select 
    ppm, 
    m_increment_value(ppm, 5) as ppm_ceil_5, 
    m_increment_value(ppm, 25) as ppm_ceil_25,
    m_increment_value(ppm, 500) as ppm_ceil_500
from 
(
    select range_value * 1e+6 as ppm
    from range_generator(10, 0.00035, 1.73579e-4)
)
/

