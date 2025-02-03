--3.1-floor-increments-examples.sql

set serveroutput on;
declare
    
    function incremental_floor(
        p_value in number
        , p_increment in number
    ) return number
    is
    begin
        return floor(p_value/p_increment) * p_increment;
    end incremental_floor;
    
    procedure print_incremental_floor(
        p_value in number
        , p_increment in number
    )
    is
    begin
        dbms_output.put_line(
            'floor: ' || p_value 
            || ' to increments of ' || p_increment 
            || ' = ' || incremental_floor(p_value, p_increment));    
    end print_incremental_floor;
begin
    print_incremental_floor(13, 5);
    print_incremental_floor(1.217, 1/4);
    print_incremental_floor(17, 12);
    print_incremental_floor(1.172839, 1/8);    
end;
/

/*
floor: 13 to increments of 5 = 10
floor: 1.217 to increments of .25 = 1
floor: 17 to increments of 12 = 12
floor: 1.172839 to increments of .125 = 1.125
*/