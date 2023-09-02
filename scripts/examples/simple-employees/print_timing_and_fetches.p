create or replace procedure print_timing_and_fetches(
    p_start in timestamp, 
    p_fetches in number,
    p_records in number, 
    p_message in varchar2)
is
begin
    dbms_output.put_line(p_message);
    
    dbms_output.put_line(p_fetches || ' fetches for ' || p_records || ' rows');

    dbms_output.put_line(
        to_char(
            extract(second from (localtimestamp - p_start))
        , 'fm990.999999')
        || ' seconds for ' || p_records || ' rows');
        
end print_timing_and_fetches;
/
