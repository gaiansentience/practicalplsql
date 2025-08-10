--search.compare_binary.menu_vectors.sql
set serveroutput on;

declare
    type t_list is table of varchar2(100);
    l_searches t_list;      
    l_columns t_list;
    l_metrics t_list;
begin
    l_searches := t_list(
        'a decadent dessert would be tasty'
        , 'what kinds of healthy lunch options are there?'
        );
        
    l_columns := t_list('embedding', 'embedding1', 'embedding2', 'embedding3');
    l_metrics := t_list('cosine','euclidean','manhattan');
    
    <<searches>>
    for s in values of l_searches loop
    
        <<models>>
        for c in values of l_columns loop
        
            <<float_metrics>>
            for m in values of l_metrics loop
                search_compare_menu_vectors(s, 3, m, c, p_use_binary => false);
            end loop float_metrics;
            
            search_compare_menu_vectors(s, 3, 'hamming', c, p_use_binary => true);
            search_compare_menu_vectors(s, 3, 'jaccard', c, p_use_binary => true);  
            
        end loop models;
    
    end loop searches;
    
end;
/

/*
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric cosine
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.050880000
Time to run search: +000000000 00:00:00.055934000
Turtle Cheesecake
Molten Lava Cake
Crème Brûlée
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric euclidean
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.004663000
Time to run search: +000000000 00:00:00.007555000
Turtle Cheesecake
Molten Lava Cake
Crème Brûlée
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric manhattan
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.004967000
Time to run search: +000000000 00:00:00.008049000
Turtle Cheesecake
Crème Brûlée
Molten Lava Cake
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric hamming
Use Column embedding_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.009478000
Time to run search: +000000000 00:00:00.013352000
Turtle Cheesecake
Molten Lava Cake
Crème Brûlée
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric jaccard
Use Column embedding_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.005491000
Time to run search: +000000000 00:00:00.007535000
Turtle Cheesecake
Molten Lava Cake
Chocolate Marble Cheesecake
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_LARGE_V1, metric cosine
Use Column embedding1, dimensions 1024, format FLOAT32
Time to get search vector: +000000000 00:00:03.995551000
Time to run search: +000000000 00:00:04.004011000
Chocolate Soufflé
Turtle Cheesecake
Molten Lava Cake
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_LARGE_V1, metric euclidean
Use Column embedding1, dimensions 1024, format FLOAT32
Time to get search vector: +000000000 00:00:00.943835000
Time to run search: +000000000 00:00:00.953499000
Chocolate Soufflé
Turtle Cheesecake
Molten Lava Cake
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_LARGE_V1, metric manhattan
Use Column embedding1, dimensions 1024, format FLOAT32
Time to get search vector: +000000000 00:00:00.930034000
Time to run search: +000000000 00:00:00.941320000
Chocolate Soufflé
Turtle Cheesecake
Molten Lava Cake
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_LARGE_V1, metric hamming
Use Column embedding1_binary, dimensions 1024, format BINARY
Time to get search vector: +000000000 00:00:01.065748000
Time to run search: +000000000 00:00:01.073347000
Turtle Cheesecake
Chocolate Soufflé
Churros
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model MXBAI_EMBED_LARGE_V1, metric jaccard
Use Column embedding1_binary, dimensions 1024, format BINARY
Time to get search vector: +000000000 00:00:00.933573000
Time to run search: +000000000 00:00:00.941120000
Turtle Cheesecake
Chocolate Soufflé
Churros
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L6_V2, metric cosine
Use Column embedding2, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.359075000
Time to run search: +000000000 00:00:00.362923000
Turtle Cheesecake
Molten Lava Cake
Crème Brûlée
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L6_V2, metric euclidean
Use Column embedding2, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.006333000
Time to run search: +000000000 00:00:00.009617000
Turtle Cheesecake
Molten Lava Cake
Crème Brûlée
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L6_V2, metric manhattan
Use Column embedding2, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.006437000
Time to run search: +000000000 00:00:00.009927000
Crème Brûlée
Turtle Cheesecake
Molten Lava Cake
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L6_V2, metric hamming
Use Column embedding2_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.020791000
Time to run search: +000000000 00:00:00.023431000
Molten Lava Cake
Hot Chocolate
Crème Brûlée
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L6_V2, metric jaccard
Use Column embedding2_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.007078000
Time to run search: +000000000 00:00:00.009421000
Molten Lava Cake
Hot Chocolate
Coconut Cream Pie
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L12_V2, metric cosine
Use Column embedding3, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.381905000
Time to run search: +000000000 00:00:00.467303000
Turtle Cheesecake
Chocolate Marble Cheesecake
Clafoutis
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L12_V2, metric euclidean
Use Column embedding3, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.014522000
Time to run search: +000000000 00:00:00.018389000
Turtle Cheesecake
Chocolate Marble Cheesecake
Clafoutis
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L12_V2, metric manhattan
Use Column embedding3, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.013553000
Time to run search: +000000000 00:00:00.018366000
Turtle Cheesecake
Clafoutis
Chocolate Marble Cheesecake
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L12_V2, metric hamming
Use Column embedding3_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.022576000
Time to run search: +000000000 00:00:00.025727000
Clafoutis
Turtle Cheesecake
Qatayef
--------------------------------------------------
Semantic search for [a decadent dessert would be tasty] top k=3
Model ALL_MINILM_L12_V2, metric jaccard
Use Column embedding3_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.014365000
Time to run search: +000000000 00:00:00.017236000
Clafoutis
Turtle Cheesecake
Qatayef
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric cosine
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.106428000
Time to run search: +000000000 00:00:00.110066000
Quinoa Salad
Egg Salad Sandwich
Cobb Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric euclidean
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.005031000
Time to run search: +000000000 00:00:00.008086000
Quinoa Salad
Egg Salad Sandwich
Cobb Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric manhattan
Use Column embedding, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.004651000
Time to run search: +000000000 00:00:00.007773000
Quinoa Salad
Egg Salad Sandwich
Cobb Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric hamming
Use Column embedding_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.007695000
Time to run search: +000000000 00:00:00.010658000
Quinoa Salad
Tofu Scramble
Apple Walnut Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_XSMALL_V1, metric jaccard
Use Column embedding_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.005599000
Time to run search: +000000000 00:00:00.007808000
Quinoa Salad
Tofu Lasagna
Vegan Lasagna
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_LARGE_V1, metric cosine
Use Column embedding1, dimensions 1024, format FLOAT32
Time to get search vector: +000000000 00:00:01.252199000
Time to run search: +000000000 00:00:01.261661000
Quinoa Salad
Egg Salad Sandwich
Lentil Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_LARGE_V1, metric euclidean
Use Column embedding1, dimensions 1024, format FLOAT32
Time to get search vector: +000000000 00:00:00.948549000
Time to run search: +000000000 00:00:00.958576000
Quinoa Salad
Egg Salad Sandwich
Lentil Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_LARGE_V1, metric manhattan
Use Column embedding1, dimensions 1024, format FLOAT32
Time to get search vector: +000000000 00:00:00.929341000
Time to run search: +000000000 00:00:00.940072000
Quinoa Salad
Egg Salad Sandwich
Lentil Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_LARGE_V1, metric hamming
Use Column embedding1_binary, dimensions 1024, format BINARY
Time to get search vector: +000000000 00:00:05.444038000
Time to run search: +000000000 00:00:05.450606000
Quinoa Salad
Egg Salad Sandwich
Asparagus Pea Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model MXBAI_EMBED_LARGE_V1, metric jaccard
Use Column embedding1_binary, dimensions 1024, format BINARY
Time to get search vector: +000000000 00:00:00.860917000
Time to run search: +000000000 00:00:00.867010000
Quinoa Salad
Egg Salad Sandwich
Asparagus Pea Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L6_V2, metric cosine
Use Column embedding2, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.229916000
Time to run search: +000000000 00:00:00.233190000
Quinoa Salad
Egg Salad Sandwich
Cobb Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L6_V2, metric euclidean
Use Column embedding2, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.007258000
Time to run search: +000000000 00:00:00.010218000
Quinoa Salad
Egg Salad Sandwich
Cobb Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L6_V2, metric manhattan
Use Column embedding2, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.006493000
Time to run search: +000000000 00:00:00.009940000
Quinoa Salad
Egg Salad Sandwich
Cobb Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L6_V2, metric hamming
Use Column embedding2_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.018663000
Time to run search: +000000000 00:00:00.020892000
Miso Soup
Grilled Zucchini Salad
Quinoa Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L6_V2, metric jaccard
Use Column embedding2_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.006978000
Time to run search: +000000000 00:00:00.009056000
Miso Soup
Quinoa Salad
Grilled Zucchini Salad
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L12_V2, metric cosine
Use Column embedding3, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.313419000
Time to run search: +000000000 00:00:00.349645000
Quinoa Salad
Cobb Salad
Egg Salad Sandwich
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L12_V2, metric euclidean
Use Column embedding3, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.014296000
Time to run search: +000000000 00:00:00.017751000
Quinoa Salad
Cobb Salad
Egg Salad Sandwich
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L12_V2, metric manhattan
Use Column embedding3, dimensions 384, format FLOAT32
Time to get search vector: +000000000 00:00:00.013647000
Time to run search: +000000000 00:00:00.017090000
Quinoa Salad
Cobb Salad
Egg Salad Sandwich
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L12_V2, metric hamming
Use Column embedding3_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.018629000
Time to run search: +000000000 00:00:00.020806000
Quinoa Salad
Cobb Salad
Tofu and Peanut Noodles
--------------------------------------------------
Semantic search for [what kinds of healthy lunch options are there?] top k=3
Model ALL_MINILM_L12_V2, metric jaccard
Use Column embedding3_binary, dimensions 384, format BINARY
Time to get search vector: +000000000 00:00:00.018473000
Time to run search: +000000000 00:00:00.020844000
Quinoa Salad
Cobb Salad
Tofu and Peanut Noodles
--------------------------------------------------


PL/SQL procedure successfully completed.


*/