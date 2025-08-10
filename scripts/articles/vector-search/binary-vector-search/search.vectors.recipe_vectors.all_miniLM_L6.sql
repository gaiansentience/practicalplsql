--search.vectors.recipe_vectors.all_miniLM_L6.sql
@generate.vectors.recipe_vectors.all_miniLM_L6.sql

prompt search recipe_vectors.embeddings using ALL_MINILM_L6_V2

declare
    l_model  varchar2(100) := 'ALL_MINILM_L6_V2';
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

update recipe_vectors.embeddings using ALL_MINILM_L6_V2
Created embeddings using ALL_MINILM_L6_V2 (384 dimensions, FLOAT32) 
Total Duration: +000000000 00:00:00.312856000


PL/SQL procedure successfully completed.

search recipe_vectors.embeddings using ALL_MINILM_L6_V2
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using ALL_MINILM_L6_V2
Vector Distance Metric cosine
Search duration: +000000000 00:00:00.005435000
Search text = [healthy dinner]
Top k=3 results:
1) Shepherd's Pie
2) Grilled Cheese Sandwiches
3) Buckwheat Pancakes
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using ALL_MINILM_L6_V2
Vector Distance Metric euclidean
Search duration: +000000000 00:00:00.005155000
Search text = [healthy dinner]
Top k=3 results:
1) Shepherd's Pie
2) Grilled Cheese Sandwiches
3) Buckwheat Pancakes
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using ALL_MINILM_L6_V2
Vector Distance Metric manhattan
Search duration: +000000000 00:00:00.004093000
Search text = [healthy dinner]
Top k=3 results:
1) Shepherd's Pie
2) Grilled Cheese Sandwiches
3) Curried Tofu
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using ALL_MINILM_L6_V2
Vector Distance Metric cosine
Search duration: +000000000 00:00:00.004074000
Search text = [yummy dessert]
Top k=3 results:
1) Strawberry Pie
2) Raspberry Tarts
3) Chocolate Cake
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using ALL_MINILM_L6_V2
Vector Distance Metric euclidean
Search duration: +000000000 00:00:00.004557000
Search text = [yummy dessert]
Top k=3 results:
1) Strawberry Pie
2) Raspberry Tarts
3) Chocolate Cake
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using ALL_MINILM_L6_V2
Vector Distance Metric manhattan
Search duration: +000000000 00:00:00.004478000
Search text = [yummy dessert]
Top k=3 results:
1) Strawberry Pie
2) Raspberry Tarts
3) Chocolate Cake
--------------------------------------------------------------------------------


PL/SQL procedure successfully completed.



*/