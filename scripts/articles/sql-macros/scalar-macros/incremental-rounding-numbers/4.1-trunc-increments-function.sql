--4.1-trunc-increments-function.sql

create or replace function trunc_increments(
    p_value in number
    , p_increment in number
) return number
is
begin
    return trunc( p_value/p_increment ) * p_increment;
end trunc_increments;
/

set serveroutput on;    
begin
    dbms_output.put_line( trunc_increments(11, 5) );
    dbms_output.put_line( trunc_increments(13, 5) );
    dbms_output.put_line( trunc_increments(1.6, 1/4) );
    dbms_output.put_line( trunc_increments(1.8, 1/4) );
    dbms_output.put_line( trunc_increments(13, 12) );
    dbms_output.put_line( trunc_increments(19, 12) );
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