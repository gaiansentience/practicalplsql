


select bin_to_num(1,0,1,0,1,0,1,0) as uint8
/
--170

select to_vector(to_vector('[1,0,1,0,1,0,1,0]', 8, int8), *, binary) as v
/
--[1]

select to_vector(to_vector('[121,-44,3,0,33,-22,42,-55]', 8, int8), *, binary) as v
/
--[121]

select to_vector(to_vector('[7.1,-7.2,7.3,-7.4,7.5,-7.6,7.7,-7.8]', 8, float32), *, binary) as v
/
--[7]

select to_vector(to_vector('[7.1e-001,-7.2e-001,7.3e-001,-7.4e-001,7.5e-001,-7.6e-001,7.7e-001,-7.8e-001]', 8, float32), *, binary) as v
/
--[1]


--select some vectors that should convert to a binary vector of [170] when dimensions are quantized
with  base(v_raw) as (
values ('[1,0,1,0,1,0,1,0]')
    ,('[121,-44,3,0,33,-22,42,-55]')
    ,('[7.1,-7.2,7.3,-7.4,7.5,-7.6,7.7,-7.8]')
    ,('[7.1e-001,-7.2e-001,7.3e-001,-7.4e-001,7.5e-001,-7.6e-001,7.7e-001,-7.8e-001]')
), vectors as (
select to_vector(v_raw, 8, int8) as v_int8, to_vector(v_raw, 8, float32) as v_float32
from base
)
select v_int8, to_vector(v_int8, *, binary) as v_int8_binary, v_float32, to_vector(v_float32, *, binary) as v_float32_binary
from vectors
/
--int8 and float32 vectors are correct.  converting to binary vector returns [1], [121], or [7] instead of [170]


--from documentation example of binary vectors:

--[25, 11, -99, -114, 13, -17, -59, 44]

--[1, 1, 0, 0, 1, 0, 0, 1]

--in binary this translates to 201
select bin_to_num(1, 1, 0, 0, 1, 0, 0, 1)
/

--so the binary vector  [201] represents this example
--the int8 vector [25, 11, -99, -114, 13, -17, -59, 44] does not converted to the binary vector [201]
select to_vector(to_vector('[25, 11, -99, -114, 13, -17, -59, 44]', 8, int8), *, binary)
/
--returns [25]

