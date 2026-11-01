set feedback off
set serveroutput on
set pagesize 0

begin
    dbms_output.put_line(q'!
with base(input) as (
    select
    !');
end;
/
        

with base as (
    select 
        to_clob(rpad('!',1009, '99 red balloons!')) as input
        , 100 as script_linesize
    from dual
    
), size_input as (
    select 
        i.input_value, i.max_chunksize
        , dbms_lob.getlength(i.input_value) as input_length
    from (
        select 
            input as input_value
            , script_linesize as max_chunksize 
        from base
        ) i
), define_chunks as (
    select 
        s.input_value, pos.chunk#, pos.offset
        , least(s.max_chunksize, s.input_length - pos.offset + 1) as chunksize
    from 
        size_input s
        cross apply (
            select 
                level as chunk#
                , (level - 1) * s.max_chunksize + 1 as offset 
            connect by level <= ceil(s.input_length/s.max_chunksize)
            ) pos
), get_chunks as (
    select 
        d.chunk#, d.chunksize, d.offset
        , dbms_lob.substr(d.input_value, d.chunksize, d.offset) as chunk_text
        , json{d.chunk#, d.chunksize, d.offset} as chunk_info
    from define_chunks d
), script_chunks as (
    select
        g.chunk#, g.chunk_info, g.chunk_text
        , case when g.chunk# > 1 then '|| ' end 
        || q'~to_clob(q'[~' || g.chunk_text || q'~]')~' 
        || ' --' || g.chunk_info
        as output
    from get_chunks g
)
select output
from script_chunks
order by chunk#
/


begin
    dbms_output.put_line(q'!
    as input
    --from dual 
)
select input 
from base
/
    !');
end;
/


spool off

set feedback on