--search.vectors.recipe_vectors.mxbai_xsmall.sql
--generate the embeddings using the mxbai_xsmall model
@generate.vectors.recipe_vectors.mxbai_xsmall.sql

prompt search recipe_vectors.embeddings using MXBAI_EMBED_XSMALL_V1

declare
    type t_list is table of varchar2(100);
    l_model  varchar2(100) := 'MXBAI_EMBED_XSMALL_V1';
    l_metrics t_list := t_list('cosine', 'euclidean', 'manhattan');
    l_searches t_list := t_list('healthy dinner', 'yummy dessert');
begin
    for s in values of l_searches loop
        for m in values of l_metrics loop
            search_recipe_vectors(s, 3, l_model, m);
        end loop;
    end loop;
end;
/

/* SCRIPT OUTPUT:

update recipe_vectors.embeddings using MXBAI_EMBED_XSMALL_V1
Created embeddings using MXBAI_EMBED_XSMALL_V1 (384 dimensions, FLOAT32) 
Total Duration: +000000000 00:00:00.220622000


PL/SQL procedure successfully completed.

search recipe_vectors.embeddings using MXBAI_EMBED_XSMALL_V1
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using MXBAI_EMBED_XSMALL_V1
Vector Distance Metric cosine
Search duration: +000000000 00:00:00.004012000
Search text = [healthy dinner]
Top k=3 results:
1) Shepherd's Pie
2) Grilled Cheese Sandwiches
3) Curried Tofu
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using MXBAI_EMBED_XSMALL_V1
Vector Distance Metric euclidean
Search duration: +000000000 00:00:00.003446000
Search text = [healthy dinner]
Top k=3 results:
1) Shepherd's Pie
2) Grilled Cheese Sandwiches
3) Curried Tofu
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using MXBAI_EMBED_XSMALL_V1
Vector Distance Metric manhattan
Search duration: +000000000 00:00:00.003557000
Search text = [healthy dinner]
Top k=3 results:
1) Shepherd's Pie
2) Grilled Cheese Sandwiches
3) Curried Tofu
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using MXBAI_EMBED_XSMALL_V1
Vector Distance Metric cosine
Search duration: +000000000 00:00:00.002781000
Search text = [yummy dessert]
Top k=3 results:
1) Strawberry Pie
2) Chocolate Cake
3) Raspberry Tarts
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using MXBAI_EMBED_XSMALL_V1
Vector Distance Metric euclidean
Search duration: +000000000 00:00:00.002627000
Search text = [yummy dessert]
Top k=3 results:
1) Strawberry Pie
2) Chocolate Cake
3) Raspberry Tarts
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using MXBAI_EMBED_XSMALL_V1
Vector Distance Metric manhattan
Search duration: +000000000 00:00:00.002920000
Search text = [yummy dessert]
Top k=3 results:
1) Strawberry Pie
2) Chocolate Cake
3) Banana, Mango and Blueberry Smoothie
--------------------------------------------------------------------------------


PL/SQL procedure successfully completed.



*/