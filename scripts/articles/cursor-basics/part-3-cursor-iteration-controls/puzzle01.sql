set serveroutput on;
set feedback off;

prompt Challenge:  Implementing limit with cursor iteration control
declare
    l_limit number := 25;
    cursor c is
        select level as id
        from dual 
        connect by level <= 111;

    type t_rows is table of c%rowtype;

    l_rows t_rows := t_rows();
    i number := 0;
begin

    dbms_output.put_line('Method 1:  process cursor with bulk collect and limit');
    open c;
	loop
		fetch c bulk collect into l_rows limit l_limit;
		exit when l_rows.count = 0;
        i := i + l_rows.count;
        dbms_output.put_line('processing batch of ' || l_rows.count || ' rows');
	end loop;
    close c;
    dbms_output.put_line('processed total of ' || i || ' rows');
	
	l_rows.delete;
    i := 0;

    dbms_output.put_line('Method 2:  process cursor rows with iteration control');
    l_rows := t_rows(for r in values of c sequence => r);
    dbms_output.put_line('processing batch of ' || l_rows.count || ' rows');
    i := i + l_rows.count;
    dbms_output.put_line('processed total of ' || i || ' rows');
    
end;
/

/* Script Output:
Challenge:  Implementing limit with cursor iteration control
Method 1:  process cursor with bulk collect and limit
processing batch of 25 rows
processing batch of 25 rows
processing batch of 25 rows
processing batch of 25 rows
processing batch of 11 rows
processed total of 111 rows
Method 2:  process cursor rows with iteration control
processing batch of 111 rows
processed total of 111 rows
*/