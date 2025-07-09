---convert vectors to binary vectors using plsql

--set an inquiry directive for conditiona compilation of code that is only valid in 23.8
set serveroutput on;
DECLARE
    l_version number;
    l_release number;
    l_version_full varchar2(20);
BEGIN
    l_version := dbms_db_version.version;

    select regexp_substr(version_full, '^\d+\.(\d+)\.', 1, 1, null, 1) 
        , version_full
    into l_release, l_version_full
    from PRODUCT_COMPONENT_VERSION;

    dbms_output.put_line('Select version_full from product_component_version returns ' || l_version_full);

    if l_version > 23 or (l_version = 23 and l_release >= 8) then
        execute immediate q'~alter session set plsql_ccflags = 'is238:true'~';
    end if;


$if $$is238 $then 
    dbms_output.put_line('Running in 23.8 or better');
$else
    dbms_output.put_line('Running in earlier release than 23.8');
$end

end;
/



set serveroutput on;
declare
    l_dense_vector vector;
    l_binary_vector vector;
    l_sparse_vector vector;
    l_serialized varchar2(4000);
    l_serialized_dense varchar2(4000);
    l_serialized_sparse varchar2(4000);

    procedure show_vector(p_vector in vector, p_caption in varchar2 default 'vector')
    is
    begin

        dbms_output.put_line(p_caption || ':  ' || from_vector(p_vector));

    end show_vector;


    function to_binary_vector(inputVector in vector) return vector
    is
        l_dimension_count number;
        l_dimension_format varchar2(100);
        e_already_binary exception;
        l_serialized clob;
        j json;
        l_n_list sys.odcinumberlist;
    begin

        show_vector(inputvector, 'input vector: ');
        
        --select vector_dimension_format(inputVector) into dimension_format;
        l_dimension_format := vector_dimension_format(inputVector);
        dbms_output.put_line(l_dimension_format);
        if l_dimension_format = 'BINARY' then raise e_already_binary; end if;

        --select vector_dimension_count|vector_dims(inputVector) into l_dimension_count;
        l_dimension_count := vector_dims(inputVector);
        if mod(l_dimension_count,8) <> 0 then
            raise_application_error(-20100, l_dimension_count || ' dimensional vector cannot be converted to binary format.  dimension count must be a multiple of 8');
        end if;


        select from_vector(inputVector returning clob format dense) 
        into l_serialized;

        --vector_serialize|from_vector not available in plsql
        --c := from_vector(inputVector returning clob);


        DBMS_OUTPUT.PUT_LINE('vector serialized to string (dense storage specified): ' || l_serialized);

        select json(inputVector) 
        into j;

        DBMS_OUTPUT.PUT_LINE('vector converted directly to json: ' || json_serialize(j));

        select json(from_vector(inputVector returning clob format dense))
        into j;

        DBMS_OUTPUT.PUT_LINE('vector serialized and then convesrted to json: ' || json_serialize(j));



        select jt.dim_val bulk collect into l_n_list
        from json_table(j, '$[*]' columns (dim_val number path '$')) jt;

        for i in 1..l_n_list.count loop

            dbms_output.put_line('l_n_list(' || i || ')=' || l_n_list(i));

            if l_n_list(i) > 0 then
                l_n_list(i) := 1;
            else
                l_n_list(i) := 0;
            end if;
        end loop;


        return inputVector;
    
    exception
        when e_already_binary then
            return inputVector;
    end to_binary_vector;

begin

--$if $$is238 $then
    l_dense_vector := to_vector('[0,0,1,0,1,0,1,0]',8,int8);
--$else
    select to_vector('[0,0,1,0,1,0,1,0]',8,int8) 
    into l_dense_vector;
--$end




--$if $$is238 $then
    l_sparse_vector := to_vector('[8,[2,4,6],[1,1,1]]',8,int8,sparse);
--$else
-----creating sparse vector not supported in plsql (23.7)
    select to_vector('[8,[2,4,6],[1,1,1]]',8,int8,sparse) 
    into l_sparse_vector;
--$end

        --from vector cannot support returning clause in plsql
        l_serialized := from_vector(l_dense_vector);  
        
        --from vector does not support returning clob|varchar or format sparse|dense in plsql
        --l_serialized := from_vector(l_dense_vector returning clob format sparse);   
        --pls-00103: encountered the symbol format when expecting...
        
                
        select from_vector(l_dense_vector returning clob format sparse) into l_serialized_sparse;


         dbms_output.put_line('dense vector serialized to sparse vector string: ' || l_serialized);

--$if $$is238 $then
        l_sparse_vector := to_vector(l_serialized_sparse,8,int8,sparse);
--$else
         select to_vector(l_serialized_sparse,8,int8,sparse) into l_sparse_vector;
--$end

         dbms_output.put_line('sparse vector from sparse string: ' || from_vector(l_sparse_vector));


--$if $$is238 $then
        --cannot convert storage format in plsql
       -- l_dense_vector := to_vector(l_sparse_vector, 8, int8);
        l_sparse_vector := to_vector(l_serialized_sparse,*,*,sparse);
--$else
        select to_vector(l_sparse_vector, *, *, dense) into l_dense_vector;
--$end

show_vector(l_sparse_vector, 'sparse vector');

show_vector(l_dense_vector, 'dense vector');

--    l_dense_vector := vector('[42]',8,binary);

    l_binary_vector := to_binary_vector(l_dense_vector);
    
    show_vector(l_binary_vector);

    

end;
/

/*

select json_serialize(json(from_vector( to_vector('[1,0,2,0,0,0,0,0]', 8, int8, dense) returning clob format dense) ) ) as vj;


SELECT FROM_VECTOR(TO_VECTOR('[5,[2,4],[1.0,2.0]]', 5, FLOAT64, SPARSE) RETURNING CLOB FORMAT dense);

-- FROM_VECTOR(TO_VECTOR('[5,[2,4],[1.0,2.0]]',5,FLOAT64,SPARSE)RETURNINGCLOBFORMAT
-- --------------------------------------------------------------------------------
-- [5,[2,4],[1.0E+000,2.0E+000]]


with base as (
    select vector('[1,2,3,4]') as v from dual
)
select 
    v
    , vector_dimension_count(v) as d_count
    , vector_dimension_format(v) as d_fmt
    , vector_dims(v) as alt_count
from base;

*/

--select to_vector('[0,0,1,0,1,0,1,0]',8,int8,dense);
--
--select to_vector('[8,[2,4,6],[1,1,1]]',8,int8,sparse) ;

--to_vector can be used with a vector to convert from sparse to dense (or dense to sparse)
select 
    to_vector(
        to_vector('[8,[2,4,6],[1,1,1]]',8,int8,sparse)
        , *, *, dense
    ) as v
/