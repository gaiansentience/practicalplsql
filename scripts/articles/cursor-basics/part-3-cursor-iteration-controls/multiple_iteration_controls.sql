prompt Using Multiple Iteration Controls
begin
    for i in 1..3, 4, REVERSE 1..3  loop
        dbms_output.put_line(i);
    end loop;
end;
/

/*Script output
Using Multiple Iteration Controls
1
2
3
4
3
2
1
*/