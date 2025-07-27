
declare
    t clob;
    v vector;
    
    function serialize(p_vector in vector) return clob
    is
        s clob;
    begin
        select from_vector(p_vector returning clob) into s;
        return s;
    end serialize;
    
    
    procedure print(p_vector in vector, p_add_python_comment in boolean default false)
    is
    begin
        
        
        dbms_output.put_line(
            case when p_add_python_comment then '# ' end ||
            'dimensions: ' || vector_dims(p_vector)
            || ' format: ' || vector_dimension_format(p_vector)
            );
            
        dbms_output.put_line(
            case when p_add_python_comment then '# ' end ||
            serialize(p_vector)
            );
            
    end print;
    
    function quantize(p_vector in vector) return vector
    is
        v vector;
    begin
        select to_binary_vector(p_vector)
        into v;
        return v;
    end quantize;
    
    procedure show(p_vector in vector, p_add_python_comment in boolean default true)
    is
    begin

        print(v, p_add_python_comment);
        print(quantize(v), p_add_python_comment);
     
    end show;
    
    procedure script(p_vector in vector)
    is
    begin
        dbms_output.put_line('#' || chr(10) || '# vector quantized with macro in database');
        show(p_vector);
        dbms_output.put_line('# quantize with sentence transformers:');
        dbms_output.put_line('# import sentence_transformers');
        dbms_output.put_line('from sentence_transformers import SentenceTransformer');
        dbms_output.put_line('from sentence_transformers.quantization import quantize_embeddings');
        dbms_output.put_line('embeddings = [' || serialize(p_vector) || ']');
        dbms_output.put_line('embeddings_binary = quantize_embeddings(embeddings, precision="ubinary")');
        dbms_output.put_line('print(embeddings_binary)' || chr(10)|| '#');
    end script;
        
    
        
begin
     --8 dimensional vector
     t := '[-0.123, -0.654, 0.345, -0.02, 0.789, -0.567, 0.888, 0]';
     v := to_vector(t);
     script(v);

     --16 dimensional vector
     t := '[-0.123, -0.654, 0.345, -0.02, 0.789, -0.567, 0.888, 0, -0.123, -0.444, -0.65, -0.02, 0.231, -0.11, 0.73, 0.22]';
     v := to_vector(t);
     script(v);

     --24 dimensional vector
     t := '[-0.123, -0.654, 0.345, -0.02, 0.789, -0.567, 0.888, 0, -0.123, -0.444, -0.65, -0.02, 0.231, -0.11, 0.73, 0, 0.12, 0.33, 0.56, -0.77, 0.88, -0.99, 0.21, 0.42]';
     v := to_vector(t);
     script(v);

     --32 dimensional vector
     t := '[-0.123, -0.654, 0.345, -0.02, 0.789, -0.567, 0.888, 0, -0.123, -0.444, -0.65, -0.02, 0.231, -0.11, 0.73, 0, 0.12, -0.33, 0.56, 0.77, 0.88, -0.99, 0.21, -0.42, -0.51, -0.61, 0.71, 0.81, -0.91, -1.01, 0.13, 0.23]';
     v := to_vector(t);
     script(v);  
     
end;
/
     
/* python syntax
>>> from sentence_transformers import SentenceTransformer
>>> from sentence_transformers.quantization import quantize_embeddings
>>> e = [[0,0,1,0,1,0,1,0]]
>>> be = quantize_embeddings(e, precision="ubinary")
>>> 
>>> print(be)
[[42]]

*/

/* generated python script in validate-binary-quantization.py */

