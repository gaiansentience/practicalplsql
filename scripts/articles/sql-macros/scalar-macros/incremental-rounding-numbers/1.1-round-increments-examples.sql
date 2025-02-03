--1.1-round-increments-examples.sql

set serveroutput on;
declare
    
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
    print_incremental_round(13, 5);
    print_incremental_round(1.217, 1/4);
    print_incremental_round(17, 12);
    print_incremental_round(1.172839, 1/8);    
end;
/

/*
round: 13 to increments of 5 = 15
round: 1.217 to increments of .25 = 1.25
round: 17 to increments of 12 = 12
round: 1.172839 to increments of .125 = 1.125
*/