select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data)
        , cosine)
fetch first 3 rows only
)
/

select 384/8;  --MXBAI_EMBED_XSMALL_V1  384 dimensions Float32... should generate 48 value binary dimensions

select r.embedding_model
    , vector_dimension_format(r.embedding) as d_fmt
    , vector_dimension_count(r.embedding) as d_count
    , r.embedding, r.id, r.name, r.doc
from recipes r;

with base as (
select 
    g.id
    , mod(j.dim#, 8) as bit#
    , ceil(j.dim#/8) as byte#
    , case when j.dim_val > 0 then 1 else 0 end as bit_val
from 
    recipes g,
    json_table(json(vector_serialize(g.embedding returning clob)), '$[*]'
        columns (dim# for ordinality, dim_val number path '$')
    ) j
), u8bytes as (
    select id
        , byte#
       -- , bin_to_num(b#1, b#2, b#3, b#4, b#5, b#6, b#7, b#8) as byte_val
        , b#1 || b#2 || b#3 || b#4 || b#5 || b#6 || b#7 || b#8 as byte_val
    from base
    pivot (max(bit_val) for bit# in (1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4, 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8))
    order by id, byte#
), vector_source as (
    select 
        id
        , json_serialize(json_arrayagg(byte_val order by byte#) returning varchar2) as vector_string
    from u8bytes
    group by id
)
select id, 
    --to_vector(
        vector_string
    --, *, binary) 
    as vec
from vector_source
/



select bin_to_num(1,1,1,1,1,1,1,1)
/




with 
function to_binary_vector(v in vector) return varchar2 sql_macro(scalar)
is
    l_sql varchar2(32000);
begin

l_sql := q'~
select
    to_vector(
        json_serialize(json_arrayagg(byte_val order by byte#) returning varchar2)
        , *, binary)
from
    (
    --u8bytes
    select 
        byte#
        , bin_to_num(b#1, b#2, b#3, b#4, b#5, b#6, b#7, b#8) as byte_val
        --, b#1 || b#2 || b#3 || b#4 || b#5 || b#6 || b#7 || b#8 as byte_val
    from 
        (
        --base
        select
            mod(j.dim#,8) as bit#
            , ceil(j.dim#/8) as byte#
            , case when j.dim_val > 0 then 1 else 0 end as bit_val
        from
        json_table(json(vector_serialize(v returning clob)), '$[*]'
            columns(dim# for ordinality, dim_val number path '$')
            ) j
        )
        pivot (
            max(bit_val) for bit# in 
            (1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4, 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        )
    )
~';


return l_sql;

end to_binary_vector;

select 
    id
    , to_binary_vector(embedding) as bvec
    --, to_binary_vector(embedding, vector_dimension_count(embedding)) as bvec
    , vector_dimension_count(embedding) as dim_count
    , embedding
from recipes
order by id
/

--[  -7.08251819E-002
 --  ,5.87849542E-002
 --  ,6.83314651E-002
 --  ,3.21347378E-002
 -- ,-5.43812173E-004
 --  ,4.243223E-003
 --  ,2.9980829E-002
 -- ,-1.70622077E-002,-3.83957811E-002,-8.50162096E-003,6.92853928E-002,-4.06727418E-002,-4.02738303E-002,8.38373695E-003,-7.25773862E-003,-1.24735748E-002,7.52747133E-002,3.19240876E-002,-1.11118378E-002,-9.23646092E-002,-1.21289305E-002,4.49986197E-002,4.13392521E-002,1.77506283E-002,4.49527986E-002,6.26381114E-002,5.74856438E-002,-3.62853184E-002,-4.15615849E-002,-8.1665054E-002,-3.0518258E-002,-2.25826874E-002,2.2733232E-002,-3.0163914E-002,2.25139971E-004,-6.97290897E-003,8.07757974E-002,8.74503981E-003,6.74439296E-002,-3.02804857E-002,5.95345022E-003,-2.78624017E-002,3.42302397E-002,-2.97268406E-002,-1.92463994E-002,-1.29920887E-002,1.73109816E-004,3.66361588E-002,8.70224833E-003,9.94844362E-003,-2.88073551E-002,1.34156402E-002,-8.03514645E-002,-7.54217282E-002,7.19908103E-002,-6.84602885E-003,-8.07554871E-002,-1.8172387E-002,8.65929585E-004,7.30935065E-003,-2.99942438E-002,-5.00110127E-002,-1.68454889E-002,2.80416422E-002,1.18818758E-002,-2.34235022E-002,-5.04638925E-002,1.15291802E-002,-3.57373506E-002,6.09862953E-002,-7.38163292E-002,1.50308497E-002,3.08211371E-002,1.49872797E-002,-3.9729476E-002,-6.83807433E-002,4.96250801E-002,-1.38414755E-001,-6.53649122E-003,5.08777015E-002,-1.3387692E-001,-3.45155224E-002,-3.76346633E-002,3.72181274E-002,1.23559311E-002,-3.06257736E-002,4.77788883E-004,4.85841781E-002,5.08090295E-002,-5.09155989E-002,-2.0059526E-002,-6.83787242E-002,2.72843521E-002,2.94148494E-002,-4.3211624E-002,-3.32700349E-002,-1.77276973E-002,-1.31646484E-001,-2.66725291E-002,6.826929E-002,2.97859926E-002,-6.46069646E-003,5.46093397E-002,-5.78884818E-002,-5.31991497E-002,1.20000709E-002,-6.33994341E-002,3.26187653E-003,-3.52960713E-002,2.58845296E-002,2.56494991E-002,7.04124272E-002,-4.62708101E-002,-8.0240123E-002,-5.85405231E-002,-1.10855792E-002,6.94882572E-002,-1.00900851E-001,4.20564488E-002,4.39198911E-002,-2.71636061E-002,4.91280444E-002,-4.57098056E-003,8.35728273E-002,-4.48436886E-002,-1.29735405E-002,8.10829774E-002,-1.23238118E-004,-7.09139481E-002,4.40443978E-002,5.35193756E-002,-1.6881983E-003,2.66133286E-002,-4.89713624E-002,7.13433605E-003,9.05600749E-003,-1.80239491E-002,-2.85483245E-002,1.2412807E-002,-2.59954855E-002,4.97793034E-002,6.84094727E-002,-2.12586187E-002,-3.7354771E-002,-1.62541848E-002,4.73752581E-002,-3.31200697E-002,-1.36728985E-002,-3.28791663E-002,4.94258627E-002,1.25669343E-002,2.53741182E-002,2.6824113E-002,-2.70707123E-002,-5.6115862E-002,3.25690117E-003,-1.37267709E-002,1.69706251E-002,8.72778073E-002,-9.92865022E-003,-3.63559723E-002,-2.42351787E-003,8.89430288E-003,1.18736252E-001,-7.80371428E-002,-8.61198641E-003,-6.20541023E-003,3.92119512E-002,-6.08072989E-003,-1.43536914E-003,2.05629729E-002,2.29106657E-003,1.06269429E-002,-6.98662698E-002,1.66061278E-002,1.20041385E-001,-1.35098742E-002,-2.61090379E-002,4.40122634E-002,-1.85153596E-002,2.56594289E-002,8.71661399E-003,-4.27117646E-002,4.48272191E-002,8.72546583E-002,1.35690216E-002,2.72592492E-002,4.24819663E-002,4.77590486E-002,5.07355332E-002,-6.91137388E-002,-4.95419353E-002,-9.95079149E-003,7.44995195E-003,-5.67121543E-002,-6.84051216E-002,1.53965447E-002,-1.73141435E-002,1.68623794E-002,-6.65067434E-002,1.29720926E-001,7.0041284E-002,2.71615498E-002,3.21381353E-002,-2.80539412E-002,-6.78326264E-002,-2.57770959E-002,1.46126468E-002,1.38527319E-001,-6.96449205E-002,-2.44701356E-002,-8.42027366E-002,-1.11752957E-001,4.60413806E-002,-8.6539641E-002,-8.60106945E-002,3.55298743E-002,8.23454931E-002,-7.60706067E-002,-8.59533772E-002,3.92868668E-002,-4.22583334E-002,-5.43857142E-002,-2.32434904E-004,4.54627685E-002,-1.44871175E-002,1.32324165E-002,5.32417931E-002,-2.38885041E-002,-9.98193547E-002,-2.39953119E-002,-5.5639673E-002,-9.44478512E-002,-6.29870966E-003,-9.14042722E-003,-6.72287792E-002,5.04167154E-002,-3.87405232E-002,-2.459093E-002,1.27790153E-001,1.36115074E-001,1.08612686E-001,7.37027824E-002,2.72737723E-002,-1.81123316E-002,8.44642147E-002,-2.005147E-002,6.38385862E-002,1.4830091E-002,5.03153577E-002,9.51171741E-002,9.50495806E-003,-2.54318062E-002,-4.2686563E-002,-6.52017146E-002,-1.14351675E-001,5.69184534E-002,-1.16959535E-001,3.94604029E-003,8.83801505E-002,-5.96047454E-002,-3.89911234E-002,1.22611448E-002,8.59511364E-003,-8.10730532E-002,-1.10215053E-003,4.27569672E-002,1.68331772E-001,9.35207494E-003,-3.24165411E-002,-4.42328583E-003,-2.36680359E-003,-9.60440338E-002,2.2808928E-002,2.20769607E-002,8.29182472E-003,1.94126144E-002,-3.78915146E-002,2.25367751E-002,5.04701287E-002,-7.99162239E-002,-6.34671971E-002,4.9159456E-002,-9.15135257E-003,-2.20156629E-002,-2.29943693E-002,7.24538346E-004,1.70769133E-002,1.31458521E-001,-3.19158696E-002,-1.14112653E-001,-4.4443462E-002,3.29187582E-003,6.10595047E-002,-6.60348684E-002,-1.04313884E-002,5.01719266E-002,-7.87696168E-002,-2.09090323E-003,-1.61987934E-002,-7.48081282E-002,-2.70080324E-002,-4.91789542E-002,8.94335378E-003,-2.51579881E-002,-5.50290011E-002,5.09344973E-002,4.26977836E-002,1.6732876E-003,1.50214639E-002,-5.40940724E-002,1.93537679E-002,2.52126958E-002,2.21864134E-002,-5.72125241E-003,-2.55711414E-002,7.71661326E-002,8.24231431E-002,3.91040072E-002,-1.12579641E-004,1.11290835E-001,-7.48564452E-002,-6.47214577E-002,2.97020469E-002,-2.82765664E-002,-4.18106616E-002,2.70652175E-002,-5.2756235E-002,3.51329222E-002,4.30177934E-002,-3.33236419E-002,1.44261867E-001,-3.41208391E-002,5.70215657E-002,1.18382387E-002,4.72521894E-002,-1.03968093E-002,3.88155654E-002,-9.23605263E-003,1.87605061E-002,2.06477232E-002,5.14766648E-002,-2.97780968E-002,-5.83747439E-002,6.91690668E-002,5.42588048E-002,3.40214707E-002,6.97681978E-002,9.52693522E-002,5.09758741E-002,6.30020723E-003,-3.14614996E-002,-4.16492261E-002,-7.83073809E-003,4.10379544E-002,-3.66133894E-003,-4.84212041E-002,1.81211997E-002,-1.55397868E-002,-3.71978581E-002,2.79912073E-002,-1.81086715E-002,-3.53517011E-002,5.5649966E-002,-6.97108284E-002,1.91279668E-002,-6.79432526E-002,3.99415903E-002,-4.89695817E-002,-3.43960598E-002,-3.13999578E-002,2.82972073E-003,-8.36415961E-003,2.34831255E-002,-1.98559184E-002,3.86341568E-003
 
 --  ,2.89735049E-002
 -- ,-6.24958724E-002
 --  ,1.93896815E-002
 -- ,-8.15636571E-003
 --  ,2.76559759E-002
 --  ,6.26144484E-002
 -- ,-1.67310219E-002
 --  ,2.17840006E-003]
--  0               1               0               1                0                1            1              0


with base as (
select 
    g.id
    , mod(j.dim#,8) as bit#
    , ceil(j.dim#/8) as byte#
    , case when j.dim_val > 0 then 1 else 0 end as bit_val
from recipes g,
json_table(json(vector_serialize(g.embedding returning clob)), '$[*]'
columns (
    dim# for ordinality,
    dim_val number path '$'
)
) j
), u8bytes as (
select id, byte#, bin_to_num(b#1, b#2, b#3, b#4, b#5, b#6, b#7, b#8) as byte_val
from base
pivot (max(bit_val) for bit# in (1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4, 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8))
order by id, byte#
), vector_source as (
select 
    id
    , json_serialize(json_arrayagg(byte_val order by byte#) returning clob value) as vector_string
from u8bytes
group by id
)
select 
    id
    , to_vector(vector_string, *, binary) as vec
from vector_source
/


select bin_to_num(0,0,1,0,1,0,1,0)
/

--macro sql
select
    to_vector(
        json_serialize(json_arrayagg(byte_val order by byte#) returning varchar2)
        , *, binary)
from
    (
    --u8bytes
    select byte#
        , bin_to_num(b#1, b#2, b#3, b#4, b#5, b#6, b#7, b#8) as byte_val
        --, b#1 || b#2 || b#3 || b#4 || b#5 || b#6 || b#7 || b#8 as byte_val
    from 
        (
        --base
        select
            mod(j.dim#,8) as bit#
            , ceil(j.dim#/8) as byte#
            , case when j.dim_val > 0 then 1 else 0 end as bit_val
        from
            json_table(
                json(vector_serialize('[0,0,1,0,1,0,1,0]' returning clob)), '$[*]'
                columns(dim# for ordinality, dim_val number path '$')
                ) j
        )
        pivot (
            max(bit_val) for bit# in 
            (1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4, 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
        )
    )
/


create or replace function to_binary_vector(v in vector) return varchar2 sql_macro(scalar)
is
    l_sql varchar2(32000);
begin

    l_sql := q'~
        select
            to_vector(
                json_serialize(json_arrayagg(byte_val order by byte#) returning varchar2)
                , *, binary)
        from
            (
            --u8bytes
            select 
                byte#
                , bin_to_num(b#1, b#2, b#3, b#4, b#5, b#6, b#7, b#8) as byte_val
            from 
                (
                --base
                select
                    mod(j.dim#,8) as bit#
                    , ceil(j.dim#/8) as byte#
                    , case when j.dim_val > 0 then 1 else 0 end as bit_val
                from
                    json_table(json(vector_serialize(v returning clob)), '$[*]'
                        columns(dim# for ordinality, dim_val number path '$')
                        ) j
                )
                pivot (
                    max(bit_val) for bit# in 
                    (1 as b#1, 2 as b#2, 3 as b#3, 4 as b#4, 5 as b#5, 6 as b#6, 7 as b#7, 0 as b#8)
                )
            )
    ~';
    
    return l_sql;

end to_binary_vector;
/


select rownum as ranking, name, doc
from
(
select name, doc, to_binary_vector(g.embedding) as bvec
from recipes g
order by 
    vector_distance(
        bvec
--        to_binary_vector(g.embedding)
        , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
        , jaccard)
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    JACCARD_DISTANCE(
        to_binary_vector(g.embedding)
        , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
        )
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        to_binary_vector(g.embedding)
        , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
        , hamming)
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    HAMMING_DISTANCE(
        to_binary_vector(g.embedding)
        , to_binary_vector(vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data))
        )
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data)
        , euclidean)
fetch first 3 rows only
)
/

select rownum as ranking, name, doc
from
(
select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(MXBAI_EMBED_XSMALL_V1 using 'healthy dinner' as data)
        , dot)
fetch first 3 rows only
)
/