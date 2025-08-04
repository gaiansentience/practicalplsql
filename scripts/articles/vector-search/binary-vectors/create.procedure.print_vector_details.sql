--create.procedure.print_vector_details.sql
    
create or replace procedure print_vector_details(v in vector)
is
    l_dim_count  number;
    l_dim_format varchar2(50);
    l_serialized varchar2(1000);
begin
    l_dim_format := vector_dimension_format(v);
    l_dim_count := vector_dimension_count(v);
    l_serialized := vector_serialize(v);
    dbms_output.put_line('Dimension Count = ' || l_dim_count);
    dbms_output.put_line('Dimension Format = ' || l_dim_format);
    dbms_output.put_line('Serialized Vector = ' || l_serialized);
end print_vector_details;
/

