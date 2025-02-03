--2.1-ceil-increments-examples.sql

set serveroutput on;
declare
    
    function incremental_ceil(
        p_value in number
        , p_increment in number
    ) return number
    is
    begin
        return ceil(p_value/p_increment) * p_increment;
    end incremental_ceil;
    
    procedure print_incremental_ceil(
        p_value in number
        , p_increment in number
    )
    is
    begin
        dbms_output.put_line(
            'ceil: ' || p_value 
            || ' to increments of ' || p_increment 
            || ' = ' || incremental_ceil(p_value, p_increment));    
    end print_incremental_ceil;
begin
    print_incremental_ceil(13, 5);
    print_incremental_ceil(1.217, 1/4);
    print_incremental_ceil(17, 12);
    print_incremental_ceil(1.172839, 1/8);    
end;
/

/*
ceil: 13 to increments of 5 = 15
ceil: 1.217 to increments of .25 = 1.25
ceil: 17 to increments of 12 = 24
ceil: 1.172839 to increments of .125 = 1.25
*/