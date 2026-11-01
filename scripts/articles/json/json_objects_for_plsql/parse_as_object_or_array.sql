



--using plsql object types to parse string json that is either an object or an array


select json_object('longPath' : json_object('k':'v'));



--select json_object('longPath':json_array(json_object('k':'v1'),json_object('k':'v2')));

set serveroutput on;
declare
type t is table of varchar2(1000) index by pls_integer;
l_json t := t(
    '[{"k":"arrayObject0"},{"k":"arrayObject1"}]'
    ,'{"k":"singletonObject"}'
    ,'[{"k":"singletonArray"}]'
    );
    

procedure parse_object(o in json_object_t)
is
begin
    dbms_output.put_line(o.get_String('k'));
end parse_object;

procedure parse_array(a in json_array_t)
is
    o json_object_t;
begin

    for i in 0..a.get_size - 1 loop
        o := treat(a.get(i) as json_object_t);
        parse_object(o);        
    end loop;

end parse_array;

procedure parse_to_objects(e in json_element_t)
is
a json_array_t := new json_array_t();
o json_object_t;
begin
dbms_output.put_line('using parse_to_objects');
--parse e as array or object based on content
--directly parse object
--parse array in loop as objects
if (e.is_object) then
    o := treat(e as json_object_t);
    parse_object(o);
elsif (e.is_array) then
    a := treat(e as json_array_t);
    for i in 0..a.get_size - 1 loop
        o := treat(a.get(i) as json_object_t);
        parse_object(o);
    end loop;
end if;

end parse_to_objects;
procedure parse_to_array(e in json_element_t)
is
a json_array_t := new json_array_t();
o json_object_t;
begin
dbms_output.put_line('using parse_to_array');

--convert object to singleton array and parse as array
--parse arrays directly
if (e.is_object) then
    a.append(e);
else
    a := treat(e as json_array_t);
end if;
parse_array(a);

end parse_to_array;

procedure test_parsing(s in varchar2)
is
e json_element_t;
begin
e := json_element_t.parse(s);

parse_to_objects(e);

parse_to_array(e);
end test_parsing;

begin



for i in 1..l_json.count loop
    test_parsing(l_json(i));
end loop;


end;
/