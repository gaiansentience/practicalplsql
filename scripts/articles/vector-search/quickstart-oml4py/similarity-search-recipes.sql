--similarity-search-recipes.sql
column name format a30
column doc format a200

select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(ALL_MINILM_L6_V2 using 'yummy dessert' as data)
        , cosine)
fetch first 3 rows only;

select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(ALL_MINILM_L6_V2 using 'serious nutrition' as data)
        , euclidean)
fetch first 3 rows only;

select name, doc
from recipes g
order by 
    vector_distance(
        g.embedding
        , vector_embedding(ALL_MINILM_L6_V2 using 'healthy snack' as data)
        , euclidean_squared)
fetch first 3 rows only;


/*
NAME                           DOC                                                                                                                                                                                                     
Strawberry Pie                 Strawberries in a light syrup and a flaky crust are a great after dinner option                                                                                                                         
Raspberry Tarts                Fresh raspberries in a folded pie crust are a great fall snack                                                                                                                                          
Grilled Cheese Sandwiches      Cheese, tomato slices and bread for a quick and delicious lunch                                                                                                                                         


NAME                           DOC                                                                                                                                                                                                     
Grilled Cheese Sandwiches      Cheese, tomato slices and bread for a quick and delicious lunch                                                                                                                                         
Curried Tofu                   Tofu, vegetables and a light curry sauce served over rice is a nutritious and easy to prepare meal for anytime                                                                                          
Oatmeal Cookies                Use oatmeal and raisins with flour, oil and egg equivalent.  Bake for a special treat                                                                                                                   


NAME                           DOC                                                                                                                                                                                                     
Grilled Cheese Sandwiches      Cheese, tomato slices and bread for a quick and delicious lunch                                                                                                                                         
Raspberry Tarts                Fresh raspberries in a folded pie crust are a great fall snack                                                                                                                                          
Strawberry Pie                 Strawberries in a light syrup and a flaky crust are a great after dinner option   
*/