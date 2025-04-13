--2.02-italy-plus-capitol.sql

set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);
    v t_vectors;
    
    cursor c_vectors is
    with base(term) as (
    values 
        ('Paris'),('Boston'),('Rome'),('Milan'),('Venice'),('London'),('Oxford')
        ,('Italy'),('capitol')
    )
    select term, vector_embedding(all_minilm_l6_v2 using term as data) as embedding
    from base;    
begin   

    v := t_vectors(for r in c_vectors index r.term => r.embedding);
    
    v('equation') := v('Italy') + v('capitol');

    dbms_output.put_line('(Italy + capitol)');
    dbms_output.put_line('Vector Distance to Rome: ' || (v('equation') <=> v('Rome')));  
    dbms_output.put_line('Vector Distance to Milan: ' || (v('equation') <=> v('Milan')));
    dbms_output.put_line('Vector Distance to Venice: ' || (v('equation') <=> v('Venice')));
    dbms_output.put_line('Vector Distance to Boston: ' || (v('equation') <=> v('Boston')));
    dbms_output.put_line('Vector Distance to Oxford: ' || (v('equation') <=> v('Oxford')));        
    dbms_output.put_line('Vector Distance to London: ' || (v('equation') <=> v('London')));    
    
end;
/
/*
(Italy + capitol)
Vector Distance to Rome: 2.9802262620126152E-001
Vector Distance to Milan: 3.9387634470790855E-001
Vector Distance to Venice: 3.630046186389756E-001
Vector Distance to Boston: 3.3752235313420953E-001
Vector Distance to Oxford: 6.2731439414881129E-001
Vector Distance to London: 4.9962797324807606E-001


PL/SQL procedure successfully completed.


*/