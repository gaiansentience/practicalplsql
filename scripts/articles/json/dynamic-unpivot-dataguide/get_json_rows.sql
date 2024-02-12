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
), json_rows as (
    select r.jrow
    from 
        json_base b,
        json_table(b.jdoc format json,'$[*]' 
            columns (
                jrow clob format json path '$'
            )
        ) r
)
select b.jrow
from json_rows b
/

/*
JROW                                                                            
--------------------------------------------------------------------------------
{"id":1,"a":"1.a","b":"1.b","c":"1.c"}
{"id":2,"a":"2.a","b":"2.b"}
{"id":3,"a":"3.a","b":"3.b","c":"3.c","d":"3.d"}
{"id":4,"a":"4.a","b":"4.b","c":"4.c","e":"4.e"}
{"id":5,"a":"5.a","f":{"fA":"4.fA","fB":"4.fB"}}
{"id":6,"a":"6.a","c":"6.c"}

6 rows selected. 
*/