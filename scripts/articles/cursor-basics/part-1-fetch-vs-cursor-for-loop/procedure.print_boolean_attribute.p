create or replace procedure print_boolean_attribute(
    p_attribute in boolean, 
    p_name in varchar2)
is
    l_message varchar2(100);
begin
    l_message := '(' || p_name || ' is ' 
        || case when p_attribute then 'true' else 'false' end 
        || ')';
    dbms_output.put_line(l_message);
end print_boolean_attribute;
/
