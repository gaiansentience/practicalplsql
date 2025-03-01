--5.1-round-from-zero-increments-function.sql

function round_from_zero_increments(
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
end round_from_zero_increments;
/

set serveroutput on;    
begin
    dbms_output.put_line( round_from_zero_increments(11, 5) );
    dbms_output.put_line( round_from_zero_increments(13, 5) );
    dbms_output.put_line( round_from_zero_increments(-11, 5) );
    dbms_output.put_line( round_from_zero_increments(-13, 5) );
    
    dbms_output.put_line( round_from_zero_increments(1.6, 1/4) );
    dbms_output.put_line( round_from_zero_increments(1.8, 1/4) );
    dbms_output.put_line( round_from_zero_increments(-1.6, 1/4) );
    dbms_output.put_line( round_from_zero_increments(-1.8, 1/4) );

    dbms_output.put_line( round_from_zero_increments(13, 12) );
    dbms_output.put_line( round_from_zero_increments(19, 12) );
    dbms_output.put_line( round_from_zero_increments(-13, 12) );
    dbms_output.put_line( round_from_zero_increments(-19, 12) );

end;
/

/*
15
15
-15
-15
1.75
2
-1.75
-2
24
24
-24
-24
*/