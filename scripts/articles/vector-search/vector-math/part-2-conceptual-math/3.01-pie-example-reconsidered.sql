--3.01-pie-example-reconsidered.sql

set serveroutput on;
declare
    type t_vectors_nt is table of vector index by varchar2(100);
    v t_vectors_nt;
    
    cursor c is
    with base(term) as (
        values ('apple pie'),('peach pie'),('apple'),('peach')
    )
    select 
        b.term
        , vector_embedding(
            ALL_MINILM_L6_V2 using b.term as data
            ) as embedding
    from base b;
begin

    v := t_vectors_nt(for r in c index r.term => r.embedding);
    
    v('compromise') := v('apple pie') - v('apple') + v('peach');
        
    if vector_distance(v('compromise'), v('peach pie')) 
        < vector_distance(v('compromise'), v('apple pie')) then
        dbms_output.put_line('Peach pie sounds good!');
    else
        dbms_output.put_line('Peach pie is not a substitute for apple pie!');
    end if;
end;
/

--Peach pie sounds good!