create or replace procedure print_timing(
    p_start in timestamp, 
    p_records in number, 
    p_message in varchar2)
is
begin
    dbms_output.put_line(
        to_char(
            extract(second from (localtimestamp - p_start))
        , 'fm0.999999')
        || ' seconds for ' || p_records || ' rows: ' || p_message);
end print_timing;
/