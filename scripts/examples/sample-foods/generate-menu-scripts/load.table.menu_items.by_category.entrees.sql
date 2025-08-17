prompt loading menu items for category: Entrees
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
 

    c := 'Entrees';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Allergy-Friendly Chickpea Curry~', q'~Chickpeas simmered in coconut milk with turmeric, ginger, and spinach. Free from nuts, gluten, and dairy. Served with brown rice.~');
create_item(c, q'~Beef Stroganoff~', q'~Tender strips of beef sautéed with onions and mushrooms in a creamy sour cream sauce, served over egg noodles or rice for a comforting meal.~');
create_item(c, q'~Brazilian Feijoada~', q'~Black bean stew with smoked pork, sausage, and beef, slow-cooked with garlic and bay leaves. Served with rice, collard greens, and orange slices.~');
create_item(c, q'~Chicken Parmesan~', q'~Breaded chicken breast fried until golden, topped with marinara sauce and melted mozzarella and parmesan cheeses, then baked. Served with pasta.~');
create_item(c, q'~Chinese Mapo Tofu~', q'~Soft tofu cubes simmered in spicy Sichuan peppercorn and chili bean sauce with minced pork and scallions. Served with steamed rice.~');
create_item(c, q'~Cuban Ropa Vieja~', q'~Shredded beef stewed with tomatoes, bell peppers, onions, and olives. Served with black beans, rice, and fried plantains.~');
create_item(c, q'~Ethiopian Doro Wat~', q'~Tender chicken drumsticks stewed in a fiery berbere spice blend, onions, garlic, and ginger. Served with injera and hard-boiled eggs.~');
create_item(c, q'~Filipino Kare-Kare~', q'~Oxtail and tripe stewed in peanut sauce with eggplant, string beans, and bok choy. Served with bagoong (fermented shrimp paste) and rice.~');
create_item(c, q'~French Duck Confit~', q'~Duck leg slow-cooked in its own fat until meltingly tender, crisped before serving. Accompanied by garlic roasted potatoes and frisée salad.~');
create_item(c, q'~German Sauerbraten~', q'~Marinated beef roast braised with vinegar, spices, and onions, served with potato dumplings and red cabbage.~');
create_item(c, q'~Gluten-Free French Coq au Vin~', q'~Chicken braised in red wine with mushrooms, pearl onions, and bacon. Served with gluten-free baguette.~');
create_item(c, q'~Gluten-Free French Ratatouille~', q'~Stewed eggplant, zucchini, bell peppers, and tomatoes, finished with fresh thyme and basil. Served with polenta.~');
create_item(c, q'~Gluten-Free Indian Butter Chicken~', q'~Chicken breast simmered in creamy tomato sauce with fenugreek and garam masala. Served with gluten-free naan.~');
create_item(c, q'~Gluten-Free Indian Chana Masala~', q'~Chickpeas simmered in tomato, onion, and garam masala sauce. Served with basmati rice and cucumber raita.~');
create_item(c, q'~Gluten-Free Indian Chicken Biryani~', q'~Basmati rice layered with spiced chicken, saffron, and fried onions. Served with gluten-free raita.~');
create_item(c, q'~Gluten-Free Indian Chicken Tikka Masala~', q'~Chicken breast grilled and simmered in creamy tomato sauce with fenugreek and garam masala. Served with gluten-free naan.~');
create_item(c, q'~Gluten-Free Indian Fish Curry~', q'~White fish fillets simmered in coconut-tomato sauce with mustard seeds and curry leaves. Served with basmati rice.~');
create_item(c, q'~Gluten-Free Indian Fish Tikka~', q'~Fish fillets marinated in spices and yogurt, grilled and served with mint chutney and lemon wedges.~');
create_item(c, q'~Gluten-Free Indian Lamb Rogan Josh~', q'~Lamb braised in aromatic tomato-yogurt sauce with Kashmiri chili and cardamom. Served with gluten-free naan.~');
create_item(c, q'~Gluten-Free Italian Chicken Piccata~', q'~Chicken breast sautéed with capers, lemon, and white wine. Served with gluten-free pasta.~');
create_item(c, q'~Gluten-Free Italian Osso Buco~', q'~Braised veal shanks in tomato-wine sauce with gremolata. Served with gluten-free risotto.~');
create_item(c, q'~Gluten-Free Italian Pollo alla Cacciatora~', q'~Chicken braised with tomatoes, olives, and rosemary. Served with gluten-free polenta.~');
create_item(c, q'~Gluten-Free Italian Risotto Milanese~', q'~Creamy Arborio rice cooked with saffron, parmesan, and white wine. Served with gluten-free breadsticks.~');
create_item(c, q'~Gluten-Free Japanese Chicken Katsu~', q'~Chicken breast coated in gluten-free panko, fried until crispy. Served with shredded cabbage and tonkatsu sauce.~');
create_item(c, q'~Gluten-Free Japanese Chicken Teriyaki~', q'~Grilled chicken glazed with gluten-free teriyaki sauce, served with steamed rice and sautéed vegetables.~');
create_item(c, q'~Gluten-Free Japanese Saba Shioyaki~', q'~Grilled mackerel seasoned with salt, served with steamed rice and pickled ginger.~');
create_item(c, q'~Gluten-Free Japanese Salmon Teriyaki~', q'~Grilled salmon fillet glazed with gluten-free teriyaki sauce, served with steamed rice and sautéed bok choy.~');
create_item(c, q'~Gluten-Free Japanese Tempura~', q'~Shrimp and vegetables battered in gluten-free rice flour, fried until crispy. Served with dipping sauce.~');
create_item(c, q'~Gluten-Free Japanese Yakitori~', q'~Chicken skewers grilled and glazed with gluten-free soy sauce, served with pickled daikon and steamed rice.~');
create_item(c, q'~Gluten-Free Mexican Chicken Enchiladas~', q'~Corn tortillas filled with shredded chicken, topped with red chile sauce and melted cheese. Served with rice and beans.~');
create_item(c, q'~Gluten-Free Mexican Chicken Mole~', q'~Chicken breast smothered in rich mole sauce made from chocolate, chilies, nuts, and spices. Served with gluten-free rice.~');
create_item(c, q'~Gluten-Free Mexican Chicken Tinga~', q'~Shredded chicken simmered in chipotle-tomato sauce, served with corn tortillas and avocado salsa.~');
create_item(c, q'~Gluten-Free Mexican Pozole~', q'~Hominy stew with chicken, radishes, cabbage, and lime. Served with gluten-free tostadas.~');
create_item(c, q'~Gluten-Free Mexican Tamales~', q'~Corn masa filled with chicken and green chile, steamed in corn husks. Served with salsa verde.~');
create_item(c, q'~Gluten-Free Moroccan Chicken with Olives~', q'~Chicken thighs braised with preserved lemon, green olives, and saffron. Served with gluten-free couscous.~');
create_item(c, q'~Gluten-Free Peruvian Quinoa Chaufa~', q'~Quinoa stir-fried with chicken, eggs, scallions, and soy sauce. Served with pickled ginger.~');
create_item(c, q'~Gluten-Free Quinoa Stuffed Peppers~', q'~Bell peppers filled with quinoa, black beans, corn, and chipotle tomato sauce, baked until tender. Served with avocado crema.~');
create_item(c, q'~Gluten-Free Thai Green Papaya Salad~', q'~Shredded green papaya tossed with lime juice, fish sauce, peanuts, and chili. Served with grilled shrimp.~');
create_item(c, q'~Gluten-Free Thai Larb Gai~', q'~Minced chicken tossed with lime juice, fish sauce, chili, and fresh herbs. Served with lettuce cups.~');
create_item(c, q'~Gluten-Free Thai Pad Krapow~', q'~Minced chicken stir-fried with holy basil, garlic, and chili. Served with jasmine rice and fried egg.~');
create_item(c, q'~Gluten-Free Thai Pad See Ew~', q'~Wide rice noodles stir-fried with tofu, Chinese broccoli, and sweet soy sauce. Served with lime wedges.~');
create_item(c, q'~Gluten-Free Thai Pad Thai~', q'~Rice noodles stir-fried with chicken, eggs, bean sprouts, and peanuts in tamarind sauce. Served with lime wedges.~');
create_item(c, q'~Gluten-Free Thai Panang Curry~', q'~Chicken simmered in coconut milk with Panang curry paste, kaffir lime, and peanuts. Served with jasmine rice.~');
create_item(c, q'~Greek Moussaka~', q'~Layers of roasted eggplant, spiced ground lamb, and creamy béchamel sauce, baked until golden. Served with a side of Greek salad.~');
create_item(c, q'~Hungarian Chicken Paprikash~', q'~Chicken thighs braised in paprika-infused sauce with onions, tomatoes, and sour cream. Served with buttered spaetzle.~');
create_item(c, q'~Indian Paneer Tikka Masala~', q'~Char-grilled paneer cubes in a creamy tomato and cashew sauce, spiced with garam masala, fenugreek, and ginger. Served with basmati rice.~');
create_item(c, q'~Indonesian Rendang~', q'~Beef slow-cooked in coconut milk, lemongrass, galangal, and a blend of aromatic spices until deeply caramelized. Served with steamed rice.~');
create_item(c, q'~Irish Beef and Guinness Stew~', q'~Tender beef chunks simmered in Guinness stout with carrots, potatoes, and onions. Served with crusty brown bread.~');
create_item(c, q'~Israeli Shakshuka~', q'~Poached eggs in a spicy tomato, bell pepper, and onion sauce, seasoned with cumin and paprika. Served with warm pita bread.~');
create_item(c, q'~Italian Eggplant Parmigiana~', q'~Breaded eggplant slices layered with marinara sauce, mozzarella, and parmesan, baked until bubbling. Served with garlic bread.~');
create_item(c, q'~Jamaican Jerk Chicken~', q'~Chicken marinated in fiery jerk spices, grilled over pimento wood. Served with rice and peas, fried plantains, and mango salsa.~');
create_item(c, q'~Japanese Okonomiyaki~', q'~Savory cabbage pancake with shrimp, pork belly, and scallions, griddled and topped with okonomiyaki sauce, mayo, bonito flakes, and nori.~');
create_item(c, q'~Korean Bibimbap~', q'~Steamed rice topped with sautéed vegetables, bulgogi beef, spicy gochujang sauce, and a fried egg. Served in a hot stone bowl.~');
create_item(c, q'~Lamb Shank~', q'~Braised lamb shank slow-cooked in red wine, garlic, and aromatic herbs until tender, served with creamy mashed potatoes and seasonal vegetables.~');
create_item(c, q'~Lebanese Kibbeh~', q'~Baked bulgur wheat and ground lamb shell stuffed with spiced minced beef, pine nuts, and onions. Served with cucumber yogurt sauce.~');
create_item(c, q'~Mexican Mole Poblano Chicken~', q'~Chicken breast smothered in rich mole sauce made from chocolate, chilies, nuts, and spices. Served with Mexican rice and corn tortillas.~');
create_item(c, q'~Moroccan Lamb Tagine~', q'~Slow-braised lamb shank simmered with apricots, almonds, preserved lemon, and aromatic spices in a traditional clay tagine. Served with fluffy couscous.~');
create_item(c, q'~Nepalese Dal Bhat~', q'~Lentil soup served with steamed rice, sautéed greens, spiced potatoes, and tomato achar. A wholesome vegetarian platter.~');
create_item(c, q'~Pakistani Nihari~', q'~Slow-cooked beef shank in a rich, aromatic gravy of ginger, garlic, and garam masala. Served with naan and lemon wedges.~');
create_item(c, q'~Peruvian Lomo Saltado~', q'~Stir-fried beef strips with onions, tomatoes, and aji amarillo, tossed with soy sauce and vinegar. Served with fries and rice.~');
create_item(c, q'~Polish Bigos~', q'~Hunter’s stew of sauerkraut, fresh cabbage, smoked sausage, pork, and mushrooms, slow-cooked with bay leaves and juniper berries.~');
create_item(c, q'~Pork Chops~', q'~Grilled pork chops seasoned with salt, pepper, and herbs, served with a side of apple sauce and roasted potatoes or vegetables.~');
create_item(c, q'~Puerto Rican Pernil~', q'~Slow-roasted pork shoulder marinated in garlic, oregano, and citrus, cooked until crispy. Served with arroz con gandules and tostones.~');
create_item(c, q'~Roast Chicken~', q'~Whole chicken seasoned with herbs and spices, roasted until the skin is crispy and the meat is juicy. Served with roasted vegetables and pan gravy.~');
create_item(c, q'~Russian Beef Stroganoff~', q'~Sautéed beef strips in a rich sour cream and mushroom sauce, finished with dill. Served over buttered egg noodles.~');
create_item(c, q'~Seitan Pot Roast~', q'~Slow-cooked seitan roast with potatoes, carrots, onions, and celery in a savory herb gravy. Served hot for a comforting, hearty meal.~');
create_item(c, q'~Seitan Schnitzel~', q'~Breaded and pan-fried seitan cutlets with a golden, crispy crust. Served with lemon wedges, potato salad, and a side of tangy mustard sauce.~');
create_item(c, q'~Seitan Wellington~', q'~A savory seitan loaf wrapped in flaky puff pastry with mushroom duxelles and spinach, baked until golden. Served with a rich red wine gravy.~');
create_item(c, q'~Singaporean Chili Crab~', q'~Whole crab stir-fried in spicy tomato-chili sauce with garlic and ginger. Served with steamed mantou buns.~');
create_item(c, q'~South African Bobotie~', q'~Spiced ground beef baked with a golden egg custard topping, flavored with curry, raisins, and almonds. Served with yellow rice.~');
create_item(c, q'~Spanish Paella Valenciana~', q'~Saffron-infused rice cooked with chicken, rabbit, green beans, snails, and rosemary. Served in a traditional paella pan.~');
create_item(c, q'~Sri Lankan Fish Ambul Thiyal~', q'~Tuna cubes cooked in a tangy blend of goraka, black pepper, turmeric, and curry leaves. Served with red rice and coconut sambol.~');
create_item(c, q'~Swedish Gravlax Salad~', q'~House-cured salmon with dill, served over baby greens, pickled beets, and horseradish cream. Accompanied by rye toast.~');
create_item(c, q'~Syrian Mujadara~', q'~Lentils and rice cooked with caramelized onions, cumin, and coriander. Served with tomato-cucumber salad and yogurt.~');
create_item(c, q'~Thai Green Curry with Tofu~', q'~Silky coconut milk simmered with green curry paste, tofu, bamboo shoots, bell peppers, and Thai basil. Served with jasmine rice.~');
create_item(c, q'~Tunisian Couscous Royale~', q'~Steamed semolina couscous topped with lamb, merguez sausage, chicken, and vegetables in a spicy harissa broth.~');
create_item(c, q'~Turkish Imam Bayildi~', q'~Whole eggplants stuffed with onions, tomatoes, garlic, and olive oil, baked until tender. Served with pilaf and yogurt.~');
create_item(c, q'~Vegan Burmese Tea Leaf Salad~', q'~Fermented tea leaves tossed with cabbage, tomatoes, peanuts, sesame seeds, and crispy garlic. Served with sticky rice.~');
create_item(c, q'~Vegan Caribbean Ackee and Tofu~', q'~Ackee fruit sautéed with tofu, tomatoes, onions, and Scotch bonnet pepper. Served with fried dumplings.~');
create_item(c, q'~Vegan Caribbean Callaloo~', q'~Leafy greens cooked with coconut milk, okra, onions, and Scotch bonnet pepper. Served with roasted sweet potatoes.~');
create_item(c, q'~Vegan Caribbean Callaloo Soup~', q'~Leafy greens simmered with coconut milk, okra, onions, and Scotch bonnet pepper. Served with roasted sweet potatoes.~');
create_item(c, q'~Vegan Caribbean Lentil Patties~', q'~Spiced lentil and vegetable patties, pan-fried and served with mango chutney and coconut rice.~');
create_item(c, q'~Vegan Caribbean Pumpkin Stew~', q'~Pumpkin, sweet potatoes, and black beans simmered in coconut milk with thyme and Scotch bonnet pepper.~');
create_item(c, q'~Vegan Caribbean Sweet Potato Stew~', q'~Sweet potatoes, black beans, and bell peppers simmered in coconut milk with thyme and Scotch bonnet pepper.~');
create_item(c, q'~Vegan Chinese Buddha’s Delight~', q'~Stir-fried tofu, shiitake mushrooms, bamboo shoots, and snow peas in ginger-garlic sauce. Served with brown rice.~');
create_item(c, q'~Vegan Ethiopian Atakilt Wat~', q'~Potatoes, carrots, and cabbage stewed in turmeric and ginger. Served with gluten-free injera.~');
create_item(c, q'~Vegan Ethiopian Atayef~', q'~Lentil stew with berbere spices, carrots, and potatoes, served with gluten-free injera and fresh tomato salad.~');
create_item(c, q'~Vegan Ethiopian Gomen~', q'~Collard greens sautéed with garlic, ginger, and onions. Served with gluten-free injera.~');
create_item(c, q'~Vegan Ethiopian Kik Alicha~', q'~Yellow split peas stewed with turmeric, ginger, and garlic. Served with gluten-free injera and sautéed greens.~');
create_item(c, q'~Vegan Ethiopian Misir Wot~', q'~Red lentils simmered in berbere spice and tomato sauce. Served with gluten-free injera and sautéed greens.~');
create_item(c, q'~Vegan Ethiopian Shiro~', q'~Chickpea flour stew with garlic, ginger, and berbere spices. Served with gluten-free injera and sautéed greens.~');
create_item(c, q'~Vegan Filipino Adobo~', q'~Jackfruit simmered in soy sauce, vinegar, garlic, and bay leaves. Served with steamed rice and pickled vegetables.~');
create_item(c, q'~Vegan Greek Gigantes Plaki~', q'~Giant butter beans baked in tomato sauce with dill, parsley, and olive oil. Served with lemon wedges and crusty bread.~');
create_item(c, q'~Vegan Indian Baingan Bharta~', q'~Roasted eggplant mashed and cooked with tomatoes, onions, ginger, and spices. Served with whole wheat roti.~');
create_item(c, q'~Vegan Indian Chole~', q'~Chickpeas simmered in spicy tomato-onion gravy with ginger and garam masala. Served with brown rice.~');
create_item(c, q'~Vegan Indian Dhokla~', q'~Steamed chickpea flour cakes spiced with ginger and green chili, topped with mustard seeds and cilantro.~');
create_item(c, q'~Vegan Indian Rajma~', q'~Red kidney beans simmered in tomato-onion gravy with ginger, garlic, and garam masala. Served with brown rice.~');
create_item(c, q'~Vegan Indian Sambar~', q'~Lentil and vegetable stew flavored with tamarind and curry leaves. Served with steamed rice and coconut chutney.~');
create_item(c, q'~Vegan Indian Tofu Curry~', q'~Tofu cubes simmered in tomato-onion gravy with ginger, garlic, and garam masala. Served with brown rice.~');
create_item(c, q'~Vegan Indian Tofu Tikka~', q'~Marinated tofu cubes grilled with bell peppers and onions, served with mint chutney and lemon wedges.~');
create_item(c, q'~Vegan Indian Vegetable Biryani~', q'~Basmati rice layered with spiced vegetables, saffron, and fried onions. Served with raita and papadum.~');
create_item(c, q'~Vegan Indian Vegetable Curry~', q'~Mixed vegetables simmered in tomato-onion gravy with ginger, garlic, and garam masala. Served with brown rice.~');
create_item(c, q'~Vegan Indian Vegetable Jalfrezi~', q'~Mixed vegetables stir-fried with tomatoes, onions, and spices. Served with brown rice.~');
create_item(c, q'~Vegan Italian Caponata~', q'~Eggplant, celery, olives, and capers stewed in sweet-and-sour tomato sauce. Served with toasted ciabatta.~');
create_item(c, q'~Vegan Italian Polenta with Mushroom Ragù~', q'~Creamy polenta topped with wild mushroom ragù, tomatoes, and fresh parsley.~');
create_item(c, q'~Vegan Jackfruit Carnitas~', q'~Shredded jackfruit marinated in citrus and spices, pan-seared until crispy. Served with corn tortillas, salsa verde, and pickled onions.~');
create_item(c, q'~Vegan Jamaican Ital Stew~', q'~Root vegetables, okra, and callaloo simmered in coconut milk with thyme and Scotch bonnet pepper. Served with rice and peas.~');
create_item(c, q'~Vegan Japanese Curry Rice~', q'~Potatoes, carrots, and tofu simmered in mild Japanese curry sauce. Served over steamed rice.~');
create_item(c, q'~Vegan Japanese Miso Soup~', q'~Silken tofu, wakame seaweed, and scallions in savory miso broth. Served with steamed rice.~');
create_item(c, q'~Vegan Japanese Onigiri~', q'~Rice balls filled with pickled plum, wrapped in nori seaweed. Served with miso soup.~');
create_item(c, q'~Vegan Japanese Soba Noodle Salad~', q'~Buckwheat noodles tossed with tofu, cucumber, carrots, and sesame dressing. Served chilled.~');
create_item(c, q'~Vegan Japanese Udon Noodle Soup~', q'~Thick wheat noodles in savory broth with tofu, mushrooms, and scallions. Served with pickled ginger.~');
create_item(c, q'~Vegan Korean Bibimbap~', q'~Steamed rice topped with sautéed vegetables, marinated tofu, spicy gochujang sauce, and a vegan egg.~');
create_item(c, q'~Vegan Korean Japchae~', q'~Sweet potato noodles stir-fried with mushrooms, spinach, carrots, and sesame oil. Served with pickled radish.~');
create_item(c, q'~Vegan Korean Kimchi Jjigae~', q'~Spicy stew of kimchi, tofu, mushrooms, and scallions, simmered in gochugaru broth. Served with steamed rice.~');
create_item(c, q'~Vegan Korean Sundubu Jjigae~', q'~Soft tofu stew with mushrooms, zucchini, and spicy gochugaru broth. Served with steamed rice.~');
create_item(c, q'~Vegan Korean Tteokbokki~', q'~Rice cakes simmered in spicy gochujang sauce with tofu, cabbage, and scallions.~');
create_item(c, q'~Vegan Lebanese Batata Harra~', q'~Spicy roasted potatoes tossed with garlic, cilantro, and chili. Served with tahini sauce.~');
create_item(c, q'~Vegan Lebanese Lentil Soup~', q'~Lentils simmered with carrots, celery, cumin, and lemon. Served with pita chips.~');
create_item(c, q'~Vegan Lebanese Maghmour~', q'~Eggplant and chickpeas stewed in tomato sauce with onions, garlic, and cumin. Served with bulgur pilaf.~');
create_item(c, q'~Vegan Lebanese Mujaddara~', q'~Lentils and rice topped with caramelized onions, served with cucumber-tomato salad and tahini sauce.~');
create_item(c, q'~Vegan Lebanese Spinach Fatayer~', q'~Pastries filled with spinach, onions, and sumac, baked until golden. Served with cucumber yogurt dip.~');
create_item(c, q'~Vegan Moroccan Chickpea Stew~', q'~Chickpeas simmered with carrots, tomatoes, cumin, and cinnamon. Served with herbed couscous.~');
create_item(c, q'~Vegan Moroccan Harira~', q'~Hearty soup of lentils, chickpeas, tomatoes, and vermicelli, spiced with cinnamon and ginger. Served with dates and lemon wedges.~');
create_item(c, q'~Vegan Moroccan Lentil Stew~', q'~Lentils simmered with carrots, tomatoes, cumin, and cinnamon. Served with herbed couscous.~');
create_item(c, q'~Vegan Moroccan Vegetable Couscous~', q'~Steamed couscous topped with carrots, zucchini, chickpeas, and raisins in spiced tomato broth.~');
create_item(c, q'~Vegan Moroccan Vegetable Tagine~', q'~Carrots, zucchini, chickpeas, and apricots slow-cooked in saffron, cinnamon, and ginger. Served with herbed couscous.~');
create_item(c, q'~Vegan Persian Sabzi Polo~', q'~Herbed basmati rice with dill, parsley, and cilantro, served with crispy tofu and saffron-infused vegetables.~');
create_item(c, q'~Vegan Spanish Pisto~', q'~Zucchini, eggplant, peppers, and tomatoes sautéed in olive oil, finished with garlic and parsley. Served with crusty bread.~');
create_item(c, q'~Vegan Thai Green Curry~', q'~Tofu, eggplant, and bamboo shoots simmered in coconut milk with green curry paste. Served with jasmine rice.~');
create_item(c, q'~Vegan Thai Massaman Curry~', q'~Potatoes, carrots, and tofu simmered in coconut milk with Massaman curry paste, peanuts, and tamarind. Served with jasmine rice.~');
create_item(c, q'~Vegan Thai Pad Thai~', q'~Rice noodles stir-fried with tofu, bean sprouts, peanuts, and tamarind sauce. Served with lime wedges.~');
create_item(c, q'~Vegan Thai Red Curry~', q'~Tofu, eggplant, and bamboo shoots simmered in coconut milk with red curry paste. Served with jasmine rice.~');
create_item(c, q'~Vegan Thai Tom Kha Soup~', q'~Coconut milk soup with mushrooms, tofu, lemongrass, galangal, and lime leaves. Served with jasmine rice.~');
create_item(c, q'~Vegan Thai Tom Yum Soup~', q'~Hot and sour broth with mushrooms, tomatoes, lemongrass, galangal, and tofu. Served with jasmine rice.~');
create_item(c, q'~Vegan Vietnamese Banh Mi~', q'~Baguette filled with marinated tofu, pickled vegetables, cucumber, cilantro, and spicy vegan mayo.~');
create_item(c, q'~Vegan Vietnamese Banh Xeo~', q'~Crispy rice flour crepes filled with mung beans, mushrooms, and bean sprouts. Served with fresh herbs and dipping sauce.~');
create_item(c, q'~Vegan Vietnamese Bun Cha~', q'~Grilled tofu patties served over rice noodles with fresh herbs, pickled carrots, and nuoc cham dipping sauce.~');
create_item(c, q'~Vegan Vietnamese Goi Cuon~', q'~Fresh rice paper rolls filled with tofu, vermicelli, lettuce, and herbs. Served with peanut dipping sauce.~');
create_item(c, q'~Vegan Vietnamese Lemongrass Tofu~', q'~Crispy tofu sautéed with lemongrass, chili, and garlic, served over vermicelli noodles and fresh herbs.~');
create_item(c, q'~Vegan Vietnamese Pho~', q'~Rice noodles in aromatic vegetable broth with mushrooms, tofu, bean sprouts, and fresh herbs.~');
create_item(c, q'~Vegetarian Ethiopian Gomen~', q'~Collard greens sautéed with garlic, ginger, and onions. Served with injera and spicy lentil stew.~');
create_item(c, q'~Vegetarian French Mushroom Bourguignon~', q'~Mushrooms braised in red wine with pearl onions, carrots, and thyme. Served with buttered noodles.~');
create_item(c, q'~Vegetarian French Quiche Lorraine~', q'~Savory custard tart with leeks, mushrooms, and Gruyère cheese. Served with mixed greens.~');
create_item(c, q'~Vegetarian French Ratatouille Tart~', q'~Flaky pastry filled with roasted eggplant, zucchini, peppers, and tomatoes. Served with arugula salad.~');
create_item(c, q'~Vegetarian French Tarte Tatin~', q'~Caramelized onion and tomato tart baked in flaky pastry. Served with mixed greens.~');
create_item(c, q'~Vegetarian Greek Briam~', q'~Roasted vegetables layered with tomatoes, onions, and olive oil. Served with feta cheese and crusty bread.~');
create_item(c, q'~Vegetarian Greek Fasolada~', q'~White bean soup with tomatoes, carrots, celery, and olive oil. Served with crusty bread.~');
create_item(c, q'~Vegetarian Greek Gemista~', q'~Tomatoes and bell peppers stuffed with rice, pine nuts, and herbs, baked in olive oil. Served with tzatziki.~');
create_item(c, q'~Vegetarian Greek Moussaka~', q'~Layers of roasted eggplant, potatoes, and creamy béchamel sauce, baked until golden. Served with Greek salad.~');
create_item(c, q'~Vegetarian Greek Spanakopita~', q'~Flaky phyllo pastry filled with spinach, feta, and herbs. Served with lemon-dill yogurt sauce.~');
create_item(c, q'~Vegetarian Indian Daal Makhani~', q'~Black lentils and kidney beans simmered in creamy tomato sauce with ginger and garlic. Served with basmati rice.~');
create_item(c, q'~Vegetarian Indian Malai Kofta~', q'~Paneer and potato dumplings in creamy tomato-cashew sauce, spiced with cardamom and fenugreek. Served with naan.~');
create_item(c, q'~Vegetarian Indian Palak Paneer~', q'~Paneer cubes in creamy spinach sauce, spiced with cumin and garlic. Served with basmati rice.~');
create_item(c, q'~Vegetarian Indian Paneer Bhurji~', q'~Scrambled paneer with tomatoes, onions, green chilies, and spices. Served with whole wheat paratha.~');
create_item(c, q'~Vegetarian Indian Vegetable Korma~', q'~Mixed vegetables in creamy cashew-coconut sauce, spiced with cardamom and cinnamon. Served with basmati rice.~');
create_item(c, q'~Vegetarian Italian Risotto Primavera~', q'~Creamy Arborio rice cooked with asparagus, peas, zucchini, and parmesan cheese. Finished with fresh basil.~');
create_item(c, q'~Vegetarian Korean Japchae~', q'~Sweet potato glass noodles stir-fried with mushrooms, spinach, carrots, and sesame oil. Served with pickled radish.~');
create_item(c, q'~Vegetarian Lebanese Mujaddara~', q'~Lentils and rice topped with caramelized onions, served with cucumber-tomato salad and yogurt.~');
create_item(c, q'~Vegetarian Mexican Chiles en Nogada~', q'~Poblano peppers stuffed with spiced vegetables and nuts, topped with creamy walnut sauce and pomegranate seeds.~');
create_item(c, q'~Vegetarian Persian Fesenjan~', q'~Eggplant and mushrooms braised in a pomegranate and walnut sauce, spiced with cinnamon and turmeric. Served with saffron rice.~');
create_item(c, q'~Vegetarian Spanish Gazpacho~', q'~Chilled tomato soup with cucumber, bell pepper, and garlic, garnished with croutons and olive oil.~');
create_item(c, q'~Vegetarian Spanish Paella~', q'~Saffron rice cooked with artichokes, bell peppers, peas, and tomatoes. Served with lemon wedges.~');
create_item(c, q'~Vegetarian Spanish Pisto~', q'~Zucchini, eggplant, peppers, and tomatoes sautéed in olive oil. Served with crusty bread.~');
create_item(c, q'~Vegetarian Spanish Tortilla~', q'~Golden potato and onion omelet, sliced and served with roasted red pepper salad and aioli.~');
create_item(c, q'~Vegetarian Thai Pineapple Fried Rice~', q'~Jasmine rice stir-fried with pineapple, cashews, raisins, and vegetables. Served in a pineapple shell.~');
create_item(c, q'~Vegetarian Turkish Börek~', q'~Phyllo pastry filled with feta, spinach, and herbs, baked until crispy. Served with tomato-cucumber salad.~');
create_item(c, q'~Vegetarian Turkish Imam Bayildi~', q'~Eggplant stuffed with onions, tomatoes, and garlic, baked in olive oil. Served with rice pilaf.~');
create_item(c, q'~Vegetarian Turkish Kuru Fasulye~', q'~White beans stewed in tomato sauce with onions and olive oil. Served with rice pilaf.~');
create_item(c, q'~Vegetarian Turkish Mercimek Köftesi~', q'~Red lentil and bulgur patties seasoned with cumin, paprika, and scallions. Served with lettuce wraps and lemon wedges.~');
create_item(c, q'~Vegetarian Turkish Pilav~', q'~Rice pilaf with chickpeas, pine nuts, and currants, flavored with cinnamon and allspice. Served with yogurt sauce.~');
create_item(c, q'~Vegetarian Turkish Zeytinyağlı Fasulye~', q'~Green beans braised in olive oil with tomatoes, onions, and garlic. Served with rice pilaf.~');
create_item(c, q'~Vietnamese Ca Kho To~', q'~Caramelized catfish fillets braised in clay pot with fish sauce, black pepper, and coconut water. Served with steamed jasmine rice.~');


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


    

