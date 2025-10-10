create or replace package body data_api
is

     procedure get_ref_cursor(
          p_rows in number default 10,
          p_results out sys_refcursor)
     is
     begin
          open p_results for
          select level as id, 'item ' || level as info
          connect by level <= p_rows;

     end get_ref_cursor;
          
     procedure get_json(
          p_rows in number default 10,
          p_results out clob)
     is
     begin
          select json_arrayagg(
                    json_object(
                         'id' value level,
                         'info' value 'item ' || level
                    )
               returning clob value) into p_results
          connect by level <= p_rows;

     end get_json;

begin
     null;
end data_api;
/
