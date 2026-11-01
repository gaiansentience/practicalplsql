--case study


--case expression


--case statement

set serveroutput on;
declare
    procedure check_input(input in boolean)
    is
        r varchar2(20);
    begin
        select case when input is true then 'input is true'
        when input is false then 'input is false'
        else 'input is null'
        end 
        into r;
        dbms_output.put_line(r);
    end check_input;
begin

    check_input(true);
    check_input(false);
    check_input(null);

end;
/

set serveroutput on;
declare
    procedure check_input(input in boolean)
    is
        r varchar2(20);
    begin
        r := case when input = true then 'input is true'
        when input = false then 'input is false'
        else 'input is null'
        end;
        dbms_output.put_line(r);
    end check_input;
begin

    check_input(true);
    check_input(false);
    check_input(null);

end;
/

set serveroutput on;
declare
    procedure check_input(input in boolean)
    is
        r varchar2(20);
    begin
        r := case when input then 'input is true'
        when not input then 'input is false'
        else 'input is null'
        end;
        dbms_output.put_line(r);
    end check_input;
begin

    check_input(true);
    check_input(false);
    check_input(null);

end;
/