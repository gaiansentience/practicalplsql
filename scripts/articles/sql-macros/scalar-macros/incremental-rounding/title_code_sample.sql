set serveroutput on;
declare
    l_pies number := 0.42;
    l_serving_size number := 1/8;
    l_servings_left number;
    l_approximate_pies number;
begin

    l_servings_left := trunc(l_pies/l_serving_size);
    dbms_output.put_line('Still ' || l_servings_left || ' pieces of pie');
    
    l_approximate_pies := floor(l_pies/l_serving_size) * l_serving_size;
    dbms_output.put_line('Based on servings, there are ' || l_approximate_pies || ' pies left');

end;
/