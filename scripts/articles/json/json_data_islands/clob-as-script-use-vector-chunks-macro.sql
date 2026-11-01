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
   


with 
function script_clob(input_clob in clob) return varchar2 sql_macro(table)
is
begin

    return q'!
    
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
            from vector_chunks(script_clob.input_clob by characters max 50 split none) c
                )
        ) g --get_chunks
    
    !';
end script_clob;



base as (
select to_clob(rpad('!',1009, '99 red balloons!')) as input
)

select c.chunk_script
from 
    base b 
    cross apply (select * from script_clob(b.input)) c
order by c.chunk#
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