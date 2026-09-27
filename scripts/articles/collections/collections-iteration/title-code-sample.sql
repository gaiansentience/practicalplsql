set serveroutput on;
declare
     type names_aa is table of varchar2(20) index by pls_integer;
     n names_aa := names_aa(
        'associative array', 'index by'
        , 'pls_integer', 'varchar2'
        , 'iteration');
begin

    dbms_output.put_Line('1 => ' || n(1));
    dbms_output.put_Line('2 => ' || n(2));
    dbms_output.put_Line('3 => ' || n(3));
    dbms_output.put_Line('4 => ' || n(4));
    
end;
/
