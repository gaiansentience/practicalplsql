prompt loading menu items for category: Sandwiches
prompt script generated: 2025-08-17 21:17:12

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
 

    c := 'Sandwiches';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Algerian Merguez Sausage Baguette~', q'~Spicy lamb merguez sausage, grilled and served on a crusty baguette. Layered with grilled peppers and harissa mayo for a fiery North African sandwich.~');
create_item(c, q'~Argentinian Choripán~', q'~Grilled chorizo sausage, smoky and spicy, served in a crusty roll. Topped with vibrant chimichurri sauce made from parsley, garlic, oregano, and vinegar, plus roasted red peppers for a burst of color and flavor.~');
create_item(c, q'~Australian Vegemite ~' || chr(38) || q'~ Avocado Toastie~', q'~Grilled sandwich with creamy avocado spread, tangy Vegemite, and melted cheddar cheese on sourdough bread. Toasted until golden for a uniquely Australian flavor combination.~');
create_item(c, q'~BLT Sandwich~', q'~A classic sandwich with crispy bacon, fresh lettuce, and juicy tomato slices layered between toasted bread and spread with mayonnaise.~');
create_item(c, q'~Belgian Croquette Sandwich~', q'~Golden potato croquettes, crunchy on the outside and creamy inside, served on a buttered roll. Topped with shredded lettuce and tangy mustard sauce for a Belgian comfort food experience.~');
create_item(c, q'~Brazilian Bauru Sandwich~', q'~Roast beef slices, melted mozzarella cheese, ripe tomato, and pickled cucumber layered on a crusty French roll. Lightly toasted and brushed with olive oil for a classic São Paulo flavor.~');
create_item(c, q'~Caesar Wrap~', q'~Grilled chicken, crisp romaine lettuce, parmesan cheese, and creamy Caesar dressing wrapped in a soft tortilla. Served with a side of chips or salad.~');
create_item(c, q'~Caprese Panini~', q'~Fresh mozzarella slices, juicy vine-ripened tomatoes, and fragrant basil leaves pressed between ciabatta bread. Grilled until golden and drizzled with a rich balsamic glaze, creating a warm, melty, and aromatic Italian classic.~');
create_item(c, q'~Caribbean Ackee ~' || chr(38) || q'~ Saltfish Sandwich~', q'~Ackee fruit and salted cod sautéed with bell peppers, onions, and tomatoes, served on a coconut bun. Finished with a touch of Scotch bonnet pepper for a true taste of Jamaica.~');
create_item(c, q'~Chicken Caesar Wrap~', q'~Grilled chicken breast, crisp romaine lettuce, parmesan cheese, and creamy Caesar dressing wrapped in a soft flour tortilla. Served with a side salad or chips.~');
create_item(c, q'~Chicken Quesadilla~', q'~A grilled flour tortilla filled with seasoned grilled chicken, melted Monterey Jack and cheddar cheeses, sautéed peppers, and onions. Served with sides of salsa, sour cream, and guacamole for dipping.~');
create_item(c, q'~Chinese Char Siu Pork Bun~', q'~Sweet and savory roasted pork, marinated in hoisin, honey, and five-spice, served in a steamed bao bun. Topped with scallions and a touch of pickled vegetables for a classic Cantonese snack.~');
create_item(c, q'~Club Sandwich~', q'~A triple-layered sandwich stacked with sliced turkey, crispy bacon, lettuce, tomato, and mayonnaise, served on toasted bread and cut into quarters. Accompanied by a pickle and fries.~');
create_item(c, q'~Cuban Medianoche~', q'~Sweet egg bread layered with succulent roast pork, thinly sliced ham, melted Swiss cheese, tangy pickles, and yellow mustard. Pressed and grilled until the bread is golden and the cheese is perfectly melted, a midnight snack favorite in Havana.~');
create_item(c, q'~Dairy-Free Chicken Salad Sandwich~', q'~Shredded chicken breast mixed with grapes, celery, and dairy-free mayo, served on multigrain bread. Topped with crisp lettuce for a creamy, crunchy, allergy-friendly lunch.~');
create_item(c, q'~Diabetic-Friendly Turkey Spinach Wrap~', q'~Lean turkey breast, fresh spinach, tomato slices, and tangy mustard wrapped in a low-carb tortilla. Balanced for blood sugar management and flavor.~');
create_item(c, q'~Egg Salad Sandwich~', q'~A classic sandwich featuring creamy egg salad made with chopped hard-boiled eggs, mayonnaise, Dijon mustard, celery, and chives, served on whole wheat bread with crisp lettuce leaves. Perfect for a light lunch or snack.~');
create_item(c, q'~Egyptian Taameya Sandwich~', q'~Egyptian-style falafel made from fava beans, seasoned with fresh herbs and spices, served in baladi bread. Filled with lettuce, tomato, pickled turnips, and creamy tahini sauce for a Middle Eastern delight.~');
create_item(c, q'~Ethiopian Berbere Chicken Wrap~', q'~Grilled chicken breast marinated in aromatic berbere spice blend, served with sautéed collard greens and spicy lentil spread. Rolled in traditional injera flatbread for a tangy, earthy finish.~');
create_item(c, q'~Falafel Pita~', q'~Crispy chickpea falafel balls, seasoned with cumin, coriander, and fresh parsley, tucked into warm pita bread. Layered with shredded lettuce, ripe tomato, cucumber slices, and finished with a creamy tahini sauce and a sprinkle of sumac.~');
create_item(c, q'~Filipino Pan de Sal Adobo~', q'~Tender chicken adobo, slow-cooked in soy sauce, vinegar, garlic, and bay leaves, stuffed into warm pan de sal rolls. Garnished with pickled papaya and a touch of garlic aioli for a Filipino twist.~');
create_item(c, q'~Finnish Lohileipä~', q'~Open-faced rye sandwich topped with smoked salmon, dill cream, cucumber slices, and pickled red onions. Finished with a sprinkle of fresh dill and lemon zest for a Scandinavian delicacy.~');
create_item(c, q'~French Croque Monsieur~', q'~Layers of thinly sliced ham and Gruyère cheese between slices of buttery brioche, topped with creamy béchamel sauce. Baked until golden and bubbling, this Parisian classic is finished with a sprinkle of nutmeg.~');
create_item(c, q'~German Leberkäse Sandwich~', q'~Thick slice of Bavarian meatloaf (Leberkäse), served warm on a pretzel bun. Topped with sweet mustard and pickled cucumbers for a savory, tangy German treat.~');
create_item(c, q'~Gluten-Free Avocado BLT~', q'~Crispy bacon, fresh lettuce, juicy tomato, and creamy avocado slices served on gluten-free toast. Finished with a touch of mayo for a classic flavor, minus the gluten.~');
create_item(c, q'~Gluten-Free Chickpea Salad Sandwich~', q'~Mashed chickpeas mixed with celery, red onion, vegan mayo, and fresh herbs, served on gluten-free bread with crisp lettuce. A protein-rich, allergy-friendly option.~');
create_item(c, q'~Gluten-Free Eggplant Parmesan Sandwich~', q'~Breaded eggplant slices, baked and layered with marinara sauce and melted mozzarella on gluten-free ciabatta. Finished with fresh basil for a classic Italian taste, gluten-free.~');
create_item(c, q'~Gluten-Free Tuna Salad Sandwich~', q'~Classic tuna salad made with celery, onion, and mayo, served on gluten-free bread with crisp lettuce and tomato. A light, allergy-friendly lunch option.~');
create_item(c, q'~Greek Gyro Sandwich~', q'~Slices of seasoned lamb and beef, slow-roasted on a vertical spit, wrapped in warm pita bread. Garnished with fresh tomatoes, onions, crisp lettuce, and a generous dollop of creamy tzatziki sauce made from Greek yogurt, cucumber, and dill.~');
create_item(c, q'~Grilled Cheese~', q'~Classic comfort food with melted cheddar cheese sandwiched between slices of buttery, toasted bread. Served hot and gooey, often with tomato soup.~');
create_item(c, q'~Halal Spiced Lamb Wrap~', q'~Halal-certified spiced lamb, grilled and sliced, wrapped with cucumber, tomato, and yogurt sauce in a soft wrap. Finished with fresh mint and sumac for a Middle Eastern flavor profile.~');
create_item(c, q'~Ham and Cheese Panini~', q'~Pressed sandwich with sliced ham and Swiss cheese, grilled until the bread is crisp and the cheese is melted. Served warm with a side salad.~');
create_item(c, q'~Hawaiian Spam Musubi Sandwich~', q'~Grilled Spam slices, sticky sushi rice, and nori seaweed layered in a toasted bun. Finished with a sweet teriyaki glaze and a sprinkle of sesame seeds for a Hawaiian fusion treat.~');
create_item(c, q'~Hungarian Lángos Sandwich~', q'~Fried potato flatbread, crispy on the outside and soft inside, topped with garlic sour cream, shredded cheese, and slices of smoked sausage. A comforting Hungarian street food favorite.~');
create_item(c, q'~Indonesian Tempeh Rendang Wrap~', q'~Spicy coconut-braised tempeh, infused with lemongrass, galangal, and chili, wrapped with cucumber, shredded carrots, and sambal mayo in a soft tortilla. A plant-based take on Indonesian rendang.~');
create_item(c, q'~Irish Breakfast Roll~', q'~Grilled sausage, crispy bacon, fried egg, black pudding, and golden hash browns wrapped in a soft floury roll. Finished with tomato relish and a sprinkle of chives for a hearty Irish breakfast on the go.~');
create_item(c, q'~Israeli Sabich Sandwich~', q'~Pita stuffed with fried eggplant, hard-boiled eggs, Israeli salad (cucumber, tomato, parsley), pickles, and creamy amba sauce made from pickled mango. A flavorful vegetarian option from Tel Aviv.~');
create_item(c, q'~Italian Porchetta Sandwich~', q'~Slow-roasted pork belly seasoned with rosemary, fennel, and garlic, sliced and served on a rustic ciabatta roll. Topped with peppery arugula, fennel slaw, and a rich garlic aioli for a robust Italian flavor profile.~');
create_item(c, q'~Jamaican Jerk Chicken Sandwich~', q'~Grilled chicken breast marinated in a blend of allspice, Scotch bonnet peppers, thyme, and ginger, served on a toasted coco bread roll. Topped with spicy mango slaw, crisp lettuce, and a hint of lime for a tropical kick.~');
create_item(c, q'~Japanese Katsu Sando~', q'~Crispy panko-breaded chicken cutlet, fried until golden and juicy, layered with shredded cabbage and tangy tonkatsu sauce. Served between slices of fluffy Japanese milk bread for a delicate yet hearty sandwich experience.~');
create_item(c, q'~Keto Egg ~' || chr(38) || q'~ Cheese Cloud Bread Sandwich~', q'~Fluffy cloud bread made from whipped eggs and cream cheese, filled with scrambled eggs, melted cheddar cheese, and sautéed spinach. A low-carb, keto-friendly breakfast sandwich.~');
create_item(c, q'~Korean Bulgogi Sandwich~', q'~Tender slices of marinated bulgogi beef, grilled to perfection and served on a toasted baguette. Topped with a vibrant kimchi slaw made from fermented cabbage, carrots, and daikon, finished with scallions and a drizzle of spicy gochujang mayo for a bold, umami-packed bite.~');
create_item(c, q'~Kosher Smoked Whitefish Salad Sandwich~', q'~Smoked whitefish salad made with celery, dill, and kosher mayo, served on challah bread with crisp lettuce and tomato. A classic deli favorite, prepared kosher.~');
create_item(c, q'~Lebanese Halloumi ~' || chr(38) || q'~ Za'atar Wrap~', q'~Grilled halloumi cheese, fresh mint leaves, tomatoes, cucumbers, and za'fatar spice blend wrapped in warm pita. Drizzled with lemon tahini dressing for a bright, herbal Mediterranean flavor.~');
create_item(c, q'~Low-Carb Turkey Lettuce Wrap~', q'~Sliced turkey breast, creamy avocado, ripe tomato, and tangy mustard wrapped in fresh iceberg lettuce leaves. A light, refreshing, and carb-conscious sandwich alternative.~');
create_item(c, q'~Low-Sodium Grilled Chicken Sandwich~', q'~Herb-grilled chicken breast, ripe tomato, crisp lettuce, and creamy avocado served on whole grain bread. Prepared with minimal salt for a heart-healthy option.~');
create_item(c, q'~Malaysian Roti John~', q'~Omelette with minced beef, onions, and aromatic spices cooked inside a baguette. Topped with spicy chili sauce and creamy mayonnaise for a Malaysian street food classic.~');
create_item(c, q'~Mexican Torta de Milanesa~', q'~Breaded chicken cutlet, fried until crisp, layered with refried beans, creamy avocado, jalapeños, lettuce, tomato, and chipotle mayo. Served on a soft telera roll for a hearty, spicy Mexican sandwich.~');
create_item(c, q'~Moroccan Chickpea Shawarma Wrap~', q'~Spiced chickpeas roasted with cumin, coriander, and paprika, wrapped in a soft flatbread. Filled with shredded lettuce, sliced tomatoes, pickled onions, and finished with a tangy harissa yogurt sauce for a North African twist.~');
create_item(c, q'~Mumbai Vada Pav~', q'~Spicy mashed potato fritter coated in chickpea flour and fried until crisp, sandwiched in a soft pav bun. Layered with fiery garlic chutney, tangy green chili, and sweet tamarind sauce, capturing the essence of Mumbai street food.~');
create_item(c, q'~Nepalese Aloo Chop Roll~', q'~Spiced potato fritters, fried until golden, wrapped with pickled radish and tangy tomato achar in a soft flatbread. A Nepalese street food favorite with layers of flavor.~');
create_item(c, q'~Nut-Free Sunflower Butter ~' || chr(38) || q'~ Banana Sandwich~', q'~Creamy sunflower seed butter spread on whole wheat bread, layered with sliced bananas and a drizzle of honey. A nut-free, kid-friendly sandwich option.~');
create_item(c, q'~Pakistani Chapli Kebab Sandwich~', q'~Spiced ground beef patty, pan-fried with coriander seeds, pomegranate, and green chili, served in naan bread. Layered with sliced onions, tomatoes, and mint chutney for a bold Pakistani flavor.~');
create_item(c, q'~Paleo Grilled Steak Sandwich~', q'~Grass-fed grilled steak, sliced thin and layered with roasted bell peppers, peppery arugula, and zesty chimichurri sauce on a sweet potato flatbread. A hearty, grain-free paleo option.~');
create_item(c, q'~Persian Kuku Sabzi Sandwich~', q'~Herb-packed Persian omelette made with parsley, cilantro, dill, and scallions, layered with walnuts and tart barberries on toasted sangak bread. Finished with a dollop of yogurt sauce for a fragrant, healthy bite.~');
create_item(c, q'~Peruvian Chicharrón Sandwich~', q'~Crispy pork belly, slow-cooked and fried, layered with sweet potato slices and salsa criolla (onion, lime, and chili). Served on a soft roll and finished with aji amarillo mayo for a spicy, creamy touch.~');
create_item(c, q'~Polish Zapiekanka~', q'~Toasted baguette topped with sautéed mushrooms, caramelized onions, and melted cheese. Finished with a drizzle of ketchup and garnished with fresh chives, this Polish street food is both savory and satisfying.~');
create_item(c, q'~Puerto Rican Tripleta~', q'~A hearty sandwich with grilled steak, roast pork, and ham, layered with lettuce, tomato, crispy potato sticks, and creamy mayo-ketchup sauce. Served on a soft roll for a true Puerto Rican feast.~');
create_item(c, q'~Russian Smoked Salmon Blini Sandwich~', q'~Delicate smoked salmon layered with dill cream cheese and pickled onions, sandwiched between fluffy blini pancakes. Finished with a touch of lemon zest and fresh chives for a refined Russian treat.~');
create_item(c, q'~Seitan BBQ Sandwich~', q'~Pulled seitan tossed in smoky barbecue sauce, piled high on a toasted bun with crunchy coleslaw and pickles. Served with a side of fries.~');
create_item(c, q'~Seitan Burrito~', q'~A large flour tortilla filled with seasoned seitan, black beans, rice, sautéed peppers, onions, and salsa. Rolled up and grilled for a satisfying, plant-based meal.~');
create_item(c, q'~Seitan Gyros~', q'~Thinly sliced seitan seasoned with Mediterranean spices, served in warm pita bread with lettuce, tomatoes, onions, and creamy vegan tzatziki sauce.~');
create_item(c, q'~Seitan Philly Cheesesteak~', q'~Sautéed seitan strips, onions, and bell peppers piled into a toasted hoagie roll and topped with melted vegan cheese sauce.~');
create_item(c, q'~Singaporean Chili Crab Roll~', q'~Sweet and spicy chili crab meat, sautéed with garlic, ginger, and chili paste, served in a toasted brioche roll. Topped with scallions and crisp lettuce for a taste of Singapore’s hawker centers.~');
create_item(c, q'~South African Bunny Chow~', q'~Hollowed-out bread loaf filled with spicy Durban-style chicken curry, slow-cooked with tomatoes, onions, and fragrant spices. Garnished with fresh coriander and served with a side of carrot salad.~');
create_item(c, q'~Soy-Free Turkey ~' || chr(38) || q'~ Cranberry Sandwich~', q'~Roast turkey breast, tangy cranberry sauce, and fresh spinach leaves served on oat bread. A soy-free, festive sandwich perfect for any season.~');
create_item(c, q'~Spanish Bocadillo de Calamares~', q'~Crispy fried calamari rings, lightly seasoned and piled onto a crusty baguette. Finished with lemon aioli, fresh arugula, and a squeeze of lemon for a taste of Madrid’s tapas bars.~');
create_item(c, q'~Sri Lankan Pol Sambol Egg Sandwich~', q'~Hard-boiled eggs sliced and layered with spicy coconut sambol (grated coconut, chili, lime, and onion) and fresh tomato slices on soft white bread. A vibrant Sri Lankan breakfast treat.~');
create_item(c, q'~Swedish Räksmörgås~', q'~Open-faced rye sandwich topped with fresh shrimp, sliced boiled egg, crisp lettuce, cucumber, dill, and creamy remoulade. Finished with a wedge of lemon for a refreshing Scandinavian bite.~');
create_item(c, q'~Syrian Muhammara Chicken Wrap~', q'~Grilled chicken breast, coated in spicy walnut-pepper muhammara spread, wrapped in saj bread with crisp lettuce and cucumber. A Middle Eastern wrap bursting with flavor and texture.~');
create_item(c, q'~Thai Satay Chicken Sandwich~', q'~Grilled chicken skewers marinated in coconut milk, lemongrass, and turmeric, served on a baguette. Topped with pickled vegetables, fresh cilantro, and a rich peanut satay sauce for a sweet and spicy flavor.~');
create_item(c, q'~Tofu Banh Mi~', q'~A Vietnamese sandwich with marinated tofu slices, pickled carrots and daikon, cucumber, cilantro, and spicy mayo, all tucked into a crisp baguette.~');
create_item(c, q'~Tofu Burrito~', q'~A large flour tortilla filled with seasoned tofu, black beans, rice, sautéed peppers, onions, and salsa. Rolled up and grilled for a satisfying, plant-based meal.~');
create_item(c, q'~Tofu and Avocado Wrap~', q'~A soft tortilla filled with grilled tofu, creamy avocado, mixed greens, shredded carrots, and a zesty lime dressing. Rolled up for a fresh, portable meal.~');
create_item(c, q'~Tuna Melt~', q'~A comforting sandwich with savory tuna salad (tuna, mayonnaise, celery, and onions) piled onto toasted bread, topped with slices of ripe tomato and melted cheddar cheese. Grilled until golden and served hot.~');
create_item(c, q'~Tunisian Fricassee~', q'~Fried bun filled with tuna, spicy harissa, olives, boiled egg, and potato salad. Drizzled with fresh lemon juice and garnished with capers for a North African sandwich with a kick.~');
create_item(c, q'~Turkey Club~', q'~A hearty triple-decker sandwich with sliced turkey, crispy bacon, lettuce, tomato, and mayonnaise, layered between toasted bread. Served with fries or a pickle.~');
create_item(c, q'~Turkish Döner Kebab Sandwich~', q'~Thinly sliced spiced lamb, slow-cooked on a vertical rotisserie, wrapped in warm lavash bread. Accompanied by fresh tomatoes, onions, lettuce, and a garlic yogurt sauce infused with mint and lemon.~');
create_item(c, q'~Vegan BBQ Jackfruit Sandwich~', q'~Pulled jackfruit simmered in smoky barbecue sauce, piled high on a toasted bun. Topped with vegan coleslaw made from cabbage, carrots, and vegan mayo, plus tangy pickles for crunch.~');
create_item(c, q'~Vegan BBQ Jackfruit Wrap~', q'~Pulled BBQ jackfruit, vegan coleslaw, and tangy pickles wrapped in a whole wheat tortilla. A smoky, plant-based BBQ wrap.~');
create_item(c, q'~Vegan BBQ Mushroom Sandwich~', q'~Pulled oyster mushrooms simmered in smoky barbecue sauce, piled onto a toasted bun. Topped with vegan coleslaw and tangy pickles for a satisfying plant-based BBQ experience.~');
create_item(c, q'~Vegan BBQ Mushroom Wrap~', q'~Pulled oyster mushrooms in smoky barbecue sauce, vegan coleslaw, and tangy pickles wrapped in a whole wheat tortilla. A savory, plant-based BBQ wrap.~');
create_item(c, q'~Vegan BBQ Seitan Sandwich~', q'~Pulled BBQ seitan, vegan coleslaw, and tangy pickles served on a toasted bun. A hearty, smoky vegan BBQ sandwich.~');
create_item(c, q'~Vegan BBQ Seitan Wrap~', q'~Pulled BBQ seitan, vegan coleslaw, and tangy pickles wrapped in a whole wheat tortilla. A hearty, smoky vegan BBQ wrap.~');
create_item(c, q'~Vegan BBQ Tempeh Sandwich~', q'~Grilled BBQ tempeh slices, vegan coleslaw, and tangy pickles served on a toasted bun. A smoky, protein-rich vegan BBQ sandwich.~');
create_item(c, q'~Vegan BBQ Tempeh Wrap~', q'~Grilled BBQ tempeh, vegan coleslaw, and tangy pickles wrapped in a whole wheat tortilla. A smoky, protein-rich vegan wrap.~');
create_item(c, q'~Vegan Buffalo Cauliflower Wrap~', q'~Crispy buffalo-spiced cauliflower florets, shredded lettuce, carrots, and vegan ranch dressing wrapped in a soft tortilla. A spicy, tangy, plant-based wrap.~');
create_item(c, q'~Vegan Curried Chickpea Salad Sandwich~', q'~Curried chickpea salad made with vegan mayo, shredded carrots, celery, and fresh cilantro, served on whole wheat bread with crisp lettuce.~');
create_item(c, q'~Vegan Curried Chickpea Wrap~', q'~Curried chickpea salad, shredded carrots, celery, and fresh cilantro wrapped in a whole wheat tortilla. A spicy, protein-rich vegan wrap.~');
create_item(c, q'~Vegan Mediterranean Chickpea Wrap~', q'~Spiced chickpeas, diced cucumber, tomato, Kalamata olives, and vegan tzatziki wrapped in a spinach tortilla. A fresh, protein-rich Mediterranean vegan wrap.~');
create_item(c, q'~Vegan Mediterranean Lentil Sandwich~', q'~Spiced lentils, roasted eggplant, diced tomatoes, and vegan tzatziki layered on multigrain bread. A hearty, protein-packed vegan sandwich.~');
create_item(c, q'~Vegan Mediterranean Lentil Wrap~', q'~Spiced lentils, roasted eggplant, diced tomatoes, and vegan tzatziki wrapped in a whole wheat tortilla. A hearty, protein-packed vegan wrap.~');
create_item(c, q'~Vegan Smoky Eggplant Sandwich~', q'~Charred eggplant slices, roasted red peppers, fresh arugula, and vegan garlic aioli layered on ciabatta bread. A smoky, savory vegan sandwich.~');
create_item(c, q'~Vegan Smoky Eggplant Wrap~', q'~Charred eggplant slices, roasted red peppers, fresh arugula, and vegan garlic aioli wrapped in a whole wheat tortilla. A smoky, savory vegan wrap.~');
create_item(c, q'~Vegan Spicy Black Bean Sandwich~', q'~Spicy black beans, corn salsa, creamy avocado, and crisp lettuce layered on multigrain bread. A flavorful, protein-rich vegan sandwich.~');
create_item(c, q'~Vegan Spicy Black Bean Wrap~', q'~Spicy black beans, corn salsa, creamy avocado, and crisp lettuce wrapped in a whole wheat tortilla. A flavorful, protein-rich vegan wrap.~');
create_item(c, q'~Vegan Spicy Chickpea Sandwich~', q'~Spicy chickpeas, shredded lettuce, tomato, cucumber, and vegan ranch dressing layered on multigrain bread. A zesty, protein-rich vegan sandwich.~');
create_item(c, q'~Vegan Spicy Chickpea Wrap~', q'~Spicy chickpeas, shredded lettuce, tomato, cucumber, and vegan ranch dressing wrapped in a whole wheat tortilla. A zesty, protein-packed vegan wrap.~');
create_item(c, q'~Vegan Spicy Lentil Sandwich~', q'~Spicy lentils, shredded lettuce, tomato, cucumber, and vegan ranch dressing layered on multigrain bread. A hearty, zesty vegan sandwich.~');
create_item(c, q'~Vegan Spicy Lentil Wrap~', q'~Spicy lentils, shredded lettuce, tomato, cucumber, and vegan ranch dressing wrapped in a whole wheat tortilla. A hearty, zesty vegan wrap.~');
create_item(c, q'~Vegan Sweet Potato ~' || chr(38) || q'~ Black Bean Wrap~', q'~Roasted sweet potatoes, black beans, corn salsa, creamy avocado, and fresh cilantro wrapped in a whole wheat tortilla. A hearty, nutrient-packed vegan wrap.~');
create_item(c, q'~Vegan Tempeh Reuben~', q'~Marinated tempeh slices, grilled and layered with tangy sauerkraut, vegan Russian dressing, and Swiss-style vegan cheese on toasted rye bread. A plant-based twist on the classic deli sandwich.~');
create_item(c, q'~Vegan Teriyaki Tofu Sandwich~', q'~Grilled teriyaki-marinated tofu, pickled ginger, shredded cabbage, and spicy sriracha mayo served on a sesame bun. A savory, Asian-inspired vegan sandwich.~');
create_item(c, q'~Vegan Teriyaki Tofu Wrap~', q'~Grilled teriyaki-marinated tofu, pickled ginger, shredded cabbage, and spicy sriracha mayo wrapped in a spinach tortilla. An Asian-inspired vegan wrap.~');
create_item(c, q'~Vegetarian Artichoke ~' || chr(38) || q'~ Olive Tapenade Sandwich~', q'~Artichoke hearts, olive tapenade, roasted tomatoes, and fresh spinach layered on focaccia bread. A Mediterranean-inspired vegetarian sandwich.~');
create_item(c, q'~Vegetarian Artichoke ~' || chr(38) || q'~ Olive Tapenade Wrap~', q'~Artichoke hearts, olive tapenade, roasted tomatoes, and fresh spinach wrapped in a whole wheat tortilla. A Mediterranean-inspired vegetarian wrap.~');
create_item(c, q'~Vegetarian Avocado ~' || chr(38) || q'~ Sprout Sandwich~', q'~Sliced avocado, alfalfa sprouts, tomato, cucumber, and lemon aioli layered on multigrain bread. A fresh, crunchy vegetarian sandwich.~');
create_item(c, q'~Vegetarian Avocado ~' || chr(38) || q'~ Sprout Wrap~', q'~Sliced avocado, alfalfa sprouts, tomato, cucumber, and lemon aioli wrapped in a whole wheat tortilla. A fresh, crunchy vegetarian wrap.~');
create_item(c, q'~Vegetarian Eggplant Caponata Sandwich~', q'~Sicilian-style eggplant caponata made with tomatoes, olives, capers, and pine nuts, layered with arugula and creamy ricotta on toasted focaccia bread.~');
create_item(c, q'~Vegetarian Grilled Portobello Mushroom Sandwich~', q'~Grilled portobello mushroom cap, roasted red peppers, fresh spinach, and creamy goat cheese layered on ciabatta bread. A rich, savory vegetarian sandwich.~');
create_item(c, q'~Vegetarian Grilled Portobello Mushroom Wrap~', q'~Grilled portobello mushroom cap, roasted red peppers, fresh spinach, and creamy goat cheese wrapped in a whole wheat tortilla. A rich, savory vegetarian wrap.~');
create_item(c, q'~Vegetarian Mediterranean Veggie Sub~', q'~Roasted eggplant, zucchini, and red peppers, layered with feta cheese, Kalamata olives, and creamy hummus on a whole wheat sub roll. Finished with a drizzle of olive oil and fresh oregano.~');
create_item(c, q'~Vegetarian Mushroom ~' || chr(38) || q'~ Swiss Sandwich~', q'~Sautéed mushrooms, melted Swiss cheese, caramelized onions, and fresh arugula layered on rye bread. A rich, earthy vegetarian sandwich.~');
create_item(c, q'~Vegetarian Mushroom ~' || chr(38) || q'~ Swiss Wrap~', q'~Sautéed mushrooms, melted Swiss cheese, caramelized onions, and fresh arugula wrapped in a whole wheat tortilla. A rich, earthy vegetarian wrap.~');
create_item(c, q'~Vegetarian Paneer Tikka Sandwich~', q'~Grilled paneer cubes marinated in tikka spices, layered with sautéed bell peppers and onions, and finished with mint chutney on a toasted roll. A flavorful vegetarian Indian sandwich.~');
create_item(c, q'~Vegetarian Roasted Beet ~' || chr(38) || q'~ Goat Cheese Sandwich~', q'~Roasted beets, creamy goat cheese, peppery arugula, and balsamic glaze layered on multigrain bread. A colorful, earthy vegetarian sandwich.~');
create_item(c, q'~Vegetarian Roasted Cauliflower ~' || chr(38) || q'~ Tahini Sandwich~', q'~Roasted cauliflower florets, creamy tahini sauce, pickled onions, and fresh arugula layered on pita bread. A nutty, tangy vegetarian sandwich.~');
create_item(c, q'~Vegetarian Roasted Cauliflower ~' || chr(38) || q'~ Tahini Wrap~', q'~Roasted cauliflower florets, creamy tahini sauce, pickled onions, and fresh arugula wrapped in a whole wheat tortilla. A nutty, tangy vegetarian wrap.~');
create_item(c, q'~Vegetarian Roasted Eggplant ~' || chr(38) || q'~ Tomato Sandwich~', q'~Roasted eggplant slices, ripe tomatoes, fresh basil, and melted mozzarella layered on toasted focaccia bread. A classic Italian vegetarian sandwich.~');
create_item(c, q'~Vegetarian Roasted Eggplant ~' || chr(38) || q'~ Tomato Wrap~', q'~Roasted eggplant slices, ripe tomatoes, fresh basil, and melted mozzarella wrapped in a whole wheat tortilla. A classic Italian vegetarian wrap.~');
create_item(c, q'~Vegetarian Roasted Red Pepper ~' || chr(38) || q'~ Goat Cheese Sandwich~', q'~Roasted red peppers, creamy goat cheese, fresh arugula, and balsamic glaze layered on multigrain bread. A tangy, creamy vegetarian sandwich.~');
create_item(c, q'~Vegetarian Roasted Red Pepper ~' || chr(38) || q'~ Goat Cheese Wrap~', q'~Roasted red peppers, creamy goat cheese, fresh arugula, and balsamic glaze wrapped in a whole wheat tortilla. A tangy, creamy vegetarian wrap.~');
create_item(c, q'~Vegetarian Roasted Red Pepper ~' || chr(38) || q'~ Hummus Wrap~', q'~Roasted red peppers, creamy hummus, cucumber slices, and fresh spinach wrapped in a soft tortilla. A light, flavorful vegetarian wrap.~');
create_item(c, q'~Vegetarian Roasted Sweet Potato ~' || chr(38) || q'~ Spinach Sandwich~', q'~Roasted sweet potato slices, sautéed spinach, crumbled feta cheese, and lemon aioli layered on multigrain bread. A sweet and savory vegetarian sandwich.~');
create_item(c, q'~Vegetarian Roasted Sweet Potato ~' || chr(38) || q'~ Spinach Wrap~', q'~Roasted sweet potato slices, sautéed spinach, crumbled feta cheese, and lemon aioli wrapped in a whole wheat tortilla. A sweet and savory vegetarian wrap.~');
create_item(c, q'~Vegetarian Roasted Vegetable ~' || chr(38) || q'~ Hummus Sandwich~', q'~Roasted zucchini, bell peppers, eggplant, and creamy hummus layered on multigrain bread. A hearty, flavorful vegetarian sandwich.~');
create_item(c, q'~Vegetarian Roasted Vegetable ~' || chr(38) || q'~ Pesto Sandwich~', q'~Roasted zucchini, bell peppers, eggplant, and basil pesto layered on multigrain bread. A flavorful, Mediterranean vegetarian sandwich.~');
create_item(c, q'~Vegetarian Roasted Vegetable ~' || chr(38) || q'~ Pesto Wrap~', q'~Roasted zucchini, bell peppers, and eggplant, tossed with basil pesto and wrapped in a spinach tortilla. A colorful, flavorful vegetarian wrap.~');
create_item(c, q'~Vegetarian Spinach ~' || chr(38) || q'~ Feta Sandwich~', q'~Sautéed spinach, crumbled feta cheese, sun-dried tomatoes, and Kalamata olives layered on multigrain bread. A Mediterranean-inspired vegetarian sandwich.~');
create_item(c, q'~Vegetarian Spinach ~' || chr(38) || q'~ Feta Wrap~', q'~Sautéed spinach, crumbled feta cheese, sun-dried tomatoes, and Kalamata olives wrapped in a spinach tortilla. Finished with a drizzle of olive oil for a Mediterranean touch.~');
create_item(c, q'~Veggie Wrap~', q'~A soft tortilla filled with assorted grilled vegetables such as zucchini, bell peppers, mushrooms, and spinach, drizzled with a tangy vinaigrette.~');
create_item(c, q'~Vietnamese Banh Mi with Lemongrass Pork~', q'~Crusty French baguette filled with lemongrass-marinated pork, pickled daikon and carrots, cucumber slices, fresh cilantro, and spicy sriracha mayo. The pork is grilled for smoky flavor, and the pickles add a tangy crunch.~');


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


    

