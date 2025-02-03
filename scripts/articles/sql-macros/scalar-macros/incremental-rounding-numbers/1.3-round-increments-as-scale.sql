--1.1-round-increments-examples.sql

set serveroutput on;
declare
    l_value number := 12345.6789;
    
    function incremental_round(
        p_value in number
        , p_increment in number
    ) return number
    is
    begin
        return round(p_value/p_increment) * p_increment;
    end incremental_round;
    
    procedure print_incremental_round(
        p_value in number
        , p_increment in number
    )
    is
    begin
        dbms_output.put_line(
            'round: ' || p_value 
            || ' to increments of ' || p_increment 
            || ' = ' || incremental_round(p_value, p_increment));    
    end print_incremental_round;
begin
    for e in -3..3 loop
        print_incremental_round(l_value, power(10, e));
    end loop;
end;
/

/*
round: 12345.6789 to increments of .001 = 12345.679
round: 12345.6789 to increments of .01 = 12345.68
round: 12345.6789 to increments of .1 = 12345.7
round: 12345.6789 to increments of 1 = 12346
round: 12345.6789 to increments of 10 = 12350
round: 12345.6789 to increments of 100 = 12300
round: 12345.6789 to increments of 1000 = 12000
*/