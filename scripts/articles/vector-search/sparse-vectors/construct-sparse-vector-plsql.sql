--construct-sparse-vector-plsql.sql
set serveroutput on;

--construct a sparse vector in plsql from sparse textual input
declare
    v vector;
begin
    v := vector('[8,[0,3,5],[11,33,77]]',*,int8,sparse);
    dbms_output.put_line(from_vector(v));
end;
/
--[8,[0,3,5],[11,33,77]]

--omitting the number of dimensions from the sparse input fails in plsql
declare
    v vector;
begin
    v := to_vector('[[0,3,5],[11,33,77]]',8,int8,sparse);
    dbms_output.put_line(from_vector(v));
end;
/
--ORA-51862: VECTOR library processing error in 'vectorliberr=LVECTOR_UNKNOWN_ERR/-221/0 from pevm_VEC_CONS'

--constructing a sparse vector in plsql from dense vector fails
declare
    v_dense vector;
    v_sparse vector;
begin
    v_dense := to_vector('[0,0,3,0,7,0,0,0]',*,int8);
    v_sparse := to_vector(v_dense,*,int8, sparse);
    dbms_output.put_line(from_vector(v_sparse));
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--PLS-00306: wrong number or types of arguments in call to 'TO_VECTOR'


--constructing a sparse vector in plsql from a dense vector requires sql
declare
    v_dense vector;
    v_sparse vector;
begin
    v_dense := to_vector('[0,0,3,0,7,0,0,0]',*,int8);
    select to_vector(v_dense,*,int8, sparse)
    into v_sparse;
    dbms_output.put_line(from_vector(v_sparse));
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
--[8,[2,4],[3,7]]

