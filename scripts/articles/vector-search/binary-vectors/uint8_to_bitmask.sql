set serveroutput on;


declare
    my_uint8 number := 171;
    my_byte varchar2(8) := '10101011';
    
    function uint8_to_byte(p_uint8 in integer, p_debug in boolean default false)
    return varchar2
    is
        x number;
        l_bit number;
        l_byte varchar2(8);
    begin
        if p_uint8 >= power(2,8) then
            raise_application_error(-20101, 'Overflow: ' || p_uint8 || ' is greater than uuint8 max size of ' || (power(2,8) - 1));
        elsif p_uint8 < 0 then
            raise_application_error(-20102, 'Range Error: ' || p_uint8 || ' is outside the range of an unsigned 8 bit integer');
        end if;
        x := p_uint8;
        if p_debug then dbms_output.put_line('input ' || p_uint8 || ' uint8'); end if;
        for pwr in reverse 0..7 loop
            if power(2,pwr) > x then
                l_bit := 0;
            else 
                l_bit := 1;
                x := x - power(2,pwr);
            end if;
            if p_debug then dbms_output.put_line('    bit ' || (pwr + 1) || ' is ' || l_bit || ' = ' || l_bit || ' * 2 exp' || pwr || ' = ' || (l_bit * power(2,pwr))); end if;
            l_byte := l_byte || l_bit;        
        end loop;
        if p_debug then dbms_output.put_line('output ' || l_byte || ' binary'); end if;
        if p_debug then dbms_output.put_line(p_uint8 || ' uint8 = ' || l_byte || ' binary'); end if;
        return l_byte;
    end uint8_to_byte;

    function byte_to_uint8(p_byte in varchar2, p_debug in boolean default false) return integer
    is
        l_bit number;
        l_power2 number;
        l_bit_as_uint8 number;
        l_uint8 number := 0;
    begin
        if p_debug then dbms_output.put_line('input byte = '|| p_byte); end if;
        for i in 1..8 loop
            l_bit := substr(p_byte, i, 1);
            l_power2 := 8 - i;
            l_bit_as_uint8 := l_bit * power(2,l_power2);
            l_uint8 := l_uint8 + l_bit_as_uint8;
            if p_debug then dbms_output.put_line('    bit ' || i || ' is ' || l_bit || ' = ' || l_bit || ' * 2 exp' || l_power2 || '=' || l_bit_as_uint8); end if;
        end loop;
        if p_debug then dbms_output.put_line('output uint8 = ' || l_uint8); end if;
        if p_debug then dbms_output.put_line(p_byte || ' binary = ' || l_uint8 || ' uint8'); end if;
        return l_uint8;
    end byte_to_uint8;

begin
--dbms_output.put_line('uint8 to byte expansion');
--for i in 0..255 loop
--my_uint8 := i;
--my_byte := uint8_to_byte(my_uint8);
--dbms_output.put_line(lpad(i,3,' ') || ' uint8 = ' || uint8_to_byte(my_uint8) || ' binary = ' || lpad(byte_to_uint8(my_byte),3,' ') || ' uint8');
--end loop;


dbms_output.put_line(uint8_to_byte(42));

end;
/