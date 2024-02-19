set long 10000
set pagesize 100

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
), dataguide_base as (
    select json_dataguide(b.jdoc) as jdg
    from json_base b
)
select jdg
from dataguide_base
/

/*
[
    {"o:path":"$.a","type":"string","o:length":4},
    {"o:path":"$.b","type":"string","o:length":4},
    {"o:path":"$.c","type":"string","o:length":4},
    {"o:path":"$.d","type":"string","o:length":4},
    {"o:path":"$.e","type":"string","o:length":4},
    {"o:path":"$.f","type":"object","o:length":32},
    {"o:path":"$.f.fA","type":"string","o:length":4},
    {"o:path":"$.f.fB","type":"string","o:length":4},
    {"o:path":"$.id","type":"number","o:length":1}
]
*/