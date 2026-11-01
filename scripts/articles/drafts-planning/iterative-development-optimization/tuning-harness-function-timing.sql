



--function testing harness, timing only
set serveroutput on;
declare

type type_test_rec is record(test_name varchar2(100), started timestamp default localtimestamp, ended timestamp, duration dsinterval_unconstrained
    , iterations number);
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
    l_tests(l_tests.last).test_name := tn;
    l_tests(l_tests.last).iterations := i;
    l_tests(l_tests.last).started := localtimestamp;
end start_test;

procedure end_test
is
begin
    l_tests(l_tests.last).ended := localtimestamp;
    l_tests(l_tests.last).duration := l_tests(l_tests.last).ended - l_tests(l_tests.last).started;
end end_test;

    --current procedure as implemented including parameters
    function test_current(n1 in number, n2 in number) return number
    is
    l_result number := 0;
    begin
        
        execute immediate 'select :n1 * :n2' 
        into l_result
        using n1, n2;
    
        return l_result;
    end test_current;

    function test_refactor#(n1 in number, n2 in number) return number
    is
    begin
        
        return n1 * n2;
        
    end test_refactor#;


    procedure run_tests(n1 in number, n2 in number, iterations in number default 10)
    is
    result number;
    begin
    
        start_test('current', iterations);
        for i in 1..iterations loop
            result := test_current(n1, n2);
        end loop;
        end_test;
                
        start_test('refactor#', iterations);
        for i in 1..iterations loop
            result := test_refactor#(n1, n2);
        end loop;
        end_test;  
                
    end run_tests;
    
    

begin

    run_tests(24, 42, 1);
    run_tests(42e7, 42e3, 100);
        
    print_results;
end;
/
