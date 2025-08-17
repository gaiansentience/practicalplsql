prompt loading menu items for category: Salads
prompt script generated: 2025-08-17 21:10:29

set feedback on;
set serveroutput on;

declare

    l_count number;
    c menu_categories.category_name%type;

    type t_category_ids is table of integer index by varchar2(100);
    l_categories t_category_ids;

    procedure load_categories_array
    is
    begin
        l_categories := t_category_ids(for r in (select category_name, category_id from menu_categories) index r.category_name => r.category_id);
    end load_categories_array;

     procedure create_item(
        p_category_name in varchar2, 
        p_item_name in varchar2, 
        p_description in varchar2, 
        p_created_by in varchar2 default 'sample')
     is
        l_category_id integer := l_categories(p_category_name);
     begin     
        savepoint new_menu_item;

        insert into menu_items (item_name, category_id, item_description, created_by)
        values (p_item_name, l_category_id, p_description, p_created_by);
    exception
        when others then
            rollback to new_menu_item;
            dbms_output.put_line('Error inserting item: ' || p_item_name || ' SQLERRM: ' || sqlerrm);            
     end create_item;

begin

    load_categories_array;
 

    c := 'Salads';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Apple Walnut Salad~', q'~Mixed greens topped with crisp apple slices, toasted walnuts, crumbled blue cheese, and dried cranberries. Finished with a honey mustard vinaigrette for a sweet and savory balance.~');
create_item(c, q'~Arugula Beet Salad~', q'~Peppery arugula leaves paired with roasted beets, creamy goat cheese, and toasted walnuts. Drizzled with a honey-balsamic vinaigrette for a sweet and earthy flavor combination.~');
create_item(c, q'~Asian Chicken Salad~', q'~Grilled chicken breast served over mixed greens, shredded cabbage, carrots, mandarin oranges, and crispy wonton strips, tossed in a sesame-ginger dressing.~');
create_item(c, q'~Asian Edamame Salad~', q'~A vibrant salad with shelled edamame, shredded cabbage, julienned carrots, and scallions, tossed in a sesame-ginger dressing and topped with toasted sesame seeds.~');
create_item(c, q'~Asparagus Pea Salad~', q'~Tender asparagus spears and sweet green peas tossed with fresh mint and a zesty lemon dressing. Garnished with shaved parmesan for a spring-inspired salad.~');
create_item(c, q'~Avocado Chickpea Salad~', q'~Creamy avocado and hearty chickpeas combined with diced cucumber, cherry tomatoes, and a lemony dressing. Garnished with fresh parsley.~');
create_item(c, q'~Avocado Corn Salad~', q'~Creamy avocado chunks, sweet corn kernels, cherry tomatoes, and red onion tossed in a tangy lime vinaigrette. Garnished with cilantro for a fresh, vibrant flavor.~');
create_item(c, q'~Berry Spinach Salad~', q'~Baby spinach leaves tossed with a medley of fresh berries, toasted almonds, and a sweet-tart poppy seed dressing. A colorful and antioxidant-rich salad.~');
create_item(c, q'~Broccoli Cranberry Salad~', q'~Crunchy broccoli florets mixed with sweet dried cranberries, roasted sunflower seeds, and red onion. Coated in a creamy yogurt-based dressing for a sweet and savory salad.~');
create_item(c, q'~Broccoli Quinoa Salad~', q'~Protein-rich quinoa mixed with steamed broccoli florets, toasted almonds, and scallions, all tossed in a lemon vinaigrette for a light, healthy salad.~');
create_item(c, q'~Cabbage Apple Slaw~', q'~Shredded cabbage and crisp apples tossed with grated carrots and a tangy apple cider vinaigrette. A crunchy, refreshing slaw perfect for picnics.~');
create_item(c, q'~Caesar Salad~', q'~Crisp romaine lettuce tossed with creamy Caesar dressing made from anchovies, garlic, lemon juice, Dijon mustard, and parmesan cheese. Garnished with crunchy croutons and extra shaved parmesan for a savory, satisfying salad.~');
create_item(c, q'~Caprese Salad~', q'~A simple yet elegant salad featuring slices of creamy fresh mozzarella, juicy ripe tomatoes, and fragrant basil leaves. Drizzled with extra virgin olive oil and balsamic glaze, finished with a sprinkle of sea salt and black pepper.~');
create_item(c, q'~Carrot Ginger Salad~', q'~Shredded carrots tossed with fresh ginger, scallions, and a sesame-soy dressing. Topped with toasted sesame seeds for a crunchy, flavorful salad.~');
create_item(c, q'~Chickpea Greek Salad~', q'~A Mediterranean-inspired salad featuring chickpeas, diced cucumber, ripe tomatoes, Kalamata olives, red onion, and crumbled feta cheese. Dressed with olive oil, lemon juice, and oregano.~');
create_item(c, q'~Chopped Detox Salad~', q'~A nutrient-dense salad with finely chopped broccoli, cauliflower, carrots, and kale, tossed in a bright lemon vinaigrette. Packed with vitamins and flavor.~');
create_item(c, q'~Cobb Salad~', q'~A hearty salad with rows of grilled chicken, crispy bacon, hard-boiled egg, avocado, blue cheese, tomatoes, and romaine lettuce, served with ranch or vinaigrette.~');
create_item(c, q'~Cucumber Tomato Salad~', q'~Refreshing salad of sliced cucumbers, ripe tomatoes, and thinly sliced red onion, tossed in a red wine vinaigrette with fresh dill and parsley.~');
create_item(c, q'~Farro Vegetable Salad~', q'~Nutty farro grains mixed with roasted seasonal vegetables, fresh herbs, and a bright lemon-herb dressing. Served chilled or at room temperature for a wholesome side.~');
create_item(c, q'~Fennel Orange Salad~', q'~Crisp fennel slices and juicy orange segments tossed with arugula and a light olive oil dressing. Finished with cracked black pepper and fresh herbs.~');
create_item(c, q'~Fruit Salad~', q'~A colorful medley of fresh seasonal fruits such as melon, berries, grapes, and citrus, cut into bite-sized pieces and lightly tossed in a citrus-honey dressing.~');
create_item(c, q'~Garden Salad~', q'~A fresh mix of leafy greens, cherry tomatoes, cucumber, carrots, and red onion, tossed in your choice of dressing. A classic, crisp starter.~');
create_item(c, q'~Greek Salad~', q'~A traditional Greek salad with crisp cucumbers, ripe tomatoes, red onion, Kalamata olives, and creamy feta cheese, tossed in a lemon-oregano vinaigrette.~');
create_item(c, q'~Grilled Zucchini Salad~', q'~Grilled zucchini slices tossed with crumbled feta cheese, fresh mint, and a squeeze of lemon. Served warm or at room temperature for a summery salad.~');
create_item(c, q'~Kale Caesar Salad~', q'~A modern twist on the classic Caesar, combining tender kale and crisp romaine lettuce, tossed in a light Caesar dressing with parmesan cheese and crunchy whole-grain croutons. Finished with a squeeze of lemon.~');
create_item(c, q'~Lentil Salad~', q'~Nutritious salad made with cooked lentils, diced carrots, celery, red onion, and fresh parsley. Tossed in a tangy Dijon mustard vinaigrette for a hearty and satisfying dish.~');
create_item(c, q'~Mango Black Bean Salad~', q'~Sweet mango cubes combined with black beans, red bell pepper, jalapeño, and cilantro, all tossed in a zesty lime dressing for a tropical, protein-rich salad.~');
create_item(c, q'~Mediterranean Lentil Salad~', q'~Earthy lentils combined with diced cucumber, tomatoes, feta cheese, Kalamata olives, and fresh herbs, all tossed in a lemon-oregano dressing.~');
create_item(c, q'~Moroccan Chickpea Salad~', q'~Chickpeas tossed with shredded carrots, golden raisins, fresh cilantro, and a cumin-spiced citrus dressing. Garnished with toasted almonds for crunch.~');
create_item(c, q'~Pear Gorgonzola Salad~', q'~Mixed greens topped with juicy pear slices, crumbled gorgonzola cheese, toasted walnuts, and dried cranberries. Dressed with a light balsamic vinaigrette.~');
create_item(c, q'~Pomegranate Spinach Salad~', q'~Fresh spinach leaves tossed with juicy pomegranate seeds, toasted walnuts, crumbled feta, and a tangy balsamic vinaigrette.~');
create_item(c, q'~Potato Salad~', q'~Creamy potato salad made with tender potatoes, hard-boiled eggs, celery, onions, and fresh herbs, all tossed in a tangy mayonnaise-mustard dressing.~');
create_item(c, q'~Pumpkin Seed Spinach Salad~', q'~Fresh spinach leaves tossed with roasted pumpkin seeds, dried cranberries, and a tangy balsamic vinaigrette. Topped with crumbled feta cheese.~');
create_item(c, q'~Quinoa Avocado Salad~', q'~Protein-packed quinoa mixed with creamy avocado chunks, juicy cherry tomatoes, crisp cucumber, and fresh herbs. Tossed in a zesty lemon dressing for a light and nutritious salad.~');
create_item(c, q'~Radish Cucumber Salad~', q'~Thinly sliced radishes and cucumbers tossed with fresh dill and a creamy yogurt dressing. Light, crisp, and refreshing.~');
create_item(c, q'~Roasted Brussels Sprout Salad~', q'~Roasted Brussels sprouts tossed with dried cranberries, toasted pecans, and a maple-Dijon vinaigrette. Served warm for a hearty, flavorful salad.~');
create_item(c, q'~Roasted Carrot Salad~', q'~Oven-roasted carrots served over a bed of arugula, topped with crumbled feta cheese and toasted pistachios. Drizzled with a honey-lemon dressing.~');
create_item(c, q'~Roasted Cauliflower Salad~', q'~Roasted cauliflower florets combined with peppery arugula, toasted almonds, and a creamy tahini sauce. Finished with a sprinkle of pomegranate seeds.~');
create_item(c, q'~Roasted Sweet Potato Salad~', q'~Roasted cubes of sweet potato combined with fresh spinach, toasted pumpkin seeds, and red onion, all tossed in a creamy tahini dressing for a hearty, nutrient-rich salad.~');
create_item(c, q'~Seitan Caesar Salad~', q'~Crisp romaine lettuce tossed with creamy vegan Caesar dressing, crunchy croutons, and grilled seitan strips. Finished with a sprinkle of vegan parmesan.~');
create_item(c, q'~Southwest Black Bean Salad~', q'~A zesty salad featuring black beans, sweet corn, diced bell peppers, red onion, and cilantro, all tossed in a tangy cilantro-lime dressing. Perfect as a side or light meal.~');
create_item(c, q'~Spinach Strawberry Salad~', q'~Fresh baby spinach leaves tossed with sweet sliced strawberries, toasted walnuts, and creamy goat cheese. Dressed with a tangy balsamic vinaigrette for a refreshing and colorful salad.~');
create_item(c, q'~Sweet Corn Tomato Salad~', q'~Sweet corn kernels mixed with diced tomatoes, fresh basil, and a drizzle of olive oil. A simple, vibrant salad that highlights summer produce.~');
create_item(c, q'~Sweet Potato Kale Salad~', q'~Tender kale leaves massaged with olive oil, topped with roasted sweet potato cubes, dried cranberries, and toasted pecans. Tossed in a maple-balsamic dressing.~');
create_item(c, q'~Tabbouleh Salad~', q'~A Middle Eastern salad made with finely chopped parsley, bulgur wheat, diced tomatoes, cucumber, mint, and scallions, all tossed in a lemon-olive oil dressing.~');
create_item(c, q'~Tofu Buddha Bowl~', q'~A nourishing bowl with baked tofu, quinoa, roasted sweet potatoes, steamed broccoli, shredded carrots, and avocado, drizzled with a zesty tahini-lemon dressing.~');
create_item(c, q'~Tofu Caesar Salad~', q'~Crisp romaine lettuce tossed with creamy vegan Caesar dressing, crunchy croutons, and grilled tofu strips. Finished with a sprinkle of vegan parmesan.~');
create_item(c, q'~Tofu Poke Bowl~', q'~Cubed tofu marinated in soy sauce and sesame oil, served over sushi rice with edamame, avocado, cucumber, seaweed salad, and pickled ginger.~');
create_item(c, q'~Tofu and Kale Power Bowl~', q'~A wholesome bowl with marinated tofu, massaged kale, roasted chickpeas, quinoa, shredded carrots, and a lemon-tahini dressing.~');
create_item(c, q'~Tofu and Mango Salad~', q'~Mixed greens topped with grilled tofu, juicy mango slices, red bell pepper, and a tangy chili-lime vinaigrette. Finished with toasted sesame seeds.~');
create_item(c, q'~Tofu and Zucchini Noodle Bowl~', q'~Spiralized zucchini noodles tossed with baked tofu, cherry tomatoes, olives, and a basil-pesto dressing for a light, gluten-free meal.~');
create_item(c, q'~Tomato Basil Mozzarella Salad~', q'~Sliced ripe tomatoes layered with fresh mozzarella and basil leaves, drizzled with balsamic glaze and extra virgin olive oil for a classic Italian salad.~');
create_item(c, q'~Waldorf Salad~', q'~A classic salad with crisp apples, celery, grapes, and toasted walnuts, all tossed in a creamy mayonnaise dressing and served on a bed of lettuce.~');
create_item(c, q'~Warm Mushroom Salad~', q'~Sautéed mushrooms served warm over fresh spinach, drizzled with a balsamic reduction and topped with toasted pine nuts for a savory, earthy salad.~');
create_item(c, q'~Watermelon Feta Salad~', q'~Juicy watermelon cubes tossed with crumbled feta cheese, fresh mint leaves, and a squeeze of lime juice. A refreshing and sweet-savory summer salad.~');
create_item(c, q'~Zucchini Ribbon Salad~', q'~Thin ribbons of zucchini tossed with toasted pine nuts, shaved parmesan, and a light lemon dressing. A delicate and elegant salad perfect for warm weather.~');


    select count(*) into l_count 
    from menu_items
    where category_id = l_categories(c);

    dbms_output.put_line('Created ' || l_count || ' menu items for category: ' || c);    

    commit;


exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/


    

