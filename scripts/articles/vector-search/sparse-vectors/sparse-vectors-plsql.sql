set serveroutput on;

create or replace procedure print_vector(v in vector)
is
    f varchar2(20);
    n number;
    t clob;
begin
    f := vector_dimension_format(v);
    n := vector_dimension_count(v);
    --n := vector_dims(v);
    --t := from_vector(v);
    t := vector_serialize(v);
    dbms_output.put_line('Vector has ' ||  n || ' dimensions in ' || f || ' format.');
    dbms_output.put_line(t);
end print_vector;
/

declare
    v vector;
    t varchar2(1000) := '[1,2,0,0,0,6,7,0]';
begin
    v := to_vector(t, *, int8, dense);
    print_vector(v);
end;
/
    
declare
    v vector;
    t varchar2(1000) := '[8,[0,1,5,6],[1,2,6,7]]';
begin
    v := to_vector(t, *, int8, sparse);
    print_vector(v);        
end;
/    



declare
    v_dense vector;
    v_sparse vector;
    t varchar2(1000) := '[1,2,0,0,0,6,7,0]';
begin
    v_dense := to_vector(t, *, int8, dense);
    print_vector(v_dense);
    
    --v_sparse := to_vector(v_dense, *, *, sparse);
    --PLS-00306: wrong number or types of arguments in call to 'TO_VECTOR'    
end;
/

declare
    v_dense vector;
    v_sparse vector;
    t varchar2(1000) := '[1,2,0,0,0,6,7,0]';
begin
    v_dense := to_vector(t, *, int8, dense);
    print_vector(v_dense);
    
    select to_vector(v_dense, *, *, sparse) into v_sparse;
    print_vector(v_sparse);  
end;
/

declare
    v_dense vector;
    v_sparse vector;
    t varchar2(1000) := '[1,2,0,0,0,6,7,0]';
begin
    v_dense := to_vector(t, *, int8, dense);
    print_vector(v_dense);
    
    --t := from_vector(v_dense returning clob format sparse);
    --PLS-00103: Encountered the symbol "FORMAT" when expecting one of the following:
    
    select from_vector(v_dense returning clob format sparse) into t;
    dbms_output.put_line('serialized to sparse storage format: ' || t);
    v_sparse := to_vector(t, *, int8, sparse);
    print_vector(v_sparse);  
end;
/

declare
    v_dense vector;
    v_sparse vector;
    t varchar2(1000) := '[1,2,0,0,0,6,7,0]';
begin
    v_dense := to_vector(t, *, int8, dense);
    print_vector(v_dense);
    
    --t := from_vector(v_dense returning clob format sparse);
    --PLS-00103: Encountered the symbol "FORMAT" when expecting one of the following:
    
    select from_vector(v_dense returning varchar2(1000) format sparse) into t;
    dbms_output.put_line('serialized to sparse storage format: ' || t);
    v_sparse := to_vector(t, *, int8, sparse);
    print_vector(v_sparse);  
end;
/

declare
    v vector;
    t varchar2(1000);
    f varchar2(20);
    n number;
begin
    v := to_vector('[8,[0,1,5,6],[1,2,6,7]]', *, *, sparse);
    t := from_vector(v);
    f := vector_dimension_format(v);
    n := vector_dims(v);
    n := vector_dimension_count(v);
    
    dbms_output.put_line('Dimensions ' || n || ', format ' || f || ', serialized: ' || t);
end;
/   


---textual vector
declare
    type v_aa is table of vector index by varchar2(50);
    type v_nt is table of vector;
    v v_aa;
    l_text_dense varchar2(1000);
    l_text_sparse varchar2(1000);
    procedure show_vector(v in v_aa, idx in varchar2)
    is
    begin
        dbms_output.put_line(from_vector(v(idx)) || ' ' || idx);
    end show_vector;    
begin
    l_text_dense := '[1,2,0,0,0,6,7,0]';
    l_text_sparse := '[8,[0,1,5,6],[1,2,6,7]]';
    
    --contstruct vectors from textual inputs
    --default is float32 dense
    v('defaultDenseFloat32') := to_vector(l_text_dense);
    show_vector(v,'defaultDenseFloat32');
    
    
    v('denseInt8') := to_vector(l_text_dense, *, int8, dense);
    v('sparseInt8') := to_vector(l_text_sparse, *, int8, sparse);
    
    show_vector(v,'denseInt8');
    show_vector(v,'sparseInt8');
    
    --passing a vector to the to_vector constructor doesn't work in plsql
--    v('sparseFromDenseInt8') := to_vector(v('denseInt8'),*,*,sparse);
--    PLS-00306: wrong number or types of arguments in call to 'TO_VECTOR'


    --v('resultVector') := to_vector(v('sourceVector'), *, *, sparse);
    select to_vector(v('denseInt8'), *, *, sparse) into v('sparseFromDenseInt8');
    show_vector(v,'sparseFromDenseInt8');
    

    
    select to_vector(v('sparseInt8'), *, *, dense) into v('denseFromSparseInt8');
    show_vector(v,'denseFromSparseInt8');
    
    select to_vector(v('denseInt8'), *, float64) into v('denseFloat64');
    show_vector(v,'denseFloat64');
    
    select to_vector(v('sparseInt8'), *, float64) into v('sparseFloat64');
    show_vector(v,'sparseFloat64');
    
    
    l_text_dense := from_vector(v('denseFloat64'));
    dbms_output.put_line(l_text_dense);
    
    l_text_sparse := from_vector(v('sparseFloat64'));
    dbms_output.put_line(l_text_sparse);    
    
    --returning clause not supported in plsql
    --l_text_dense := from_vector(v('denseFloat64') returning clob format sparse);
    --PLS-00103: Encountered the symbol "FORMAT" when expecting one of the following:
    
    select from_vector(v('denseInt8') returning clob format sparse) into l_text_sparse;
    dbms_output.put_line(l_text_sparse);    
    
    select from_vector(v('sparseInt8') returning clob format dense) into l_text_dense;
    dbms_output.put_line(l_text_dense);     
    
end;
/

