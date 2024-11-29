prompt design-get_test_json-function.sql

--use the same json documents to design each part of the functionality
--use conditional compilation for Oracle21 json type constructor
--add a print procedure to test the function

set serveroutput on

declare

    function local#get_test_json(
        p_structure in varchar2 default 'simple'
    ) return $if dbms_db_version.version < 21 $then clob $else json $end
    is
        l_json_text clob;
    begin
        if p_structure = 'simple' then
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

    end local#get_test_json;
    
    procedure local#print_test_json(p_structure in varchar2 default 'simple')
    is
        l_jdoc $if dbms_db_version.version >= 21 $then json; $else clob; $end
    begin
        dbms_output.put_line('Test JSON Document: ' || p_structure);
        l_jdoc := local#get_test_json(p_structure);
        
$if dbms_db_version.version < 21 $then
        select json_serialize(l_jdoc returning clob pretty) 
        into l_jdoc from dual;
$end
        
        dbms_output.put_line($if dbms_db_version.version >= 21 $then json_serialize(l_jdoc pretty) $else l_jdoc $end);
    end local#print_test_json;

begin
    local#print_test_json('simple');
    local#print_test_json('nested');
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