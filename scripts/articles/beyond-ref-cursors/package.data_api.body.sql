create or replace package body data_api
is

     procedure get_ref_cursor(
          p_rows in number default 10,
          p_results out rc_data)
     is
     begin
          open p_results for
          select level as id, 'item ' || level as info
          connect by level <= p_rows;

     end get_ref_cursor;
     
    function fget_ref_cursor(
        p_rows in number default 10
    ) return rc_data
    is
        rc rc_data;
    begin
        get_ref_cursor(p_rows, rc);
        return rc;
    end fget_ref_cursor;
          
    procedure get_json(
        p_rows in number default 10,
        p_results out clob)
    is
        rc rc_data;
        t data_tab;
    begin
    
        get_ref_cursor(p_rows, rc);
        fetch rc bulk collect into t;
        close rc;
        
        select json_arrayagg(json_object(c.*) returning clob)
        into p_results
        from table(t) c;
    
    end get_json;
    
    function fget_json(
        p_rows in number default 10
    ) return clob
    is
        c clob;
    begin
        get_json(p_rows, c);
        return c;
    end fget_json;
     
    function loopback(
        p_value in number default 1)
    return number
    is
    begin
        return p_value;
    end loopback;

begin
     null;
end data_api;
/
