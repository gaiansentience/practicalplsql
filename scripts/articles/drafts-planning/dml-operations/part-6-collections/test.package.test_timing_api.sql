prompt testing timing api
set serveroutput on;

begin

    test_timing_api.initialize;
    
    for i number(4,2) in 1..2 by 0.2 loop
    
        begin    
            test_timing_api.start_test('dbms_session.sleep - ' || i, i);
            
            case when i = 3 then
                raise program_error;
            else
                dbms_session.sleep(i);
            end case;
            
            test_timing_api.stop_test(print => true);
        
        exception
            when others then
                test_timing_api.print_error;
        end;
    
    end loop;
    
    test_timing_api.print_results;

end;
/
    
