--5.1-round-from-zero-increments-examples.sql

set serveroutput on;
declare
    
    function incremental_round_from_zero(
        p_value in number
        , p_increment in number
    ) return number
    is
    begin
    return 
        case sign(p_value) 
            when -1 then floor(p_value/p_increment)
            else ceil(p_value/p_increment) 
        end * p_increment;
    end incremental_round_from_zero;
    
    procedure print_incremental_round_from_zero(
        p_value in number
        , p_increment in number
    )
    is
    begin
        dbms_output.put_line(
            'round from zero: ' || p_value 
            || ' to increments of ' || p_increment 
            || ' = ' || incremental_round_from_zero(p_value, p_increment));    
    end print_incremental_round_from_zero;
begin
    print_incremental_round_from_zero(13, 5);
    print_incremental_round_from_zero(1.217, 1/4);
    print_incremental_round_from_zero(17, 12);
    print_incremental_round_from_zero(1.172839, 1/8); 
end;
/

/*
round from zero: 13 to increments of 5 = 15
round from zero: 1.217 to increments of 1/4 = 1.25
round from zero: 17 to increments of 12 = 24
round from zero: 1.172839 to increments of 1/8 = 1.25
*/