prompt design-test_jdoc-package.sql

--use the same json documents to design each part of the functionality
--use conditional compilation for Oracle21 json type constructor
--add a print procedure to test the function
--put them in the package to use during design process

create or replace package design#dynamic_json 
authid current_user
as

    subtype t_structure is varchar2(6);
    c_simple constant t_structure := 'simple';
    c_nested constant t_structure := 'nested';
    
    function test_jdoc(p_structure in varchar2 default c_simple
    ) return $if dbms_db_version.version < 21 $then clob $else json $end ;

    procedure print_test_jdoc(p_structure in varchar2 default c_simple);

end design#dynamic_json;
/

create or replace package body design#dynamic_json 
as

    function test_jdoc(p_structure in varchar2 default c_simple
    ) return $if dbms_db_version.version < 21 $then clob $else json $end
    is
        l_json_text clob;
    begin
        if p_structure = c_simple then
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
        
        return $if dbms_db_version.version < 21 $then l_json_text $else json(l_json_text) $end ;

    end test_jdoc;
    
    procedure print_test_jdoc(p_structure in varchar2 default c_simple)
    is
        l_jdoc $if dbms_db_version.version >= 21 $then json; $else clob; $end
    begin
        dbms_output.put_line('Test JSON Document: ' || p_structure);
        l_jdoc := test_jdoc(p_structure);

$if dbms_db_version.version < 21 $then
        select json_serialize(l_jdoc returning clob pretty) 
        into l_jdoc from dual;
$end
        
        dbms_output.put_line($if dbms_db_version.version >= 21 $then json_serialize(l_jdoc pretty) $else l_jdoc $end);
    end print_test_jdoc;
    
end design#dynamic_json;
/

set serveroutput on
begin
    design#dynamic_json.print_test_jdoc();
    design#dynamic_json.print_test_jdoc(design#dynamic_json.c_nested);
end;
/

/*
Test JSON Document: simple
[
  {"name" : "square", "side" : 5, "color" : "blue"},
  {"name" : "rectangle", "length" : 5, "width" : 3},
  {"name" : "box", "length" : 5, "width" : 3, "height" : 2},
  {"name" : "hexagon", "side" : 3, "color" : "red"},
  {"name" : "circle", "radius" : 3}
]

Test JSON Document: nested
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
*/