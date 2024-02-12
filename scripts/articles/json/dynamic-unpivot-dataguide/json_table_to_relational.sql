column id format 999
column a format a6
column b format a6
column c format a6
column d format a6
column e format a6
column fB format a6
column fA format a6
set null '(null)'

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
)
select * from relational_base
/

/*
  id a      b      c      d      e      fA     fB    
---- ------ ------ ------ ------ ------ ------ ------
   1 1.a    1.b    1.c    (null) (null) (null) (null)
   2 2.a    2.b    (null) (null) (null) (null) (null)
   3 3.a    3.b    3.c    3.d    (null) (null) (null)
   4 4.a    4.b    4.c    (null) 4.e    (null) (null)
   5 5.a    (null) (null) (null) (null) 4.fA   4.fB  
   6 6.a    (null) 6.c    (null) (null) (null) (null)

6 rows selected. 
*/