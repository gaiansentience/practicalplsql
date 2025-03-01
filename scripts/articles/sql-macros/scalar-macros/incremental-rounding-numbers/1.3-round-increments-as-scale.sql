--1.3-round-increments-as-scale.sql

set serveroutput on;
declare
    l_value number := 12345.6789;    
begin
    
    dbms_output.put_line('round(n, i) = round_increments(n, power(10, i * -1)');
    for i in reverse -2..2 loop
        dbms_output.put( 'round(n, ' || i || ') = ' );
        dbms_output.put_line( round(l_value, i) );
    end loop;  
    
    dbms_output.put_line('round(n, e * -1) = round_increments(n, power(10, e))');
    for e in -2..2 loop
        dbms_output.put( 'round_increments(n, ' || power(10, e) || ') = ' );
        dbms_output.put_line( round_increments(l_value, power(10, e)) );
    end loop;

end;
/

/*
round(n, i) = round_increments(n, power(10, i * -1)
round(n, 2) = 12345.68
round(n, 1) = 12345.7
round(n, 0) = 12346
round(n, -1) = 12350
round(n, -2) = 12300

round(n, e * -1) = round_increments(n, power(10, e))
round_increments(n, .01) = 12345.68
round_increments(n, .1) = 12345.7
round_increments(n, 1) = 12346
round_increments(n, 10) = 12350
round_increments(n, 100) = 12300
*/