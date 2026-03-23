set serveroutput on;
declare
    procedure what_to_choose(true_today in boolean, true_always in boolean)
    is
        dynamic_data boolean;
        static_rules boolean;    
    begin
        dynamic_data := true_today and not true_always;
        static_rules := not dynamic_data;
    
        dbms_output.put_line(
            'When data is ' || case when dynamic_data then 'dynamic' else 'static' end
            || ' and rules are static then '
            || case when static_rules and not dynamic_data then 'unqualified assertions are better' 
                else ' assertions should ignore legacy data' end);
    end what_to_choose;
begin
    what_to_choose(true_today => true, true_always => true);
    what_to_choose(true_today => true, true_always => false);
end;
/