

create or replace package test_cursors
as

    type data_rec is record(
        id number,
        info varchar2(100)
    );
    
    type data_tab is table of data_rec;
    
    type rc_data is ref cursor return data_rec;
    
    procedure get_data(
        details out rc_data);
        
    procedure get_data_json(
        details out json);
    

end test_cursors;
/

create or replace package body test_cursors
as

    procedure get_data(
        details out rc_data
    )
    is
    begin
    
        open details for
        select level as id, 'info ' || level as info
        from dual
        connect by level <= 10;
        
    end get_data;
    
    procedure get_data_json(
        details out json
    )
    is
        t data_tab;
        rc rc_data;
    begin
        get_data(rc);
        fetch rc bulk collect into t;
        close rc;
        
        select json_arrayagg(json_object(c.*))
        into details
        from table(t) c;
        
    end get_data_json;
    
end test_cursors;
/

set serveroutput on;
declare
    rc test_cursors.rc_data;
    t test_cursors.data_tab;
    j json;
begin

    test_cursors.get_data(rc);
    
    fetch rc bulk collect into t;
    
    close rc;
    
    for i in 1..t.count loop
    
        dbms_output.put_line(t(i).id || ': ' || t(i).info);
        
    end loop;
    
    select json_arrayagg(json_object(c.*))
    into j
    from table(t) c;
    
    dbms_output.put_line(json_serialize(j returning clob pretty));
    
end;
/

declare
    j json;
begin
    test_cursors.get_data_json(j);
    dbms_output.put_line(json_serialize(j returning clob pretty));
end;
/