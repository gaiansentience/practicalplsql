--vector_origin, vector_random, vector_random_per_row

select vector_origin(16,binary);


select vector_random(16,binary);

select level as id, vector_random(16,binary), vector_random_per_row(16,binary)
connect by level < 10