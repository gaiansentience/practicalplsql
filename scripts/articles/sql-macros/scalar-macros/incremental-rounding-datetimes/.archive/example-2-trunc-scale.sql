set serveroutput on;
declare
    n number := 1234.56789;
    l_increment number;
begin
    for scale in reverse -2..2 loop
        
        l_increment := power(10, -1 * scale);
        dbms_output.put_line('
trunc(n, ' || scale || ') = ' || trunc(n, scale) || '
    = trunc( n/power(10, -1 * ' || scale || ') ) * power(10, -1 * ' || scale || ') 
    = trunc( n/' || l_increment || ' ) * ' || l_increment || ' 
    = trunc( ' || n || '/' || l_increment || ' ) * ' || l_increment || '
    = trunc( ' || n / l_increment || ' ) * ' || l_increment || '
    = ' || trunc( n / l_increment ) || ' * ' || l_increment || '
    = ' || trunc( n/l_increment ) * l_increment
            );

    end loop;
end;
/
