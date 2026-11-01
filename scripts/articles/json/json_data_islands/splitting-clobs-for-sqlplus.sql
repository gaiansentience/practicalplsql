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
        , 100 as max_chunk
    from dual
), evaluate_input as (
    select 
        l.input, l.input_length, l.max_chunk
        , ceil(l.input_length/l.max_chunk) as chunk_count
    from (
        select 
            b.input
            , dbms_lob.getlength(b.input) as input_length
            , b.max_chunk
        from (
            select input, max_chunk 
            from base
            ) b
        ) l
), estimate_chunks as (
    select 
        u.input
        , p.chunk#
        , p.chunk_offset
        , least(u.max_chunk, u.input_length - p.chunk_offset + 1) as chunk_size
    from 
        evaluate_input u
        cross apply (
            select 
                level as chunk#
                , (level - 1) * u.max_chunk + 1 as chunk_offset 
            from dual
            connect by level <= u.chunk_count
            ) p
), get_chunks as (
    select 
        chunk_text, chunk#, chunk_size, chunk_offset, chunk_end
        , json{'chunk' value {chunk#, chunk_size, chunk_offset, chunk_end}} as chunk_info
       -- , json_object('chunk' value json_object(chunk#, chunk_size, chunk_offset, chunk_end)) as chunk_info
    from (
        select 
            e.chunk#
            , e.chunk_size
            , e.chunk_offset
            , e.chunk_offset + e.chunk_size - 1 as chunk_end
            , dbms_lob.substr(e.input, e.chunk_size, e.chunk_offset) as chunk_text
        from estimate_chunks e)
), script_chunks as (
    select
        chunk#, chunk_info, chunk_text
        , case when chunk# > 1 then '|| ' end 
        || q'~to_clob(q'[~' || chunk_text || q'~]')~' 
        || ' --' || chunk_info
        as output
    from get_chunks
    order by chunk#
)
select output
from script_chunks
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