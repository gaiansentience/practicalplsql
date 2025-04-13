--2.02-italy-plus-capital.sql

set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);
    v t_vectors;
    
    cursor c_vectors is
    with base(term) as (
    values 
        ('Paris'),('Boston'),('Rome'),('Milan'),('Venice'),('London'),('Oxford')
        ,('Italy'),('capital')
    )
    select term, vector_embedding(all_minilm_l6_v2 using term as data) as embedding
    from base;    
begin   

    v := t_vectors(for r in c_vectors index r.term => r.embedding);
    
    v('equation') := v('Italy') + v('capital');

    dbms_output.put_line('(Italy + capital)');
    dbms_output.put_line('Vector Distance to Rome: ' || (v('equation') <=> v('Rome')));  
    dbms_output.put_line('Vector Distance to Milan: ' || (v('equation') <=> v('Milan')));
    dbms_output.put_line('Vector Distance to Venice: ' || (v('equation') <=> v('Venice')));
    dbms_output.put_line('Vector Distance to Boston: ' || (v('equation') <=> v('Boston')));
    dbms_output.put_line('Vector Distance to Oxford: ' || (v('equation') <=> v('Oxford')));        
    dbms_output.put_line('Vector Distance to London: ' || (v('equation') <=> v('London')));    
    
end;
/
/*
(Italy + capital)
Vector Distance to Rome: 3.6240224760576656E-001
Vector Distance to Milan: 4.1047204677196603E-001
Vector Distance to Venice: 3.8740155351994054E-001
Vector Distance to Boston: 3.9790772095926996E-001
Vector Distance to Oxford: 6.1004993062506807E-001
Vector Distance to London: 5.5103133474311905E-001

*/