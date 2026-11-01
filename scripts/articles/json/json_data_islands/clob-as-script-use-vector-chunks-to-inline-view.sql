set feedback off
set serveroutput on
set pagesize 0


begin
    dbms_output.put_line(q'!
select
    !');

end;
/

with base as (
    select 
        to_clob(rpad('!',1009, '99 red balloons!')) as input
        , 50 as max_chunk
    from dual
    
), script_chunks as (
    select
        g.chunk#, g.chunk_info, g.chunk_text
        , case when g.chunk# > 1 then '|| ' end 
        || q'~to_clob(q'[~' || g.chunk_text || q'~]')~' 
        || ' --' || g.chunk_info
        as chunk_script
    from (
        select chunk#, chunksize, offset, chunk_text
            , json{chunk#, chunksize, offset} as chunk_info
        from (
            select 
                row_number() over (order by c.chunk_offset) as chunk#
                , c.chunk_length as chunksize
                , c.chunk_offset as offset
                , c.chunk_text
            from 
                base b
                cross apply vector_chunks(b.input by characters max 50 split none) c
                )
        ) g --get_chunks
)
select chunk_script
from script_chunks
order by chunk#
/

begin
    dbms_output.put_line(q'!
as input
--from dual
/
!');

end;
/

set feedback on



