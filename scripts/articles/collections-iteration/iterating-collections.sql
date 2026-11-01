set serveroutput on;
declare
     type names_aa is table of varchar2(20) index by pls_integer;
     n names_aa := names_aa('cat', 'dog', 'bird');
begin

    dbms_output.put_Line('1 => ' || n(1));
    dbms_output.put_Line('2 => ' || n(2));
    dbms_output.put_Line('3 => ' || n(3));
    
end;
/



--numeric indexes

--dense with simple loop from 1 to count
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
    i pls_integer := 1;
begin
    loop
        dbms_output.put_line(i || ' => ' || n(i));
        i := n.next(i);
        exit when i = n.count;
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--iteration in reverse order
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
    i pls_integer := n.count;
begin
    loop
        dbms_output.put_line(i || ' => ' || n(i));
        i := n.prior(i);
        exit when i = 1;
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/


--dense using while loop
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
    i pls_integer := 1;
begin
    while i <= n.count loop
        dbms_output.put_line(i || ' => ' || n(i));
        i := n.next(i);
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--dense, starting with 1, implicit iterator, from 1 to count
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin

    for i in 1..n.count loop
        dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin

    for i in reverse 1..n.count loop
        dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/


--dense, not starting from 1, from 1 to count gets no_data_found
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa(3 => 'cat', 4 => 'dog', 5 => 'bird');
begin

    for i in 1..n.count loop
        dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--dense, not starting from 1, from 1 to count with exists check, count <> last, misses elements
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa(3 => 'cat', 4 => 'dog', 5 => 'bird');
begin

    for i in 1..n.count loop
        if n.exists(i) then
            dbms_output.put_line(i || ' => ' || n(i));
        else
            dbms_output.put_line(i || ' does not exist');
        end if;
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--dense, not starting from 1, from first to last
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa(3 => 'cat', 4 => 'dog', 5 => 'bird');
begin

    for i in n.first..n.last loop
        dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--using reverse for last to first iteration
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa(3 => 'cat', 4 => 'dog', 5 => 'bird');
begin

    for i in reverse n.first..n.last loop
        dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/


--sparse, 1 to count
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin

    n.delete(2);
    for i in 1..n.count loop
        dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--sparse, first to last
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin

    n.delete(2);
    for i in n.first..n.last loop
        dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--sparse, first to last, exists check
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin

    n.delete(2);
    for i in n.first..n.last loop
        if n.exists(i) then
            dbms_output.put_line(i || ' => ' || n(i));
        else
            dbms_output.put_line('element ' || i || ' does not exist');
        end if;
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--sparse, use next to only iterate present elements
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
    i pls_integer := n.first;
begin

    n.delete(2);
    while i is not null loop
        dbms_output.put_line(i || ' => ' || n(i));
        i := n.next(i);
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
    i pls_integer := n.first;
begin

    n.delete(2);
    loop
        dbms_output.put_line(i || ' => ' || n(i));
        i := n.next(i);
        exit when i is null;
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/


--string indexes cant iterate from 1 to count
declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('a' => 'apple', 'x' => 'orange', 'n' => 'plum');
begin

    for i in 1..n.count loop
        dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--string indexes cant iterate from first to last (string index wont convert to a number)
declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('a' => 'apple', 'x' => 'orange', 'n' => 'plum');
begin

    for i in n.first..n.last loop
      dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--use simple loop to iterate string indexes with exit condition
declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('z' => 'apple', 'x' => 'orange', 'y' => 'banana');
    i varchar2(2) := n.first;
begin

    loop
        dbms_output.put_line(i || ' => ' || n(i));
        i := n.next(i);
        exit when i is null;
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--use next to iterate string indexes
declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('a' => 'apple', 'b' => 'orange', 'c' => 'banana');
    i varchar2(2) := n.first;
begin

    while i is not null loop
        dbms_output.put_line(i || ' => ' || n(i));
        i := n.next(i);
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--string array cannot have null index
begin
    declare
        type names_aa is table of varchar2(20) index by varchar2(2);
        n names_aa := names_aa(null => 'apple', 'b' => 'orange', 'c' => 'banana');
        i varchar2(2) := n.first;
    begin
    
        while i is not null loop
            dbms_output.put_line(i || ' => ' || n(i));
            i := n.next(i);
        end loop;
    
    exception
      when others then
        dbms_output.put_line(sqlerrm);
    end;
exception
  when others then
    dbms_output.put_line('outer error: ' || sqlerrm);
end;
/

--can use empty string for index, looks like a null for most purposes, while not null misses it
begin
    declare
        type names_aa is table of varchar2(20) index by varchar2(2);
        n names_aa := names_aa('' => 'apple', 'b' => 'orange', 'c' => 'banana');
        i varchar2(2) := n.first;
    begin
        dbms_output.put_line(n'#' || i || '# =>' || n(i));
        while i is not null loop
            dbms_output.put_line(i || ' => ' || n(i));
            i := n.next(i);
        end loop;
    
    exception
      when others then
        dbms_output.put_line(sqlerrm);
    end;
exception
  when others then
    dbms_output.put_line('outer error: ' || sqlerrm);
end;
/

--can use empty string for index, looks like a null for most purposes, simple loop works
begin
    declare
        type names_aa is table of varchar2(20) index by varchar2(2);
        n names_aa := names_aa('' => 'apple', 'b' => 'orange', 'c' => 'banana');
        i varchar2(2) := n.first;
    begin
        dbms_output.put_line(n'#' || i || '# =>' || n(i));
        loop
            exit when not n.exists(i);            
            dbms_output.put_line(i || ' => ' || n(i));
            i := n.next(i);
        end loop;
    
    exception
      when others then
        dbms_output.put_line(sqlerrm);
    end;
exception
  when others then
    dbms_output.put_line('outer error: ' || sqlerrm);
end;

/


--iterating string indexes, next is always based on alphabetical sort
declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('z' => 'apple', 'x' => 'orange', 'y' => 'banana');
    i varchar2(2) := n.first;
begin

    while i is not null loop
      dbms_output.put_line(i || ' => ' || n(i));
      i := n.next(i);
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/





--indices of
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin

    for i in indices of n loop
      dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--indices of with reverse
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin

    for i in reverse indices of n loop
      dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/


declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin
    n.delete(2);
    for i in indices of n loop
        dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/


declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('a' => 'apple', 'x' => 'orange', 'n' => 'plum');
begin

    for i in indices of n loop
      dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('a' => 'apple', 'x' => 'orange', 'n' => 'plum');
begin

    for i in reverse indices of n loop
      dbms_output.put_line(i || ' => ' || n(i));
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--21c enhancements

--values of
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin
    n.delete(2);
    for v in values of n loop
        dbms_output.put_line('? => ' || v);
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/


declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('a' => 'apple', 'x' => 'orange', 'n' => 'plum');
begin

    for v in values of n loop
        dbms_output.put_line('? => ' || v);
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--values of applies a sort
declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('a' => 'plum', 'x' => 'apple', 'n' => 'orange');
begin

    for v in values of n loop
        dbms_output.put_line('? => ' || v);
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

--pairs of

declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird');
begin
    n.delete(2);
    for i, v in pairs of n loop
      dbms_output.put_line(i || ' => ' || v);
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/


declare
    type names_aa is table of varchar2(20) index by varchar2(2);
    n names_aa := names_aa('a' => 'apple', 'x' => 'orange', 'n' => 'plum');
begin

    for i, v in pairs of n loop
      dbms_output.put_line(i || ' => ' || v);
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/


--mutable indexes
declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird','frog');
begin

    for i mutable in 1..n.count loop
        dbms_output.put_line('start iteration i = ' || i);
        dbms_output.put_line(i || ' => ' || n(i));
        if mod(i,2) = 0 then
            i := i + 1;
        end if;
        dbms_output.put_line('end iteration i = ' || i);

    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/

declare
    type names_aa is table of varchar2(20) index by pls_integer;
    n names_aa := names_aa('cat','dog','turtle','bird','frog');
    loop_counter pls_integer := 1;
begin

    for i mutable in 1..n.count loop
        dbms_output.put_line(i || ' => ' || n(i));
        i := case i
                when 2 then 4
                when 5 then 2
                else i
            end;
        loop_counter := loop_counter + 1;
        exit when loop_counter > 10;
    end loop;

exception
  when others then
    dbms_output.put_line(sqlerrm);
end;
/



--mutating collections