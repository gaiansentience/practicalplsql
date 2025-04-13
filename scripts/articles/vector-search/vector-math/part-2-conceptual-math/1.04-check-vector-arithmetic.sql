--1.04-check-vector-arithmetic.sql

set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);
    v t_vectors;
    cursor c is
    with base(term) as (
    values 
        ('Paris'),('Rome'),('London')
        ,('France'),('Italy'),('United Kingdom')
    )
    select 
        b.term, 
        vector_embedding(ALL_MINILM_L6_V2 using b.term as data) as embedding
    from base b;    
    
begin

    v := t_vectors(for r in c index r.term => r.embedding);
    
    
    v('equation') := v('Rome') - v('Italy') + v('France');
    dbms_output.put_line('(Rome - Italy + France)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to London: ' || vector_distance(v('equation'), v('London')));

    v('equation') := v('Rome') - v('Italy') + v('United Kingdom');
    dbms_output.put_line('(Rome - Italy + United Kingdom)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to London: ' || vector_distance(v('equation'), v('London')));
    
    v('equation') := v('London') - v('United Kingdom') + v('Italy');
    dbms_output.put_line('(London - United Kingdom + Italy)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to Rome: ' || vector_distance(v('equation'), v('Rome')));
    
    v('equation') := v('London') - v('United Kingdom') + v('France');
    dbms_output.put_line('(London - United Kingdom + France)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to Rome: ' || vector_distance(v('equation'), v('Rome')));
        
end;
/

/*
(Rome - Italy + France)
Distance to Paris: 2.9965084512286433E-001
Distance to London: 5.9621648436293428E-001
(Rome - Italy + United Kingdom)
Distance to Paris: 5.9460183089094121E-001
Distance to London: 3.9756368514909457E-001
(London - United Kingdom + Italy)
Distance to Paris: 4.6865291500436113E-001
Distance to Rome: 4.090754894227332E-001
(London - United Kingdom + France)
Distance to Paris: 2.3190182385379965E-001
Distance to Rome: 4.8457594091850864E-001


PL/SQL procedure successfully completed.


*/