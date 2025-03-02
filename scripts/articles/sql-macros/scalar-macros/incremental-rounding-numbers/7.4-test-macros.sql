--7.4-test-macros.sql

select 
    n as "number"
    , i as "increment"
    , to_increments_sqm(n,i, 'round') as "round_n_i"
    , to_increments_sqm(n,i, 'ceil') as "ceil_n_i"
    , to_increments_sqm(n,i, 'floor') as "floor_n_i"
    , to_increments_sqm(n,i, 'trunc') as "trunc_n_i"
    , to_increments_sqm(n,i, 'round-from-zero') as "round_from_zero_n_i"
from test_data
order by i, abs(n), n
/

/*
    number  increment  round_n_i   ceil_n_i  floor_n_i  trunc_n_i round_from_zero_n_i
---------- ---------- ---------- ---------- ---------- ---------- -------------------
     -0.42        .25       -0.5      -0.25       -0.5      -0.25                -0.5
       .42        .25         .5         .5        .25        .25                  .5
     -1.08        .25         -1         -1      -1.25         -1               -1.25
      1.08        .25          1       1.25          1          1                1.25
      -8.5          5        -10         -5        -10         -5                 -10
       8.5          5         10         10          5          5                  10
       -13          5        -15        -10        -15        -10                 -15
        13          5         15         15         10         10                  15
*/