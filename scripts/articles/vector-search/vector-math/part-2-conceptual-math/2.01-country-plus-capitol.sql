--2.01-country-plus-capitol.sql

set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);
    v t_vectors;
    cursor c is
    with base(term) as (
    values 
        ('Paris'),('Rome'),('London')
        ,('France'),('Italy'),('United Kingdom')
        ,('capitol')
    )
    select 
        b.term, 
        vector_embedding(ALL_MINILM_L6_V2 using b.term as data) as embedding
    from base b;    
    
begin

    v := t_vectors(for r in c index r.term => r.embedding);
    
    v('equation') := v('Italy') + v('capitol');
    dbms_output.put_line('(Italy + capitol)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to London: ' || vector_distance(v('equation'), v('London')));
    dbms_output.put_line('Distance to Rome: ' || vector_distance(v('equation'), v('Rome')));

    v('equation') := v('United Kingdom') + v('capitol');
    dbms_output.put_line('(United Kingdom + capitol)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to London: ' || vector_distance(v('equation'), v('London')));
    dbms_output.put_line('Distance to Rome: ' || vector_distance(v('equation'), v('Rome')));
    
    v('equation') := v('France') + v('capitol');
    dbms_output.put_line('(France + capitol)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to London: ' || vector_distance(v('equation'), v('London')));
    dbms_output.put_line('Distance to Rome: ' || vector_distance(v('equation'), v('Rome')));
    
end;
/

/*
(Italy + capitol)
Distance to Paris: 4.3417309641346358E-001
Distance to London: 4.9962797324807606E-001
Distance to Rome: 2.9802262620126152E-001
(United Kingdom + capitol)
Distance to Paris: 4.7775750538870176E-001
Distance to London: 3.1825374713509702E-001
Distance to Rome: 4.7997438619014166E-001
(France + capitol)
Distance to Paris: 2.7786227275012021E-001
Distance to London: 4.7659735866171526E-001
Distance to Rome: 3.67444080817251E-001


PL/SQL procedure successfully completed.
*/