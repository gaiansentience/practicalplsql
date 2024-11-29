prompt design.json_document.sql

prompt use the same json document(s) to design each part of the functionality
prompt use conditional compilation for Oracle21 json type constructor
prompt put this function in the package so that it is available later for unit testing

create or replace package dynamic_json 
authid current_user
as

    --return json documents for unit testing
    function test#get_json_document(
        p_complexity in varchar2 default 'simple'
    ) return $if dbms_db_version.version < 21 $then clob $else json $end ;

end dynamic_json;
/

create or replace package body dynamic_json 
as

    function test#get_json_document(
        p_complexity in varchar2 default 'simple'
    ) return $if dbms_db_version.version < 21 $then clob $else json $end
    is
        l_json_text clob;
    $if dbms_db_version.version >= 21 $then
        l_json json;
    $end
    begin
        if p_complexity = 'simple' then
            l_json_text := to_clob(
                q'~
                [
                {"name":"square","side":5,"color":"blue"},
                {"name":"rectangle","length":5,"width":3},  
                {"name":"box","length":5,"width":3,"height":2},  
                {"name":"hexagon","side":3,"color":"red"},
                {"name":"circle","radius":3},
                ]
            ~');
        else
            l_json_text := to_clob(
                q'~
                {"my_shapes":
                    [
                    {"name":"square","side":5,"color":"blue"},
                    {"name":"rectangle","length":5,"width":3},  
                    {"name":"box","length":5,"width":3,"height":2},  
                    {"name":"hexagon","side":3,"color":"red"},
                    {"name":"circle","radius":3},
                    ]
                }
            ~');
        end if;
    $if dbms_db_version.version < 21 $then 
        return l_json_text;
    $else
        l_json := json(l_json_text);
        return l_json;
    $end
    end test#get_json_document;

end dynamic_json;
/

prompt test the function
set serveroutput on
declare
    procedure print_sample(p_heading in varchar2, p_structure in varchar2)
    is
        l_jdoc $if dbms_db_version.version >= 21 $then json; $else clob; $end
    begin
        dbms_output.put_line(p_heading);
        l_jdoc := dynamic_json.test#get_json_document(p_structure);
        dbms_output.put_line($if dbms_db_version.version >= 21 $then json_serialize(l_jdoc pretty) $else l_jdoc $end);
    end print_sample;
begin
    print_sample('Simple Test JSON document:', 'simple');
    print_sample('Complex Test JSON document:', 'nested');
end;
/

/*
design.json_document.sql
use the same json document(s) to design each part of the functionality
use conditional compilation for Oracle21 json type constructor
put this function in the package so that it is available later for unit testing

Package DYNAMIC_JSON compiled


Package Body DYNAMIC_JSON compiled

test the function

Simple Test JSON document:
[
  {"name" : "square", "side" : 5, "color" : "blue"},
  {"name" : "rectangle", "length" : 5, "width" : 3},
  {"name" : "box", "length" : 5, "width" : 3, "height" : 2},
  {"name" : "hexagon", "side" : 3, "color" : "red"},
  {"name" : "circle", "radius" : 3}
]

Complex Test JSON document:
{
  "my_shapes" :
  [
    {"name" : "square", "side" : 5, "color" : "blue"},
    {"name" : "rectangle", "length" : 5, "width" : 3},
    {"name" : "box", "length" : 5, "width" : 3, "height" : 2},
    {"name" : "hexagon", "side" : 3, "color" : "red"},
    {"name" : "circle", "radius" : 3}
  ]
}


PL/SQL procedure successfully completed.

*/