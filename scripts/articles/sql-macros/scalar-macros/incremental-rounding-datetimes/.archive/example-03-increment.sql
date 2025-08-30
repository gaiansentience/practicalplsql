set serveroutput on;
declare
    n number := 1234.56789;

    function increment_value(
        p_n in number
        , p_increment in number
        , p_mode in integer default 1
    ) return number
    is
    begin
        return case p_mode
            when 1 then ceil(p_n/p_increment) * p_increment
            when -1 then floor(p_n/p_increment) * p_increment
            else round(p_n/p_increment) * p_increment
            end;
    end increment_value;   
begin
    dbms_output.put_line('n = ' || n);

    for l_increment number in 
        1/32, 1/8, 1/4, 1/2
        , 2, 5, 12, 50, 144 
    loop
        
        dbms_output.put_line('
floor(n by ' || l_increment || ') = ' || increment_value(n, l_increment, -1) || '
ceil(n by ' || l_increment || ') = ' || increment_value(n, l_increment, 1) 
        );

    end loop;    

end;
/
