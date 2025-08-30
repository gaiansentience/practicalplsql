--1.1.function.get_vector_details.sql

--Create a function to serialize a vector and show dimension format
create or replace function get_vector_details(
    v in vector
    ) return varchar2
is
begin
    return 
        case v 
            when is null then 'NULL' 
            else 
                from_vector(v) 
                || ' ' || vector_dimension_format(v) 
        end;
end get_vector_details;
/
--Function GET_VECTOR_DETAILS compiled

--Test the function
set serveroutput on;
declare
    v vector;
begin
    dbms_output.put_line(get_vector_details(v));
    
    v := to_vector('[1,2,3]',3,int8);
    dbms_output.put_line(get_vector_details(v));
    
    v := to_vector('[150,775,357]',3,float32);
    dbms_output.put_line(get_vector_details(v));
    
    v := to_vector('[15000,77500,357000]',3,float64);
    dbms_output.put_line(get_vector_details(v));    

end;
/
/*
NULL
[1,2,3] INT8
[1.5E+002,7.75E+002,3.57E+002] FLOAT32
[1.5E+004,7.75E+004,3.57E+005] FLOAT64
*/