select r.*
from
table(dynamic_json_table.unpivot_json(
q'~
{"rows":[
{"objectId":11,"a":"1.a","b":"1.b","c":"1.c"},
{"objectId":12,"a":"2.a","b":"2.b","c":"2.c","e":"2.e"},
{"objectId":13,"a":"3.a","b":"3.b","c":"3.c"},
{"objectId":14,"a":"4.a","b":"4.b","c":"4.c","d":{"d1":"4.d1","d2":"4.d2"}},
{"objectId":15,"a":"5.a","b":"5.b","c":"5.c"},
{"objectId":16,"a":"6.a","b":"6.b","c":"6.c"}
]}    
~'
,'objectId'
,'rows')) r
/

with base as (
select o.* from all_objects o
fetch first 10000 rows only
), json_base as (
select
    json_arrayagg(
        json_object(b.* absent on null returning clob)
    returning clob) as jdoc
from base b
)
select r.*
from
json_base b, dynamic_json_table.unpivot_json(b.jdoc,'OBJECT_ID') r
/

set serveroutput on;
declare
    l_sql varchar2(32000);
    l_jdoc clob;
begin

    l_jdoc := 
q'~
{"rows":[
{"objectId":1,"a":"1.a","b":"1.b","c":"1.c"},
{"objectId":2,"a":"2.a","b":"2.b","c":"2.c","e":"2.e"},
{"objectId":3,"a":"3.a","b":"3.b","c":"3.c"},
{"objectId":4,"a":"4.a","b":"4.b","c":"4.c","d":{"d1":"4.d1","d2":"4.d2"}},
{"objectId":5,"a":"5.a","b":"5.b","c":"5.c"},
{"objectId":6,"a":"6.a","b":"6.b","c":"6.c"}
]}        
~';
    l_sql := dynamic_json_table.get_sql(l_jdoc,null,'rows');
    dbms_output.put_line(l_sql);

end;
/