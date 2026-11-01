set feedback off
column chunk_script format a4000
set serveroutput on
set pagesize 0

begin
    dbms_output.put_line(q'!
with base(input) as (
    select
    !');
end;
/
        
--prepare for macro: convert all parsing cte to inline views
with base as (
    select 
        to_clob(rpad('!',1009, '99 red balloons!')) as input
        , 100 as script_linesize
    from dual
    
), script_chunks as (
    select
        g.chunk#, g.chunk_info, g.chunk_text
        , case when g.chunk# > 1 then '|| ' end 
        || q'~to_clob(q'[~' || g.chunk_text || q'~]')~' 
        || ' --' || g.chunk_info
        as chunk_script
    from (
        select 
            d.chunk#, d.chunksize, d.offset
            , dbms_lob.substr(d.input_value, d.chunksize, d.offset) as chunk_text
            , json{d.chunk#, d.chunksize, d.offset} as chunk_info
        from (
            select 
                s.input_value, pos.chunk#, pos.offset
                , least(s.max_chunksize, s.input_length - pos.offset + 1) as chunksize
            from 
                (
                select 
                    i.input_value, i.max_chunksize
                    , dbms_lob.getlength(i.input_value) as input_length
                from (
                    select 
                        input as input_value
                        , script_linesize as max_chunksize 
                    from base
                    ) i                
                ) s --size_input
                cross apply (
                    select 
                        level as chunk#
                        , (level - 1) * s.max_chunksize + 1 as offset 
                    connect by level <= ceil(s.input_length/s.max_chunksize)
                    ) pos        
            ) d --define_chunks
        ) g --get_chunks
)
select chunk_script
from script_chunks
order by chunk#
/


begin
    dbms_output.put_line(q'!
    as input
)
select input 
from base
/
    !');
end;
/


spool off

set feedback on