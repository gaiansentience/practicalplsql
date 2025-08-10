--search.vectors.recipe_vectors.mxbai_large.sql
@generate.vectors.recipe_vectors.mxbai_large.sql

prompt search recipe_vectors.embeddings using MXBAI_EMBED_LARGE_V1

declare
    l_model  varchar2(100) := 'MXBAI_EMBED_LARGE_V1';
    l_metrics sys.odcivarchar2list := sys.odcivarchar2list('cosine', 'euclidean', 'manhattan');
    l_searches sys.odcivarchar2list := sys.odcivarchar2list('healthy dinner', 'yummy dessert');
begin
    for s in values of l_searches loop
        for m in values of l_metrics loop
            search_recipe_vectors(s, 3, l_model, m);
        end loop;
    end loop;
end;
/

/* SCRIPT OUTPUT:

update recipe_vectors.embeddings using MXBAI_EMBED_LARGE_V1
Created embeddings using MXBAI_EMBED_LARGE_V1 (1024 dimensions, FLOAT32) 
Total Duration: +000000000 00:00:02.956819000


PL/SQL procedure successfully completed.

search recipe_vectors.embeddings using MXBAI_EMBED_LARGE_V1
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using MXBAI_EMBED_LARGE_V1
Vector Distance Metric cosine
Search duration: +000000000 00:00:00.060860000
Search text = [healthy dinner]
Top k=3 results:
1) Curried Tofu
2) Shepherd's Pie
3) Miso Soup
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using MXBAI_EMBED_LARGE_V1
Vector Distance Metric euclidean
Search duration: +000000000 00:00:00.059541000
Search text = [healthy dinner]
Top k=3 results:
1) Curried Tofu
2) Shepherd's Pie
3) Miso Soup
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using MXBAI_EMBED_LARGE_V1
Vector Distance Metric manhattan
Search duration: +000000000 00:00:00.060535000
Search text = [healthy dinner]
Top k=3 results:
1) Curried Tofu
2) Shepherd's Pie
3) Miso Soup
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using MXBAI_EMBED_LARGE_V1
Vector Distance Metric cosine
Search duration: +000000000 00:00:00.067204000
Search text = [yummy dessert]
Top k=3 results:
1) Chocolate Cake
2) Strawberry Pie
3) Oatmeal Cookies
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using MXBAI_EMBED_LARGE_V1
Vector Distance Metric euclidean
Search duration: +000000000 00:00:00.067956000
Search text = [yummy dessert]
Top k=3 results:
1) Chocolate Cake
2) Strawberry Pie
3) Oatmeal Cookies
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using MXBAI_EMBED_LARGE_V1
Vector Distance Metric manhattan
Search duration: +000000000 00:00:00.067085000
Search text = [yummy dessert]
Top k=3 results:
1) Chocolate Cake
2) Strawberry Pie
3) Oatmeal Cookies
--------------------------------------------------------------------------------


PL/SQL procedure successfully completed.



*/