--1.1-round-increments-function.sql

create or replace function round_increments(
    p_value in number
    , p_increment in number
) return number
is
begin
    return round( p_value/p_increment ) * p_increment;
end round_increments;
/
    
set serveroutput on;
begin
    dbms_output.put_line( round_increments(11, 5) );
    dbms_output.put_line( round_increments(13, 5) );
    dbms_output.put_line( round_increments(1.6, 1/4) );
    dbms_output.put_line( round_increments(1.8, 1/4) );
    dbms_output.put_line( round_increments(13, 12) );
    dbms_output.put_line( round_increments(19, 12) );
end;
/

/*
10
15
1.5
1.75
12
24
*/