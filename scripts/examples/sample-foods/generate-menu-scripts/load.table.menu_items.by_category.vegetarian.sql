prompt loading menu items for category: Vegetarian
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
 

    c := 'Vegetarian';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Eggplant Parmesan~', q'~Breaded and fried eggplant slices layered with marinara sauce and mozzarella cheese, baked until bubbly and golden. Served with a side of pasta.~');
create_item(c, q'~Grilled Vegetable Platter~', q'~A colorful assortment of seasonal vegetables such as zucchini, bell peppers, eggplant, and asparagus, marinated in olive oil, garlic, and herbs, then grilled to perfection. Served warm and garnished with fresh herbs and a drizzle of balsamic reduction.~');
create_item(c, q'~Mapo Tofu~', q'~A classic Sichuan dish featuring soft tofu cubes simmered in a spicy, aromatic sauce made with fermented bean paste, ground Sichuan peppercorns, minced garlic, and ground pork or mushrooms. Served hot with steamed rice.~');
create_item(c, q'~Mushroom Risotto~', q'~Creamy risotto made with Arborio rice, sautéed mushrooms, onions, garlic, and parmesan cheese. Finished with fresh herbs and a drizzle of truffle oil.~');
create_item(c, q'~Seitan Bourguignon~', q'~Hearty stew featuring seitan chunks braised in red wine with mushrooms, pearl onions, carrots, and fresh thyme. Served over creamy mashed potatoes or crusty bread.~');
create_item(c, q'~Seitan Jambalaya~', q'~A spicy Creole rice dish with seitan chunks, bell peppers, celery, onions, tomatoes, and Cajun spices. Slow-cooked for deep, smoky flavor.~');
create_item(c, q'~Seitan Katsu Curry~', q'~Breaded and fried seitan cutlets served over steamed rice and topped with a rich Japanese curry sauce made from onions, carrots, potatoes, and mild spices.~');
create_item(c, q'~Seitan Stir-Fry~', q'~Tender strips of seitan sautéed with colorful bell peppers, broccoli, carrots, and snap peas in a savory garlic-ginger soy sauce. Served over steamed jasmine rice for a protein-packed meal.~');
create_item(c, q'~Seitan Teriyaki Bowl~', q'~Grilled seitan glazed with sweet and savory teriyaki sauce, served over steamed rice with broccoli, carrots, and edamame.~');
create_item(c, q'~Seitan Tikka Masala~', q'~Chunks of seitan marinated in Indian spices, grilled, and simmered in a rich, creamy tomato-cashew sauce. Served with basmati rice and naan.~');
create_item(c, q'~Seitan and Broccoli Stir-Fry~', q'~Seitan strips and crisp broccoli florets stir-fried in a savory hoisin-garlic sauce, finished with toasted sesame seeds. Served over steamed rice.~');
create_item(c, q'~Seitan and Vegetable Curry~', q'~Seitan cubes simmered with assorted vegetables in a fragrant coconut curry sauce, flavored with ginger, garlic, and spices. Served with jasmine rice.~');
create_item(c, q'~Stuffed Peppers~', q'~Bell peppers filled with a savory mixture of rice, vegetables, herbs, and cheese, baked until the peppers are tender and the filling is golden.~');
create_item(c, q'~Tofu Coconut Curry~', q'~Tofu cubes simmered in a creamy coconut milk curry with bell peppers, snap peas, and carrots. Flavored with ginger, garlic, and lemongrass, served over jasmine rice.~');
create_item(c, q'~Tofu Katsu Curry~', q'~Breaded and fried tofu cutlets served over steamed rice and topped with a rich Japanese curry sauce made from onions, carrots, potatoes, and mild spices.~');
create_item(c, q'~Tofu Stir-Fry~', q'~Cubes of tofu stir-fried with colorful vegetables in a savory soy-ginger sauce. Served over steamed jasmine rice for a healthy, plant-based meal.~');
create_item(c, q'~Tofu Tikka Masala~', q'~Marinated tofu cubes grilled and simmered in a creamy, spiced tomato sauce with ginger, garlic, and garam masala. Served with basmati rice and warm naan bread.~');
create_item(c, q'~Tofu and Broccoli Stir-Fry~', q'~Tofu cubes and crisp broccoli florets stir-fried in a savory garlic-ginger sauce, finished with toasted sesame seeds. Served with steamed jasmine rice.~');
create_item(c, q'~Tofu and Eggplant Stir-Fry~', q'~Tofu and tender eggplant pieces stir-fried with garlic, ginger, and a sweet-spicy soy sauce. Served with steamed rice and garnished with scallions.~');
create_item(c, q'~Tofu and Sweet Potato Curry~', q'~Tofu and sweet potato chunks simmered in a fragrant curry sauce with coconut milk, ginger, and spices. Served with steamed basmati rice.~');
create_item(c, q'~Tofu and Vegetable Skewers~', q'~Marinated tofu cubes and colorful vegetables threaded onto skewers and grilled until lightly charred. Served with a tangy peanut dipping sauce.~');
create_item(c, q'~Vegetable Curry~', q'~A medley of fresh vegetables simmered in a fragrant curry sauce made with coconut milk, tomatoes, ginger, garlic, and a blend of spices. Served with steamed rice.~');
create_item(c, q'~Vegetable Stir-Fry~', q'~A colorful medley of fresh vegetables such as bell peppers, broccoli, carrots, and snap peas, quickly stir-fried in a savory soy-ginger sauce. Served over steamed rice.~');
create_item(c, q'~Vegetarian Arepas~', q'~Venezuelan corn cakes grilled until golden and stuffed with black beans, creamy avocado, queso fresco, and pickled onions. Served with a tangy cilantro-lime crema for dipping.~');
create_item(c, q'~Vegetarian Bamia~', q'~Middle Eastern okra stew simmered with ripe tomatoes, onions, garlic, and coriander. Served over fluffy basmati rice and finished with a squeeze of lemon.~');
create_item(c, q'~Vegetarian Bibimbap~', q'~A colorful Korean rice bowl topped with sautéed spinach, shiitake mushrooms, julienned carrots, bean sprouts, pickled radish, and a perfectly fried egg. Served with spicy gochujang sauce and a sprinkle of toasted sesame seeds for authentic flavor.~');
create_item(c, q'~Vegetarian Biryani~', q'~Fragrant Indian basmati rice cooked with a medley of vegetables, saffron threads, toasted cashews, golden raisins, and a blend of aromatic spices including cardamom, cloves, and cinnamon. Served with cooling cucumber raita and fresh cilantro.~');
create_item(c, q'~Vegetarian Bulgogi Bowl~', q'~Korean-style marinated tofu grilled and served over steamed rice with pickled vegetables, sautéed spinach, and a sprinkle of toasted sesame seeds.~');
create_item(c, q'~Vegetarian Caponata~', q'~Sicilian eggplant stew with tomatoes, celery, green olives, capers, and sweet-sour vinegar. Slow-cooked for depth of flavor and served with toasted rustic bread.~');
create_item(c, q'~Vegetarian Chakalaka~', q'~South African spicy vegetable relish with tomatoes, bell peppers, carrots, onions, and baked beans. Served hot with traditional pap (maize porridge).~');
create_item(c, q'~Vegetarian Chana Dal~', q'~Indian split chickpea stew cooked with tomatoes, ginger, garlic, cumin, and turmeric. Served with warm chapati and fresh coriander.~');
create_item(c, q'~Vegetarian Chana Masala~', q'~Indian chickpeas simmered in a rich tomato sauce with onions, ginger, garlic, and garam masala. Served with fluffy basmati rice and fresh coriander.~');
create_item(c, q'~Vegetarian Chilaquiles~', q'~Mexican tortilla chips simmered in tangy green tomatillo salsa, topped with crumbled queso fresco, crema, sliced avocado, and fresh cilantro.~');
create_item(c, q'~Vegetarian Chili~', q'~Hearty chili made with a variety of beans, tomatoes, bell peppers, corn, and spices. Slow-cooked for rich flavor and served with cornbread or rice.~');
create_item(c, q'~Vegetarian Choucroute~', q'~Alsatian sauerkraut braised with tender potatoes, carrots, sweet apples, and juniper berries. Served with slices of rye bread and whole grain mustard.~');
create_item(c, q'~Vegetarian Daal~', q'~Indian lentil stew simmered with ripe tomatoes, ginger, garlic, cumin, and turmeric. Served with steamed basmati rice and fresh coriander.~');
create_item(c, q'~Vegetarian Dolma~', q'~Mediterranean grape leaves stuffed with fragrant rice, pine nuts, currants, and fresh herbs. Simmered gently in a lemon-olive oil broth and served chilled as a mezze.~');
create_item(c, q'~Vegetarian Doro Wat~', q'~Ethiopian spicy stew of lentils, carrots, potatoes, and aromatic berbere spices. Slow-cooked and served with traditional injera flatbread for scooping.~');
create_item(c, q'~Vegetarian Empanadas~', q'~Argentinian pastry pockets filled with sautéed spinach, earthy mushrooms, sweet onions, and melty cheese. Baked until golden brown and served with a zesty chimichurri sauce.~');
create_item(c, q'~Vegetarian Enchiladas~', q'~Corn tortillas filled with sautéed spinach, earthy mushrooms, and creamy cheese. Rolled and topped with spicy red chili sauce, then baked until bubbly and served with sour cream and cilantro.~');
create_item(c, q'~Vegetarian Falafel Wrap~', q'~Middle Eastern spiced chickpea fritters, crispy on the outside and tender inside, wrapped in warm pita bread with lettuce, tomato, cucumber, pickled turnips, and a drizzle of tahini sauce.~');
create_item(c, q'~Vegetarian Fattoush~', q'~Middle Eastern salad of mixed greens, ripe tomatoes, cucumbers, radishes, crispy pita chips, and a tangy sumac-lemon dressing. Garnished with fresh mint and parsley.~');
create_item(c, q'~Vegetarian Fesenjan~', q'~Persian stew of tender eggplant, toasted walnuts, and tangy pomegranate molasses. Simmered until rich and served with fragrant saffron rice.~');
create_item(c, q'~Vegetarian Gado-Gado~', q'~Indonesian salad of blanched vegetables, tofu, tempeh, and boiled eggs. Served with a rich, spicy peanut sauce and garnished with crispy shallots.~');
create_item(c, q'~Vegetarian Gnocchi alla Sorrentina~', q'~Italian potato dumplings baked in a rich tomato sauce with creamy mozzarella and fresh basil. Finished under the broiler for a bubbly, golden crust.~');
create_item(c, q'~Vegetarian Goulash~', q'~Hungarian-style stew featuring chunks of potatoes, carrots, bell peppers, and mushrooms simmered in a paprika-spiced tomato sauce. Finished with a dollop of sour cream and served with slices of hearty rye bread.~');
create_item(c, q'~Vegetarian Gumbo~', q'~Louisiana-style stew with tender okra, bell peppers, celery, tomatoes, kidney beans, and Cajun spices. Slow-cooked for deep flavor and served over steamed rice with a sprinkle of scallions.~');
create_item(c, q'~Vegetarian Jollof Rice~', q'~A West African specialty of tomato-based rice cooked with bell peppers, onions, carrots, and sweet peas. Seasoned with thyme, bay leaves, and Scotch bonnet peppers for a subtle heat, and served with fried plantains.~');
create_item(c, q'~Vegetarian Katsu Curry~', q'~Japanese breaded tofu cutlet served over steamed rice and topped with a mild curry sauce made from caramelized onions, carrots, and potatoes.~');
create_item(c, q'~Vegetarian Katsu Don~', q'~Japanese rice bowl topped with breaded tofu cutlet, caramelized onions, and egg simmered in a sweet soy broth. Garnished with scallions and nori strips.~');
create_item(c, q'~Vegetarian Katsu Sando~', q'~Japanese sandwich with breaded and fried tofu cutlet, shredded cabbage, and tangy tonkatsu sauce, all nestled in soft, pillowy milk bread.~');
create_item(c, q'~Vegetarian Kimbap~', q'~Korean seaweed rice rolls filled with pickled radish, sautéed spinach, carrots, and marinated tofu. Sliced and served with a soy-sesame dipping sauce.~');
create_item(c, q'~Vegetarian Koshari~', q'~Egyptian street food featuring layers of rice, lentils, macaroni, chickpeas, and crispy fried onions. Topped with a spicy tomato sauce and a splash of garlic vinegar.~');
create_item(c, q'~Vegetarian Koshari Bowl~', q'~Egyptian rice, lentils, macaroni, chickpeas, and crispy onions layered and topped with spicy tomato sauce and garlic vinegar.~');
create_item(c, q'~Vegetarian Koshimbir~', q'~Maharashtrian salad of grated carrots, cucumber, shredded coconut, roasted peanuts, and mustard seeds. Dressed with lemon juice and garnished with fresh cilantro.~');
create_item(c, q'~Vegetarian Kuku Bademjan~', q'~Persian eggplant frittata with ripe tomatoes, onions, and fresh herbs. Baked until set and served with warm flatbread.~');
create_item(c, q'~Vegetarian Kuku Kadoo~', q'~Persian zucchini frittata with fresh herbs, scallions, and tangy feta cheese. Baked until golden and served with yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Morgh~', q'~Persian chickpea frittata with fresh herbs, onions, and turmeric. Baked until golden and served with a tangy yogurt sauce.~');
create_item(c, q'~Vegetarian Kuku Sabzi~', q'~Persian herb frittata packed with parsley, cilantro, dill, scallions, and walnuts. Baked until fluffy and green, then sliced and served with yogurt and flatbread.~');
create_item(c, q'~Vegetarian Kuku Sabzi Bowl~', q'~Persian herb frittata served over fragrant saffron rice with feta cheese, toasted walnuts, and a dollop of yogurt sauce.~');
create_item(c, q'~Vegetarian Kuku Sabzi Bruschetta~', q'~Persian herb frittata cubes served on toasted baguette slices with feta cheese and walnuts. Drizzled with olive oil and fresh herbs.~');
create_item(c, q'~Vegetarian Kuku Sabzi Bruschetta Bites~', q'~Persian herb frittata cubes served on mini toasted baguette slices with feta cheese and walnuts. Finished with olive oil and herbs.~');
create_item(c, q'~Vegetarian Kuku Sabzi Bruschetta Bites Micro~', q'~Persian herb frittata cubes served on micro toasted baguette slices with feta cheese and walnuts.~');
create_item(c, q'~Vegetarian Kuku Sabzi Bruschetta Bites Mini~', q'~Persian herb frittata cubes served on mini toasted baguette slices with feta cheese and walnuts.~');
create_item(c, q'~Vegetarian Kuku Sabzi Burger~', q'~Persian herb frittata formed into burger patties, grilled and served on a bun with feta cheese, fresh greens, and a tangy yogurt sauce.~');
create_item(c, q'~Vegetarian Kuku Sabzi Croquette~', q'~Persian herb frittata formed into croquettes, breaded and fried until golden. Served with a cool yogurt sauce.~');
create_item(c, q'~Vegetarian Kuku Sabzi Crostini~', q'~Persian herb frittata cubes served on crostini with feta cheese and walnuts. Finished with a drizzle of olive oil and fresh herbs.~');
create_item(c, q'~Vegetarian Kuku Sabzi Crostini Bites~', q'~Persian herb frittata cubes served on mini crostini with feta cheese and walnuts. Finished with olive oil and herbs.~');
create_item(c, q'~Vegetarian Kuku Sabzi Crostini Bites Micro~', q'~Persian herb frittata cubes served on micro crostini with feta cheese and walnuts.~');
create_item(c, q'~Vegetarian Kuku Sabzi Crostini Bites Mini~', q'~Persian herb frittata cubes served on mini crostini with feta cheese and walnuts.~');
create_item(c, q'~Vegetarian Kuku Sabzi Empanada~', q'~Persian herb frittata baked in pastry with feta cheese and walnuts. Served with a tangy yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Sabzi Empanada Bites~', q'~Persian herb frittata baked in mini pastry shells with feta cheese and walnuts. Served with a cool yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Sabzi Empanada Bites Micro~', q'~Persian herb frittata baked in micro pastry shells with feta cheese and walnuts. Served with yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Sabzi Empanada Bites Mini~', q'~Persian herb frittata baked in mini pastry shells with feta cheese and walnuts. Served with yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Sabzi Flatbread~', q'~Persian herb frittata baked on flatbread with feta cheese, walnuts, and sliced tomatoes. Cut into wedges and served warm.~');
create_item(c, q'~Vegetarian Kuku Sabzi Flatbread Bites~', q'~Persian herb frittata baked on mini flatbread with feta cheese, walnuts, and sliced tomatoes. Served as bite-sized snacks.~');
create_item(c, q'~Vegetarian Kuku Sabzi Flatbread Bites Micro~', q'~Persian herb frittata baked on micro flatbread with feta cheese, walnuts, and sliced tomatoes.~');
create_item(c, q'~Vegetarian Kuku Sabzi Flatbread Bites Mini~', q'~Persian herb frittata baked on mini flatbread with feta cheese, walnuts, and sliced tomatoes.~');
create_item(c, q'~Vegetarian Kuku Sabzi Focaccia~', q'~Persian herb frittata baked on focaccia bread with feta cheese, walnuts, and sliced tomatoes. Cut into squares and served warm.~');
create_item(c, q'~Vegetarian Kuku Sabzi Focaccia Bites~', q'~Persian herb frittata baked on mini focaccia bread with feta cheese, walnuts, and sliced tomatoes. Served warm as snacks.~');
create_item(c, q'~Vegetarian Kuku Sabzi Focaccia Bites Micro~', q'~Persian herb frittata baked on micro focaccia bread with feta cheese, walnuts, and sliced tomatoes. Served warm as micro snacks.~');
create_item(c, q'~Vegetarian Kuku Sabzi Focaccia Bites Mini~', q'~Persian herb frittata baked on mini focaccia bread with feta cheese, walnuts, and sliced tomatoes. Served warm as mini snacks.~');
create_item(c, q'~Vegetarian Kuku Sabzi Frittata~', q'~Classic Persian herb frittata with parsley, cilantro, dill, scallions, and walnuts. Baked until golden and sliced for serving.~');
create_item(c, q'~Vegetarian Kuku Sabzi Kebab~', q'~Persian herb and lentil kebabs grilled and served with saffron rice and a cool yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Sabzi Muffin~', q'~Persian herb frittata baked in muffin tins with feta cheese and walnuts. Served as a portable snack or appetizer.~');
create_item(c, q'~Vegetarian Kuku Sabzi Muffin Bites~', q'~Persian herb frittata baked in mini muffin tins with feta cheese and walnuts. Served as bite-sized snacks or appetizers.~');
create_item(c, q'~Vegetarian Kuku Sabzi Muffin Bites Micro~', q'~Persian herb frittata baked in micro muffin tins with feta cheese and walnuts. Served as micro snacks.~');
create_item(c, q'~Vegetarian Kuku Sabzi Muffin Bites Mini~', q'~Persian herb frittata baked in mini muffin tins with feta cheese and walnuts. Served as bite-sized snacks.~');
create_item(c, q'~Vegetarian Kuku Sabzi Pita~', q'~Persian herb frittata served in pita bread with feta cheese, walnuts, and fresh herbs. Served with a side of yogurt sauce.~');
create_item(c, q'~Vegetarian Kuku Sabzi Pita Bites~', q'~Persian herb frittata served in mini pita bread with feta cheese, walnuts, and fresh herbs. Served with yogurt sauce.~');
create_item(c, q'~Vegetarian Kuku Sabzi Pita Bites Micro~', q'~Persian herb frittata served in micro pita bread with feta cheese, walnuts, and fresh herbs.~');
create_item(c, q'~Vegetarian Kuku Sabzi Pita Bites Mini~', q'~Persian herb frittata served in mini pita bread with feta cheese, walnuts, and fresh herbs.~');
create_item(c, q'~Vegetarian Kuku Sabzi Pizza~', q'~Persian herb frittata baked on a thin pizza crust with feta cheese, walnuts, and sliced tomatoes. Cut into wedges and served warm.~');
create_item(c, q'~Vegetarian Kuku Sabzi Pizza Bites~', q'~Persian herb frittata baked on mini pizza crusts with feta cheese, walnuts, and sliced tomatoes. Served as bite-sized appetizers.~');
create_item(c, q'~Vegetarian Kuku Sabzi Pizza Bites Micro~', q'~Persian herb frittata baked on micro pizza crusts with feta cheese, walnuts, and sliced tomatoes. Served as micro appetizers.~');
create_item(c, q'~Vegetarian Kuku Sabzi Pizza Bites Mini~', q'~Persian herb frittata baked on mini pizza crusts with feta cheese, walnuts, and sliced tomatoes. Served as mini appetizers.~');
create_item(c, q'~Vegetarian Kuku Sabzi Polo~', q'~Persian herbed rice with dill, parsley, cilantro, and saffron. Served with tangy yogurt and toasted walnuts.~');
create_item(c, q'~Vegetarian Kuku Sabzi Quesadilla~', q'~Persian herb frittata folded in a flour tortilla with feta cheese and walnuts, grilled until crispy and golden.~');
create_item(c, q'~Vegetarian Kuku Sabzi Quesadilla Bites~', q'~Persian herb frittata folded in mini tortillas with feta cheese and walnuts, grilled until crispy and golden.~');
create_item(c, q'~Vegetarian Kuku Sabzi Quesadilla Bites Micro~', q'~Persian herb frittata folded in micro tortillas with feta cheese and walnuts, grilled until crispy and golden.~');
create_item(c, q'~Vegetarian Kuku Sabzi Quesadilla Bites Mini~', q'~Persian herb frittata folded in mini tortillas with feta cheese and walnuts, grilled until crispy and golden.~');
create_item(c, q'~Vegetarian Kuku Sabzi Quiche~', q'~Persian herb frittata baked in a buttery quiche crust with feta cheese, walnuts, and scallions. Served in wedges for brunch or lunch.~');
create_item(c, q'~Vegetarian Kuku Sabzi Quiche Bites~', q'~Persian herb frittata baked in mini quiche crusts with feta cheese, walnuts, and scallions. Served as bite-sized appetizers.~');
create_item(c, q'~Vegetarian Kuku Sabzi Quiche Bites Micro~', q'~Persian herb frittata baked in micro quiche crusts with feta cheese, walnuts, and scallions. Served as micro appetizers.~');
create_item(c, q'~Vegetarian Kuku Sabzi Quiche Bites Mini~', q'~Persian herb frittata baked in mini quiche crusts with feta cheese, walnuts, and scallions. Served as mini appetizers.~');
create_item(c, q'~Vegetarian Kuku Sabzi Roll~', q'~Persian herb frittata rolled with tangy feta cheese and toasted walnuts, sliced and served as an appetizer.~');
create_item(c, q'~Vegetarian Kuku Sabzi Roll-Ups~', q'~Persian herb frittata rolled with feta cheese and walnuts, sliced and served as bite-sized finger food.~');
create_item(c, q'~Vegetarian Kuku Sabzi Roll-Ups Bites~', q'~Persian herb frittata rolled with feta cheese and walnuts, sliced and served as mini finger food for parties.~');
create_item(c, q'~Vegetarian Kuku Sabzi Roll-Ups Bites Micro~', q'~Persian herb frittata rolled with feta cheese and walnuts, sliced and served as micro finger food.~');
create_item(c, q'~Vegetarian Kuku Sabzi Roll-Ups Bites Mini~', q'~Persian herb frittata rolled with feta cheese and walnuts, sliced and served as mini finger food.~');
create_item(c, q'~Vegetarian Kuku Sabzi Salad~', q'~Persian herb frittata cubes tossed with mixed greens, feta cheese, walnuts, and a bright lemon dressing.~');
create_item(c, q'~Vegetarian Kuku Sabzi Sandwich~', q'~Persian herb frittata slices served in a sandwich with feta cheese, walnuts, and fresh greens. Perfect for lunch or a light dinner.~');
create_item(c, q'~Vegetarian Kuku Sabzi Skewer Bites~', q'~Persian herb frittata cubes skewered with cherry tomatoes and feta cheese, grilled and served with a cool yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Sabzi Skewer Bites Micro~', q'~Persian herb frittata cubes skewered with cherry tomatoes and feta cheese, grilled and served with yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Sabzi Skewer Bites Mini~', q'~Persian herb frittata cubes skewered with cherry tomatoes and feta cheese, grilled and served with yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Sabzi Skewers~', q'~Persian herb frittata cubes skewered with cherry tomatoes and feta cheese, grilled and served with a cool yogurt dip.~');
create_item(c, q'~Vegetarian Kuku Sabzi Tart~', q'~Persian herb frittata baked in a flaky pastry crust with feta cheese and walnuts. Served in slices as a savory treat.~');
create_item(c, q'~Vegetarian Kuku Sabzi Tartine~', q'~Persian herb frittata slices served on toasted bread with feta cheese, walnuts, and fresh herbs. Perfect as an appetizer or snack.~');
create_item(c, q'~Vegetarian Kuku Sabzi Tartine Bites~', q'~Persian herb frittata slices served on mini toasted bread with feta cheese, walnuts, and fresh herbs. Perfect for parties.~');
create_item(c, q'~Vegetarian Kuku Sabzi Tartine Bites Micro~', q'~Persian herb frittata slices served on micro toasted bread with feta cheese, walnuts, and fresh herbs.~');
create_item(c, q'~Vegetarian Kuku Sabzi Tartine Bites Mini~', q'~Persian herb frittata slices served on mini toasted bread with feta cheese, walnuts, and fresh herbs.~');
create_item(c, q'~Vegetarian Kuku Sabzi Wrap~', q'~Persian herb frittata wrapped in a soft flatbread with feta cheese, walnuts, and fresh herbs. Served with a side of yogurt sauce.~');
create_item(c, q'~Vegetarian Kuku Sibzamini~', q'~Persian potato patties mixed with scallions, turmeric, and eggs. Pan-fried until crispy and served with a cool yogurt dip.~');
create_item(c, q'~Vegetarian Lablabi~', q'~Tunisian chickpea stew flavored with garlic, cumin, and spicy harissa. Served over toasted bread and garnished with olives, preserved lemon, and fresh parsley.~');
create_item(c, q'~Vegetarian Lasagna~', q'~Layers of tender pasta sheets, roasted zucchini, spinach, mushrooms, creamy ricotta, and tangy marinara sauce. Baked with mozzarella and parmesan until golden and bubbly.~');
create_item(c, q'~Vegetarian Lo Mein~', q'~Chinese wheat noodles stir-fried with tofu, bok choy, carrots, snow peas, and shiitake mushrooms in a savory soy-ginger sauce. Finished with sesame oil and scallions.~');
create_item(c, q'~Vegetarian Mafe~', q'~West African peanut stew with sweet potatoes, carrots, tomatoes, and spinach. Slow-cooked in a rich peanut-tomato sauce and served with steamed rice.~');
create_item(c, q'~Vegetarian Malai Kofta~', q'~Indian paneer and potato dumplings simmered in a silky tomato-cashew cream sauce, flavored with cardamom and fenugreek. Served with warm naan bread and fresh coriander.~');
create_item(c, q'~Vegetarian Moussaka~', q'~A classic Greek casserole layered with slices of roasted eggplant, tender potatoes, and zucchini, all smothered in a rich tomato-lentil sauce seasoned with cinnamon and oregano. Topped with a creamy béchamel sauce and baked until golden and bubbling.~');
create_item(c, q'~Vegetarian Okonomiyaki~', q'~Japanese savory pancake made with shredded cabbage, carrots, scallions, and shiitake mushrooms. Griddled until crispy, topped with sweet okonomiyaki sauce, creamy mayo, and a sprinkle of bonito flakes.~');
create_item(c, q'~Vegetarian Pad Thai~', q'~Thai rice noodles stir-fried with cubes of tofu, crunchy bean sprouts, scallions, shredded carrots, and a tangy tamarind sauce. Garnished with crushed roasted peanuts, fresh cilantro, and lime wedges for a burst of flavor and texture.~');
create_item(c, q'~Vegetarian Paella~', q'~A vibrant Spanish dish featuring saffron-infused rice cooked slowly with artichoke hearts, roasted red peppers, sweet peas, ripe tomatoes, and smoked paprika. Finished with a garnish of lemon wedges and fresh parsley, this paella is prepared in a traditional wide pan to create a flavorful socarrat crust.~');
create_item(c, q'~Vegetarian Pastel de Choclo~', q'~Chilean corn pie with sautéed onions, mushrooms, briny olives, and hard-boiled eggs. Topped with sweet corn pudding and baked until golden brown.~');
create_item(c, q'~Vegetarian Pierogi~', q'~Polish dumplings filled with creamy mashed potatoes, sautéed onions, and cheese. Boiled and then pan-fried for a crispy finish, served with sour cream and fresh chives.~');
create_item(c, q'~Vegetarian Poutine~', q'~Canadian comfort food of crispy golden fries topped with squeaky cheese curds and smothered in a savory vegetarian mushroom gravy.~');
create_item(c, q'~Vegetarian Pozole~', q'~Mexican hominy stew with zucchini, mushrooms, sliced radishes, shredded cabbage, and a spicy guajillo chili broth. Served with lime wedges and tostadas.~');
create_item(c, q'~Vegetarian Ratatouille~', q'~A rustic French Provençal stew of tender eggplant, zucchini, bell peppers, ripe tomatoes, and sweet onions. Simmered slowly in olive oil with fresh thyme and basil, this dish is served warm with crusty bread.~');
create_item(c, q'~Vegetarian Rendang~', q'~Indonesian coconut curry featuring jackfruit, potatoes, and green beans, slow-cooked with lemongrass, galangal, kaffir lime leaves, and a blend of warming spices.~');
create_item(c, q'~Vegetarian Samosas~', q'~Indian crispy pastry triangles stuffed with a savory mixture of spiced potatoes, green peas, and carrots. Deep-fried until golden and served with fresh mint chutney and tangy tamarind sauce.~');
create_item(c, q'~Vegetarian Sfeeha~', q'~Lebanese open-faced pies topped with spiced lentils, tomatoes, onions, and pine nuts. Baked until golden and served with a side of yogurt sauce.~');
create_item(c, q'~Vegetarian Sopa de Lima~', q'~Mexican lime soup with roasted vegetables, crispy tortilla strips, and fresh cilantro. The broth is infused with citrus and mild chili for a refreshing finish.~');
create_item(c, q'~Vegetarian Sushi Platter~', q'~An assortment of hand-rolled sushi featuring fillings such as creamy avocado, crisp cucumber, pickled daikon, roasted sweet potato, and marinated shiitake mushrooms. Served with soy sauce, fiery wasabi, and pickled ginger for a complete Japanese experience.~');
create_item(c, q'~Vegetarian Szechuan Stir-Fry~', q'~Chinese stir-fry of tofu, bell peppers, broccoli, and roasted peanuts tossed in a fiery Szechuan peppercorn sauce. Served over steamed jasmine rice.~');
create_item(c, q'~Vegetarian Tabbouleh~', q'~Levantine salad of fluffy bulgur wheat tossed with parsley, mint, diced tomatoes, cucumber, and a zesty lemon-olive oil dressing. Served chilled as a refreshing starter.~');
create_item(c, q'~Vegetarian Tagine~', q'~A Moroccan slow-cooked stew made in a traditional clay pot, combining chickpeas, sweet potatoes, carrots, dried apricots, preserved lemon, and ras el hanout spices. Served over fluffy couscous and garnished with toasted almonds and cilantro.~');
create_item(c, q'~Vegetarian Tamales~', q'~Traditional Mexican masa dough filled with roasted poblano peppers, sweet corn kernels, and creamy cheese. Wrapped in corn husks and steamed until tender, these tamales are served with tangy salsa verde and fresh cilantro.~');
create_item(c, q'~Vegetarian Tandoori Platter~', q'~Indian tandoor-roasted vegetables and paneer marinated in spiced yogurt, grilled until smoky and served with mint chutney and lemon wedges.~');
create_item(c, q'~Vegetarian Tikka~', q'~Indian paneer cubes marinated in yogurt and spices, grilled with bell peppers and onions. Served sizzling hot with mint chutney and lemon wedges for a burst of freshness.~');
create_item(c, q'~Vegetarian Tlayuda~', q'~Oaxacan crispy tortilla topped with black bean puree, grilled vegetables, creamy avocado, crumbled queso fresco, and smoky salsa roja.~');
create_item(c, q'~Vegetarian Tom Yum Soup~', q'~Thai hot and sour broth infused with lemongrass, kaffir lime leaves, galangal, and chili. Filled with tofu cubes, mushrooms, and finished with fresh cilantro and a squeeze of lime for a refreshing kick.~');
create_item(c, q'~Vegetarian Tostada de Aguacate~', q'~Mexican crispy tortilla topped with smashed avocado, lime juice, sliced radish, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Aguacate y Frijol~', q'~Mexican crispy tortilla topped with smashed avocado, refried black beans, tangy salsa, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Aguacate y Queso~', q'~Mexican crispy tortilla topped with smashed avocado, crumbled queso fresco, tangy salsa, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Aguacate y Queso Bites~', q'~Mexican crispy tortilla topped with smashed avocado, crumbled queso fresco, tangy salsa, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Aguacate y Queso Bites Mini~', q'~Mexican crispy tortilla topped with smashed avocado, crumbled queso fresco, tangy salsa, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Alcachofa~', q'~Mexican crispy tortilla topped with marinated artichoke hearts, creamy black beans, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Alcachofa y Queso~', q'~Mexican crispy tortilla topped with marinated artichoke hearts, crumbled queso fresco, and tangy salsa verde.~');
create_item(c, q'~Vegetarian Tostada de Alcachofa y Queso Bites~', q'~Mexican crispy tortilla topped with marinated artichoke hearts, crumbled queso fresco, and tangy salsa verde.~');
create_item(c, q'~Vegetarian Tostada de Alcachofa y Queso Bites Micro~', q'~Mexican crispy tortilla topped with marinated artichoke hearts, crumbled queso fresco, and tangy salsa verde.~');
create_item(c, q'~Vegetarian Tostada de Alcachofa y Queso Bites Mini~', q'~Mexican crispy tortilla topped with marinated artichoke hearts, crumbled queso fresco, and tangy salsa verde.~');
create_item(c, q'~Vegetarian Tostada de Betabel~', q'~Mexican crispy tortilla topped with roasted beets, creamy goat cheese, peppery arugula, and toasted pumpkin seeds.~');
create_item(c, q'~Vegetarian Tostada de Calabacín~', q'~Mexican crispy tortilla topped with grilled zucchini, creamy black beans, avocado slices, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Calabaza~', q'~Mexican crispy tortilla topped with roasted squash, creamy black beans, pickled onions, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Calabaza y Elote~', q'~Mexican crispy tortilla topped with roasted squash, sweet corn, creamy black beans, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Calabaza y Elote Bites~', q'~Mexican crispy tortilla topped with roasted squash, sweet corn, creamy black beans, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Calabaza y Elote Bites Micro~', q'~Mexican crispy tortilla topped with roasted squash, sweet corn, creamy black beans, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Calabaza y Elote Bites Mini~', q'~Mexican crispy tortilla topped with roasted squash, sweet corn, creamy black beans, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Champiñones~', q'~Mexican crispy tortilla topped with sautéed mushrooms, garlic, aromatic epazote, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Chayote~', q'~Mexican crispy tortilla topped with sautéed chayote squash, creamy black beans, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Elote~', q'~Mexican crispy tortilla topped with roasted corn, smoky chipotle mayo, crumbled cotija cheese, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Espinaca~', q'~Mexican crispy tortilla topped with sautéed spinach, garlic, mushrooms, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Espinaca y Hongos~', q'~Mexican crispy tortilla topped with sautéed spinach, mushrooms, garlic, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Espinaca y Hongos Bites~', q'~Mexican crispy tortilla topped with sautéed spinach, mushrooms, garlic, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Espinaca y Hongos Bites Micro~', q'~Mexican crispy tortilla topped with sautéed spinach, mushrooms, garlic, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Espinaca y Hongos Bites Mini~', q'~Mexican crispy tortilla topped with sautéed spinach, mushrooms, garlic, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Espinaca y Queso~', q'~Mexican crispy tortilla topped with sautéed spinach, crumbled queso fresco, and tangy salsa verde.~');
create_item(c, q'~Vegetarian Tostada de Espárragos~', q'~Mexican crispy tortilla topped with grilled asparagus, creamy black beans, avocado slices, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Flor de Calabaza~', q'~Mexican crispy tortilla topped with sautéed squash blossoms, aromatic epazote, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Frijol~', q'~Mexican crispy tortilla topped with refried black beans, shredded lettuce, diced tomato, creamy avocado, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Frijol y Calabaza~', q'~Mexican crispy tortilla topped with refried black beans, roasted squash, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Frijol y Calabaza Bites~', q'~Mexican crispy tortilla topped with refried black beans, roasted squash, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Frijol y Calabaza Bites Micro~', q'~Mexican crispy tortilla topped with refried black beans, roasted squash, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Frijol y Nopal~', q'~Mexican crispy tortilla topped with refried black beans, grilled cactus, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Frijoles Negros~', q'~Mexican crispy tortilla topped with refried black beans, creamy avocado, tangy salsa, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Hongos~', q'~Mexican crispy tortilla topped with sautéed mushrooms, aromatic epazote, garlic, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Hongos y Epazote~', q'~Mexican crispy tortilla topped with sautéed mushrooms, aromatic epazote, garlic, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Hongos y Queso~', q'~Mexican crispy tortilla topped with sautéed mushrooms, crumbled queso fresco, and tangy salsa verde.~');
create_item(c, q'~Vegetarian Tostada de Hongos y Queso Bites~', q'~Mexican crispy tortilla topped with sautéed mushrooms, crumbled queso fresco, and tangy salsa verde.~');
create_item(c, q'~Vegetarian Tostada de Hongos y Queso Bites Micro~', q'~Mexican crispy tortilla topped with sautéed mushrooms, crumbled queso fresco, and tangy salsa verde.~');
create_item(c, q'~Vegetarian Tostada de Mango~', q'~Mexican crispy tortilla topped with fresh mango slices, creamy avocado, lime juice, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Mango y Aguacate~', q'~Mexican crispy tortilla topped with fresh mango, smashed avocado, lime juice, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Mango y Aguacate Bites~', q'~Mexican crispy tortilla topped with fresh mango, smashed avocado, lime juice, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Mango y Aguacate Bites Mini~', q'~Mexican crispy tortilla topped with fresh mango, smashed avocado, lime juice, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Nopal~', q'~Mexican crispy tortilla topped with grilled cactus paddles, creamy black beans, fresh pico de gallo, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Nopalitos~', q'~Mexican crispy tortilla topped with sautéed cactus paddles, tomatoes, onions, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Papa~', q'~Mexican crispy tortilla topped with spiced mashed potatoes, shredded lettuce, tangy salsa, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Papa y Chorizo~', q'~Mexican crispy tortilla topped with spiced potatoes, vegetarian chorizo, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Papa y Hongos~', q'~Mexican crispy tortilla topped with spiced potatoes, sautéed mushrooms, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Papa y Hongos Bites~', q'~Mexican crispy tortilla topped with spiced potatoes, sautéed mushrooms, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Papa y Hongos Bites Micro~', q'~Mexican crispy tortilla topped with spiced potatoes, sautéed mushrooms, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Pepino~', q'~Mexican crispy tortilla topped with sliced cucumber, creamy avocado, lime juice, and crumbled cotija cheese.~');
create_item(c, q'~Vegetarian Tostada de Pepino y Queso~', q'~Mexican crispy tortilla topped with sliced cucumber, crumbled queso fresco, lime juice, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Pepino y Queso Bites~', q'~Mexican crispy tortilla topped with sliced cucumber, crumbled queso fresco, lime juice, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Pepino y Queso Bites Mini~', q'~Mexican crispy tortilla topped with sliced cucumber, crumbled queso fresco, lime juice, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Pimiento~', q'~Mexican crispy tortilla topped with roasted bell peppers, creamy black beans, avocado slices, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Pimiento y Frijol~', q'~Mexican crispy tortilla topped with roasted bell peppers, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Pimiento y Frijol Bites~', q'~Mexican crispy tortilla topped with roasted bell peppers, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Pimiento y Frijol Bites Micro~', q'~Mexican crispy tortilla topped with roasted bell peppers, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Pimiento y Frijol Bites Mini~', q'~Mexican crispy tortilla topped with roasted bell peppers, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Piña~', q'~Mexican crispy tortilla topped with grilled pineapple, creamy avocado, black beans, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Piña y Frijol~', q'~Mexican crispy tortilla topped with grilled pineapple, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Piña y Frijol Bites~', q'~Mexican crispy tortilla topped with grilled pineapple, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Piña y Frijol Bites Mini~', q'~Mexican crispy tortilla topped with grilled pineapple, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Rábano~', q'~Mexican crispy tortilla topped with sliced radishes, creamy avocado, black beans, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Rábano y Frijol~', q'~Mexican crispy tortilla topped with sliced radishes, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Rábano y Frijol Bites~', q'~Mexican crispy tortilla topped with sliced radishes, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Rábano y Frijol Bites Mini~', q'~Mexican crispy tortilla topped with sliced radishes, refried black beans, creamy avocado, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostada de Tomate~', q'~Mexican crispy tortilla topped with juicy heirloom tomatoes, creamy avocado, crumbled queso fresco, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Tomate y Aguacate~', q'~Mexican crispy tortilla topped with juicy heirloom tomatoes, smashed avocado, crumbled queso fresco, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Tomate y Aguacate Bites~', q'~Mexican crispy tortilla topped with heirloom tomatoes, smashed avocado, crumbled queso fresco, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Tomate y Aguacate Bites Mini~', q'~Mexican crispy tortilla topped with heirloom tomatoes, smashed avocado, crumbled queso fresco, and fresh cilantro.~');
create_item(c, q'~Vegetarian Tostada de Zanahoria~', q'~Mexican crispy tortilla topped with spiced roasted carrots, creamy black beans, avocado slices, and crumbled queso fresco.~');
create_item(c, q'~Vegetarian Tostadas~', q'~Crispy corn tortillas layered with refried black beans, shredded lettuce, fresh pico de gallo, creamy avocado slices, and crumbled queso fresco. Finished with a drizzle of lime crema.~');
create_item(c, q'~Vegetarian Tostones~', q'~Caribbean twice-fried plantain slices topped with creamy black bean puree, ripe avocado, and pickled onions. Finished with a sprinkle of fresh cilantro.~');
create_item(c, q'~Vegetarian Tteokbokki~', q'~Korean chewy rice cakes simmered in a spicy gochujang sauce with cabbage, carrots, scallions, and boiled eggs. Finished with sesame seeds and sliced green onions.~');
create_item(c, q'~Vegetarian Tteokguk~', q'~Korean rice cake soup with mushrooms, spinach, and scallions in a savory vegetable broth. Garnished with toasted seaweed and sliced egg ribbons.~');


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


    

