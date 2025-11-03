create or replace package data_api authid definer 
is

    type data_rec is record(
        id number,
        info varchar2(100)
    );
    
    type data_tab is table of data_rec;
    
    type rc_data is ref cursor return data_rec;
    
     procedure get_ref_cursor(
          p_rows in number default 10,
          p_results out rc_data);
          
    function fget_ref_cursor(
        p_rows in number default 10
    ) return rc_data;
          
    procedure get_json(
        p_rows in number default 10,
        p_results out clob);
          
    function fget_json(
        p_rows in number default 10
    ) return clob;
          
    function loopback(
        p_value in number default 1)
    return number;
     
end data_api;
/
