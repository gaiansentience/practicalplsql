--3.1-floor-increments-function.sql

create or replace function floor_increments(
    p_value in number
    , p_increment in number
) return number
is
begin
    return floor( p_value/p_increment ) * p_increment;
end floor_increments;
/

set serveroutput on;    
begin
    dbms_output.put_line( floor_increments(11, 5) );
    dbms_output.put_line( floor_increments(13, 5) );
    dbms_output.put_line( floor_increments(1.6, 1/4) );
    dbms_output.put_line( floor_increments(1.8, 1/4) );
    dbms_output.put_line( floor_increments(13, 12) );
    dbms_output.put_line( floor_increments(19, 12) );
end;
/

/*
10
10
1.5
1.75
12
12
*/