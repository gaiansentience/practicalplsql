create or replace package data_api authid definer 
is

     procedure get_ref_cursor(
          p_rows in number default 10,
          p_results out sys_refcursor);
          
     procedure get_json(
          p_rows in number default 10,
          p_results out clob);
     
end data_api;
/
