set feedback off;
set serveroutput on;

prompt Using an Iteration Control as an Array Constructor
declare
    type t_table is table of number index by pls_integer;
    l_rows t_table;
begin
    l_rows := t_table(for i in 0..4 index i => power(2, i));
    
    dbms_output.put_line('Powers of 2:');
    for i in indices of l_rows loop
        dbms_output.put_line(i || ' => ' || l_rows(i));
    end loop;    
end;
/

/* Script Output:
Using an Iteration Control as an Array Constructor
Powers of 2:
0 => 1
1 => 2
2 => 4
3 => 8
4 => 16
*/