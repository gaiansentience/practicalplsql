--2.01-country-plus-capital.sql

set serveroutput on;
declare
    type t_vectors is table of vector index by varchar2(100);
    v t_vectors;
    cursor c is
    with base(term) as (
    values 
        ('Paris'),('Rome'),('London')
        ,('France'),('Italy'),('United Kingdom')
        ,('capital')
    )
    select 
        b.term, 
        vector_embedding(ALL_MINILM_L6_V2 using b.term as data) as embedding
    from base b;    
    
begin

    v := t_vectors(for r in c index r.term => r.embedding);
    
    v('equation') := v('Italy') + v('capital');
    dbms_output.put_line('(Italy + capital)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to London: ' || vector_distance(v('equation'), v('London')));
    dbms_output.put_line('Distance to Rome: ' || vector_distance(v('equation'), v('Rome')));

    v('equation') := v('United Kingdom') + v('capital');
    dbms_output.put_line('(United Kingdom + capital)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to London: ' || vector_distance(v('equation'), v('London')));
    dbms_output.put_line('Distance to Rome: ' || vector_distance(v('equation'), v('Rome')));
    
    v('equation') := v('France') + v('capital');
    dbms_output.put_line('(France + capital)');
    dbms_output.put_line('Distance to Paris: ' || vector_distance(v('equation'), v('Paris')));
    dbms_output.put_line('Distance to London: ' || vector_distance(v('equation'), v('London')));
    dbms_output.put_line('Distance to Rome: ' || vector_distance(v('equation'), v('Rome')));
    
end;
/

/*
(Italy + capital)
Distance to Paris: 5.0221515483701262E-001
Distance to London: 5.5103133474311905E-001
Distance to Rome: 3.6240224760576656E-001

(United Kingdom + capital)
Distance to Paris: 5.4262974078288229E-001
Distance to London: 3.6615389352489458E-001
Distance to Rome: 5.4107460014668729E-001

(France + capital)
Distance to Paris: 3.4374537856466458E-001
Distance to London: 5.263360473587797E-001
Distance to Rome: 4.2970427215207985E-001
*/