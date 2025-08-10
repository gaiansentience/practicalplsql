--search.vectors.recipe_vectors.all_miniLM_L12.sql
@generate.vectors.recipe_vectors.all_miniLM_L12.sql

prompt search recipe_vectors.embeddings using ALL_MINILM_L12_V2

declare
    l_model  varchar2(100) := 'ALL_MINILM_L12_V2';
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

update recipe_vectors.embeddings using ALL_MINILM_L12_V2
Created embeddings using ALL_MINILM_L12_V2 (384 dimensions, FLOAT32) 
Total Duration: +000000000 00:00:00.397068000


PL/SQL procedure successfully completed.

search recipe_vectors.embeddings using ALL_MINILM_L12_V2
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using ALL_MINILM_L12_V2
Vector Distance Metric cosine
Search duration: +000000000 00:00:00.007937000
Search text = [healthy dinner]
Top k=3 results:
1) Shepherd's Pie
2) Curried Tofu
3) Grilled Cheese Sandwiches
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using ALL_MINILM_L12_V2
Vector Distance Metric euclidean
Search duration: +000000000 00:00:00.007518000
Search text = [healthy dinner]
Top k=3 results:
1) Shepherd's Pie
2) Curried Tofu
3) Grilled Cheese Sandwiches
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [healthy dinner]
Search completed using ALL_MINILM_L12_V2
Vector Distance Metric manhattan
Search duration: +000000000 00:00:00.008594000
Search text = [healthy dinner]
Top k=3 results:
1) Shepherd's Pie
2) Curried Tofu
3) Grilled Cheese Sandwiches
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using ALL_MINILM_L12_V2
Vector Distance Metric cosine
Search duration: +000000000 00:00:00.010256000
Search text = [yummy dessert]
Top k=3 results:
1) Strawberry Pie
2) Chocolate Cake
3) Banana, Mango and Blueberry Smoothie
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using ALL_MINILM_L12_V2
Vector Distance Metric euclidean
Search duration: +000000000 00:00:00.012566000
Search text = [yummy dessert]
Top k=3 results:
1) Strawberry Pie
2) Chocolate Cake
3) Banana, Mango and Blueberry Smoothie
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Run Test Vector Search For [yummy dessert]
Search completed using ALL_MINILM_L12_V2
Vector Distance Metric manhattan
Search duration: +000000000 00:00:00.008949000
Search text = [yummy dessert]
Top k=3 results:
1) Strawberry Pie
2) Chocolate Cake
3) Banana, Mango and Blueberry Smoothie
--------------------------------------------------------------------------------


PL/SQL procedure successfully completed.



*/

