prompt loading menu items for category: Vegan
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
 

    c := 'Vegan';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Argentinian Vegan Empanadas~', q'~Hand pies filled with spiced lentils, onions, bell peppers, olives, and smoked paprika. Baked until golden and served with chimichurri sauce and pickled red onions.~');
create_item(c, q'~Australian Veggie Pie~', q'~A flaky pastry crust filled with lentils, carrots, peas, mushrooms, and onions in a savory gravy. Baked until golden brown and served with tomato chutney and a side salad.~');
create_item(c, q'~Belgian Endive Salad~', q'~Fresh endive leaves tossed with toasted walnuts, sliced apples, dried cranberries, and a tangy mustard vinaigrette. Garnished with chives and vegan blue cheese crumbles.~');
create_item(c, q'~Caribbean Jerk Jackfruit~', q'~Young jackfruit marinated in a fiery jerk seasoning blend of allspice, Scotch bonnet peppers, thyme, and ginger. Grilled and served with coconut rice, mango salsa, and fried plantains.~');
create_item(c, q'~Chickpea Burger~', q'~A flavorful burger patty made from mashed chickpeas, herbs, and spices, grilled and served on a bun with lettuce, tomato, and vegan mayo.~');
create_item(c, q'~Colombian Arepas~', q'~Cornmeal cakes stuffed with black beans, sautéed peppers, and vegan cheese, grilled until crispy. Served with avocado salsa and pickled red onions.~');
create_item(c, q'~Cuban Vegan Picadillo~', q'~Lentils and diced vegetables simmered with green olives, raisins, capers, and tomato sauce. Seasoned with cumin and oregano, then served with rice and sweet fried plantains.~');
create_item(c, q'~Czech Vegan Goulash~', q'~Seitan chunks stewed in a paprika-rich tomato sauce with onions, bell peppers, caraway seeds, and garlic. Served with homemade dumplings and fresh parsley.~');
create_item(c, q'~Egyptian Koshari~', q'~A layered dish of rice, lentils, macaroni, and crispy fried onions, topped with spicy tomato sauce, garlic vinegar, and chickpeas. Served with a side of pickled vegetables.~');
create_item(c, q'~Ethiopian Misir Wot~', q'~Red lentils slow-cooked in a spicy berbere sauce made from chili powder, fenugreek, ginger, garlic, and onions. Served with traditional injera flatbread, which is made from teff flour and provides a tangy complement to the stew.~');
create_item(c, q'~Falafel Wrap~', q'~Crispy chickpea falafel balls wrapped in soft pita bread, layered with fresh lettuce, tomatoes, cucumbers, pickled onions, and drizzled with creamy tahini sauce. Served with a side of tangy yogurt dip and lemon wedges.~');
create_item(c, q'~Filipino Vegan Adobo~', q'~Mushrooms and tofu braised in a tangy sauce of soy sauce, vinegar, garlic, bay leaves, and black peppercorns. Served with steamed rice and a side of pickled papaya salad.~');
create_item(c, q'~Finnish Pea Soup~', q'~A creamy split pea soup with carrots, leeks, and fresh dill, simmered until velvety. Served with rye crackers and a dollop of vegan sour cream.~');
create_item(c, q'~French Ratatouille~', q'~A rustic Provençal casserole of thinly sliced zucchini, eggplant, bell peppers, and tomatoes, layered and slow-cooked with garlic, thyme, rosemary, and olive oil. Served with crusty baguette and a drizzle of balsamic reduction.~');
create_item(c, q'~German Vegan Currywurst~', q'~Grilled seitan sausage sliced and topped with spicy curry ketchup made from tomatoes, curry powder, and smoked paprika. Served with crispy fries and tangy sauerkraut.~');
create_item(c, q'~Greek Stuffed Tomatoes~', q'~Ripe tomatoes hollowed and filled with herbed rice, toasted pine nuts, currants, and fresh mint. Baked in olive oil until tender and served with lemon wedges and a side of roasted potatoes.~');
create_item(c, q'~Hawaiian Vegan Poke Bowl~', q'~Marinated tofu cubes, seaweed salad, edamame, mango, avocado, and pickled ginger over sushi rice. Drizzled with sesame-ginger dressing and topped with crispy onions.~');
create_item(c, q'~Hungarian Paprikash~', q'~Seitan strips simmered in a rich paprika and tomato sauce with sautéed onions, bell peppers, and garlic. Served over homemade dumplings and finished with a dollop of vegan sour cream.~');
create_item(c, q'~Indian Chana Masala~', q'~Tender chickpeas simmered in a tomato-onion gravy infused with garam masala, cumin, coriander, ginger, and fresh cilantro. Finished with a squeeze of lemon and served alongside fragrant basmati rice and crispy papadum.~');
create_item(c, q'~Indonesian Tempeh Satay~', q'~Grilled tempeh skewers marinated in turmeric, coriander, and coconut milk. Served with spicy peanut sauce, cucumber salad, and rice cakes called lontong.~');
create_item(c, q'~Irish Vegan Stew~', q'~Root vegetables, mushrooms, and pearl barley simmered in a savory vegetable broth with fresh thyme, parsley, and bay leaves. Served with homemade soda bread and vegan butter.~');
create_item(c, q'~Israeli Sabich Bowl~', q'~Roasted eggplant, chickpeas, cucumber, tomato, pickled turnip, and parsley, drizzled with creamy tahini sauce and served over crispy pita chips. Finished with amba mango pickle and sumac.~');
create_item(c, q'~Italian Eggplant Caponata~', q'~Roasted eggplant, tomatoes, green olives, and capers stewed in a sweet and tangy agrodolce sauce with celery and onions. Served warm or cold with toasted ciabatta and a drizzle of extra virgin olive oil.~');
create_item(c, q'~Jamaican Callaloo Stew~', q'~Leafy callaloo greens cooked with coconut milk, okra, tomatoes, Scotch bonnet peppers, and allspice. Served with rice and peas, and garnished with fresh thyme.~');
create_item(c, q'~Japanese Vegan Ramen~', q'~A rich, umami-packed miso broth simmered with kombu and shiitake mushrooms, poured over springy ramen noodles. Topped with grilled tofu, nori strips, sautéed bok choy, scallions, corn, and a drizzle of chili oil and toasted sesame seeds.~');
create_item(c, q'~Korean Bibimbap Bowl~', q'~Steamed short-grain rice topped with sautéed spinach, shiitake mushrooms, julienned carrots, bean sprouts, and spicy gochujang-marinated tofu. Garnished with nori strips, sesame seeds, and served with kimchi.~');
create_item(c, q'~Lebanese Mujadara~', q'~A comforting dish of lentils and rice cooked with caramelized onions, cumin, and cinnamon. Topped with crispy fried shallots, fresh parsley, and served with a side of tangy cucumber-yogurt salad and pita bread.~');
create_item(c, q'~Malaysian Laksa~', q'~Rice noodles in a spicy coconut broth infused with lemongrass, galangal, and chili paste. Topped with tofu puffs, bean sprouts, fresh herbs, and a swirl of chili oil.~');
create_item(c, q'~Mexican Elote Salad~', q'~Grilled sweet corn kernels tossed with vegan mayonnaise, lime juice, smoked paprika, chili powder, and fresh cilantro. Garnished with sliced scallions, diced avocado, and a sprinkle of vegan cotija cheese.~');
create_item(c, q'~Moroccan Harira Soup~', q'~A tomato-based soup with lentils, chickpeas, vermicelli noodles, celery, and fragrant spices such as cinnamon, ginger, and turmeric. Finished with fresh cilantro and lemon wedges.~');
create_item(c, q'~Moroccan Vegetable Tagine~', q'~A slow-cooked North African stew featuring carrots, potatoes, zucchini, chickpeas, and dried apricots, simmered with aromatic spices such as cumin, cinnamon, ginger, and coriander. Finished with preserved lemon and fresh cilantro, and served over fluffy, saffron-infused couscous.~');
create_item(c, q'~Nepalese Vegan Momos~', q'~Steamed dumplings filled with cabbage, carrots, ginger, garlic, and scallions. Served with spicy tomato-sesame chutney and a side of pickled radish salad.~');
create_item(c, q'~Pakistani Aloo Gobi~', q'~Potatoes and cauliflower cooked with tomatoes, ginger, cumin, turmeric, and garam masala. Garnished with fresh cilantro and served with warm naan and tangy mango chutney.~');
create_item(c, q'~Persian Herb Kuku~', q'~A baked frittata made from a blend of fresh parsley, cilantro, dill, scallions, and chickpea flour. Seasoned with turmeric and black pepper, then served with pickled vegetables and warm lavash bread.~');
create_item(c, q'~Peruvian Quinoa Chaufa~', q'~Stir-fried quinoa with bell peppers, scallions, carrots, and marinated tofu, seasoned with soy sauce, ginger, and a touch of sesame oil. Served with lime wedges and fresh cilantro.~');
create_item(c, q'~Polish Vegan Pierogi~', q'~Handmade dumplings filled with mashed potatoes, sautéed onions, and wild mushrooms. Boiled and pan-fried until golden, then served with vegan sour cream and chive oil.~');
create_item(c, q'~Quinoa Salad~', q'~A protein-rich salad with fluffy quinoa, diced vegetables, fresh herbs, and a lemony vinaigrette. Light, nutritious, and perfect for a healthy lunch.~');
create_item(c, q'~Russian Mushroom Stroganoff~', q'~Sautéed cremini and porcini mushrooms with onions and garlic, simmered in a creamy cashew sauce flavored with paprika and Dijon mustard. Served over egg-free noodles and garnished with fresh dill.~');
create_item(c, q'~Seitan Fajitas~', q'~Sizzling seitan strips marinated in smoky spices, grilled with onions and peppers, and served with warm flour tortillas, guacamole, salsa, and lime wedges.~');
create_item(c, q'~Seitan Pad Thai~', q'~Rice noodles stir-fried with seitan strips, bean sprouts, scallions, and peanuts in a tangy tamarind sauce. Garnished with lime wedges and cilantro.~');
create_item(c, q'~Seitan Piccata~', q'~Pan-seared seitan cutlets in a tangy lemon-caper sauce, served with sautéed spinach and roasted potatoes for a Mediterranean-inspired entrée.~');
create_item(c, q'~Seitan Tacos~', q'~Soft corn tortillas filled with seasoned seitan, shredded lettuce, pico de gallo, avocado, and a drizzle of chipotle crema.~');
create_item(c, q'~Seitan and Mushroom Stroganoff~', q'~Sautéed seitan and mushrooms in a creamy, dairy-free stroganoff sauce with onions, garlic, and paprika. Served over egg-free noodles or rice.~');
create_item(c, q'~Seitan and Spinach Lasagna~', q'~Layers of pasta, seitan crumbles, sautéed spinach, marinara sauce, and vegan cheese, baked until bubbly and golden.~');
create_item(c, q'~Spanish Gazpacho~', q'~A refreshing chilled soup of ripe tomatoes, cucumber, bell pepper, garlic, and olive oil, blended until smooth. Garnished with diced vegetables, croutons, and a drizzle of sherry vinegar.~');
create_item(c, q'~Sri Lankan Jackfruit Curry~', q'~Tender jackfruit chunks simmered in coconut milk with curry leaves, mustard seeds, turmeric, and cinnamon. Served with red rice, coconut sambal, and lime wedges.~');
create_item(c, q'~Swiss Rösti~', q'~Crispy shredded potato pancake topped with sautéed wild mushrooms, spinach, and melted vegan cheese. Served with apple compote and a sprinkle of fresh chives.~');
create_item(c, q'~Syrian Fattet Hummus~', q'~Layers of toasted pita chips, creamy hummus, chickpeas, and pine nuts, drizzled with lemon-tahini sauce and extra virgin olive oil. Finished with fresh parsley and sumac.~');
create_item(c, q'~Thai Green Curry~', q'~A fragrant coconut milk curry made with homemade green curry paste, including lemongrass, galangal, kaffir lime leaves, and green chilies. Tofu, bamboo shoots, Japanese eggplant, and bell peppers are simmered until tender, then finished with Thai basil and served with jasmine rice.~');
create_item(c, q'~Tofu Enchiladas~', q'~Corn tortillas filled with sautéed tofu, black beans, and vegetables, rolled and baked in a spicy enchilada sauce. Topped with vegan cheese and fresh cilantro.~');
create_item(c, q'~Tofu Lasagna~', q'~Layers of pasta, tofu ricotta, spinach, and marinara sauce baked until bubbly and golden. A hearty, dairy-free take on the Italian classic.~');
create_item(c, q'~Tofu Pad Thai~', q'~Rice noodles stir-fried with crispy tofu, bean sprouts, scallions, and peanuts in a tangy tamarind sauce. Garnished with lime wedges and fresh cilantro for a vibrant, plant-based twist on the Thai favorite.~');
create_item(c, q'~Tofu Parmigiana~', q'~Breaded tofu slices baked with marinara sauce and vegan mozzarella, served over spaghetti for a plant-based twist on the Italian-American favorite.~');
create_item(c, q'~Tofu Piccata~', q'~Pan-seared tofu cutlets in a tangy lemon-caper sauce, served with sautéed spinach and roasted potatoes for a Mediterranean-inspired entrée.~');
create_item(c, q'~Tofu and Black Bean Chili~', q'~A hearty chili with crumbled tofu, black beans, tomatoes, bell peppers, and smoky spices. Simmered until thick and served with cornbread.~');
create_item(c, q'~Tofu and Broccoli Alfredo~', q'~Pasta tossed in a creamy, dairy-free Alfredo sauce made from blended tofu and cashews, with steamed broccoli florets and cracked black pepper.~');
create_item(c, q'~Tofu and Lentil Shepherd's Pie~', q'~A comforting casserole with a savory tofu and lentil filling, topped with creamy mashed potatoes and baked until golden.~');
create_item(c, q'~Tofu and Mushroom Stroganoff~', q'~Sautéed tofu and mushrooms in a creamy, dairy-free stroganoff sauce with onions, garlic, and paprika. Served over egg-free noodles or rice.~');
create_item(c, q'~Tofu and Pea Risotto~', q'~Creamy Arborio rice risotto with tender peas and pan-seared tofu cubes, finished with fresh herbs and a drizzle of olive oil.~');
create_item(c, q'~Tofu and Vegetable Paella~', q'~A Spanish-style rice dish with saffron-infused rice, tofu cubes, bell peppers, peas, and artichoke hearts. Cooked until golden and aromatic.~');
create_item(c, q'~Tunisian Couscous~', q'~Steamed couscous topped with roasted carrots, zucchini, chickpeas, and spicy harissa sauce. Garnished with preserved lemon, olives, and fresh mint.~');
create_item(c, q'~Ukrainian Borscht~', q'~A vibrant beet soup with potatoes, cabbage, carrots, and dill, simmered in vegetable broth. Served hot with vegan sour cream, rye bread, and fresh garlic.~');
create_item(c, q'~Vegan Arepa Reina Pepiada~', q'~Cornmeal arepa filled with creamy avocado, mashed chickpeas, lime juice, cilantro, and red onion. Served with tangy cabbage slaw and hot sauce.~');
create_item(c, q'~Vegan Banh Xeo~', q'~Vietnamese crispy turmeric crepes filled with mung beans, mushrooms, bean sprouts, and scallions. Served with fresh herbs and spicy dipping sauce.~');
create_item(c, q'~Vegan Biryani~', q'~Fragrant basmati rice layered with spiced vegetables, raisins, toasted cashews, and saffron. Served with cooling cucumber raita and crispy papadum.~');
create_item(c, q'~Vegan Borscht~', q'~Beetroot soup with potatoes, carrots, cabbage, and dill, simmered in vegetable broth. Served hot with vegan sour cream, rye bread, and fresh garlic.~');
create_item(c, q'~Vegan Bulgogi~', q'~Thinly sliced seitan marinated in soy sauce, garlic, ginger, sesame oil, and pear juice. Grilled and served with kimchi, steamed rice, and scallion salad.~');
create_item(c, q'~Vegan Burger~', q'~A plant-based burger patty made from a blend of legumes, grains, and vegetables, grilled and served on a toasted bun with lettuce, tomato, onion, pickles, and vegan mayo. Accompanied by a side of crispy fries.~');
create_item(c, q'~Vegan Caldo Verde~', q'~Portuguese potato and kale soup with smoked tofu, garlic, and olive oil. Served with rustic bread and a drizzle of extra virgin olive oil.~');
create_item(c, q'~Vegan Cassoulet~', q'~French white bean stew with carrots, celery, tomatoes, and herbed seitan sausage. Slow-cooked and served with crusty bread and fresh thyme.~');
create_item(c, q'~Vegan Chakalaka~', q'~South African spicy vegetable relish with beans, tomatoes, peppers, carrots, and curry powder. Served with pap and fresh coriander.~');
create_item(c, q'~Vegan Chana Dal~', q'~Split chickpeas simmered with tomatoes, ginger, cumin, turmeric, and garlic. Served with steamed basmati rice, mango pickle, and fresh coriander.~');
create_item(c, q'~Vegan Chilaquiles~', q'~Crispy tortilla chips simmered in spicy tomato sauce, topped with tofu scramble, sliced avocado, vegan crema, and pickled jalapeños.~');
create_item(c, q'~Vegan Chili Mac~', q'~Elbow macaroni tossed with spicy vegan chili made from kidney beans, tomatoes, bell peppers, and vegan cheddar. Baked until bubbly and topped with scallions.~');
create_item(c, q'~Vegan Chraime~', q'~North African tomato stew with chickpeas, bell peppers, spicy harissa, cumin, and garlic. Served with fluffy couscous and fresh parsley.~');
create_item(c, q'~Vegan Churrasco~', q'~Grilled marinated seitan steak served with chimichurri sauce, roasted potatoes, grilled vegetables, and pickled onions.~');
create_item(c, q'~Vegan Enchiladas~', q'~Corn tortillas filled with sautéed zucchini, bell peppers, and black beans, rolled and baked in red enchilada sauce. Topped with vegan cheese, cilantro, and avocado slices.~');
create_item(c, q'~Vegan Fattoush~', q'~Levantine salad of mixed greens, tomatoes, cucumbers, radishes, and crispy pita chips, tossed in sumac-lemon dressing. Garnished with fresh mint and pomegranate seeds.~');
create_item(c, q'~Vegan Fesenjan~', q'~Persian walnut and pomegranate stew with roasted eggplant, chickpeas, and cinnamon. Served over saffron rice and garnished with pomegranate seeds and fresh parsley.~');
create_item(c, q'~Vegan Gado-Gado~', q'~Indonesian salad of steamed potatoes, green beans, cabbage, tempeh, and tofu, topped with creamy peanut sauce, crispy shallots, and prawn crackers.~');
create_item(c, q'~Vegan Goulash~', q'~Hungarian paprika stew with seitan, potatoes, carrots, bell peppers, and tomatoes. Served with rustic bread and a sprinkle of fresh parsley.~');
create_item(c, q'~Vegan Gumbo~', q'~Louisiana-style stew with okra, bell peppers, celery, smoked tofu, and tomatoes, simmered in a spicy roux. Served over rice and garnished with scallions and filé powder.~');
create_item(c, q'~Vegan Jollof Rice~', q'~West African tomato rice cooked with bell peppers, onions, Scotch bonnet peppers, and warming spices. Served with fried plantains, spicy tofu, and a side of coleslaw.~');
create_item(c, q'~Vegan Katsu Curry~', q'~Breaded tofu cutlet served over steamed rice with Japanese curry sauce made from carrots, potatoes, peas, and onions. Garnished with pickled ginger and scallions.~');
create_item(c, q'~Vegan Katsu Sando~', q'~Japanese sandwich with breaded tofu cutlet, shredded cabbage, tangy tonkatsu sauce, and vegan mayo on soft milk bread. Served with pickled daikon and carrot salad.~');
create_item(c, q'~Vegan Khao Pad~', q'~Thai fried rice with tofu, pineapple, cashews, peas, carrots, and fresh basil. Served with lime wedges and chili flakes.~');
create_item(c, q'~Vegan Khao Soi~', q'~Northern Thai coconut curry noodle soup with crispy tofu, pickled mustard greens, crunchy noodles, and shallots. Finished with lime wedges and chili oil.~');
create_item(c, q'~Vegan Kitchari~', q'~Indian rice and lentil porridge with turmeric, ginger, cumin, and seasonal vegetables. Served with mango chutney and crispy papadum.~');
create_item(c, q'~Vegan Korma~', q'~Creamy Indian curry with cashews, coconut milk, mixed vegetables, cardamom, cinnamon, and warming spices. Served with basmati rice and naan bread.~');
create_item(c, q'~Vegan Koshari~', q'~Egyptian rice, lentils, and pasta topped with spicy tomato sauce, crispy fried onions, and chickpeas. Served with garlic vinegar and pickled vegetables.~');
create_item(c, q'~Vegan Lablabi~', q'~Tunisian chickpea soup with garlic, cumin, harissa, and crusty bread. Garnished with olives, capers, and preserved lemon.~');
create_item(c, q'~Vegan Lasagna~', q'~Layers of pasta, roasted vegetables, and vegan cheese, baked in a rich tomato sauce until bubbly and golden. A comforting, plant-based twist on a classic.~');
create_item(c, q'~Vegan Lecsó~', q'~Hungarian pepper stew with tomatoes, onions, smoked tofu, and paprika. Served with crusty bread and pickled cucumbers.~');
create_item(c, q'~Vegan Lomo Saltado~', q'~Peruvian stir-fry of marinated tofu, onions, tomatoes, and crispy fries, tossed in soy sauce, vinegar, and aji amarillo paste. Served with steamed rice and cilantro.~');
create_item(c, q'~Vegan Moussaka~', q'~Layers of roasted eggplant, potatoes, and lentil ragout, topped with creamy cashew béchamel sauce. Baked until golden and served with a Greek salad.~');
create_item(c, q'~Vegan Okonomiyaki~', q'~Japanese savory pancake made with shredded cabbage, carrots, scallions, and flour. Pan-fried and topped with vegan mayo, sweet soy glaze, nori flakes, and pickled ginger.~');
create_item(c, q'~Vegan Pad Thai~', q'~Rice noodles stir-fried with tofu, bean sprouts, scallions, and peanuts in a tangy tamarind-peanut sauce. Garnished with lime wedges and cilantro.~');
create_item(c, q'~Vegan Paella~', q'~Saffron-infused rice cooked in a traditional paella pan with artichoke hearts, bell peppers, peas, roasted tomatoes, and smoked paprika. Garnished with lemon wedges and fresh parsley.~');
create_item(c, q'~Vegan Panzanella~', q'~Tuscan bread salad with ripe tomatoes, cucumbers, red onion, basil, and olive oil vinaigrette. Served with grilled ciabatta and balsamic glaze.~');
create_item(c, q'~Vegan Pho~', q'~Vietnamese rice noodle soup with aromatic broth made from charred onions, ginger, star anise, and cinnamon. Topped with grilled tofu, bean sprouts, Thai basil, jalapeño slices, and lime wedges.~');
create_item(c, q'~Vegan Pozole~', q'~Mexican hominy stew with mushrooms, zucchini, green chilies, and garlic. Garnished with sliced radish, shredded cabbage, lime wedges, and tostadas.~');
create_item(c, q'~Vegan Pozole Verde~', q'~Mexican hominy stew with tomatillos, poblano peppers, zucchini, and fresh cilantro. Garnished with sliced radish, shredded lettuce, and lime wedges.~');
create_item(c, q'~Vegan Rendang~', q'~Indonesian coconut curry with jackfruit, lemongrass, galangal, kaffir lime leaves, and toasted coconut. Slow-cooked for rich flavor and served with steamed rice.~');
create_item(c, q'~Vegan Saganaki~', q'~Greek pan-fried vegan cheese served with lemon wedges, Kalamata olives, grilled pita bread, and fresh oregano.~');
create_item(c, q'~Vegan Sambar~', q'~South Indian lentil stew with carrots, potatoes, eggplant, tomatoes, tamarind, and aromatic spices. Served with steamed rice, dosa, and coconut chutney.~');
create_item(c, q'~Vegan Sancocho~', q'~Colombian stew with root vegetables, corn on the cob, plantains, jackfruit, and yuca, simmered in a savory broth with cilantro and scallions. Served with rice and avocado.~');
create_item(c, q'~Vegan Shawarma~', q'~Spiced seitan strips wrapped in warm pita with lettuce, tomato, cucumber, pickled turnip, and creamy tahini sauce. Finished with sumac and fresh parsley.~');
create_item(c, q'~Vegan Shepherd’s Pie~', q'~Savory lentil and vegetable filling made with carrots, peas, and mushrooms, topped with creamy mashed potatoes. Baked until golden and served hot with gravy.~');
create_item(c, q'~Vegan Sopes~', q'~Thick corn cakes topped with refried beans, sautéed mushrooms, shredded lettuce, salsa roja, and vegan crema. Garnished with cilantro and radish slices.~');
create_item(c, q'~Vegan Souvlaki~', q'~Grilled marinated seitan skewers served with warm pita, tomato, cucumber, red onion, and creamy vegan tzatziki sauce. Finished with fresh oregano and lemon wedges.~');
create_item(c, q'~Vegan Sushi Platter~', q'~Assorted sushi rolls filled with avocado, cucumber, pickled radish, marinated tofu, and carrot. Served with wasabi, pickled ginger, and tamari dipping sauce.~');
create_item(c, q'~Vegan Tabbouleh~', q'~Fresh parsley, mint, tomatoes, cucumber, and bulgur wheat tossed in lemon-olive oil dressing. Served chilled with crisp romaine leaves and olives.~');
create_item(c, q'~Vegan Tacos~', q'~Soft corn tortillas filled with seasoned lentils, sautéed vegetables, fresh salsa, and creamy avocado. Topped with cilantro and lime for a flavorful vegan meal.~');
create_item(c, q'~Vegan Tamales~', q'~Corn masa dough filled with black beans, roasted peppers, and vegan cheese, wrapped in corn husks and steamed. Served with salsa verde and pickled jalapeños.~');
create_item(c, q'~Vegan Tikka Masala~', q'~Grilled tofu cubes simmered in a creamy tomato-cashew sauce with garam masala, ginger, fenugreek, and coriander. Served with basmati rice and garlic naan.~');
create_item(c, q'~Vegan Tom Yum Soup~', q'~A spicy and sour Thai broth with mushrooms, tofu, lemongrass, galangal, kaffir lime leaves, and chili. Garnished with cilantro, lime wedges, and sliced red chilies.~');
create_item(c, q'~Vegan Tostada~', q'~Crispy corn tortilla topped with refried black beans, shredded lettuce, pico de gallo, sliced avocado, and vegan cheese. Finished with jalapeño slices and lime wedges.~');
create_item(c, q'~Vegan Tostada de Nopal~', q'~Crispy tortilla topped with grilled cactus paddles, black beans, pico de gallo, avocado, and pickled jalapeños.~');
create_item(c, q'~Vegan Tostones~', q'~Twice-fried green plantains served with garlic-lime dipping sauce, black bean salad, and pickled red onions. Garnished with fresh cilantro.~');
create_item(c, q'~Vegan Tostones Rellenos~', q'~Stuffed fried plantains filled with black beans, avocado, salsa fresca, and pickled jalapeños. Topped with cilantro and lime crema.~');
create_item(c, q'~Vegan Tteokbokki~', q'~Chewy Korean rice cakes simmered in spicy gochujang sauce with cabbage, carrots, scallions, and mushrooms. Topped with sesame seeds and sliced nori.~');
create_item(c, q'~Vegan Tteokguk~', q'~Korean rice cake soup with mushrooms, spinach, scallions, and savory vegetable broth. Garnished with nori strips, sesame seeds, and chili flakes.~');
create_item(c, q'~Vietnamese Vegan Banh Mi~', q'~A crusty French baguette filled with marinated tofu slices, pickled carrots and daikon, cucumber, jalapeño, cilantro, and vegan sriracha mayo. Finished with a splash of soy sauce and a sprinkle of toasted sesame seeds.~');


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


    

