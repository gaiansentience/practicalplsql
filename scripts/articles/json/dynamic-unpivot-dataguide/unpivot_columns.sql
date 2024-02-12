column id format 999
column key format a10
column value format a10

with json_base as (
    select
        q'~
        [
            {"id":1,"a":"1.a","b":"1.b","c":"1.c"},
            {"id":2,"a":"2.a","b":"2.b"},
            {"id":3,"a":"3.a","b":"3.b","c":"3.c","d":"3.d"},
            {"id":4,"a":"4.a","b":"4.b","c":"4.c","e":"4.e"},
            {"id":5,"a":"5.a",
                "f":{"fA":"4.fA","fB":"4.fB"}
            },
            {"id":6,"a":"6.a","c":"6.c"}
        ]
        ~' as jdoc
    from dual
), relational_base as (
select 
    r."id", r."a", r."b", r."c", r."d", r."e", r."fA", r."fB"
from 
    json_base b,
    json_table(b.jdoc,'$[*]' columns (
        "id" number path '$.id'
        , "a"  path '$.a'
        , "b"  path '$.b'
        , "c"  path '$.c'
        , "d"  path '$.d'
        , "e"  path '$.e'
        , "fA"  path '$.f.fA'
        , "fB"  path '$.f.fB'
        )
    ) r
), unpivot_columns as (
select
    "id", "key", "value"
from 
    relational_base
    unpivot (
        "value" for "key" in ("a", "b", "c", "d", "e", "fA", "fB")
    )
)
select "id", "key", "value"
from unpivot_columns
where "id" in (1,3,5)
/
/*
  id key        value     
---- ---------- ----------
   1 a          1.a       
   1 b          1.b       
   1 c          1.c       
   3 a          3.a       
   3 b          3.b       
   3 c          3.c       
   3 d          3.d       
   5 a          5.a       
   5 fA         4.fA      
   5 fB         4.fB      
*/