prompt loading menu items for category: Appetizers
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
 

    c := 'Appetizers';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Anticuchos~', q'~Grilled skewers of marinated beef heart, seasoned with Peruvian spices and served with boiled potatoes and spicy ají sauce.~');
create_item(c, q'~Arancini~', q'~Sicilian rice balls stuffed with mozzarella and peas, coated in breadcrumbs and fried until golden. Served with a side of marinara sauce.~');
create_item(c, q'~Baba Ganoush~', q'~Smoky roasted eggplant blended with tahini, garlic, lemon juice, and olive oil. Served with grilled flatbread and fresh parsley.~');
create_item(c, q'~Baked Brie en Croûte~', q'~Creamy brie cheese wrapped in puff pastry and baked until golden. Served with fig jam and toasted baguette slices.~');
create_item(c, q'~Baked Falafel Balls~', q'~Oven-baked chickpea falafel balls seasoned with cumin, coriander, and parsley. Served with tahini sauce and pickled turnips.~');
create_item(c, q'~Baked Jalapeño Poppers~', q'~Jalapeño peppers stuffed with cream cheese and cheddar, coated in breadcrumbs and baked until golden.~');
create_item(c, q'~Baked Sweet Potato Wedges~', q'~Seasoned sweet potato wedges roasted until caramelized and served with chipotle aioli.~');
create_item(c, q'~Baked Zucchini Chips~', q'~Thinly sliced zucchini baked until crisp, seasoned with garlic powder and Parmesan. A healthy, gluten-free snack.~');
create_item(c, q'~Bruschetta~', q'~Grilled slices of rustic Italian bread brushed with olive oil, rubbed with garlic, and topped with a vibrant mixture of diced ripe tomatoes, fresh basil, extra virgin olive oil, balsamic vinegar, and a sprinkle of sea salt. Served as a classic appetizer.~');
create_item(c, q'~Buffalo Wings~', q'~Juicy chicken wings fried until crispy, then tossed in spicy buffalo sauce. Served with celery sticks and creamy blue cheese or ranch dressing.~');
create_item(c, q'~Caprese Skewers~', q'~Skewered cherry tomatoes, fresh mozzarella balls, and basil leaves drizzled with balsamic glaze. A refreshing Italian appetizer.~');
create_item(c, q'~Ceviche~', q'~Fresh fish marinated in lime juice, mixed with diced tomatoes, onions, cilantro, and jalapeños. Served chilled with crispy plantain chips, a Peruvian delicacy.~');
create_item(c, q'~Chaat Platter~', q'~Assorted Indian street snacks including papdi chaat, dahi puri, and aloo tikki, topped with yogurt, chutneys, and sev.~');
create_item(c, q'~Cheese Quesadilla~', q'~Grilled flour tortilla filled with melted cheddar and Monterey Jack cheeses. Served with salsa fresca and sour cream.~');
create_item(c, q'~Cheese Stuffed Peppers~', q'~Mini bell peppers filled with herbed cream cheese and baked until soft. Garnished with fresh chives.~');
create_item(c, q'~Chicken Satay~', q'~Tender strips of marinated chicken skewered and grilled over an open flame, served with a creamy, spicy peanut sauce and a side of cucumber salad for a flavorful Southeast Asian starter.~');
create_item(c, q'~Chimichurri Shrimp~', q'~Grilled shrimp marinated in garlic, parsley, and vinegar, served with tangy chimichurri sauce.~');
create_item(c, q'~Corn Fritters~', q'~Crispy fritters made with sweet corn kernels, scallions, and a hint of cayenne. Served with cilantro-lime crema.~');
create_item(c, q'~Crab Rangoon~', q'~Crispy wontons filled with a creamy mixture of crab meat, cream cheese, and scallions. Served with sweet and sour dipping sauce.~');
create_item(c, q'~Crispy Avocado Fries~', q'~Sliced avocado coated in panko breadcrumbs and fried until golden. Served with cilantro-lime dipping sauce.~');
create_item(c, q'~Crispy Cauliflower Bites~', q'~Cauliflower florets tossed in spicy buffalo sauce and baked until crisp. Served with vegan ranch dressing.~');
create_item(c, q'~Crispy Chickpea Fritters~', q'~Savory chickpea fritters seasoned with cumin and coriander, fried until golden. Served with yogurt sauce.~');
create_item(c, q'~Crispy Chickpeas~', q'~Roasted chickpeas tossed with smoked paprika, cumin, and sea salt. Crunchy, protein-rich, and vegan-friendly.~');
create_item(c, q'~Crispy Halloumi~', q'~Pan-seared Cypriot halloumi cheese slices served with lemon wedges and fresh mint.~');
create_item(c, q'~Crispy Lotus Root Chips~', q'~Thinly sliced lotus root fried until golden and sprinkled with sea salt. Served with wasabi mayo.~');
create_item(c, q'~Crispy Plantain Chips~', q'~Thinly sliced plantains fried until crisp and sprinkled with sea salt. Served with garlic mojo sauce.~');
create_item(c, q'~Crispy Polenta Fries~', q'~Golden-fried sticks of creamy polenta, seasoned with rosemary and Parmesan. Served with spicy tomato dipping sauce.~');
create_item(c, q'~Crispy Quinoa Cakes~', q'~Golden quinoa patties flavored with scallions, cilantro, and cumin. Served with lemon-tahini sauce.~');
create_item(c, q'~Crispy Tofu Nuggets~', q'~Bite-sized tofu pieces coated in seasoned panko breadcrumbs and fried until golden. Served with sweet chili dipping sauce.~');
create_item(c, q'~Dolma~', q'~Tender grape leaves stuffed with a fragrant mixture of rice, pine nuts, currants, and fresh herbs. Served chilled with a drizzle of olive oil and lemon.~');
create_item(c, q'~Edamame~', q'~Steamed young soybeans sprinkled with sea salt, served in their pods. A classic Japanese starter, rich in protein and fiber.~');
create_item(c, q'~Eggplant Rollatini~', q'~Thin slices of eggplant rolled with ricotta and spinach, baked in marinara sauce and topped with mozzarella.~');
create_item(c, q'~Empanadas~', q'~Flaky pastry turnovers filled with seasoned ground beef, onions, olives, and hard-boiled eggs. Baked until golden and served with chimichurri sauce, a South American classic.~');
create_item(c, q'~Falafel~', q'~Golden-brown chickpea fritters seasoned with cumin, coriander, and fresh herbs. Served with creamy tahini sauce and pickled vegetables, a Middle Eastern favorite.~');
create_item(c, q'~French Fries~', q'~Golden, crispy potato fries seasoned with sea salt. Served hot and perfect as a side or snack, with ketchup or your favorite dipping sauce.~');
create_item(c, q'~Garlic Bread~', q'~Toasted baguette slices brushed with garlic-infused butter and sprinkled with parsley. Baked until golden and fragrant, perfect as a side or appetizer.~');
create_item(c, q'~Goat Cheese Croquettes~', q'~Creamy goat cheese balls coated in breadcrumbs and fried until golden. Served with honey and thyme.~');
create_item(c, q'~Gyoza~', q'~Japanese dumplings filled with ground pork, cabbage, ginger, and garlic. Pan-fried until crispy and served with soy-vinegar dipping sauce.~');
create_item(c, q'~Hummus Trio~', q'~Creamy chickpea hummus served three ways: classic, roasted red pepper, and spicy harissa. Accompanied by warm pita bread and fresh vegetables.~');
create_item(c, q'~Jamaican Patties~', q'~Flaky pastry pockets filled with spicy curried vegetables. Baked until golden and served with mango chutney.~');
create_item(c, q'~Kimchi Pancakes~', q'~Savory Korean pancakes made with fermented kimchi, scallions, and a light flour batter. Pan-fried and served with soy dipping sauce.~');
create_item(c, q'~Lentil Kibbeh~', q'~Middle Eastern bulgur and lentil croquettes seasoned with cumin, coriander, and mint. Served with yogurt-tahini sauce.~');
create_item(c, q'~Mini Arepas~', q'~Venezuelan corn cakes stuffed with black beans, avocado, and queso fresco. Gluten-free and vegetarian.~');
create_item(c, q'~Mini BBQ Chicken Skewers~', q'~Grilled chicken skewers glazed with smoky BBQ sauce.~');
create_item(c, q'~Mini BBQ Pulled Jackfruit Sliders~', q'~Mini buns filled with smoky BBQ jackfruit, vegan coleslaw, and pickles.~');
create_item(c, q'~Mini Caprese Salad Cups~', q'~Cherry tomatoes, mozzarella balls, and basil leaves served in mini cups with balsamic glaze.~');
create_item(c, q'~Mini Cheese Soufflés~', q'~Light and airy cheese soufflés baked in mini ramekins. Served with chive crème fraîche.~');
create_item(c, q'~Mini Chicken Croquette Cup~', q'~Phyllo cups filled with chicken croquettes.~');
create_item(c, q'~Mini Chicken Croquette Cups~', q'~Phyllo cups filled with chicken croquettes.~');
create_item(c, q'~Mini Chicken Croquettes~', q'~Chicken croquettes coated in breadcrumbs and fried until golden.~');
create_item(c, q'~Mini Chicken Empanada Cup~', q'~Phyllo cups filled with chicken empanada filling.~');
create_item(c, q'~Mini Chicken Empanada Cups~', q'~Phyllo cups filled with spiced chicken and olives.~');
create_item(c, q'~Mini Chicken Empanada Triangle Cup~', q'~Phyllo cups filled with chicken empanada triangles.~');
create_item(c, q'~Mini Chicken Empanada Triangle Cups~', q'~Phyllo cups filled with chicken empanada triangles.~');
create_item(c, q'~Mini Chicken Empanada Triangles~', q'~Flaky pastry triangles filled with spiced chicken.~');
create_item(c, q'~Mini Chicken Empanadas~', q'~Flaky pastry turnovers filled with spiced chicken, onions, and olives. Baked until golden.~');
create_item(c, q'~Mini Chicken Falafel Ball Cup~', q'~Phyllo cups filled with chicken falafel balls.~');
create_item(c, q'~Mini Chicken Falafel Ball Cups~', q'~Phyllo cups filled with chicken falafel balls.~');
create_item(c, q'~Mini Chicken Falafel Balls~', q'~Falafel balls made with chicken and chickpeas, baked until crisp.~');
create_item(c, q'~Mini Chicken Meatball Skewer Cup~', q'~Phyllo cups filled with chicken meatball skewers.~');
create_item(c, q'~Mini Chicken Meatball Skewers~', q'~Chicken meatballs skewered and grilled.~');
create_item(c, q'~Mini Chicken Meatballs~', q'~Chicken meatballs seasoned with herbs and spices, baked until golden.~');
create_item(c, q'~Mini Chicken Quesadilla Wedge Cup~', q'~Phyllo cups filled with chicken quesadilla wedges.~');
create_item(c, q'~Mini Chicken Quesadilla Wedge Cups~', q'~Phyllo cups filled with chicken quesadilla wedges.~');
create_item(c, q'~Mini Chicken Quesadilla Wedges~', q'~Grilled flour tortillas filled with chicken and cheese, cut into mini wedges.~');
create_item(c, q'~Mini Chicken Quesadillas~', q'~Grilled flour tortillas filled with chicken and cheese, cut into mini wedges.~');
create_item(c, q'~Mini Chicken Quiche Cup~', q'~Phyllo cups filled with chicken quiche filling.~');
create_item(c, q'~Mini Chicken Quiche Cups~', q'~Mini quiches filled with chicken, spinach, and cheese.~');
create_item(c, q'~Mini Chicken Samosa Cup~', q'~Phyllo cups filled with chicken samosa filling.~');
create_item(c, q'~Mini Chicken Samosa Cups~', q'~Phyllo cups filled with chicken samosa filling.~');
create_item(c, q'~Mini Chicken Samosas~', q'~Crispy pastry triangles filled with spiced chicken and peas.~');
create_item(c, q'~Mini Chicken Satay Cup~', q'~Phyllo cups filled with chicken satay and peanut sauce.~');
create_item(c, q'~Mini Chicken Satay Cups~', q'~Phyllo cups filled with chicken satay and peanut sauce.~');
create_item(c, q'~Mini Chicken Satay Skewers~', q'~Grilled chicken skewers marinated in Indonesian spices, served with peanut sauce.~');
create_item(c, q'~Mini Chicken Shawarma~', q'~Marinated chicken slices wrapped in mini pita with garlic sauce, pickles, and lettuce.~');
create_item(c, q'~Mini Chicken Spinach Artichoke Dip Cup~', q'~Phyllo cups filled with chicken, spinach, and artichoke dip.~');
create_item(c, q'~Mini Chicken Spinach Artichoke Dip Cups~', q'~Phyllo cups filled with chicken, spinach, and artichoke dip.~');
create_item(c, q'~Mini Chicken Spring Roll Cup~', q'~Phyllo cups filled with chicken spring roll filling.~');
create_item(c, q'~Mini Chicken Spring Roll Cups~', q'~Phyllo cups filled with chicken spring roll filling.~');
create_item(c, q'~Mini Chicken Spring Rolls~', q'~Rice paper rolls filled with chicken, vermicelli noodles, and vegetables.~');
create_item(c, q'~Mini Chicken Stuffed Pepper Cup~', q'~Phyllo cups filled with chicken stuffed pepper filling.~');
create_item(c, q'~Mini Chicken Stuffed Pepper Cups~', q'~Phyllo cups filled with chicken stuffed pepper filling.~');
create_item(c, q'~Mini Chicken Stuffed Peppers~', q'~Mini bell peppers filled with chicken, rice, and herbs.~');
create_item(c, q'~Mini Chicken Tikka Skewers~', q'~Chicken pieces marinated in yogurt and Indian spices, grilled on skewers.~');
create_item(c, q'~Mini Corn Dogs~', q'~Bite-sized hot dogs dipped in cornmeal batter and fried until golden. Served with mustard and ketchup.~');
create_item(c, q'~Mini Crab Cakes~', q'~Maryland-style crab cakes made with lump crab meat, herbs, and spices. Pan-seared and served with remoulade sauce.~');
create_item(c, q'~Mini Egg Rolls~', q'~Crispy egg rolls filled with shredded cabbage, carrots, and mushrooms. Served with sweet and sour sauce.~');
create_item(c, q'~Mini Eggplant Parmesan Bites~', q'~Breaded eggplant rounds topped with marinara and mozzarella, baked until bubbly.~');
create_item(c, q'~Mini Falafel Sliders~', q'~Mini pita pockets filled with falafel, lettuce, tomato, and tahini sauce.~');
create_item(c, q'~Mini Greek Meatballs~', q'~Lamb and beef meatballs seasoned with oregano and mint, served with tzatziki sauce.~');
create_item(c, q'~Mini Mushroom Tartlets~', q'~Savory tartlets filled with sautéed mushrooms, shallots, and Gruyère cheese.~');
create_item(c, q'~Mini Potato Latkes~', q'~Crispy potato pancakes seasoned with onion and served with applesauce and sour cream.~');
create_item(c, q'~Mini Roasted Beet Salad~', q'~Roasted beet cubes tossed with goat cheese, arugula, and toasted walnuts.~');
create_item(c, q'~Mini Roasted Cauliflower Cups~', q'~Roasted cauliflower florets tossed with tahini sauce and pomegranate seeds.~');
create_item(c, q'~Mini Roasted Eggplant Dip Cups~', q'~Phyllo cups filled with smoky roasted eggplant dip and topped with parsley.~');
create_item(c, q'~Mini Roasted Garlic Hummus Cups~', q'~Phyllo cups filled with roasted garlic hummus and topped with paprika.~');
create_item(c, q'~Mini Roasted Red Pepper Dip Cups~', q'~Phyllo cups filled with roasted red pepper dip and topped with feta cheese.~');
create_item(c, q'~Mini Roasted Red Pepper Hummus Cups~', q'~Phyllo cups filled with roasted red pepper hummus and topped with olives.~');
create_item(c, q'~Mini Roasted Sweet Potato Cups~', q'~Roasted sweet potato cubes tossed with cinnamon and maple syrup.~');
create_item(c, q'~Mini Roasted Tomato Bruschetta~', q'~Toasted baguette slices topped with roasted cherry tomatoes, garlic, and basil.~');
create_item(c, q'~Mini Shrimp Ceviche Cups~', q'~Shrimp marinated in lime juice, mixed with tomatoes, onions, and cilantro. Served in mini cups.~');
create_item(c, q'~Mini Shrimp Toasts~', q'~Crispy baguette slices topped with shrimp mousse and sesame seeds, fried until golden.~');
create_item(c, q'~Mini Smoked Salmon Blinis~', q'~Buckwheat blinis topped with smoked salmon, crème fraîche, and dill.~');
create_item(c, q'~Mini Spanakopita Triangles~', q'~Bite-sized phyllo triangles filled with spinach, feta, and dill. Baked until crisp and golden.~');
create_item(c, q'~Mini Spicy Tuna Rolls~', q'~Sushi rolls filled with spicy tuna, cucumber, and avocado. Served with soy sauce.~');
create_item(c, q'~Mini Spinach Artichoke Dip Cups~', q'~Phyllo cups filled with creamy spinach and artichoke dip, baked until bubbly.~');
create_item(c, q'~Mini Spinach Feta Puffs~', q'~Puff pastry squares filled with spinach and feta cheese, baked until golden.~');
create_item(c, q'~Mini Stuffed Peppers~', q'~Mini bell peppers filled with seasoned ground turkey, rice, and herbs. Baked until tender.~');
create_item(c, q'~Mini Sweet Potato Croquettes~', q'~Mashed sweet potato balls coated in breadcrumbs and fried until golden.~');
create_item(c, q'~Mini Tacos~', q'~Corn tortillas filled with spiced jackfruit, pickled onions, and avocado crema. Vegan and gluten-free.~');
create_item(c, q'~Mini Thai Chicken Satay~', q'~Grilled chicken skewers marinated in Thai spices, served with peanut dipping sauce.~');
create_item(c, q'~Mini Tuna Tartare~', q'~Diced sushi-grade tuna tossed with sesame oil, soy sauce, and scallions. Served on crispy wonton chips.~');
create_item(c, q'~Mini Vegan Empanadas~', q'~Flaky pastry turnovers filled with spiced lentils and vegetables.~');
create_item(c, q'~Mini Vegan Falafel Balls~', q'~Chickpea falafel balls seasoned with cumin and coriander, baked until crisp.~');
create_item(c, q'~Mini Vegan Lentil Ball Skewer Cup~', q'~Phyllo cups filled with lentil ball skewers.~');
create_item(c, q'~Mini Vegan Lentil Ball Skewers~', q'~Lentil balls skewered and grilled.~');
create_item(c, q'~Mini Vegan Lentil Balls~', q'~Lentil balls seasoned with cumin and coriander, baked until crisp.~');
create_item(c, q'~Mini Vegan Mushroom Tartlet Cup~', q'~Phyllo cups filled with mushroom tartlet filling.~');
create_item(c, q'~Mini Vegan Mushroom Tartlet Cups~', q'~Phyllo cups filled with mushroom tartlet filling.~');
create_item(c, q'~Mini Vegan Mushroom Tartlets~', q'~Savory tartlets filled with sautéed mushrooms and vegan cheese.~');
create_item(c, q'~Mini Vegan Polenta Cake Cup~', q'~Phyllo cups filled with polenta cakes and mushrooms.~');
create_item(c, q'~Mini Vegan Polenta Cake Cups~', q'~Phyllo cups filled with polenta cakes and mushrooms.~');
create_item(c, q'~Mini Vegan Polenta Cakes~', q'~Polenta cakes topped with sautéed mushrooms and vegan cheese.~');
create_item(c, q'~Mini Vegan Potato Cake Cup~', q'~Phyllo cups filled with potato cakes and scallions.~');
create_item(c, q'~Mini Vegan Potato Cake Cups~', q'~Phyllo cups filled with potato cakes and scallions.~');
create_item(c, q'~Mini Vegan Potato Cakes~', q'~Potato cakes seasoned with scallions and herbs, pan-fried until golden.~');
create_item(c, q'~Mini Vegan Quiche Cups~', q'~Mini quiches filled with spinach, mushrooms, and vegan cheese.~');
create_item(c, q'~Mini Vegan Roasted Beet Cup~', q'~Phyllo cups filled with roasted beet cubes and arugula.~');
create_item(c, q'~Mini Vegan Roasted Beet Cups~', q'~Roasted beet cubes tossed with vegan cheese and arugula.~');
create_item(c, q'~Mini Vegan Roasted Cauliflower Cup~', q'~Phyllo cups filled with roasted cauliflower florets.~');
create_item(c, q'~Mini Vegan Roasted Cauliflower Cups~', q'~Roasted cauliflower florets tossed with tahini sauce.~');
create_item(c, q'~Mini Vegan Roasted Garlic Hummus Cup~', q'~Phyllo cups filled with roasted garlic hummus.~');
create_item(c, q'~Mini Vegan Roasted Garlic Hummus Cups~', q'~Phyllo cups filled with roasted garlic hummus.~');
create_item(c, q'~Mini Vegan Roasted Red Pepper Hummus Cup~', q'~Phyllo cups filled with roasted red pepper hummus.~');
create_item(c, q'~Mini Vegan Roasted Red Pepper Hummus Cups~', q'~Phyllo cups filled with roasted red pepper hummus.~');
create_item(c, q'~Mini Vegan Roasted Tomato Bruschetta~', q'~Toasted baguette slices topped with roasted cherry tomatoes and basil.~');
create_item(c, q'~Mini Vegan Roasted Tomato Bruschetta Cup~', q'~Phyllo cups filled with roasted cherry tomatoes and basil.~');
create_item(c, q'~Mini Vegan Roasted Tomato Bruschetta Cups~', q'~Phyllo cups filled with roasted cherry tomatoes and basil.~');
create_item(c, q'~Mini Vegan Sausage Rolls~', q'~Puff pastry filled with seasoned lentil and vegetable sausage, baked until golden.~');
create_item(c, q'~Mini Vegan Spinach Puff Cup~', q'~Phyllo cups filled with spinach and vegan cheese.~');
create_item(c, q'~Mini Vegan Spinach Puff Cups~', q'~Phyllo cups filled with spinach and vegan cheese.~');
create_item(c, q'~Mini Vegan Spinach Puffs~', q'~Puff pastry squares filled with spinach and vegan cheese.~');
create_item(c, q'~Mini Vegan Spring Rolls~', q'~Rice paper rolls filled with tofu, vermicelli noodles, and fresh vegetables.~');
create_item(c, q'~Mini Vegan Stuffed Mushrooms~', q'~Mushroom caps filled with vegan cream cheese, garlic, and herbs.~');
create_item(c, q'~Mini Vegan Stuffed Peppers~', q'~Mini bell peppers filled with quinoa, black beans, and corn.~');
create_item(c, q'~Mini Vegan Sushi Cup~', q'~Phyllo cups filled with avocado, cucumber, and pickled radish sushi filling.~');
create_item(c, q'~Mini Vegan Sushi Cups~', q'~Sushi cups filled with avocado, cucumber, and pickled radish.~');
create_item(c, q'~Mini Vegan Sushi Rolls~', q'~Sushi rolls filled with avocado, cucumber, and pickled radish. Served with soy sauce.~');
create_item(c, q'~Mini Vegan Tofu Satay Cup~', q'~Phyllo cups filled with tofu satay and peanut sauce.~');
create_item(c, q'~Mini Vegan Tofu Satay Cups~', q'~Phyllo cups filled with tofu satay and peanut sauce.~');
create_item(c, q'~Mini Vegan Tofu Skewers~', q'~Grilled tofu skewers marinated in soy-ginger sauce.~');
create_item(c, q'~Mini Vegetable Pakoras~', q'~Assorted vegetables dipped in spiced chickpea batter and fried until crisp.~');
create_item(c, q'~Mini Vegetable Quiches~', q'~Individual quiches filled with spinach, mushrooms, and Gruyère cheese. Baked in a flaky pastry crust.~');
create_item(c, q'~Mozzarella Sticks~', q'~Crispy breaded mozzarella cheese sticks fried until golden and gooey inside. Served hot with a side of tangy marinara sauce for dipping.~');
create_item(c, q'~Mushroom Crostini~', q'~Toasted baguette slices topped with sautéed wild mushrooms, garlic, thyme, and a sprinkle of Parmesan.~');
create_item(c, q'~Okonomiyaki Bites~', q'~Mini Japanese savory pancakes made with cabbage, scallions, and shrimp, topped with okonomiyaki sauce and bonito flakes.~');
create_item(c, q'~Onion Rings~', q'~Thick slices of sweet onion dipped in a seasoned batter, then deep-fried until crunchy and golden brown. Served as a classic appetizer with a side of zesty dipping sauce or ketchup.~');
create_item(c, q'~Pakora~', q'~Assorted vegetables dipped in a spiced chickpea flour batter and deep-fried until crisp. Served with tangy tamarind and mint chutneys, a popular Indian snack.~');
create_item(c, q'~Pani Puri~', q'~Crispy hollow puris filled with spicy potato, chickpeas, and tangy tamarind water. A popular Indian street food appetizer.~');
create_item(c, q'~Patatas Bravas~', q'~Crispy fried potato cubes topped with spicy tomato sauce and creamy aioli. A classic Spanish tapas dish.~');
create_item(c, q'~Pão de Queijo~', q'~Brazilian cheese bread balls made with tapioca flour and Parmesan cheese. Gluten-free and served warm from the oven.~');
create_item(c, q'~Roasted Beet Carpaccio~', q'~Thinly sliced roasted beets drizzled with olive oil, balsamic reduction, and topped with toasted walnuts and microgreens.~');
create_item(c, q'~Seitan Satay Skewers~', q'~Grilled skewers of marinated seitan served with a spicy, creamy peanut dipping sauce and a side of cucumber salad.~');
create_item(c, q'~Sichuan Peppercorn Tofu~', q'~Crispy tofu cubes tossed in a spicy Sichuan peppercorn sauce with scallions and bell peppers.~');
create_item(c, q'~Spanakopita~', q'~Flaky phyllo pastry filled with spinach, feta cheese, onions, and fresh dill. Baked until golden and served warm, a Greek favorite.~');
create_item(c, q'~Spring Rolls~', q'~Crispy rolls filled with a mix of fresh vegetables and sometimes shrimp or pork, wrapped in thin pastry and fried until golden. Served with sweet chili dipping sauce.~');
create_item(c, q'~Stuffed Grape Leaves~', q'~Tender grape leaves rolled with a filling of rice, fresh herbs, and lemon zest. Served chilled with tzatziki sauce.~');
create_item(c, q'~Stuffed Mushrooms~', q'~Mushroom caps filled with a savory mixture of cream cheese, garlic, herbs, and breadcrumbs, baked until golden and bubbly. Served as a flavorful appetizer.~');
create_item(c, q'~Sweet Potato Fries~', q'~Hand-cut sweet potato fries tossed with smoked paprika and sea salt. Served with chipotle mayo.~');
create_item(c, q'~Tandoori Paneer Skewers~', q'~Chunks of paneer cheese marinated in tandoori spices and grilled on skewers. Served with mint chutney.~');
create_item(c, q'~Thai Fish Cakes~', q'~Spicy fish patties blended with red curry paste, kaffir lime leaves, and green beans. Served with sweet chili cucumber relish.~');
create_item(c, q'~Tofu Lettuce Wraps~', q'~Crispy tofu crumbles stir-fried with water chestnuts, mushrooms, and hoisin sauce, served in crisp lettuce cups and garnished with scallions and sesame seeds.~');
create_item(c, q'~Tofu Satay~', q'~Grilled skewers of marinated tofu served with a creamy, spicy peanut sauce and a side of cucumber salad for a Southeast Asian-inspired appetizer.~');
create_item(c, q'~Tofu and Vegetable Tempura~', q'~Lightly battered tofu and assorted vegetables fried until crisp and golden. Served with a soy-based dipping sauce for a crunchy appetizer.~');
create_item(c, q'~Tostones~', q'~Twice-fried green plantain slices, crispy on the outside and tender inside. Served with garlic mojo sauce, a Caribbean specialty.~');
create_item(c, q'~Vegetable Samosa~', q'~A crispy, golden-fried pastry triangle stuffed with a savory mixture of spiced potatoes, peas, carrots, and aromatic Indian spices. Served hot with tangy tamarind chutney and cooling mint yogurt sauce.~');
create_item(c, q'~Vegetable Tempura~', q'~Assorted seasonal vegetables dipped in a light Japanese tempura batter and fried until crisp. Served with tentsuyu dipping sauce.~');
create_item(c, q'~Vegetarian Sushi Rolls~', q'~Assorted sushi rolls filled with avocado, cucumber, pickled radish, and carrot. Served with soy sauce, wasabi, and pickled ginger.~');
create_item(c, q'~Vietnamese Fresh Spring Rolls~', q'~Rice paper rolls filled with shrimp, vermicelli noodles, lettuce, mint, and cilantro. Served with hoisin-peanut dipping sauce.~');


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


    

