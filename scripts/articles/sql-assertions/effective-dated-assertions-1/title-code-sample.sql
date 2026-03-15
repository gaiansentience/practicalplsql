set serveroutput on;
declare
    procedure what_to_choose(true_today in boolean, true_always in boolean)
    is
        dynamic_data boolean;
    begin
        dynamic_data := true_today and not true_always;
    
        dbms_output.put_line(
            'When data is ' || case when dynamic_data then 'dynamic' else 'static' end
            || ' and rules are inflexible then ' 
            || case when not dynamic_data then 'universal assertions are great' 
                else 'universal assertions have issues' end);
    end what_to_choose;
begin
    what_to_choose(true_today => true, true_always => true);
    what_to_choose(true_today => true, true_always => false);
end;
/