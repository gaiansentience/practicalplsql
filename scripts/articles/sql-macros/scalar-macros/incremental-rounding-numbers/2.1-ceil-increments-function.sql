--2.1-ceil-increments-function.sql

create or replace function ceil_increments(
    p_value in number
    , p_increment in number
) return number
is
begin
    return ceil( p_value/p_increment ) * p_increment;
end ceil_increments;
/

set serveroutput on;   
begin
    dbms_output.put_line( ceil_increments(11, 5) );
    dbms_output.put_line( ceil_increments(13, 5) );
    dbms_output.put_line( ceil_increments(1.6, 1/4) );
    dbms_output.put_line( ceil_increments(1.8, 1/4) );
end;
/

/*
15
15
1.75
2
*/