set serveroutput on;
declare
    n number := 1234.56789;

    function ceil_scaled(p_n in number, p_scale in integer default 0) return number
    is
        l_increment number := power(10, -1 * p_scale);
    begin
        return ceil(p_n/l_increment) * l_increment;
    end ceil_scaled;   
begin
    dbms_output.put_line('n = ' || n);
    dbms_output.put_line('ceil(n) = ' || ceil(n));
    for scale in reverse -2..2 loop
        dbms_output.put_line('
ceil_scaled(n, ' || scale || ')
    = ceil( n/power(10, -1 * ' || scale || ') ) * power(10, -1 * ' || scale || ')
    = ceil( n/' || power(10, -1 * scale) || ' ) * ' || power(10, -1 * scale) || '
    = ceil( ' || n || '/' || power(10, -1 * scale) || ' ) * ' || power(10, -1 * scale) || '
    = ceil( ' || n / power(10, -1 * scale) || ' ) * ' || power(10, -1 * scale) || '
    = ' || ceil( n / power(10, -1 * scale) ) || ' * ' || power(10, -1 * scale) || '
    = ' || ceil_scaled(n, scale)
        );
    end loop;
end;
/
