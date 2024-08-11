create table if not exists recipes (
    id number, 
    name varchar2(100), 
    doc varchar2(4000), 
    embedding vector, 
    embedding_model varchar2(100)
);
/

declare
    procedure insert_recipe(
        p_id number, 
        p_name in varchar2, 
        p_doc in varchar2)
    is
    begin
        insert into recipes(id, name, doc)
        values (p_id, p_name, p_doc);
    end insert_recipe;
begin

    execute immediate('truncate table recipes drop storage');
    
    insert_recipe(1, 'Oatmeal Cookies', 
        'Use oatmeal and raisins with flour, oil and egg equivalent.  Bake for a special treat');
    insert_recipe(2, 'Strawberry Pie', 
        'Strawberries in a light syrup and a flaky crust are a great after dinner option');
    insert_recipe(3, 'Grilled Cheese Sandwiches', 
        'Cheese, tomato slices and bread for a quick and delicious lunch');
    insert_recipe(4, 'Miso Soup', 
        'Miso with tofu cubes and sliced green onions are the perfect complement to a sushi dinner');
    insert_recipe(5, 'Curried Tofu', 
        'Tofu, vegetables and a light curry sauce served over rice is a nutritious and easy to prepare meal for anytime');
    insert_recipe(6, 'Raspberry Tarts', 
        'Fresh raspberries in a folded pie crust are a great fall snack');
    
    update recipes g
    set 
        embedding = vector_embedding(all_minilm_l6_v2 using g.doc as data), 
        embedding_model = 'ALL_MINILM_L6_V2';


commit;

end;
/