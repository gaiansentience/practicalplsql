prompt design-7.1-test_jdoc-package.sql

--add test documents with row identifier keys in the json object

create or replace package dynamic_json#test 
authid current_user
as

    subtype json_format is varchar2(10);
    c_array_simple    constant json_format := 'simple';
    c_array_nested    constant json_format := 'nested';
    c_array_simple_id constant json_format := 'simple_id';
    c_array_nested_id constant json_format := 'nested_id';
    
    function test_jdoc(format_option in json_format default c_array_simple
    ) return $if dbms_db_version.version < 21 $then clob $else json $end ;

    procedure debug_test_jdoc(format_option in json_format default c_array_simple);

end dynamic_json#test;
/

create or replace package body dynamic_json#test 
as

    function test_jdoc(format_option in json_format default c_array_simple
    ) return $if dbms_db_version.version < 21 $then clob $else json $end
    is
        l_json_text clob;
    begin
        case format_option 
            when c_array_simple then
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
            when c_array_nested then
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
            when c_array_simple_id then
                l_json_text := to_clob(
                    q'~
                    [
                    {"shape_id":101,"name":"square","side":5,"color":"blue"},
                    {"shape_id":102,"name":"rectangle","length":5,"width":3},  
                    {"shape_id":103,"name":"box","length":5,"width":3,"height":2},  
                    {"shape_id":104,"name":"hexagon","side":3,"color":"red"},
                    {"shape_id":105,"name":"circle","radius":3},
                    ]
                ~');
            when c_array_nested_id then
                l_json_text := to_clob(
                    q'~
                    {"my_shapes":
                        [
                        {"shape_id":101,"name":"square","side":5,"color":"blue"},
                        {"shape_id":102,"name":"rectangle","length":5,"width":3},  
                        {"shape_id":103,"name":"box","length":5,"width":3,"height":2},  
                        {"shape_id":104,"name":"hexagon","side":3,"color":"red"},
                        {"shape_id":105,"name":"circle","radius":3},
                        ]
                    }
                ~');
            else
                raise_application_error(-20100, format_option || ' is an undefined test document type');
        end case;
        
        return $if dbms_db_version.version < 21 $then l_json_text $else json(l_json_text) $end ;

    end test_jdoc;
    
    procedure debug_test_jdoc(format_option in json_format default c_array_simple)
    is
        l_jdoc $if dbms_db_version.version >= 21 $then json; $else clob; $end
        c_separator constant varchar2(100) := lpad('-', 50, '-');
    begin
        dbms_output.put_line(c_separator);    
        dbms_output.put_line('Test JSON Document: ' || format_option);
        dbms_output.put_line(c_separator);
        l_jdoc := test_jdoc(format_option);

$if dbms_db_version.version < 21 $then
        select json_serialize(l_jdoc returning clob pretty) 
        into l_jdoc from dual;
$end
        
        dbms_output.put_line($if dbms_db_version.version >= 21 $then json_serialize(l_jdoc pretty) $else l_jdoc $end);
    end debug_test_jdoc;
    
end dynamic_json#test;
/

--test the functions
set serveroutput on
begin
    dynamic_json#test.debug_test_jdoc(dynamic_json#test.c_array_simple_id);
    dynamic_json#test.debug_test_jdoc(dynamic_json#test.c_array_nested_id);
end;
/

/*
design-7.1-test_jdoc-package.sql

Package DYNAMIC_JSON#TEST compiled


Package Body DYNAMIC_JSON#TEST compiled

--------------------------------------------------
Test JSON Document: simple_id
--------------------------------------------------
[
  {
    "shape_id" : 101,
    "name" : "square",
    "side" : 5,
    "color" : "blue"
  },
  {
    "shape_id" : 102,
    "name" : "rectangle",
    "length" : 5,
    "width" : 3
  },
  {
    "shape_id" : 103,
    "name" : "box",
    "length" : 5,
    "width" : 3,
    "height" : 2
  },
  {
    "shape_id" : 104,
    "name" : "hexagon",
    "side" : 3,
    "color" : "red"
  },
  {
    "shape_id" : 105,
    "name" : "circle",
    "radius" : 3
  }
]
--------------------------------------------------
Test JSON Document: nested_id
--------------------------------------------------
{
  "my_shapes" :
  [
    {
      "shape_id" : 101,
      "name" : "square",
      "side" : 5,
      "color" : "blue"
    },
    {
      "shape_id" : 102,
      "name" : "rectangle",
      "length" : 5,
      "width" : 3
    },
    {
      "shape_id" : 103,
      "name" : "box",
      "length" : 5,
      "width" : 3,
      "height" : 2
    },
    {
      "shape_id" : 104,
      "name" : "hexagon",
      "side" : 3,
      "color" : "red"
    },
    {
      "shape_id" : 105,
      "name" : "circle",
      "radius" : 3
    }
  ]
}


PL/SQL procedure successfully completed.

*/