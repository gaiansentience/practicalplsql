

--2.02.03.quantize-vector-macro.sql

---create a scalar macro from the subquery, passing the vector as a paramter
create or replace function to_binary_vector(
    p_input_vector in vector
    ) return varchar2
    sql_macro (scalar)
is
begin

    return q'~
    
        select 
            to_vector(
                json_serialize(
                    json_arrayagg(pb.uint_byte order by pb.byte#) 
                    returning clob)
                , *, binary)
        from 
            (
            select
                p.byte#
                , bin_to_num(p.b#1, p.b#2, p.b#3, p.b#4, p.b#5, p.b#6, p.b#7, p.b#8) as uint_byte
            from 
                (
                select 
                    case sign(jt.dimval) when 1 then 1 else 0 end as dim_bitval
                    , mod(jt.dim#, 8) as bit#
                    , ceil(jt.dim#/8) as byte#
                from 
                    json_table (
                        json(vector_serialize(p_input_vector returning clob))
                        , '$[*]'
                        columns(
                            dim# for ordinality
                            , dimval number path '$'
                            )
                        ) jt
                ) q
            pivot(
                max(q.dim_bitval) for bit# in (
                    1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4
                    , 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
                ) p
            ) pb 
    
    ~';
end to_binary_vector;
/

