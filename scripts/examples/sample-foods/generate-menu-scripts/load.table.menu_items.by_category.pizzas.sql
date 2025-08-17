prompt loading menu items for category: Pizzas
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
 

    c := 'Pizzas';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Apple ~' || chr(38) || q'~ Brie Pizza~', q'~Thinly sliced apples, creamy brie, mozzarella, walnuts, and a drizzle of honey.~');
create_item(c, q'~Artichoke ~' || chr(38) || q'~ Olive Pizza~', q'~Marinated artichoke hearts, Kalamata olives, roasted garlic, mozzarella, and feta cheese.~');
create_item(c, q'~BBQ Brisket Pizza~', q'~Tender smoked brisket, barbecue sauce, caramelized onions, cheddar and mozzarella cheeses, finished with crispy fried onions.~');
create_item(c, q'~BBQ Chicken Pizza~', q'~Pizza topped with tangy barbecue sauce, grilled chicken, red onions, mozzarella, and cheddar cheese. Baked until the crust is crisp and the cheese is bubbly.~');
create_item(c, q'~Bacon Cheeseburger Pizza~', q'~Ground beef, crispy bacon, cheddar and mozzarella cheeses, pickles, onions, and a swirl of burger sauce.~');
create_item(c, q'~Breakfast Pizza~', q'~Scrambled eggs, breakfast sausage, crispy bacon, cheddar and mozzarella cheeses, finished with chives.~');
create_item(c, q'~Broccoli Rabe ~' || chr(38) || q'~ Sausage Pizza~', q'~Sautéed broccoli rabe, Italian sausage, garlic, mozzarella, and chili flakes.~');
create_item(c, q'~Buffalo Cauliflower Pizza~', q'~Crispy buffalo cauliflower florets, ranch drizzle, mozzarella, and sliced scallions on a golden crust.~');
create_item(c, q'~Buffalo Chicken Pizza~', q'~Spicy buffalo sauce base, grilled chicken breast, red onions, mozzarella, and blue cheese crumbles, finished with a drizzle of ranch dressing and chopped scallions.~');
create_item(c, q'~Buffalo Mozzarella ~' || chr(38) || q'~ Tomato Pizza~', q'~Creamy buffalo mozzarella, heirloom tomatoes, basil, and extra virgin olive oil.~');
create_item(c, q'~Buffalo Ranch Veggie Pizza~', q'~Buffalo sauce base, roasted vegetables, mozzarella, and a swirl of ranch dressing.~');
create_item(c, q'~Buffalo Tofu Pizza~', q'~Crispy buffalo tofu, ranch drizzle, mozzarella, and sliced scallions on a vegan crust.~');
create_item(c, q'~Cajun Seafood Pizza~', q'~Cajun-spiced shrimp and crab, bell peppers, mozzarella, and a touch of hot sauce.~');
create_item(c, q'~Caprese Pizza~', q'~A classic combination of fresh mozzarella, sliced tomatoes, basil leaves, and a drizzle of balsamic glaze on a golden crust.~');
create_item(c, q'~Caramelized Onion ~' || chr(38) || q'~ Gruyère Pizza~', q'~Sweet caramelized onions, nutty Gruyère cheese, mozzarella, and fresh thyme.~');
create_item(c, q'~Chicken Alfredo Pizza~', q'~Creamy Alfredo sauce, grilled chicken breast, broccoli florets, mozzarella, and parmesan cheese.~');
create_item(c, q'~Chicken Pesto Pizza~', q'~A gourmet pizza with a base of basil pesto sauce, topped with grilled chicken breast slices, sun-dried tomatoes, mozzarella, and parmesan cheese. Baked until golden and garnished with fresh basil.~');
create_item(c, q'~Chorizo ~' || chr(38) || q'~ Manchego Pizza~', q'~Spanish chorizo, sliced red peppers, manchego cheese, mozzarella, and smoked paprika.~');
create_item(c, q'~Cuban Mojo Pork Pizza~', q'~Mojo-marinated pulled pork, pickles, Swiss cheese, mozzarella, and yellow mustard drizzle.~');
create_item(c, q'~Egg ~' || chr(38) || q'~ Asparagus Pizza~', q'~Tender asparagus spears, cracked eggs, mozzarella, parmesan, and a sprinkle of black pepper.~');
create_item(c, q'~Eggplant Parmesan Pizza~', q'~Breaded eggplant slices, marinara sauce, mozzarella, parmesan, and fresh basil on a golden crust.~');
create_item(c, q'~Fig ~' || chr(38) || q'~ Goat Cheese Pizza~', q'~Sweet figs, creamy goat cheese, caramelized onions, mozzarella, and a drizzle of balsamic reduction.~');
create_item(c, q'~Four Cheese Pizza~', q'~A decadent pizza with a blend of mozzarella, cheddar, parmesan, and gorgonzola cheeses, melted over a thin, crispy crust and finished with a sprinkle of herbs.~');
create_item(c, q'~French Onion Pizza~', q'~Caramelized onions, Gruyère cheese, mozzarella, and a sprinkle of thyme on a golden crust.~');
create_item(c, q'~Greek Gyro Pizza~', q'~Seasoned gyro meat, sliced red onions, tomatoes, feta cheese, mozzarella, and a drizzle of creamy tzatziki sauce.~');
create_item(c, q'~Hawaiian Pizza~', q'~Pizza with a sweet and savory combination of sliced ham and juicy pineapple chunks, topped with mozzarella cheese and tomato sauce.~');
create_item(c, q'~Jerk Chicken Pizza~', q'~Jamaican jerk-marinated chicken, pineapple, red onions, mozzarella, and fresh cilantro.~');
create_item(c, q'~Kimchi ~' || chr(38) || q'~ Pork Belly Pizza~', q'~Spicy kimchi, crispy pork belly, mozzarella, scallions, and sesame seeds.~');
create_item(c, q'~Lemon Ricotta Pizza~', q'~Creamy ricotta, lemon zest, mozzarella, fresh basil, and a touch of black pepper.~');
create_item(c, q'~Margherita Pizza~', q'~A traditional Neapolitan pizza featuring a thin, chewy crust topped with tangy tomato sauce, slices of fresh mozzarella cheese, and fragrant basil leaves. Baked in a hot oven until the cheese is bubbly and the crust is golden.~');
create_item(c, q'~Mediterranean Delight Pizza~', q'~A thin crust pizza topped with roasted eggplant, zucchini, sun-dried tomatoes, Kalamata olives, feta cheese, and a touch of oregano.~');
create_item(c, q'~Miso Eggplant Pizza~', q'~Miso-glazed eggplant, scallions, mozzarella, sesame seeds, and a touch of chili oil.~');
create_item(c, q'~Moroccan Lamb Pizza~', q'~Spiced ground lamb, roasted red peppers, feta, mozzarella, and a sprinkle of cumin and coriander.~');
create_item(c, q'~Pear ~' || chr(38) || q'~ Gorgonzola Pizza~', q'~Sliced pears, creamy gorgonzola, walnuts, mozzarella, and a drizzle of honey.~');
create_item(c, q'~Peking Duck Pizza~', q'~Shredded Peking duck, hoisin sauce, scallions, mozzarella, and crispy wonton strips.~');
create_item(c, q'~Pepperoni Pizza~', q'~Classic pizza with a crispy crust, tangy tomato sauce, gooey mozzarella cheese, and generous slices of spicy pepperoni. Baked until the edges are golden and the cheese is bubbling.~');
create_item(c, q'~Pesto Shrimp Pizza~', q'~Basil pesto base, marinated shrimp, cherry tomatoes, mozzarella, and parmesan cheese.~');
create_item(c, q'~Philly Cheesesteak Pizza~', q'~Thinly sliced steak, sautéed onions and peppers, provolone and mozzarella cheeses, on a garlic butter crust.~');
create_item(c, q'~Pineapple Jalapeño Pizza~', q'~Sweet pineapple chunks, spicy jalapeño slices, mozzarella, and a tangy tomato sauce.~');
create_item(c, q'~Prosciutto ~' || chr(38) || q'~ Arugula Pizza~', q'~A crispy crust with tomato sauce, mozzarella, thinly sliced prosciutto, baked and topped with fresh arugula and shaved parmesan.~');
create_item(c, q'~Pulled Jackfruit BBQ Pizza~', q'~Vegan pulled jackfruit in tangy barbecue sauce, red onions, bell peppers, and vegan mozzarella.~');
create_item(c, q'~Pulled Pork Pizza~', q'~Slow-cooked pulled pork, tangy barbecue sauce, caramelized onions, cheddar and mozzarella cheeses, finished with fresh cilantro.~');
create_item(c, q'~Pumpkin Sage Pizza~', q'~Roasted pumpkin puree, crispy sage leaves, mozzarella, ricotta, and toasted pine nuts.~');
create_item(c, q'~Roasted Beet ~' || chr(38) || q'~ Feta Pizza~', q'~Roasted beet slices, crumbled feta, arugula, mozzarella, and balsamic glaze.~');
create_item(c, q'~Roasted Corn ~' || chr(38) || q'~ Chorizo Pizza~', q'~Sweet roasted corn, spicy chorizo, mozzarella, cheddar, and fresh cilantro.~');
create_item(c, q'~Roasted Garlic ~' || chr(38) || q'~ Spinach Pizza~', q'~Creamy roasted garlic sauce, sautéed spinach, mozzarella, and a touch of nutmeg.~');
create_item(c, q'~Roasted Tomato ~' || chr(38) || q'~ Burrata Pizza~', q'~Oven-roasted tomatoes, creamy burrata cheese, basil, and a drizzle of olive oil.~');
create_item(c, q'~Sausage Pizza~', q'~A hearty pizza featuring Italian sausage crumbles, roasted red and green peppers, onions, mozzarella cheese, and a robust tomato sauce on a traditional pizza crust. Finished with a sprinkle of oregano.~');
create_item(c, q'~Seafood Pizza~', q'~A gourmet pizza topped with shrimp, calamari, and mussels, along with tomato sauce, mozzarella cheese, and fresh herbs. Baked until the seafood is tender.~');
create_item(c, q'~Sicilian Square Pizza~', q'~Thick, airy crust topped with tomato sauce, mozzarella, anchovies, capers, and oregano.~');
create_item(c, q'~Smoked Salmon Pizza~', q'~A crispy crust with dill cream cheese, smoked salmon, capers, red onions, and fresh chives.~');
create_item(c, q'~Spicy Italian Pizza~', q'~A robust pizza with spicy Italian sausage, pepperoni, roasted red peppers, mozzarella, and a fiery arrabbiata sauce.~');
create_item(c, q'~Spicy Shrimp Pizza~', q'~Marinated shrimp, spicy tomato sauce, roasted garlic, mozzarella, and fresh cilantro.~');
create_item(c, q'~Spinach and Ricotta Pizza~', q'~Pizza topped with creamy ricotta cheese, sautéed spinach, mozzarella, and a hint of garlic, baked until golden and delicious.~');
create_item(c, q'~Sweet Potato ~' || chr(38) || q'~ Sage Pizza~', q'~Roasted sweet potato slices, crispy sage, mozzarella, ricotta, and toasted pecans.~');
create_item(c, q'~Tandoori Chicken Pizza~', q'~Tandoori-marinated chicken, red onions, bell peppers, mozzarella, and a drizzle of mint yogurt sauce.~');
create_item(c, q'~Thai Chicken Pizza~', q'~Peanut sauce base, grilled chicken, shredded carrots, red bell peppers, mozzarella, and fresh cilantro.~');
create_item(c, q'~Truffle Mushroom Pizza~', q'~A luxurious pizza featuring wild mushrooms sautéed in truffle oil, layered over creamy garlic sauce, topped with mozzarella, fontina, and a sprinkle of fresh thyme.~');
create_item(c, q'~Veggie Pizza~', q'~A hand-tossed pizza crust topped with tangy tomato sauce, mozzarella cheese, and a medley of fresh vegetables such as bell peppers, mushrooms, onions, olives, and spinach. Baked until the crust is crisp and the cheese is bubbly.~');
create_item(c, q'~White Garlic Pizza~', q'~A rich white sauce base with roasted garlic, ricotta, mozzarella, parmesan, and a sprinkle of fresh parsley.~');
create_item(c, q'~Zaatar ~' || chr(38) || q'~ Halloumi Pizza~', q'~Zaatar-spiced olive oil, grilled halloumi cheese, tomatoes, olives, and fresh mint.~');


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


    

