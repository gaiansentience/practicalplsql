set serveroutput on;
declare
    n number := 1234.56789;

    function floor_scaled(p_n in number, p_scale in integer default 0) return number
    is
        l_increment number := power(10, -1 * p_scale);
    begin
        return floor(p_n/l_increment) * l_increment;
    end floor_scaled;   
begin
    dbms_output.put_line('n = ' || n);
    dbms_output.put_line('floor(n) = ' || floor(n));
    for scale in reverse -2..2 loop
        dbms_output.put_line('
floor_scaled(n, ' || scale || ')
    = floor( n/power(10, -1 * ' || scale || ') ) * power(10, -1 * ' || scale || ')
    = floor( n/' || power(10, -1 * scale) || ' ) * ' || power(10, -1 * scale) || '
    = floor( ' || n || '/' || power(10, -1 * scale) || ' ) * ' || power(10, -1 * scale) || '
    = floor( ' || n / power(10, -1 * scale) || ' ) * ' || power(10, -1 * scale) || '
    = ' || floor( n / power(10, -1 * scale) ) || ' * ' || power(10, -1 * scale) || '
    = ' || floor_scaled(n, scale)
        );
    end loop;
end;
/
