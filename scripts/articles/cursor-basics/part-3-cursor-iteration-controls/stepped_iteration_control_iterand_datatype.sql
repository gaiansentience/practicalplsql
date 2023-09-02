prompt Stepped iteration control specifies datatype for iterator
begin
    for i number in 1..3 by 0.5 loop
        dbms_output.put(i);
    end loop;
end;
/

/*Script output
Stepped iteration control specifies datatype for iterator
1
1.5
2
2.5
3
*/