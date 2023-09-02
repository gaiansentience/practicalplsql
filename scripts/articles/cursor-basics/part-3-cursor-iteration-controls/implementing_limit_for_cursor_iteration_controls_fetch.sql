set serveroutput on;
set feedback off;

prompt implementing limit with cursor iteration controls: offset fetch
declare

    l_rows number := 130;
    l_limit number := 11;

    cursor c is
        select level as id
        from dual 
        connect by level <= l_rows;

    cursor c_limit(p_offset number) is
        select id
        from
            (
            select level as id
            from dual 
            connect by level <= l_rows
            ) 
        order by id
        offset p_offset rows
        fetch first l_limit rows only;

    type t_rows is table of c%rowtype;

    l_fetch_rows t_rows;
    l_all_rows t_rows := t_rows();
    i number := 0;
begin

    open c;
	loop
		fetch c bulk collect into l_fetch_rows limit l_limit;
		exit when l_fetch_rows.count = 0;
		l_all_rows := l_all_rows multiset union l_fetch_rows;
	end loop;
    close c;
	dbms_output.put_line('bulk collect with limit: ' || l_all_rows.count);
	
	l_all_rows.delete;

    loop
		l_fetch_rows := t_rows(for r in values of c_limit(i) sequence => r);
		exit when l_fetch_rows is null or l_fetch_rows.count = 0;
        i := i + l_fetch_rows.count;
		l_all_rows := l_all_rows multiset union l_fetch_rows;
    end loop;    
    dbms_output.put_line('iteration control array constructor ' || l_all_rows.count);
    
end;
/