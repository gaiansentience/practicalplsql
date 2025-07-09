--update_recipe_embeddings-mxbai_large.sql

set serveroutput on;
declare


begin
    
    update recipes g
    set 
        embedding = vector_embedding(MXBAI_EMBED_LARGE_V1 using g.doc as data), 
        embedding_model = 'MXBAI_EMBED_LARGE_V1';
        
    commit;
    
end;
/

/*

Mining Model: MXBAI_EMBED_LARGE_V1
Search Expression: yummy dessert
1-Chocolate Cake
2-Strawberry Pie
3-Oatmeal Cookies
--------------------------------------------------
Mining Model: MXBAI_EMBED_XSMALL_V1
Search Expression: yummy dessert
1-Strawberry Pie
2-Raspberry Tarts
3-Chocolate Cake
--------------------------------------------------

*/
