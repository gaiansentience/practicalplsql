create or replace procedure print_employee(
    p_name in varchar2,
    p_job in varchar2 default null)
is
    l_message varchar2(100);
begin
    l_message := p_name || case when p_job is not null then ' ' || p_job end; 
    dbms_output.put_line(l_message);
end print_employee;
/
