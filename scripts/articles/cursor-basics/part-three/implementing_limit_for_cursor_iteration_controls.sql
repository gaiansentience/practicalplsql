set serveroutput on;
declare

    l_rows number := 130;
    l_limit number := 11;
    l_buckets number := ceil(l_rows/l_limit);

    cursor c is
        select level as id
        from dual 
        connect by level <= l_rows;

    cursor c1(b number) is
        select id
        from
            (
            select level as id, ntile(l_buckets) over (order by level) as ntile_bucket
            from dual 
            connect by level <= l_rows
            ) 
        where ntile_bucket = b;

    type t is table of c%rowtype;

    l t;
    m t := t();
    i number := 0;
begin

    open c;
	loop
		fetch c bulk collect into l limit l_limit;
		exit when l.count = 0;
		m := m multiset union l;
	end loop;
    close c;
	dbms_output.put_line('bulk collect with limit: ' || m.count);
	
	m.delete;

    for i in 1..l_buckets loop
		l := t(for r in values of c1(i) sequence => r);
		exit when l is null or l.count = 0;
		m := m multiset union l;
    end loop;    
    dbms_output.put_line('iteration control array constructor ' || m.count);
    
end;
/