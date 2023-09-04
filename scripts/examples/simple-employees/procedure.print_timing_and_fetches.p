create or replace procedure print_timing_and_fetches(
    p_start in timestamp, 
    p_fetches in number,
    p_records in number, 
    p_message in varchar2,
    p_single_line in boolean default false)
is
begin

    if not p_single_line then
    
    dbms_output.put_line(p_message);
    
    dbms_output.put_line(p_fetches || ' fetches for ' || p_records || ' rows');

    dbms_output.put_line(
        to_char(
            extract(second from (localtimestamp - p_start))
        , 'fm990.999999')
        || ' seconds for ' || p_records || ' rows');
    
    else
    
        dbms_output.put_line(
            rpad(p_message,40,'.')
            || 'fetches: ' || rpad(p_fetches,9,' ') 
            || 'rows: '|| rpad(p_records,9,' ') 
            || ' seconds: '
            || to_char(
                extract(second from (localtimestamp - p_start))
                , 'fm990.999999')            
        );
    
    end if;
        
end print_timing_and_fetches;
/
