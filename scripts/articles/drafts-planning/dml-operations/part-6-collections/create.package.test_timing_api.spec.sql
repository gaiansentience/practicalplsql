


create or replace package test_timing_api as

    subtype t_test_name is varchar2(100);
    
    type t_test_rec is record (
        name t_test_name,
        details number,
        started timestamp,
        duration interval day to second(9) default null
        );

    type t_test_nt is table of t_test_rec;

    procedure start_test(name in t_test_name, details in number default null);
    
    procedure stop_test(print in boolean default false);
    
    procedure print_error;
    
    procedure print_results;
    
    procedure initialize;
    
end test_timing_api;
/

