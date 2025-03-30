--5.1-vector-division.sql

set serveroutput on;
declare 
    v1 vector := vector('[27,32]', *, int8);
    v2 vector := vector('[3,8]', *, int8);
begin
    show_vector_math('/', v1, v2, v1/v2);
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--PLS-00999: implementation restriction (may be temporary) Dimension-wise vector divide