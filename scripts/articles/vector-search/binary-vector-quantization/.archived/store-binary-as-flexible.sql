column f_serialize format a10
column b_serialize format a20
column b_fmt format a10
column f_fmt format a10

drop table if exists test_binary_storage
/


create table test_binary_storage (
    id integer generated always as identity,
    notes varchar2(4000),
    vflexible vector(*,*),
    vint8 vector(*, int8),
    vfloat32 vector(*, float32),
    vfloat64 vector(*, float64),
    vbinary vector(*, binary)
)
/

insert into test_binary_storage(vint8, notes)
values(vector('[-5, -9, 5, -65, 23, -2, 42, -33]', 8, int8), 'Insert 8 dimensional int8 vector that quantizes to packed binary vector of [42]')
/

insert into test_binary_storage (vflexible,notes)
values (vector('[42]',8,binary), 'Insert Binary Vector to Flexible column')
/


insert into test_binary_storage(vbinary, notes)
values (vector('[42]',8,binary), 'Insert Binary Vector to binary column')
/

commit;


--fails with ORA-51814 (failing on implicit conversion to int8 during insert)
insert into test_binary_storage(vint8, notes)
values (vector('[42]',8,binary), 'Insert Binary Vector to int8 column')
/
--SQL Error: ORA-51814: Vector of BINARY format cannot have any operation performed with vector of any other type.

--fails with ORA-51814 (failing on implicit conversion to float32 during insert)
insert into test_binary_storage(vfloat32, notes)
values (vector('[42]',8,binary), 'Insert Binary Vector to float32 column')
/

--fails with ORA-51814 (failing on implicit conversion to float64 during insert)
insert into test_binary_storage(vfloat64, notes)
values (vector('[42]',8,binary), 'Insert Binary Vector to float64 column')
/


select 
    vector_serialize(vflexible) as f_serialize, vector_dimension_format(vflexible) as f_fmt, vector_dims(vflexible) as f_dims,vflexible, to_vector(vector_serialize(vflexible),8,binary) as vflex_to_binary 
    --vector_serialize(vbinary) as b_serialize, vector_dimension_format(vbinary) as b_fmt, vector_dims(vbinary) as b_dims,vbinary
from test_binary_storage
where vflexible is not null
/


select 
    --vector_serialize(vflexible) as f_serialize, vector_dimension_format(vflexible) as f_fmt, vector_dims(vflexible) as f_dims,vflexible, to_vector(vector_serialize(vflexible),8,binary) as vflex_to_binary 
    vector_serialize(vbinary) as b_serialize, vector_dimension_format(vbinary) as b_fmt, vector_dims(vbinary) as b_dims,vbinary
from test_binary_storage
where vbinary is not null
/



-- drop table test_binary_storage purge
-- /