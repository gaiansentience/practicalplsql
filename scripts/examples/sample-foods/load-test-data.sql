
set serveroutput on;

DECLARE
    l_count number;
     procedure create_category(p_name in varchar2, p_description in varchar2, p_created_by in varchar2) 
     is
     begin
          insert into menu_categories (category_name, category_description, created_by)
          values (p_name, p_description, p_created_by);
     end;
BEGIN

    delete menu_categories;
    
     create_category('Appetizers', 'Starters to whet your appetite', 'admin');
     create_category('Main Courses', 'Hearty and filling main dishes', 'admin');
     create_category('Desserts', 'Sweet treats to end your meal', 'admin');
     create_category('Beverages', 'Drinks to complement your meal', 'admin');
     create_category('Salads', 'Fresh and healthy salads', 'admin');
     create_category('Soups', 'Warm and comforting soups', 'admin');
     create_category('Sandwiches', 'Quick and easy sandwiches', 'admin');
     create_category('Pizzas', 'Delicious pizzas with various toppings', 'admin');
     create_category('Pastas', 'Tasty pasta dishes with rich sauces', 'admin');
     create_category('Seafood', 'Fresh seafood dishes', 'admin');
     create_category('Vegetarian', 'Delicious vegetarian options', 'admin');
     create_category('Vegan', 'Healthy and tasty vegan dishes', 'admin');
     create_category('Gluten-Free', 'Options for gluten-sensitive diners', 'admin');
     create_category('Breakfast', 'Morning meals to start your day', 'admin');

     commit;
     
     select count(*) into l_count
     from menu_categories;
     
     dbms_output.put_line('Created ' || l_count || ' menu categories');
     

EXCEPTION
     when others then
          dbms_output.put_line('Error creating categories: ' || sqlerrm);
          rollback;
END;
/



DECLARE

    l_count number;

    type t_category_ids is table of integer index by varchar2(100);
    l_categories t_category_ids;
    
    procedure load_categories
    is
    begin
        l_categories := t_category_ids(for r in (select category_name, category_id from menu_categories) index r.category_name => r.category_id);
        
        for i, v in pairs of l_categories loop
            dbms_output.put_line('category ' || v || ' = ' || i);
        end loop;
        
    end load_categories;
    
     procedure create_item(p_item_name in varchar2, p_category_name in varchar2, p_description in varchar2, p_created_by in varchar2)
     is
        l_category_id integer := l_categories(p_category_name);
     begin     
        insert into menu_items (item_name, category_id, item_description, created_by)
        values (p_item_name, l_category_id, p_description, p_created_by);
     end create_item;
BEGIN

    load_categories;

     delete menu_items;

     create_item('Bruschetta','Appetizers', 'Grilled slices of rustic Italian bread brushed with olive oil, rubbed with garlic, and topped with a vibrant mixture of diced ripe tomatoes, fresh basil, extra virgin olive oil, balsamic vinegar, and a sprinkle of sea salt. Served as a classic appetizer.', 'admin');
     create_item('Caesar Salad','Salads', 'Crisp romaine lettuce tossed with creamy Caesar dressing made from anchovies, garlic, lemon juice, Dijon mustard, and parmesan cheese. Garnished with crunchy croutons and extra shaved parmesan for a savory, satisfying salad.', 'admin');
     create_item('Margherita Pizza','Pizzas', 'A traditional Neapolitan pizza featuring a thin, chewy crust topped with tangy tomato sauce, slices of fresh mozzarella cheese, and fragrant basil leaves. Baked in a hot oven until the cheese is bubbly and the crust is golden.', 'admin');
     create_item('Spaghetti Carbonara','Pastas', 'Classic Italian pasta dish with al dente spaghetti tossed in a creamy sauce made from eggs, grated pecorino romano cheese, crispy pancetta, and freshly cracked black pepper. Served hot and garnished with extra cheese.', 'admin');
     create_item('Tiramisu','Desserts', 'A decadent Italian dessert made by layering espresso-soaked ladyfinger biscuits with a rich mascarpone cream, dusted with cocoa powder. Chilled to perfection, offering a harmonious blend of coffee and creamy sweetness.', 'admin');
     create_item('Margarita','Beverages', 'A refreshing cocktail crafted with premium tequila, freshly squeezed lime juice, and orange-flavored triple sec, shaken with ice and served in a salt-rimmed glass. Garnished with a lime wedge for a zesty finish.', 'admin');
     create_item('Lentil Soup','Soups', 'Hearty and nourishing soup made with tender lentils simmered with aromatic vegetables such as carrots, celery, onions, garlic, and tomatoes. Seasoned with herbs and spices for a comforting, protein-rich meal.', 'admin');
     create_item('Caprese Salad','Salads', 'A simple yet elegant salad featuring slices of creamy fresh mozzarella, juicy ripe tomatoes, and fragrant basil leaves. Drizzled with extra virgin olive oil and balsamic glaze, finished with a sprinkle of sea salt and black pepper.', 'admin');
     create_item('Vegan Burger','Vegan', 'A plant-based burger patty made from a blend of legumes, grains, and vegetables, grilled and served on a toasted bun with lettuce, tomato, onion, pickles, and vegan mayo. Accompanied by a side of crispy fries.', 'admin');
     create_item('Gluten-Free Pasta','Gluten-Free', 'Pasta made from gluten-free ingredients such as rice, corn, or quinoa flour, cooked al dente and tossed with your choice of sauce. Suitable for gluten-sensitive diners without compromising on taste or texture.', 'admin');
     create_item('Kale Caesar Salad','Salads', 'A modern twist on the classic Caesar, combining tender kale and crisp romaine lettuce, tossed in a light Caesar dressing with parmesan cheese and crunchy whole-grain croutons. Finished with a squeeze of lemon.', 'admin');
     create_item('Spinach Strawberry Salad','Salads', 'Fresh baby spinach leaves tossed with sweet sliced strawberries, toasted walnuts, and creamy goat cheese. Dressed with a tangy balsamic vinaigrette for a refreshing and colorful salad.', 'admin');
     create_item('Quinoa Avocado Salad','Salads', 'Protein-packed quinoa mixed with creamy avocado chunks, juicy cherry tomatoes, crisp cucumber, and fresh herbs. Tossed in a zesty lemon dressing for a light and nutritious salad.', 'admin');
     create_item('Chickpea Greek Salad','Salads', 'A Mediterranean-inspired salad featuring chickpeas, diced cucumber, ripe tomatoes, Kalamata olives, red onion, and crumbled feta cheese. Dressed with olive oil, lemon juice, and oregano.', 'admin');
     create_item('Arugula Beet Salad','Salads', 'Peppery arugula leaves paired with roasted beets, creamy goat cheese, and toasted walnuts. Drizzled with a honey-balsamic vinaigrette for a sweet and earthy flavor combination.', 'admin');
     create_item('Lentil Salad','Salads', 'Nutritious salad made with cooked lentils, diced carrots, celery, red onion, and fresh parsley. Tossed in a tangy Dijon mustard vinaigrette for a hearty and satisfying dish.', 'admin');
     create_item('Broccoli Cranberry Salad','Salads', 'Crunchy broccoli florets mixed with sweet dried cranberries, roasted sunflower seeds, and red onion. Coated in a creamy yogurt-based dressing for a sweet and savory salad.', 'admin');
     create_item('Asian Edamame Salad','Salads', 'A vibrant salad with shelled edamame, shredded cabbage, julienned carrots, and scallions, tossed in a sesame-ginger dressing and topped with toasted sesame seeds.', 'admin');
     create_item('Cucumber Tomato Salad','Salads', 'Refreshing salad of sliced cucumbers, ripe tomatoes, and thinly sliced red onion, tossed in a red wine vinaigrette with fresh dill and parsley.', 'admin');
     create_item('Southwest Black Bean Salad','Salads', 'A zesty salad featuring black beans, sweet corn, diced bell peppers, red onion, and cilantro, all tossed in a tangy cilantro-lime dressing. Perfect as a side or light meal.', 'admin');
     create_item('Apple Walnut Salad','Salads', 'Mixed greens topped with crisp apple slices, toasted walnuts, crumbled blue cheese, and dried cranberries. Finished with a honey mustard vinaigrette for a sweet and savory balance.', 'admin');
     create_item('Roasted Sweet Potato Salad','Salads', 'Roasted cubes of sweet potato combined with fresh spinach, toasted pumpkin seeds, and red onion, all tossed in a creamy tahini dressing for a hearty, nutrient-rich salad.', 'admin');
     create_item('Farro Vegetable Salad','Salads', 'Nutty farro grains mixed with roasted seasonal vegetables, fresh herbs, and a bright lemon-herb dressing. Served chilled or at room temperature for a wholesome side.', 'admin');
     create_item('Watermelon Feta Salad','Salads', 'Juicy watermelon cubes tossed with crumbled feta cheese, fresh mint leaves, and a squeeze of lime juice. A refreshing and sweet-savory summer salad.', 'admin');
     create_item('Avocado Corn Salad','Salads', 'Creamy avocado chunks, sweet corn kernels, cherry tomatoes, and red onion tossed in a tangy lime vinaigrette. Garnished with cilantro for a fresh, vibrant flavor.', 'admin');
     create_item('Zucchini Ribbon Salad','Salads', 'Thin ribbons of zucchini tossed with toasted pine nuts, shaved parmesan, and a light lemon dressing. A delicate and elegant salad perfect for warm weather.', 'admin');
     create_item('Carrot Ginger Salad','Salads', 'Shredded carrots tossed with fresh ginger, scallions, and a sesame-soy dressing. Topped with toasted sesame seeds for a crunchy, flavorful salad.', 'admin');
     create_item('Mango Black Bean Salad','Salads', 'Sweet mango cubes combined with black beans, red bell pepper, jalapeño, and cilantro, all tossed in a zesty lime dressing for a tropical, protein-rich salad.', 'admin');
     create_item('Pear Gorgonzola Salad','Salads', 'Mixed greens topped with juicy pear slices, crumbled gorgonzola cheese, toasted walnuts, and dried cranberries. Dressed with a light balsamic vinaigrette.', 'admin');
     create_item('Tabbouleh Salad','Salads', 'A Middle Eastern salad made with finely chopped parsley, bulgur wheat, diced tomatoes, cucumber, mint, and scallions, all tossed in a lemon-olive oil dressing.', 'admin');
     create_item('Moroccan Chickpea Salad','Salads', 'Chickpeas tossed with shredded carrots, golden raisins, fresh cilantro, and a cumin-spiced citrus dressing. Garnished with toasted almonds for crunch.', 'admin');
     create_item('Roasted Cauliflower Salad','Salads', 'Roasted cauliflower florets combined with peppery arugula, toasted almonds, and a creamy tahini sauce. Finished with a sprinkle of pomegranate seeds.', 'admin');
     create_item('Tomato Basil Mozzarella Salad','Salads', 'Sliced ripe tomatoes layered with fresh mozzarella and basil leaves, drizzled with balsamic glaze and extra virgin olive oil for a classic Italian salad.', 'admin');
     create_item('Sweet Potato Kale Salad','Salads', 'Tender kale leaves massaged with olive oil, topped with roasted sweet potato cubes, dried cranberries, and toasted pecans. Tossed in a maple-balsamic dressing.', 'admin');
     create_item('Broccoli Quinoa Salad','Salads', 'Protein-rich quinoa mixed with steamed broccoli florets, toasted almonds, and scallions, all tossed in a lemon vinaigrette for a light, healthy salad.', 'admin');
     create_item('Cabbage Apple Slaw','Salads', 'Shredded cabbage and crisp apples tossed with grated carrots and a tangy apple cider vinaigrette. A crunchy, refreshing slaw perfect for picnics.', 'admin');
     create_item('Mediterranean Lentil Salad','Salads', 'Earthy lentils combined with diced cucumber, tomatoes, feta cheese, Kalamata olives, and fresh herbs, all tossed in a lemon-oregano dressing.', 'admin');
     create_item('Pumpkin Seed Spinach Salad','Salads', 'Fresh spinach leaves tossed with roasted pumpkin seeds, dried cranberries, and a tangy balsamic vinaigrette. Topped with crumbled feta cheese.', 'admin');
     create_item('Asparagus Pea Salad','Salads', 'Tender asparagus spears and sweet green peas tossed with fresh mint and a zesty lemon dressing. Garnished with shaved parmesan for a spring-inspired salad.', 'admin');
     create_item('Radish Cucumber Salad','Salads', 'Thinly sliced radishes and cucumbers tossed with fresh dill and a creamy yogurt dressing. Light, crisp, and refreshing.', 'admin');
     create_item('Roasted Carrot Salad','Salads', 'Oven-roasted carrots served over a bed of arugula, topped with crumbled feta cheese and toasted pistachios. Drizzled with a honey-lemon dressing.', 'admin');
     create_item('Chopped Detox Salad','Salads', 'A nutrient-dense salad with finely chopped broccoli, cauliflower, carrots, and kale, tossed in a bright lemon vinaigrette. Packed with vitamins and flavor.', 'admin');
     create_item('Berry Spinach Salad','Salads', 'Baby spinach leaves tossed with a medley of fresh berries, toasted almonds, and a sweet-tart poppy seed dressing. A colorful and antioxidant-rich salad.', 'admin');
     create_item('Warm Mushroom Salad','Salads', 'Sautéed mushrooms served warm over fresh spinach, drizzled with a balsamic reduction and topped with toasted pine nuts for a savory, earthy salad.', 'admin');
     create_item('Fennel Orange Salad','Salads', 'Crisp fennel slices and juicy orange segments tossed with arugula and a light olive oil dressing. Finished with cracked black pepper and fresh herbs.', 'admin');
     create_item('Grilled Zucchini Salad','Salads', 'Grilled zucchini slices tossed with crumbled feta cheese, fresh mint, and a squeeze of lemon. Served warm or at room temperature for a summery salad.', 'admin');
     create_item('Sweet Corn Tomato Salad','Salads', 'Sweet corn kernels mixed with diced tomatoes, fresh basil, and a drizzle of olive oil. A simple, vibrant salad that highlights summer produce.', 'admin');
     create_item('Roasted Brussels Sprout Salad','Salads', 'Roasted Brussels sprouts tossed with dried cranberries, toasted pecans, and a maple-Dijon vinaigrette. Served warm for a hearty, flavorful salad.', 'admin');
     create_item('Avocado Chickpea Salad','Salads', 'Creamy avocado and hearty chickpeas combined with diced cucumber, cherry tomatoes, and a lemony dressing. Garnished with fresh parsley.', 'admin');
     create_item('Pomegranate Spinach Salad','Salads', 'Fresh spinach leaves tossed with juicy pomegranate seeds, toasted walnuts, crumbled feta, and a tangy balsamic vinaigrette.', 'admin');
     create_item('Omelette','Breakfast', 'Fluffy egg omelette cooked to order and filled with your choice of ingredients such as cheese, ham, mushrooms, spinach, tomatoes, and herbs. Served hot with toast or salad.', 'admin');
     create_item('Fish Tacos','Seafood', 'Soft corn tortillas filled with grilled or battered fish, topped with crunchy cabbage slaw, fresh pico de gallo, creamy avocado, and a drizzle of tangy lime crema.', 'admin');
     create_item('Vegetable Stir-Fry','Vegetarian', 'A colorful medley of fresh vegetables such as bell peppers, broccoli, carrots, and snap peas, quickly stir-fried in a savory soy-ginger sauce. Served over steamed rice.', 'admin');
     create_item('Club Sandwich','Sandwiches', 'A triple-layered sandwich stacked with sliced turkey, crispy bacon, lettuce, tomato, and mayonnaise, served on toasted bread and cut into quarters. Accompanied by a pickle and fries.', 'admin');    
     create_item('Pepperoni Pizza','Pizzas', 'Classic pizza with a crispy crust, tangy tomato sauce, gooey mozzarella cheese, and generous slices of spicy pepperoni. Baked until the edges are golden and the cheese is bubbling.', 'admin');
     create_item('Chocolate Cake','Desserts', 'Rich, moist chocolate cake layered with smooth chocolate frosting and finished with a glossy ganache. Perfect for chocolate lovers and special occasions.', 'admin');
     create_item('Iced Coffee','Beverages', 'Freshly brewed coffee chilled and poured over ice, served with your choice of milk or sweetener. A refreshing pick-me-up for any time of day.', 'admin');   
     create_item('Greek Salad','Salads', 'A traditional Greek salad with crisp cucumbers, ripe tomatoes, red onion, Kalamata olives, and creamy feta cheese, tossed in a lemon-oregano vinaigrette.', 'admin');
     create_item('Clam Chowder','Soups', 'Creamy soup made with tender clams, diced potatoes, onions, and celery, simmered in a rich, savory broth with a hint of smoky bacon. Served with oyster crackers.', 'admin');
     create_item('BLT Sandwich','Sandwiches', 'A classic sandwich with crispy bacon, fresh lettuce, and juicy tomato slices layered between toasted bread and spread with mayonnaise.', 'admin');
     create_item('Pesto Pasta','Pastas', 'Al dente pasta tossed with vibrant basil pesto sauce, made from fresh basil, garlic, pine nuts, parmesan cheese, and extra virgin olive oil. Garnished with more cheese and pine nuts.', 'admin');  
     create_item('Chicken Alfredo','Pastas', 'Tender grilled chicken breast served over fettuccine pasta coated in a rich, creamy Alfredo sauce made with butter, cream, and parmesan cheese.', 'admin');
     create_item('Eggplant Parmesan','Vegetarian', 'Breaded and fried eggplant slices layered with marinara sauce and mozzarella cheese, baked until bubbly and golden. Served with a side of pasta.', 'admin');
     create_item('Minestrone Soup','Soups', 'Hearty Italian soup filled with seasonal vegetables, beans, pasta, and tomatoes, simmered in a savory broth and seasoned with herbs. Served with crusty bread.', 'admin');
     create_item('Garlic Bread','Appetizers', 'Toasted baguette slices brushed with garlic-infused butter and sprinkled with parsley. Baked until golden and fragrant, perfect as a side or appetizer.', 'admin');
     create_item('Mozzarella Sticks','Appetizers', 'Crispy breaded mozzarella cheese sticks fried until golden and gooey inside. Served hot with a side of tangy marinara sauce for dipping.', 'admin');
     create_item('French Fries','Appetizers', 'Golden, crispy potato fries seasoned with sea salt. Served hot and perfect as a side or snack, with ketchup or your favorite dipping sauce.', 'admin');
     create_item('Buffalo Wings','Appetizers', 'Juicy chicken wings fried until crispy, then tossed in spicy buffalo sauce. Served with celery sticks and creamy blue cheese or ranch dressing.', 'admin');
     create_item('Stuffed Mushrooms','Appetizers', 'Mushroom caps filled with a savory mixture of cream cheese, garlic, herbs, and breadcrumbs, baked until golden and bubbly. Served as a flavorful appetizer.', 'admin');
     create_item('Spring Rolls','Appetizers', 'Crispy rolls filled with a mix of fresh vegetables and sometimes shrimp or pork, wrapped in thin pastry and fried until golden. Served with sweet chili dipping sauce.', 'admin');
     create_item('Chicken Caesar Wrap','Sandwiches', 'Grilled chicken breast, crisp romaine lettuce, parmesan cheese, and creamy Caesar dressing wrapped in a soft flour tortilla. Served with a side salad or chips.', 'admin');
     create_item('Turkey Club','Sandwiches', 'A hearty triple-decker sandwich with sliced turkey, crispy bacon, lettuce, tomato, and mayonnaise, layered between toasted bread. Served with fries or a pickle.', 'admin');
     create_item('Grilled Cheese','Sandwiches', 'Classic comfort food with melted cheddar cheese sandwiched between slices of buttery, toasted bread. Served hot and gooey, often with tomato soup.', 'admin');
     create_item('Ham and Cheese Panini','Sandwiches', 'Pressed sandwich with sliced ham and Swiss cheese, grilled until the bread is crisp and the cheese is melted. Served warm with a side salad.', 'admin');
     create_item('Veggie Wrap','Sandwiches', 'A soft tortilla filled with assorted grilled vegetables such as zucchini, bell peppers, mushrooms, and spinach, drizzled with a tangy vinaigrette.', 'admin');
     create_item('BBQ Chicken Pizza','Pizzas', 'Pizza topped with tangy barbecue sauce, grilled chicken, red onions, mozzarella, and cheddar cheese. Baked until the crust is crisp and the cheese is bubbly.', 'admin');
     create_item('Four Cheese Pizza','Pizzas', 'A decadent pizza with a blend of mozzarella, cheddar, parmesan, and gorgonzola cheeses, melted over a thin, crispy crust and finished with a sprinkle of herbs.', 'admin');
     create_item('Hawaiian Pizza','Pizzas', 'Pizza with a sweet and savory combination of sliced ham and juicy pineapple chunks, topped with mozzarella cheese and tomato sauce.', 'admin');
     create_item('Spinach and Ricotta Pizza','Pizzas', 'Pizza topped with creamy ricotta cheese, sautéed spinach, mozzarella, and a hint of garlic, baked until golden and delicious.', 'admin');
     create_item('Seafood Pizza','Pizzas', 'A gourmet pizza topped with shrimp, calamari, and mussels, along with tomato sauce, mozzarella cheese, and fresh herbs. Baked until the seafood is tender.', 'admin');
     create_item('Lasagna','Pastas', 'Layered pasta dish with sheets of pasta, rich meat sauce, creamy béchamel, and melted mozzarella and parmesan cheeses. Baked until bubbly and golden.', 'admin');
     create_item('Fettuccine Alfredo','Pastas', 'Fettuccine pasta tossed in a luxurious Alfredo sauce made from butter, heavy cream, and parmesan cheese. Creamy, rich, and comforting.', 'admin');
     create_item('Bolognese Pasta','Pastas', 'Pasta served with a hearty, slow-simmered meat sauce made from ground beef, tomatoes, onions, carrots, celery, and Italian herbs.', 'admin');
     create_item('Penne Arrabbiata','Pastas', 'Penne pasta tossed in a spicy tomato sauce made with garlic, crushed red pepper flakes, and extra virgin olive oil. Garnished with fresh parsley.', 'admin');
     create_item('Mac and Cheese','Pastas', 'Elbow macaroni baked in a creamy cheese sauce made from cheddar and parmesan, topped with buttery breadcrumbs and baked until golden.', 'admin');
     create_item('Seafood Risotto','Seafood', 'Creamy Arborio rice risotto cooked slowly with white wine, garlic, and a medley of fresh seafood such as shrimp, scallops, and mussels. Finished with parsley and lemon.', 'admin');
     create_item('Grilled Salmon','Seafood', 'Fresh salmon fillet marinated in lemon, garlic, and herbs, then grilled to perfection. Served with seasonal vegetables and a wedge of lemon.', 'admin');
     create_item('Shrimp Scampi','Seafood', 'Succulent shrimp sautéed in garlic butter and white wine sauce, tossed with linguine pasta and finished with fresh parsley and a squeeze of lemon.', 'admin');
     create_item('Fish and Chips','Seafood', 'Crispy battered fish fillet fried until golden, served with thick-cut fries, tartar sauce, and a wedge of lemon. A classic pub favorite.', 'admin');
     create_item('Crab Cakes','Seafood', 'Pan-seared crab cakes made with lump crab meat, herbs, and spices, served with a zesty remoulade sauce and a side of mixed greens.', 'admin');
     create_item('Vegetable Curry','Vegetarian', 'A medley of fresh vegetables simmered in a fragrant curry sauce made with coconut milk, tomatoes, ginger, garlic, and a blend of spices. Served with steamed rice.', 'admin');
     create_item('Stuffed Peppers','Vegetarian', 'Bell peppers filled with a savory mixture of rice, vegetables, herbs, and cheese, baked until the peppers are tender and the filling is golden.', 'admin');
     create_item('Mushroom Risotto','Vegetarian', 'Creamy risotto made with Arborio rice, sautéed mushrooms, onions, garlic, and parmesan cheese. Finished with fresh herbs and a drizzle of truffle oil.', 'admin');
     create_item('Tofu Stir-Fry','Vegetarian', 'Cubes of tofu stir-fried with colorful vegetables in a savory soy-ginger sauce. Served over steamed jasmine rice for a healthy, plant-based meal.', 'admin');
     create_item('Mapo Tofu','Vegetarian', 'A classic Sichuan dish featuring soft tofu cubes simmered in a spicy, aromatic sauce made with fermented bean paste, ground Sichuan peppercorns, minced garlic, and ground pork or mushrooms. Served hot with steamed rice.', 'admin');
     create_item('Tofu Pad Thai','Vegan', 'Rice noodles stir-fried with crispy tofu, bean sprouts, scallions, and peanuts in a tangy tamarind sauce. Garnished with lime wedges and fresh cilantro for a vibrant, plant-based twist on the Thai favorite.', 'admin');
     create_item('Tofu Tikka Masala','Vegetarian', 'Marinated tofu cubes grilled and simmered in a creamy, spiced tomato sauce with ginger, garlic, and garam masala. Served with basmati rice and warm naan bread.', 'admin');
     create_item('Seitan Stir-Fry','Vegetarian', 'Tender strips of seitan sautéed with colorful bell peppers, broccoli, carrots, and snap peas in a savory garlic-ginger soy sauce. Served over steamed jasmine rice for a protein-packed meal.', 'admin');
     create_item('Seitan Fajitas','Vegan', 'Sizzling seitan strips marinated in smoky spices, grilled with onions and peppers, and served with warm flour tortillas, guacamole, salsa, and lime wedges.', 'admin');
     create_item('Seitan Bourguignon','Vegetarian', 'Hearty stew featuring seitan chunks braised in red wine with mushrooms, pearl onions, carrots, and fresh thyme. Served over creamy mashed potatoes or crusty bread.', 'admin');
     create_item('Seitan Schnitzel','Main Courses', 'Breaded and pan-fried seitan cutlets with a golden, crispy crust. Served with lemon wedges, potato salad, and a side of tangy mustard sauce.', 'admin');
     create_item('Seitan Gyros','Sandwiches', 'Thinly sliced seitan seasoned with Mediterranean spices, served in warm pita bread with lettuce, tomatoes, onions, and creamy vegan tzatziki sauce.', 'admin');
     create_item('Seitan BBQ Sandwich','Sandwiches', 'Pulled seitan tossed in smoky barbecue sauce, piled high on a toasted bun with crunchy coleslaw and pickles. Served with a side of fries.', 'admin');
     create_item('Seitan Tikka Masala','Vegetarian', 'Chunks of seitan marinated in Indian spices, grilled, and simmered in a rich, creamy tomato-cashew sauce. Served with basmati rice and naan.', 'admin');
     create_item('Seitan Satay Skewers','Appetizers', 'Grilled skewers of marinated seitan served with a spicy, creamy peanut dipping sauce and a side of cucumber salad.', 'admin');
     create_item('Seitan and Broccoli Stir-Fry','Vegetarian', 'Seitan strips and crisp broccoli florets stir-fried in a savory hoisin-garlic sauce, finished with toasted sesame seeds. Served over steamed rice.', 'admin');
     create_item('Seitan Piccata','Vegan', 'Pan-seared seitan cutlets in a tangy lemon-caper sauce, served with sautéed spinach and roasted potatoes for a Mediterranean-inspired entrée.', 'admin');
     create_item('Seitan and Vegetable Curry','Vegetarian', 'Seitan cubes simmered with assorted vegetables in a fragrant coconut curry sauce, flavored with ginger, garlic, and spices. Served with jasmine rice.', 'admin');
     create_item('Seitan Philly Cheesesteak','Sandwiches', 'Sautéed seitan strips, onions, and bell peppers piled into a toasted hoagie roll and topped with melted vegan cheese sauce.', 'admin');
     create_item('Seitan Teriyaki Bowl','Vegetarian', 'Grilled seitan glazed with sweet and savory teriyaki sauce, served over steamed rice with broccoli, carrots, and edamame.', 'admin');
     create_item('Seitan Pot Roast','Main Courses', 'Slow-cooked seitan roast with potatoes, carrots, onions, and celery in a savory herb gravy. Served hot for a comforting, hearty meal.', 'admin');
     create_item('Seitan Caesar Salad','Salads', 'Crisp romaine lettuce tossed with creamy vegan Caesar dressing, crunchy croutons, and grilled seitan strips. Finished with a sprinkle of vegan parmesan.', 'admin');
     create_item('Seitan Burrito','Sandwiches', 'A large flour tortilla filled with seasoned seitan, black beans, rice, sautéed peppers, onions, and salsa. Rolled up and grilled for a satisfying, plant-based meal.', 'admin');
     create_item('Seitan and Mushroom Stroganoff','Vegan', 'Sautéed seitan and mushrooms in a creamy, dairy-free stroganoff sauce with onions, garlic, and paprika. Served over egg-free noodles or rice.', 'admin');
     create_item('Seitan Katsu Curry','Vegetarian', 'Breaded and fried seitan cutlets served over steamed rice and topped with a rich Japanese curry sauce made from onions, carrots, potatoes, and mild spices.', 'admin');
     create_item('Seitan Bolognese','Pastas', 'Hearty Italian pasta dish with seitan crumbles simmered in a rich tomato sauce with garlic, onions, carrots, and Italian herbs. Served over spaghetti.', 'admin');
     create_item('Seitan Jambalaya','Vegetarian', 'A spicy Creole rice dish with seitan chunks, bell peppers, celery, onions, tomatoes, and Cajun spices. Slow-cooked for deep, smoky flavor.', 'admin');
     create_item('Seitan Tacos','Vegan', 'Soft corn tortillas filled with seasoned seitan, shredded lettuce, pico de gallo, avocado, and a drizzle of chipotle crema.', 'admin');
     create_item('Seitan and Spinach Lasagna','Vegan', 'Layers of pasta, seitan crumbles, sautéed spinach, marinara sauce, and vegan cheese, baked until bubbly and golden.', 'admin');
     create_item('Seitan Pad Thai','Vegan', 'Rice noodles stir-fried with seitan strips, bean sprouts, scallions, and peanuts in a tangy tamarind sauce. Garnished with lime wedges and cilantro.', 'admin');
     create_item('Seitan Wellington','Main Courses', 'A savory seitan loaf wrapped in flaky puff pastry with mushroom duxelles and spinach, baked until golden. Served with a rich red wine gravy.', 'admin');
     create_item('Tofu Buddha Bowl','Salads', 'A nourishing bowl with baked tofu, quinoa, roasted sweet potatoes, steamed broccoli, shredded carrots, and avocado, drizzled with a zesty tahini-lemon dressing.', 'admin');
     create_item('Tofu Banh Mi','Sandwiches', 'A Vietnamese sandwich with marinated tofu slices, pickled carrots and daikon, cucumber, cilantro, and spicy mayo, all tucked into a crisp baguette.', 'admin');
     create_item('Tofu Scramble','Breakfast', 'Crumbled tofu sautéed with turmeric, onions, bell peppers, and spinach, mimicking scrambled eggs. Served hot with toast or breakfast potatoes.', 'admin');
     create_item('Tofu Katsu Curry','Vegetarian', 'Breaded and fried tofu cutlets served over steamed rice and topped with a rich Japanese curry sauce made from onions, carrots, potatoes, and mild spices.', 'admin');
     create_item('Tofu Lettuce Wraps','Appetizers', 'Crispy tofu crumbles stir-fried with water chestnuts, mushrooms, and hoisin sauce, served in crisp lettuce cups and garnished with scallions and sesame seeds.', 'admin');
     create_item('Tofu Pho','Soups', 'A fragrant Vietnamese noodle soup with rice noodles, silken tofu, bean sprouts, fresh herbs, and a savory, aromatic broth infused with star anise and cinnamon.', 'admin');
     create_item('Tofu and Vegetable Skewers','Vegetarian', 'Marinated tofu cubes and colorful vegetables threaded onto skewers and grilled until lightly charred. Served with a tangy peanut dipping sauce.', 'admin');
     create_item('Tofu Enchiladas','Vegan', 'Corn tortillas filled with sautéed tofu, black beans, and vegetables, rolled and baked in a spicy enchilada sauce. Topped with vegan cheese and fresh cilantro.', 'admin');
     create_item('Tofu Poke Bowl','Salads', 'Cubed tofu marinated in soy sauce and sesame oil, served over sushi rice with edamame, avocado, cucumber, seaweed salad, and pickled ginger.', 'admin');
     create_item('Tofu Lasagna','Vegan', 'Layers of pasta, tofu ricotta, spinach, and marinara sauce baked until bubbly and golden. A hearty, dairy-free take on the Italian classic.', 'admin');
     create_item('Tofu and Broccoli Stir-Fry','Vegetarian', 'Tofu cubes and crisp broccoli florets stir-fried in a savory garlic-ginger sauce, finished with toasted sesame seeds. Served with steamed jasmine rice.', 'admin');
     create_item('Tofu Satay','Appetizers', 'Grilled skewers of marinated tofu served with a creamy, spicy peanut sauce and a side of cucumber salad for a Southeast Asian-inspired appetizer.', 'admin');
     create_item('Tofu Miso Soup','Soups', 'A light Japanese soup with silken tofu cubes, wakame seaweed, and scallions in a savory miso broth. Served hot as a comforting starter.', 'admin');
     create_item('Tofu Burrito','Sandwiches', 'A large flour tortilla filled with seasoned tofu, black beans, rice, sautéed peppers, onions, and salsa. Rolled up and grilled for a satisfying, plant-based meal.', 'admin');
     create_item('Tofu and Spinach Quiche','Breakfast', 'A savory, eggless quiche made with blended tofu, sautéed spinach, onions, and herbs in a flaky pastry crust. Baked until golden and set.', 'admin');
     create_item('Tofu Coconut Curry','Vegetarian', 'Tofu cubes simmered in a creamy coconut milk curry with bell peppers, snap peas, and carrots. Flavored with ginger, garlic, and lemongrass, served over jasmine rice.', 'admin');
     create_item('Tofu Sushi Rolls','Pizzas', 'Nori rolls filled with seasoned sushi rice, marinated tofu strips, avocado, cucumber, and carrots. Served with soy sauce, pickled ginger, and wasabi.', 'admin');
     create_item('Tofu Parmigiana','Vegan', 'Breaded tofu slices baked with marinara sauce and vegan mozzarella, served over spaghetti for a plant-based twist on the Italian-American favorite.', 'admin');
     create_item('Tofu and Eggplant Stir-Fry','Vegetarian', 'Tofu and tender eggplant pieces stir-fried with garlic, ginger, and a sweet-spicy soy sauce. Served with steamed rice and garnished with scallions.', 'admin');
     create_item('Tofu Caesar Salad','Salads', 'Crisp romaine lettuce tossed with creamy vegan Caesar dressing, crunchy croutons, and grilled tofu strips. Finished with a sprinkle of vegan parmesan.', 'admin');
     create_item('Tofu and Kimchi Stew','Soups', 'A spicy Korean jjigae with tofu cubes, kimchi, mushrooms, and scallions simmered in a rich, flavorful broth. Served bubbling hot with steamed rice.', 'admin');
     create_item('Tofu Piccata','Vegan', 'Pan-seared tofu cutlets in a tangy lemon-caper sauce, served with sautéed spinach and roasted potatoes for a Mediterranean-inspired entrée.', 'admin');
     create_item('Tofu and Vegetable Tempura','Appetizers', 'Lightly battered tofu and assorted vegetables fried until crisp and golden. Served with a soy-based dipping sauce for a crunchy appetizer.', 'admin');
     create_item('Tofu and Pea Risotto','Vegan', 'Creamy Arborio rice risotto with tender peas and pan-seared tofu cubes, finished with fresh herbs and a drizzle of olive oil.', 'admin');
     create_item('Tofu and Sweet Potato Curry','Vegetarian', 'Tofu and sweet potato chunks simmered in a fragrant curry sauce with coconut milk, ginger, and spices. Served with steamed basmati rice.', 'admin');
     create_item('Tofu and Mushroom Stroganoff','Vegan', 'Sautéed tofu and mushrooms in a creamy, dairy-free stroganoff sauce with onions, garlic, and paprika. Served over egg-free noodles or rice.', 'admin');
     create_item('Tofu and Kale Power Bowl','Salads', 'A wholesome bowl with marinated tofu, massaged kale, roasted chickpeas, quinoa, shredded carrots, and a lemon-tahini dressing.', 'admin');
     create_item('Tofu and Pineapple Fried Rice','Pastas', 'Stir-fried jasmine rice with tofu cubes, sweet pineapple, peas, carrots, and cashews in a savory soy sauce. Garnished with scallions and cilantro.', 'admin');
     create_item('Tofu and Avocado Wrap','Sandwiches', 'A soft tortilla filled with grilled tofu, creamy avocado, mixed greens, shredded carrots, and a zesty lime dressing. Rolled up for a fresh, portable meal.', 'admin');
     create_item('Tofu and Black Bean Chili','Vegan', 'A hearty chili with crumbled tofu, black beans, tomatoes, bell peppers, and smoky spices. Simmered until thick and served with cornbread.', 'admin');
     create_item('Tofu and Zucchini Noodle Bowl','Salads', 'Spiralized zucchini noodles tossed with baked tofu, cherry tomatoes, olives, and a basil-pesto dressing for a light, gluten-free meal.', 'admin');
     create_item('Tofu and Peanut Noodles','Pastas', 'Rice noodles tossed with crispy tofu, shredded vegetables, and a creamy peanut sauce. Topped with chopped peanuts and fresh cilantro.', 'admin');
     create_item('Tofu and Mango Salad','Salads', 'Mixed greens topped with grilled tofu, juicy mango slices, red bell pepper, and a tangy chili-lime vinaigrette. Finished with toasted sesame seeds.', 'admin');
     create_item('Tofu and Lentil Shepherd''s Pie','Vegan', 'A comforting casserole with a savory tofu and lentil filling, topped with creamy mashed potatoes and baked until golden.', 'admin');
     create_item('Tofu and Tomato Shakshuka','Breakfast', 'A North African-inspired breakfast with tofu cubes simmered in a spicy tomato and bell pepper sauce, seasoned with cumin and paprika. Served with crusty bread.', 'admin');
     create_item('Tofu and Vegetable Paella','Vegan', 'A Spanish-style rice dish with saffron-infused rice, tofu cubes, bell peppers, peas, and artichoke hearts. Cooked until golden and aromatic.', 'admin');
     create_item('Tofu and Broccoli Alfredo','Vegan', 'Pasta tossed in a creamy, dairy-free Alfredo sauce made from blended tofu and cashews, with steamed broccoli florets and cracked black pepper.', 'admin');
     create_item('Vegetarian Chili','Vegetarian', 'Hearty chili made with a variety of beans, tomatoes, bell peppers, corn, and spices. Slow-cooked for rich flavor and served with cornbread or rice.', 'admin');
     create_item('Vegan Tacos','Vegan', 'Soft corn tortillas filled with seasoned lentils, sautéed vegetables, fresh salsa, and creamy avocado. Topped with cilantro and lime for a flavorful vegan meal.', 'admin');
     create_item('Quinoa Salad','Vegan', 'A protein-rich salad with fluffy quinoa, diced vegetables, fresh herbs, and a lemony vinaigrette. Light, nutritious, and perfect for a healthy lunch.', 'admin');
     create_item('Vegan Pad Thai','Vegan', 'Rice noodles stir-fried with tofu, bean sprouts, scallions, and peanuts in a tangy tamarind-peanut sauce. Garnished with lime wedges and cilantro.', 'admin');
     create_item('Vegan Lasagna','Vegan', 'Layers of pasta, roasted vegetables, and vegan cheese, baked in a rich tomato sauce until bubbly and golden. A comforting, plant-based twist on a classic.', 'admin');
     create_item('Chickpea Burger','Vegan', 'A flavorful burger patty made from mashed chickpeas, herbs, and spices, grilled and served on a bun with lettuce, tomato, and vegan mayo.', 'admin');
     create_item('Gluten-Free Pizza','Gluten-Free', 'Pizza made with a gluten-free crust, topped with tomato sauce, mozzarella cheese, and your choice of toppings. Baked until crisp and golden.', 'admin');
     create_item('Gluten-Free Brownie','Gluten-Free', 'Fudgy chocolate brownie made without gluten, featuring rich cocoa flavor and a moist, chewy texture. Perfect for gluten-sensitive dessert lovers.', 'admin');
     create_item('Gluten-Free Bread','Gluten-Free', 'Freshly baked bread made from gluten-free flours, with a soft crumb and golden crust. Ideal for sandwiches or toast.', 'admin');
     create_item('Gluten-Free Pancakes','Gluten-Free', 'Fluffy pancakes made with gluten-free flour, served hot with maple syrup and fresh fruit. Light, airy, and perfect for breakfast.', 'admin');
     create_item('Gluten-Free Muffin','Gluten-Free', 'Moist blueberry muffin made without gluten, bursting with juicy berries and topped with a crunchy streusel. Great for breakfast or snacking.', 'admin');
     create_item('Pancakes','Breakfast', 'Stack of fluffy pancakes made from scratch, served with butter and warm maple syrup. Optionally topped with fresh fruit or whipped cream.', 'admin');
     create_item('French Toast','Breakfast', 'Slices of bread soaked in a cinnamon-vanilla egg mixture, pan-fried until golden, and served with powdered sugar, syrup, and fresh berries.', 'admin');
     create_item('Breakfast Burrito','Breakfast', 'A large flour tortilla filled with scrambled eggs, cheese, sausage or bacon, potatoes, and salsa. Rolled up and served hot for a hearty breakfast.', 'admin');
     create_item('Avocado Toast','Breakfast', 'Toasted artisan bread topped with smashed ripe avocado, a sprinkle of sea salt, cracked black pepper, and optional toppings like poached eggs or tomatoes.', 'admin');
     create_item('Eggs Benedict','Breakfast', 'Poached eggs and Canadian bacon layered on toasted English muffin halves, topped with rich, velvety hollandaise sauce. Served with breakfast potatoes.', 'admin');
     create_item('Fruit Salad','Salads', 'A colorful medley of fresh seasonal fruits such as melon, berries, grapes, and citrus, cut into bite-sized pieces and lightly tossed in a citrus-honey dressing.', 'admin');
     create_item('Caesar Wrap','Sandwiches', 'Grilled chicken, crisp romaine lettuce, parmesan cheese, and creamy Caesar dressing wrapped in a soft tortilla. Served with a side of chips or salad.', 'admin');
     create_item('Tomato Soup','Soups', 'Classic creamy tomato soup made from ripe tomatoes, onions, garlic, and herbs, simmered and blended until smooth. Served hot with a swirl of cream.', 'admin');
     create_item('Chicken Noodle Soup','Soups', 'Comforting soup with tender chicken pieces, egg noodles, carrots, celery, and onions, simmered in a savory broth and seasoned with herbs.', 'admin');
     create_item('Beef Stew','Soups', 'Hearty stew with chunks of beef, potatoes, carrots, and onions, slow-cooked in a rich, savory broth until the meat is tender and the flavors are deep.', 'admin');
     create_item('Miso Soup','Soups', 'Traditional Japanese soup with a savory miso broth, soft tofu cubes, seaweed, and scallions. Light, warming, and perfect as a starter.', 'admin');
     create_item('Pumpkin Soup','Soups', 'Creamy soup made from roasted pumpkin, onions, garlic, and warming spices, blended until smooth and finished with a swirl of cream and toasted seeds.', 'admin');
     create_item('Garden Salad','Salads', 'A fresh mix of leafy greens, cherry tomatoes, cucumber, carrots, and red onion, tossed in your choice of dressing. A classic, crisp starter.', 'admin');
     create_item('Cobb Salad','Salads', 'A hearty salad with rows of grilled chicken, crispy bacon, hard-boiled egg, avocado, blue cheese, tomatoes, and romaine lettuce, served with ranch or vinaigrette.', 'admin');
     create_item('Asian Chicken Salad','Salads', 'Grilled chicken breast served over mixed greens, shredded cabbage, carrots, mandarin oranges, and crispy wonton strips, tossed in a sesame-ginger dressing.', 'admin');
     create_item('Waldorf Salad','Salads', 'A classic salad with crisp apples, celery, grapes, and toasted walnuts, all tossed in a creamy mayonnaise dressing and served on a bed of lettuce.', 'admin');
     create_item('Potato Salad','Salads', 'Creamy potato salad made with tender potatoes, hard-boiled eggs, celery, onions, and fresh herbs, all tossed in a tangy mayonnaise-mustard dressing.', 'admin');
     create_item('Lemonade','Beverages', 'Refreshing beverage made from freshly squeezed lemons, pure cane sugar, and cold water, served over ice with a slice of lemon.', 'admin');
     create_item('Espresso','Beverages', 'A strong, concentrated shot of Italian coffee brewed under pressure, served in a small cup. Rich, bold, and aromatic.', 'admin');
     create_item('Cappuccino','Beverages', 'Classic Italian coffee drink with equal parts espresso, steamed milk, and frothy milk foam. Served hot and dusted with cocoa powder.', 'admin');
     create_item('Herbal Tea','Beverages', 'Caffeine-free tea brewed from a blend of dried herbs, flowers, and fruits. Served hot or iced, with a variety of flavors available.', 'admin');
     create_item('Smoothie','Beverages', 'A thick, blended beverage made from fresh fruit, yogurt, and juice or milk. Served chilled and packed with vitamins and flavor.', 'admin');
     create_item('Chocolate Mousse','Desserts', 'Light and airy chocolate dessert made from whipped cream and rich chocolate, chilled until set and served in individual cups. Garnished with chocolate shavings.', 'admin');
     create_item('Apple Pie','Desserts', 'Classic American dessert with a flaky pastry crust filled with spiced apples, baked until golden and served warm with a scoop of vanilla ice cream.', 'admin');
     create_item('Fruit Tart','Desserts', 'Buttery tart shell filled with smooth pastry cream and topped with an array of fresh seasonal fruits. Glazed for a beautiful, glossy finish.', 'admin');
     create_item('Panna Cotta','Desserts', 'Silky Italian dessert made from sweetened cream set with gelatin, served chilled and topped with fresh berries or fruit coulis.', 'admin');
     create_item('Chicken Parmesan','Main Courses', 'Breaded chicken breast fried until golden, topped with marinara sauce and melted mozzarella and parmesan cheeses, then baked. Served with pasta.', 'admin');
     create_item('Beef Stroganoff','Main Courses', 'Tender strips of beef sautéed with onions and mushrooms in a creamy sour cream sauce, served over egg noodles or rice for a comforting meal.', 'admin');
     create_item('Roast Chicken','Main Courses', 'Whole chicken seasoned with herbs and spices, roasted until the skin is crispy and the meat is juicy. Served with roasted vegetables and pan gravy.', 'admin');
     create_item('Pork Chops','Main Courses', 'Grilled pork chops seasoned with salt, pepper, and herbs, served with a side of apple sauce and roasted potatoes or vegetables.', 'admin');
     create_item('Lamb Shank','Main Courses', 'Braised lamb shank slow-cooked in red wine, garlic, and aromatic herbs until tender, served with creamy mashed potatoes and seasonal vegetables.', 'admin');
     create_item('Grilled Vegetable Platter','Vegetarian', 'A colorful assortment of seasonal vegetables such as zucchini, bell peppers, eggplant, and asparagus, marinated in olive oil, garlic, and herbs, then grilled to perfection. Served warm and garnished with fresh herbs and a drizzle of balsamic reduction.', 'admin');
     create_item('Falafel Wrap','Vegan', 'Crispy chickpea falafel balls wrapped in soft pita bread, layered with fresh lettuce, tomatoes, cucumbers, pickled onions, and drizzled with creamy tahini sauce. Served with a side of tangy yogurt dip and lemon wedges.', 'admin');
     create_item('Egg Salad Sandwich','Sandwiches', 'A classic sandwich featuring creamy egg salad made with chopped hard-boiled eggs, mayonnaise, Dijon mustard, celery, and chives, served on whole wheat bread with crisp lettuce leaves. Perfect for a light lunch or snack.', 'admin');
     create_item('Tuna Melt','Sandwiches', 'A comforting sandwich with savory tuna salad (tuna, mayonnaise, celery, and onions) piled onto toasted bread, topped with slices of ripe tomato and melted cheddar cheese. Grilled until golden and served hot.', 'admin');
     create_item('Chicken Quesadilla','Sandwiches', 'A grilled flour tortilla filled with seasoned grilled chicken, melted Monterey Jack and cheddar cheeses, sautéed peppers, and onions. Served with sides of salsa, sour cream, and guacamole for dipping.', 'admin');
     create_item('Veggie Pizza','Pizzas', 'A hand-tossed pizza crust topped with tangy tomato sauce, mozzarella cheese, and a medley of fresh vegetables such as bell peppers, mushrooms, onions, olives, and spinach. Baked until the crust is crisp and the cheese is bubbly.', 'admin');
     create_item('Sausage Pizza','Pizzas', 'A hearty pizza featuring Italian sausage crumbles, roasted red and green peppers, onions, mozzarella cheese, and a robust tomato sauce on a traditional pizza crust. Finished with a sprinkle of oregano.', 'admin');
     create_item('Chicken Pesto Pizza','Pizzas', 'A gourmet pizza with a base of basil pesto sauce, topped with grilled chicken breast slices, sun-dried tomatoes, mozzarella, and parmesan cheese. Baked until golden and garnished with fresh basil.', 'admin');
     create_item('Ravioli','Pastas', 'Tender pasta pockets stuffed with a creamy blend of ricotta cheese and spinach, gently simmered and served with a rich tomato basil sauce. Finished with a sprinkle of parmesan and fresh herbs.', 'admin');
     create_item('Gnocchi','Pastas', 'Soft, pillowy potato dumplings tossed in a savory tomato sauce with garlic, basil, and a touch of olive oil. Served hot and topped with grated parmesan cheese and cracked black pepper.', 'admin');
     create_item('Seafood Linguine','Seafood', 'Linguine pasta tossed with a medley of fresh seafood including shrimp, scallops, and mussels, sautéed in a white wine, garlic, and tomato sauce. Finished with parsley and a squeeze of lemon.', 'admin');
     create_item('Grilled Shrimp Skewers','Seafood', 'Juicy shrimp marinated in garlic, lemon, and herbs, threaded onto skewers with colorful bell peppers, onions, and cherry tomatoes, then grilled until lightly charred. Served with a zesty dipping sauce.', 'admin');
     create_item('Vegetable Samosa','Appetizers', 'A crispy, golden-fried pastry triangle stuffed with a savory mixture of spiced potatoes, peas, carrots, and aromatic Indian spices. Served hot with tangy tamarind chutney and cooling mint yogurt sauce.', 'admin');
     create_item('Onion Rings','Appetizers', 'Thick slices of sweet onion dipped in a seasoned batter, then deep-fried until crunchy and golden brown. Served as a classic appetizer with a side of zesty dipping sauce or ketchup.', 'admin');
     create_item('Chicken Satay','Appetizers', 'Tender strips of marinated chicken skewered and grilled over an open flame, served with a creamy, spicy peanut sauce and a side of cucumber salad for a flavorful Southeast Asian starter.', 'admin');
     create_item('Greek Yogurt Parfait','Desserts', 'Layers of rich, creamy Greek yogurt alternated with fresh seasonal fruit, crunchy granola, and a drizzle of honey. Served in a tall glass for a refreshing and nutritious dessert or breakfast.', 'admin');
     create_item('Berry Smoothie Bowl','Desserts', 'A thick, vibrant smoothie made from blended berries, banana, and yogurt, poured into a bowl and topped with fresh berries, sliced fruit, crunchy seeds, and a sprinkle of granola for added texture.', 'admin');
     create_item('Matcha Latte','Beverages', 'A soothing beverage made by whisking finely ground Japanese matcha green tea powder with steamed milk, creating a creamy, frothy drink with a vibrant green color and earthy, slightly sweet flavor.', 'admin');
     create_item('Hot Chocolate','Beverages', 'A decadent drink made from rich cocoa powder and steamed milk, sweetened to perfection and topped with a generous swirl of whipped cream and chocolate shavings. Perfect for warming up on a chilly day.', 'admin');
     create_item('Iced Tea','Beverages', 'Refreshing black tea brewed and chilled over ice, served with a slice of lemon and a touch of sweetness. A classic, thirst-quenching beverage ideal for hot weather.', 'admin');
     create_item('Breakfast Sandwich','Breakfast', 'A hearty morning sandwich featuring a freshly cooked egg, melted cheese, and crispy bacon layered on a toasted English muffin. Served hot and perfect for a grab-and-go breakfast.', 'admin');
     create_item('Bagel with Cream Cheese','Breakfast', 'A freshly toasted bagel, crisp on the outside and chewy inside, generously spread with smooth, tangy cream cheese. Often served plain or with toppings like smoked salmon, capers, or sliced tomatoes for a classic breakfast treat.', 'admin');
     create_item('Huevos Rancheros','Breakfast', 'A traditional Mexican breakfast dish featuring fried eggs served on lightly fried corn tortillas, topped with a savory tomato-chili sauce, refried beans, avocado slices, and crumbled cheese. Garnished with cilantro and often accompanied by rice.', 'admin');
     create_item('Shakshuka','Breakfast', 'A North African and Middle Eastern breakfast of eggs poached in a spicy, aromatic tomato and bell pepper sauce, seasoned with cumin, paprika, and garlic. Served hot in a skillet, often with crusty bread for dipping.', 'admin');
     create_item('Baklava','Desserts', 'A rich, sweet pastry made of layers of flaky phyllo dough filled with finely chopped nuts, such as pistachios or walnuts, and sweetened with honey or syrup. Finished with a fragrant hint of cinnamon or clove and cut into diamond shapes.', 'admin');
     create_item('Cannoli','Desserts', 'A classic Sicilian dessert consisting of crisp, fried pastry tubes filled with a creamy, sweetened ricotta cheese mixture, often studded with chocolate chips or candied fruit. The ends are typically dusted with powdered sugar or dipped in crushed pistachios.', 'admin');
     create_item('Crème Brûlée','Desserts', 'A decadent French dessert featuring a rich, silky vanilla custard base topped with a thin, crackly layer of caramelized sugar. Served chilled, the contrast between the creamy custard and crisp sugar topping is irresistible.', 'admin');
     create_item('Eclair','Desserts', 'A delicate French pastry made from choux dough, baked until golden and hollow, then filled with smooth pastry cream and finished with a glossy chocolate glaze. Light, airy, and indulgent.', 'admin');
     create_item('Profiteroles','Desserts', 'Small, round choux pastry puffs filled with sweet whipped cream, custard, or ice cream, and drizzled with warm chocolate sauce. Often served stacked as a dramatic dessert centerpiece.', 'admin');
     create_item('Brownie','Desserts', 'A dense, fudgy chocolate cake square with a crackly top and rich, moist interior. Sometimes studded with nuts or chocolate chips, brownies are beloved for their deep cocoa flavor and chewy texture.', 'admin');
     create_item('Lemon Tart','Desserts', 'A crisp, buttery pastry shell filled with tangy, silky lemon curd. The tart is baked until set and often finished with a dusting of powdered sugar or a swirl of whipped cream for a refreshing, zesty dessert.', 'admin');
     create_item('Rice Pudding','Desserts', 'A comforting dessert made by simmering rice in soymilk and sugar until creamy, then flavored with vanilla, cinnamon, and sometimes raisins. Served warm or chilled, often sprinkled with ground cinnamon.', 'admin');
     create_item('Bread Pudding','Desserts', 'A homey dessert made from cubes of stale bread soaked in a rich custard of eggs, milk, sugar, and spices, then baked until golden. Often includes raisins or nuts and served with a warm sauce.', 'admin');
     create_item('Banoffee Pie','Desserts', 'A British dessert pie with a buttery biscuit crust, layered with sliced bananas, luscious toffee caramel, and clouds of whipped cream. Sometimes topped with chocolate shavings for extra indulgence.', 'admin');
     create_item('Sticky Toffee Pudding','Desserts', 'A moist British sponge cake made with finely chopped dates, drenched in a warm, buttery toffee sauce. Served hot, often with vanilla ice cream or custard for a comforting finish.', 'admin');
     create_item('Peach Cobbler','Desserts', 'A classic Southern dessert featuring sweet, juicy peaches baked beneath a golden, biscuit-like topping. Served warm, often with a scoop of vanilla ice cream or whipped cream.', 'admin');
     create_item('Pecan Pie','Desserts', 'A Southern favorite with a flaky pie crust filled with a gooey, caramel-like mixture of eggs, butter, and brown sugar, generously studded with toasted pecan halves. Sweet, nutty, and rich.', 'admin');
     create_item('Pumpkin Pie','Desserts', 'A holiday staple with a flaky crust and a creamy, spiced pumpkin filling made with cinnamon, nutmeg, and cloves. Baked until set and served with a dollop of whipped cream.', 'admin');
     create_item('Key Lime Pie','Desserts', 'A tangy, creamy pie made with key lime juice, sweetened condensed milk, and egg yolks in a crisp graham cracker crust. Topped with whipped cream or meringue for a refreshing finish.', 'admin');
     create_item('Bread and Butter Pudding','Desserts', 'A British dessert of buttered bread slices layered in a dish, soaked in a sweet egg custard with raisins or currants, and baked until golden and puffed. Finished with a sprinkle of nutmeg or cinnamon.', 'admin');
     create_item('Apple Crumble','Desserts', 'Warm baked apples tossed with sugar and cinnamon, topped with a crumbly mixture of flour, butter, and brown sugar. Baked until bubbling and golden, served with custard or ice cream.', 'admin');
     create_item('Cherry Clafoutis','Desserts', 'A rustic French dessert of fresh cherries baked in a thick, flan-like batter. The result is a custardy, lightly sweet treat, dusted with powdered sugar and served warm.', 'admin');
     create_item('Chocolate Soufflé','Desserts', 'A light, airy baked dessert made with rich chocolate and whipped egg whites, resulting in a delicate, puffy texture. Served hot, often with a dusting of powdered sugar or a scoop of ice cream.', 'admin');
     create_item('Molten Lava Cake','Desserts', 'A decadent individual chocolate cake with a warm, gooey, molten chocolate center that flows out when cut. Served with vanilla ice cream or berries for a dramatic dessert.', 'admin');
     create_item('Fruit Sorbet','Desserts', 'A refreshing frozen dessert made from pureed fruit, sugar, and water, churned until smooth and icy. Dairy-free and intensely flavorful, perfect as a palate cleanser or light dessert.', 'admin');
     create_item('Gelato','Desserts', 'An Italian-style ice cream with a dense, creamy texture and intense flavor, made with less air and fat than traditional ice cream. Available in a variety of classic and creative flavors.', 'admin');
     create_item('Affogato','Desserts', 'A simple yet elegant Italian dessert where a scoop of creamy vanilla gelato is "drowned" with a shot of hot, freshly brewed espresso, creating a delightful contrast of temperatures and flavors.', 'admin');
     create_item('Semifreddo','Desserts', 'An Italian "half-frozen" dessert with a mousse-like texture, made from whipped cream, eggs, and sugar, often flavored with chocolate, fruit, or nuts. Served sliced, soft, and creamy.', 'admin');
     create_item('Tartufo','Desserts', 'An Italian frozen dessert consisting of a ball of gelato with a hidden center of fruit or syrup, coated in a chocolate shell and sometimes rolled in cocoa or nuts.', 'admin');
     create_item('Zabaglione','Desserts', 'A classic Italian custard dessert made by whisking egg yolks, sugar, and sweet wine (usually Marsala) over gentle heat until light and frothy. Served warm or chilled, sometimes with fruit.', 'admin');
     create_item('Cassata','Desserts', 'A traditional Sicilian cake made with layers of sponge cake soaked in liqueur, sweet ricotta cheese, candied fruit, and a covering of marzipan and colorful icing.', 'admin');
     create_item('Sfogliatella','Desserts', 'A shell-shaped Italian pastry with crisp, flaky layers, filled with a sweet ricotta and semolina mixture, often flavored with candied citrus and cinnamon.', 'admin');
     create_item('Pastel de Nata','Desserts', 'A Portuguese custard tart with a crisp, flaky pastry shell and a creamy, caramelized egg custard filling. Served warm, dusted with cinnamon and powdered sugar.', 'admin');
     create_item('Tres Leches Cake','Desserts', 'A light sponge cake soaked in a mixture of three milks—evaporated, condensed, and heavy cream—resulting in a moist, sweet, and creamy dessert. Topped with whipped cream and fruit.', 'admin');
     create_item('Churros','Desserts', 'Spanish fried dough pastries, crisp on the outside and soft inside, coated in cinnamon sugar and often served with a cup of thick, rich chocolate sauce for dipping.', 'admin');
     create_item('Flan','Desserts', 'A creamy caramel custard dessert with a silky texture, made from eggs, milk, and sugar, baked in a caramel-lined mold and inverted to reveal a golden caramel sauce.', 'admin');
     create_item('Dulce de Leche','Desserts', 'A luscious, sweet caramel spread made by slowly simmering milk and sugar until thick and golden. Used as a filling or topping for cakes, cookies, and pastries.', 'admin');
     create_item('Alfajores','Desserts', 'South American shortbread cookies sandwiched with a layer of dulce de leche and often rolled in coconut or dusted with powdered sugar. Tender, crumbly, and sweet.', 'admin');
     create_item('Arroz con Leche','Desserts', 'A traditional Spanish and Latin American rice pudding made by simmering rice with milk, sugar, and cinnamon until creamy. Sometimes garnished with raisins or citrus zest.', 'admin');
     create_item('Mango Sticky Rice','Desserts', 'A popular Thai dessert featuring sweet, glutinous rice cooked in coconut milk, served with ripe mango slices and drizzled with more coconut cream. Finished with a sprinkle of sesame seeds or mung beans.', 'admin');
     create_item('Halo-Halo','Desserts', 'A vibrant Filipino shaved ice dessert layered with sweetened beans, jellies, fruits, and leche flan, topped with evaporated milk and purple yam ice cream. Served in a tall glass for mixing.', 'admin');
     create_item('Bibingka','Desserts', 'A Filipino coconut rice cake baked in banana leaves, resulting in a soft, slightly chewy texture. Topped with salted egg, cheese, and grated coconut for a sweet-savory flavor.', 'admin');
     create_item('Kheer','Desserts', 'An Indian rice pudding simmered with milk, sugar, and fragrant cardamom, often garnished with slivered almonds, pistachios, and golden raisins. Served chilled or warm.', 'admin');
     create_item('Gulab Jamun','Desserts', 'Soft, deep-fried milk-based dough balls soaked in a fragrant sugar syrup flavored with rose water or cardamom. Served warm and enjoyed during celebrations.', 'admin');
     create_item('Rasgulla','Desserts', 'Spongy, soft cheese balls made from chenna (Indian cottage cheese), cooked in a light sugar syrup. A popular Bengali dessert, served chilled and syrupy.', 'admin');
     create_item('Jalebi','Desserts', 'Bright orange, spiral-shaped Indian sweets made by deep-frying fermented batter and soaking the crisp coils in saffron-infused sugar syrup. Sweet, sticky, and aromatic.', 'admin');
     create_item('Kulfi','Desserts', 'A dense, creamy Indian frozen dessert made from slowly simmered milk, flavored with cardamom, saffron, or pistachios, and molded into cones or sticks.', 'admin');
     create_item('Barfi','Desserts', 'A traditional Indian sweet made from condensed milk and sugar, cooked until thick and cut into squares. Often flavored with cardamom, nuts, or coconut, and garnished with edible silver leaf.', 'admin');
     create_item('Bakso','Desserts', 'Sweet Indonesian dessert balls made from glutinous rice flour, filled with palm sugar and sometimes coconut, boiled until chewy and served in sweet syrup.', 'admin');
     create_item('Sago Pudding','Desserts', 'A creamy pudding made from translucent tapioca pearls simmered in coconut milk and sweetened with sugar. Served chilled, sometimes with fruit or syrup.', 'admin');
     create_item('Egg Tart','Desserts', 'A delicate pastry shell filled with smooth, lightly sweetened egg custard, baked until just set. Popular in Chinese bakeries and often enjoyed with tea.', 'admin');
     create_item('Mochi','Desserts', 'A Japanese treat made from glutinous rice pounded into a chewy, elastic dough, then filled with sweet red bean paste, ice cream, or fruit. Soft, stretchy, and subtly sweet.', 'admin');
     create_item('Dorayaki','Desserts', 'A Japanese confection consisting of two fluffy, pancake-like cakes sandwiched around a sweet red bean paste filling. Soft, moist, and perfect for snacking.', 'admin');
     create_item('Taiyaki','Desserts', 'A fish-shaped Japanese cake with a crisp exterior and a sweet filling, typically red bean paste, custard, or chocolate. Popular as a street food snack.', 'admin');
     create_item('Daifuku','Desserts', 'A soft, round mochi (glutinous rice cake) stuffed with a sweet filling, usually red bean paste or fruit. Chewy and delicate, often dusted with potato starch.', 'admin');
     create_item('Yokan','Desserts', 'A traditional Japanese dessert made from red bean paste, agar, and sugar, set into a firm, sliceable jelly. Served in neat blocks, subtly sweet and smooth.', 'admin');
     create_item('Che','Desserts', 'A Vietnamese sweet dessert soup or pudding, made with a variety of ingredients such as beans, jellies, fruit, and coconut milk. Served cold or at room temperature.', 'admin');
     create_item('Bingsu','Desserts', 'A popular Korean shaved ice dessert topped with sweetened condensed milk, fruit, red beans, mochi, and sometimes ice cream. Light, refreshing, and customizable.', 'admin');
     create_item('Tteok','Desserts', 'A Korean rice cake dessert made from steamed glutinous rice flour, often filled with sweetened red bean paste or coated in powdered beans. Chewy and subtly sweet.', 'admin');
     create_item('Lamington','Desserts', 'An Australian sponge cake cut into squares, dipped in chocolate icing, and rolled in desiccated coconut. Sometimes filled with jam or cream for extra richness.', 'admin');
     create_item('Pavlova','Desserts', 'A meringue-based dessert with a crisp crust and soft, marshmallow-like center, topped with whipped cream and fresh fruit such as kiwi, strawberries, and passionfruit. Light and elegant.', 'admin');
     create_item('Anzac Biscuit','Desserts', 'A traditional Australian and New Zealand cookie made with rolled oats, coconut, golden syrup, and butter. Crisp, chewy, and with a caramelized flavor.', 'admin');
     create_item('Sticky Rice Cake','Desserts', 'A sweet Asian dessert made from glutinous rice, sometimes filled with sweet bean paste or nuts, and steamed or baked until chewy and sticky.', 'admin');
     create_item('Sacher Torte','Desserts', 'A famous Austrian chocolate cake with layers of dense chocolate sponge, apricot jam, and a smooth dark chocolate glaze. Served with unsweetened whipped cream.', 'admin');
     create_item('Linzer Torte','Desserts', 'An Austrian tart made with a buttery, nutty dough (often almonds or hazelnuts) and filled with raspberry or red currant jam, topped with a lattice crust.', 'admin');
     create_item('Dobos Torte','Desserts', 'A Hungarian cake with multiple thin layers of sponge cake and chocolate buttercream, topped with a crisp caramel layer. Elegant and rich.', 'admin');
     create_item('Kremes','Desserts', 'A Hungarian dessert consisting of layers of crisp puff pastry filled with a thick, creamy vanilla custard. Cut into squares and dusted with powdered sugar.', 'admin');
     create_item('Tufahije','Desserts', 'A Bosnian dessert of poached apples stuffed with walnuts and sugar, simmered in syrup and often topped with whipped cream. Served chilled for a refreshing treat.', 'admin');
     create_item('Knafeh','Desserts', 'A Middle Eastern dessert made with shredded phyllo dough layered with sweet cheese or semolina, baked until golden, and soaked in fragrant sugar syrup. Garnished with pistachios.', 'admin');
     create_item('Basbousa','Desserts', 'A moist, sweet semolina cake from the Middle East, soaked in simple syrup and often flavored with rose or orange blossom water. Topped with almonds or coconut.', 'admin');
     create_item('Maamoul','Desserts', 'Shortbread-like cookies from the Middle East, filled with dates, nuts, or figs, and molded into decorative shapes. Delicate, buttery, and lightly sweet.', 'admin');
     create_item('Qatayef','Desserts', 'A stuffed pancake dessert popular during Ramadan, filled with sweet cheese or nuts, folded and fried or baked, then drizzled with syrup.', 'admin');
     create_item('Chocolate Eclair','Desserts', 'A classic French pastry made from choux dough, filled with rich vanilla pastry cream and topped with a glossy chocolate glaze. Light, airy, and indulgent.', 'admin');
     create_item('Classic New York Cheesecake','Desserts', 'A rich, dense, and creamy cheesecake made with cream cheese, eggs, and sugar atop a buttery graham cracker crust. Baked to perfection and served plain or with a strawberry topping.', 'admin');
     create_item('Strawberry Swirl Cheesecake','Desserts', 'Creamy vanilla cheesecake with ribbons of sweet strawberry puree swirled throughout, baked on a crisp graham cracker crust and topped with fresh strawberries.', 'admin');
     create_item('Chocolate Marble Cheesecake','Desserts', 'A decadent cheesecake with a marbled blend of creamy vanilla and rich chocolate batters, baked on a chocolate cookie crust and finished with chocolate shavings.', 'admin');
     create_item('Lemon Ricotta Cheesecake','Desserts', 'A light and tangy cheesecake made with ricotta cheese and fresh lemon zest, baked on a buttery shortbread crust and dusted with powdered sugar.', 'admin');
     create_item('Blueberry Cheesecake','Desserts', 'Classic cheesecake topped with a vibrant blueberry compote, featuring plump, juicy berries and a hint of lemon over a crisp graham cracker base.', 'admin');
     create_item('Salted Caramel Cheesecake','Desserts', 'Ultra-creamy cheesecake layered with luscious salted caramel sauce, set on a buttery cookie crust and finished with a sprinkle of flaky sea salt.', 'admin');
     create_item('Oreo Cheesecake','Desserts', 'A cookies-and-cream lover’s dream: smooth cheesecake studded with crushed Oreo cookies, baked on a chocolate cookie crust and topped with whipped cream and more Oreos.', 'admin');
     create_item('Pumpkin Cheesecake','Desserts', 'A seasonal favorite with spiced pumpkin puree blended into creamy cheesecake, baked on a gingersnap crust and topped with cinnamon whipped cream.', 'admin');
     create_item('Raspberry White Chocolate Cheesecake','Desserts', 'Silky white chocolate cheesecake swirled with tart raspberry puree, baked on a chocolate cookie crust and garnished with fresh raspberries.', 'admin');
     create_item('Matcha Green Tea Cheesecake','Desserts', 'A Japanese-inspired cheesecake infused with earthy matcha green tea powder, creating a delicate flavor and a beautiful green hue, set on a crisp cookie crust.', 'admin');
     create_item('Mango Cheesecake','Desserts', 'Tropical mango puree blended into creamy cheesecake, layered on a coconut-graham crust and topped with a glossy mango glaze and fresh mango slices.', 'admin');
     create_item('Red Velvet Cheesecake','Desserts', 'A striking red velvet cake base topped with a layer of classic cheesecake, finished with cream cheese frosting and white chocolate curls.', 'admin');
     create_item('Turtle Cheesecake','Desserts', 'A decadent treat with a chocolate cookie crust, creamy cheesecake, and layers of gooey caramel, toasted pecans, and rich chocolate ganache.', 'admin');
     create_item('Key Lime Cheesecake','Desserts', 'A tangy, refreshing cheesecake made with key lime juice and zest, baked on a graham cracker crust and topped with whipped cream and lime slices.', 'admin');
     create_item('Espresso Cheesecake','Desserts', 'Bold espresso-infused cheesecake with a chocolate cookie crust, topped with chocolate-covered coffee beans and a dusting of cocoa powder.', 'admin');
     create_item('Dulce de Leche Cheesecake','Desserts', 'Creamy cheesecake swirled with sweet, caramel-like dulce de leche, baked on a cinnamon graham crust and finished with a drizzle of more dulce de leche.', 'admin');
     create_item('Peanut Butter Cup Cheesecake','Desserts', 'Rich peanut butter cheesecake loaded with chunks of peanut butter cups, set on a chocolate cookie crust and topped with chocolate ganache and chopped peanuts.', 'admin');
     create_item('S’mores Cheesecake','Desserts', 'A campfire-inspired cheesecake with a graham cracker crust, chocolate cheesecake filling, and a toasted marshmallow topping.', 'admin');
     create_item('Amaretto Almond Cheesecake','Desserts', 'Smooth cheesecake flavored with amaretto liqueur and almond extract, baked on an almond cookie crust and topped with toasted sliced almonds.', 'admin');
     create_item('Black Forest Cheesecake','Desserts', 'A chocolate cheesecake layered with sweet cherry compote and whipped cream, set on a chocolate cookie crust and garnished with chocolate curls and cherries.', 'admin');
     create_item('Pistachio Cheesecake','Desserts', 'Creamy cheesecake blended with roasted pistachios, set on a pistachio shortbread crust and topped with whipped cream and chopped pistachios.', 'admin');
     create_item('Baileys Irish Cream Cheesecake','Desserts', 'A luscious cheesecake infused with Baileys Irish Cream liqueur, baked on a chocolate cookie crust and topped with chocolate ganache and whipped cream.', 'admin');
     create_item('Meyer Lemon Cheesecake','Desserts', 'A bright and tangy cheesecake made with sweet Meyer lemon juice and zest, baked on a vanilla wafer crust and topped with candied lemon slices.', 'admin');
     create_item('Chocolate Hazelnut Cheesecake','Desserts', 'A decadent cheesecake swirled with chocolate hazelnut spread, set on a chocolate-hazelnut crust and topped with toasted hazelnuts and chocolate drizzle.', 'admin');
     create_item('Opera Cake','Desserts', 'A sophisticated French dessert with layers of almond sponge cake soaked in coffee syrup, coffee buttercream, and chocolate ganache, finished with a shiny chocolate glaze.', 'admin');
     create_item('Financier','Desserts', 'A small, moist French almond cake with a delicate crumb and a crisp, golden exterior. Traditionally baked in rectangular molds and enjoyed with tea or coffee.', 'admin');
     create_item('Madeleine','Desserts', 'A classic French sponge cake baked in a distinctive shell shape, with a light, buttery texture and a hint of lemon or vanilla. Perfect for dipping in tea.', 'admin');
     create_item('Clafoutis','Desserts', 'A rustic French dessert of fresh fruit, typically cherries, baked in a thick, pancake-like batter until puffed and golden. Served warm and dusted with powdered sugar.', 'admin');
     create_item('Tarte Tatin','Desserts', 'A French upside-down tart made by caramelizing apples in butter and sugar, then baking with a pastry crust. Inverted before serving to reveal glossy, tender fruit.', 'admin');
     create_item('Mont Blanc','Desserts', 'A French dessert made with sweetened chestnut puree piped over a mound of whipped cream, resembling a snow-capped mountain. Sometimes served on a crisp meringue base.', 'admin');
     create_item('Paris-Brest','Desserts', 'A ring-shaped French choux pastry filled with rich praline-flavored cream and topped with toasted almonds and powdered sugar. Created to commemorate a famous bicycle race.', 'admin');
     create_item('Rum Baba','Desserts', 'A small yeast cake soaked in rum syrup, often filled with whipped cream or pastry cream. Moist, boozy, and served as an elegant dessert.', 'admin');
     create_item('Charlotte','Desserts', 'A classic French dessert made by lining a mold with ladyfingers or sponge cake and filling it with fruit mousse, custard, or Bavarian cream. Chilled and unmolded for serving.', 'admin');
     create_item('Fruit Parfait','Desserts', 'A layered dessert of fresh fruit, creamy yogurt or custard, and crunchy granola or cake, served in a tall glass for a colorful and refreshing treat.', 'admin');
     create_item('Ice Cream Sundae','Desserts', 'A classic dessert featuring scoops of ice cream topped with sauces, whipped cream, nuts, sprinkles, and a cherry. Customizable with endless flavor and topping combinations.', 'admin');
     create_item('Frozen Yogurt','Desserts', 'A chilled dessert made from cultured yogurt, offering a tangy flavor and creamy texture. Served soft-serve style and often topped with fruit, nuts, or candy.', 'admin');
     create_item('Peanut Butter Pie','Desserts', 'A creamy, no-bake pie with a chocolate cookie crust and a rich peanut butter filling, topped with whipped cream and chocolate shavings for a sweet-salty treat.', 'admin');
     create_item('Rocky Road','Desserts', 'A chocolate confection loaded with marshmallows, roasted nuts, and sometimes dried fruit, creating a chewy, crunchy, and sweet treat. Served as bars or ice cream.', 'admin');
     create_item('Smore','Desserts', 'A campfire favorite made by sandwiching toasted marshmallow and a square of chocolate between two graham crackers. Gooey, melty, and nostalgic.', 'admin');
     create_item('Pumpkin Roll','Desserts', 'A spiced pumpkin cake baked in a thin sheet, spread with sweet cream cheese filling, and rolled into a spiral. Sliced to reveal a beautiful swirl pattern.', 'admin');
     create_item('Red Velvet Cake','Desserts', 'A striking red cocoa cake with a tender crumb, layered with tangy cream cheese frosting. Moist, slightly chocolatey, and visually stunning.', 'admin');
     create_item('Black Forest Cake','Desserts', 'A German chocolate sponge cake layered with whipped cream and cherries, soaked with cherry liqueur, and decorated with chocolate shavings and more cherries.', 'admin');
     create_item('German Chocolate Cake','Desserts', 'A layered chocolate cake filled and topped with a rich coconut-pecan frosting. Sweet, nutty, and deeply chocolatey, with a moist crumb.', 'admin');
     create_item('Boston Cream Pie','Desserts', 'A classic American dessert with layers of light sponge cake filled with smooth vanilla pastry cream and topped with a glossy chocolate ganache.', 'admin');
     create_item('Angel Food Cake','Desserts', 'A light and airy sponge cake made with whipped egg whites, sugar, and flour, known for its fluffy texture and subtle sweetness. Often served with berries or a dusting of powdered sugar.', 'admin');
     create_item('Pineapple Upside-Down Cake','Desserts', 'A moist vanilla cake baked with caramelized pineapple rings and maraschino cherries on the bottom, then inverted to reveal a glossy, fruity topping.', 'admin');
     create_item('Carrot Cake','Desserts', 'A spiced cake made with grated carrots, walnuts, and warm spices, layered with rich cream cheese frosting. Moist and flavorful, often garnished with nuts or carrot decorations.', 'admin');
     create_item('Coconut Cream Pie','Desserts', 'A flaky pie crust filled with creamy coconut custard, topped with whipped cream and toasted coconut flakes for a tropical, decadent dessert.', 'admin');
     create_item('Mississippi Mud Pie','Desserts', 'A rich chocolate pie with a crumbly cookie crust, gooey chocolate filling, and a layer of whipped cream or marshmallow topping. Named for its dense, "muddy" appearance.', 'admin');
     create_item('Chess Pie','Desserts', 'A classic Southern pie with a buttery, flaky crust and a sweet, dense custard filling made from eggs, sugar, butter, and a hint of cornmeal or vinegar.', 'admin');
     create_item('Buttermilk Pie','Desserts', 'A traditional Southern dessert featuring a creamy, tangy custard made with buttermilk, eggs, and sugar, baked in a flaky pie shell and often dusted with nutmeg.', 'admin');
     create_item('Shoofly Pie','Desserts', 'A Pennsylvania Dutch pie with a molasses-based filling, topped with a crumbly streusel. The sweet, sticky filling contrasts with the crisp crust and crumb topping.', 'admin');
     create_item('Grasshopper Pie','Desserts', 'A no-bake pie with a chocolate cookie crust and a creamy, mint-flavored filling made with crème de menthe and crème de cacao, often topped with whipped cream and chocolate shavings.', 'admin');
     create_item('Lemon Meringue Pie','Desserts', 'A tart and tangy lemon curd filling in a flaky crust, topped with a billowy, golden-brown meringue. The perfect balance of sweet and sour flavors.', 'admin');
     create_item('Chocolate Chip Cookie','Desserts', 'A classic American cookie made with buttery dough and loaded with semi-sweet chocolate chips. Crispy on the edges and chewy in the center.', 'admin');
     create_item('Snickerdoodle','Desserts', 'A soft, chewy cookie rolled in cinnamon sugar before baking, giving it a crackled surface and a warm, spicy flavor. A nostalgic favorite.', 'admin');
     create_item('Oatmeal Raisin Cookie','Desserts', 'A hearty cookie made with rolled oats, plump raisins, and a hint of cinnamon. Chewy and wholesome, often enjoyed as a comforting snack.', 'admin');
     create_item('Peanut Butter Cookie','Desserts', 'A rich, crumbly cookie with a deep peanut butter flavor, often marked with a crisscross pattern on top. Salty-sweet and satisfying.', 'admin');
     create_item('Sugar Cookie','Desserts', 'A sweet, buttery cookie with a tender crumb, perfect for decorating with icing or sprinkles. Simple yet delicious, popular for holidays and celebrations.', 'admin');


     commit;

     select count(*) into l_count
     from menu_items;
     
     dbms_output.put_line('Created ' || l_count || ' menu items');
     
     for r in (
        select mc.category_name, count(*) as menu_item_count 
        from 
            menu_categories mc 
            join menu_items mi on mc.category_id = mi.category_id
        group by mc.category_name
        order by mc.category_name) loop
            
        dbms_output.put_line(r.category_name || ':  ' || r.menu_item_count || ' items.');
        
    end loop;

EXCEPTION
     when others then
          dbms_output.put_line('Error creating menu items: ' || sqlerrm);
          rollback;
END;
/
