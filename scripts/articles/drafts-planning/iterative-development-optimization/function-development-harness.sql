
select s.sid, n.name, s.value from v$statname n
join v$sesstat s on s.statistic# = n.statistic#
where s.sid = sys_context('userenv','sid') and value > 0
and (n.name like '%CPU%' or name like '%memory%');


--function testing harness, timing only
set serveroutput on;
declare

type type_test_rec is record(
    test_name varchar2(100)
    , started timestamp default localtimestamp
    , ended timestamp default null
    , duration dsinterval_unconstrained
    , iterations number default null);
type type_test_nt is table of type_test_rec;
l_tests type_test_nt := type_test_nt();

procedure p(s in varchar2) is begin dbms_output.put_line(s); end p;

procedure print_results is begin
for i,v in pairs of l_tests loop
    p('test ' || i || json_serialize(json(v) returning varchar2));
end loop;
end print_results;

procedure start_test(tn in varchar2, i in number)
is 
begin
    l_tests.extend;
    l_tests(l_tests.last) := type_test_rec(test_name => tn, iterations => i);
end start_test;

procedure end_test
is
begin
    l_tests(l_tests.last).ended := localtimestamp;
    l_tests(l_tests.last).duration := l_tests(l_tests.last).ended - l_tests(l_tests.last).started;
end end_test;

    function multiply_numbers(x in number, y in number) return number
    is
    z number;
    begin
        execute immediate q'!
        begin
            select :x * :y
            into :z
            from dual;
        end;        
        !' 
        using x, y, out z;

        return z;
    end multiply_numbers;
    
    function refactor1(x in number, y in number) return number
    is
    z number;
    begin
        execute immediate q'!
        begin
            select :x * :y
            into :z;
        end;        
        !' 
        using x, y, out z;

        return z;
    end refactor1;
    
    function refactor2(x in number, y in number) return number
    is
    z number;
    begin
        execute immediate q'!
        begin
            :z := :x * :y;
        end;        
        !' 
        using out z, x, y;
        
        return z;
    end refactor2;
    
    function refactor3(x in number, y in number) return number
    is
    z number;
    begin
        execute immediate 'select :x * :y from dual' 
        into z
        using x, y;
        
        return z;
    end refactor3;
    
    function refactor4(x in number, y in number) return number
    is
    z number;
    begin
        execute immediate 'select :x * :y' 
        into z
        using x, y;

        return z;
    end refactor4;    

    function refactor5(x in number, y in number) return number
    is
    z number;
    begin
        select x * y 
        into z;

        return z;
    end refactor5;    

    function refactor6(x in number, y in number) return number
    is
    z number;
    begin
        z := x * y; 

        return z;
    end refactor6;  
    
    procedure run_tests(x in number, y in number, iterations in number default 10)
    is
    result number;
    begin
    
        start_test('current', iterations);
        for i in 1..iterations loop
            result := multiply_numbers(x, y);
        end loop;
        end_test;
        
        start_test('refactor1', iterations);
        for i in 1..iterations loop
            result := refactor1(x, y);
        end loop;
        end_test;
        
        start_test('refactor2', iterations);
        for i in 1..iterations loop
            result := refactor2(x, y);
        end loop;
        end_test;  
        
        start_test('refactor3', iterations);
        for i in 1..iterations loop
            result := refactor3(x, y);
        end loop;
        end_test; 

        start_test('refactor4', iterations);
        for i in 1..iterations loop
            result := refactor4(x, y);
        end loop;
        end_test; 
        
        start_test('refactor5', iterations);
        for i in 1..iterations loop
            result := refactor5(x, y);
        end loop;
        end_test; 
        
        start_test('refactor6', iterations);
        for i in 1..iterations loop
            result := refactor6(x, y);
        end loop;
        end_test;         
        
    end run_tests;
    
    

begin

    run_tests(42e7, 1.7e-3, 100);
        
    print_results;
end;
/
