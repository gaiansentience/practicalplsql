--4.1-trunc-increments-examples.sql

set serveroutput on;
declare
    
    function incremental_trunc(
        p_value in number
        , p_increment in number
    ) return number
    is
    begin
        return trunc(p_value/p_increment) * p_increment;
    end incremental_trunc;
    
    procedure print_incremental_trunc(
        p_value in number
        , p_increment in number
    )
    is
    begin
        dbms_output.put_line(
            'trunc: ' || p_value 
            || ' to increments of ' || p_increment 
            || ' = ' || incremental_trunc(p_value, p_increment));    
    end print_incremental_trunc;
begin
    print_incremental_trunc(13, 5);
    print_incremental_trunc(1.217, 1/4);
    print_incremental_trunc(17, 12);
    print_incremental_trunc(1.172839, 1/8);    
end;
/

/*
trunc: 13 to increments of 5 = 10
trunc: 1.217 to increments of .25 = 1
trunc: 17 to increments of 12 = 12
trunc: 1.172839 to increments of .125 = 1.125
*/