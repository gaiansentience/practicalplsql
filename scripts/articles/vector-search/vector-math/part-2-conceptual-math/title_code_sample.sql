declare
    apple_pie vector;
    apple     vector;
    peach     vector;
    peach_pie vector;
begin
    if apple_pie - apple + peach = peach_pie then
        dbms_output.put_line('Peach pie sounds good!');
    else
        dbms_output.put_line('Apple pie again?');
    end if;
exception
    when others then
        dbms_output.put_line('Too futuristic?');
end;
/
--PLS-00306: wrong number or types of arguments in call to '='
