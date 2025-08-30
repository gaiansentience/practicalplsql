prompt loading menu items for category: Gluten-Free
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
 

    c := 'Gluten-Free';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Gluten-Free Afghan Ashak~', q'~Steamed gluten-free dumplings filled with leeks, topped with tomato meat sauce and garlic yogurt. Garnished with dried mint and chili flakes for an Afghan specialty.~');
create_item(c, q'~Gluten-Free Afghan Bolani~', q'~Stuffed gluten-free flatbread filled with mashed potatoes, green onions, cilantro, and spices. Pan-fried until golden and served with yogurt dip.~');
create_item(c, q'~Gluten-Free Afghan Firnee~', q'~Silky gluten-free custard flavored with cardamom, vanilla, and topped with crushed pistachios and rose petals. Served during Afghan celebrations.~');
create_item(c, q'~Gluten-Free Afghan Kabuli Pulao~', q'~Fragrant basmati rice cooked with lamb, sweet carrots, raisins, and toasted almonds. Seasoned with cardamom, cumin, and saffron, and served with yogurt sauce.~');
create_item(c, q'~Gluten-Free Afghan Mantu~', q'~Steamed dumplings made with gluten-free flour, filled with spiced beef and onions, topped with garlic yogurt sauce and tomato meat sauce.~');
create_item(c, q'~Gluten-Free Afghan Qabili Palau~', q'~Fragrant gluten-free rice with lamb, carrots, raisins, and almonds, seasoned with cumin, cardamom, and cinnamon. Served with yogurt sauce for an Afghan feast.~');
create_item(c, q'~Gluten-Free Afghan Sheer Korma~', q'~Creamy gluten-free vermicelli pudding with dates, nuts, coconut, and rose water. Served during Eid celebrations in Afghanistan.~');
create_item(c, q'~Gluten-Free Algerian Chakhchoukha~', q'~Shredded gluten-free flatbread mixed with lamb stew, chickpeas, carrots, and aromatic spices. Served with harissa sauce and fresh coriander.~');
create_item(c, q'~Gluten-Free Algerian Chorba~', q'~Hearty lamb and vegetable soup flavored with coriander, mint, and gluten-free vermicelli noodles. Garnished with fresh cilantro and served with gluten-free flatbread.~');
create_item(c, q'~Gluten-Free Algerian Griwech~', q'~Twisted gluten-free pastries fried and soaked in orange blossom honey, sprinkled with sesame seeds for an Algerian dessert.~');
create_item(c, q'~Gluten-Free Algerian Merguez~', q'~Spicy lamb sausage grilled and served with gluten-free roasted potatoes, tomato salad, and a drizzle of harissa oil.~');
create_item(c, q'~Gluten-Free Algerian Mhadjeb~', q'~Stuffed gluten-free flatbread filled with tomatoes, onions, peppers, and spices, pan-fried until crispy and served with harissa sauce.~');
create_item(c, q'~Gluten-Free Algerian Rechta~', q'~Homemade gluten-free noodles served with chicken, chickpeas, and carrots in a saffron-infused broth. Garnished with fresh parsley and lemon zest.~');
create_item(c, q'~Gluten-Free Algerian Tamina~', q'~Sweet gluten-free semolina dessert flavored with honey, cinnamon, and butter, served during Algerian celebrations and holidays.~');
create_item(c, q'~Gluten-Free American BBQ Ribs~', q'~Slow-smoked pork ribs glazed with tangy gluten-free barbecue sauce, cooked until fall-off-the-bone tender. Served with creamy coleslaw and warm gluten-free cornbread.~');
create_item(c, q'~Gluten-Free Argentine Empanadas~', q'~Golden pastries made from gluten-free dough, filled with seasoned ground beef, onions, green olives, and hard-boiled eggs. Baked until crisp and served with chimichurri sauce.~');
create_item(c, q'~Gluten-Free Australian Lamingtons~', q'~Soft gluten-free sponge cake squares dipped in rich chocolate icing and rolled in shredded coconut. A classic Australian treat, perfect for dessert or afternoon tea.~');
create_item(c, q'~Gluten-Free Bangladeshi Bhapa Pitha~', q'~Steamed gluten-free rice cakes filled with coconut and jaggery, served warm and garnished with toasted sesame seeds for a Bangladeshi festival treat.~');
create_item(c, q'~Gluten-Free Bangladeshi Bhuna Khichuri~', q'~Fragrant gluten-free rice and lentil pilaf cooked with carrots, peas, potatoes, and aromatic spices. Served with fried eggplant and spicy pickles.~');
create_item(c, q'~Gluten-Free Bangladeshi Chingri Bhorta~', q'~Mashed shrimp with mustard oil, green chilies, onions, and garlic, served with gluten-free rice and fresh coriander for a Bangladeshi specialty.~');
create_item(c, q'~Gluten-Free Bangladeshi Fuchka~', q'~Crispy gluten-free shells filled with spiced mashed potatoes, chickpeas, and tangy tamarind water. Served as a popular Bangladeshi street snack.~');
create_item(c, q'~Gluten-Free Bangladeshi Mishti Doi~', q'~Sweetened gluten-free yogurt dessert flavored with saffron, cardamom, and a hint of rose water. Served chilled and garnished with pistachios.~');
create_item(c, q'~Gluten-Free Bangladeshi Pitha~', q'~Steamed gluten-free rice cakes filled with coconut and jaggery, served during Bangladeshi festivals and celebrations.~');
create_item(c, q'~Gluten-Free Belgian Waffles~', q'~Crispy gluten-free waffles with deep pockets, served with whipped cream, fresh berries, and a drizzle of pure maple syrup. Perfect for breakfast or brunch.~');
create_item(c, q'~Gluten-Free Brazilian Feijoada~', q'~Rich black bean stew slow-cooked with pork shoulder, beef brisket, and spicy sausage. Served with gluten-free rice, orange slices, sautéed collard greens, and farofa for a traditional Brazilian feast.~');
create_item(c, q'~Gluten-Free Bread~', q'~Freshly baked bread made from gluten-free flours, with a soft crumb and golden crust. Ideal for sandwiches or toast.~');
create_item(c, q'~Gluten-Free Brownie~', q'~Fudgy chocolate brownie made without gluten, featuring rich cocoa flavor and a moist, chewy texture. Perfect for gluten-sensitive dessert lovers.~');
create_item(c, q'~Gluten-Free Burmese Coconut Jelly~', q'~Layered coconut and pandan jelly made with gluten-free agar, served chilled and topped with toasted coconut flakes.~');
create_item(c, q'~Gluten-Free Burmese Mohinga~', q'~Rice noodle soup with fish broth, lemongrass, banana stem, and crispy chickpea fritters. Garnished with boiled eggs, cilantro, and lime for a Burmese breakfast staple.~');
create_item(c, q'~Gluten-Free Burmese Mont Hin Gar~', q'~Fish noodle soup with gluten-free rice noodles, banana stem, lemongrass, and crispy chickpea fritters. Garnished with boiled eggs and cilantro for a Burmese breakfast.~');
create_item(c, q'~Gluten-Free Burmese Mont Let Saung~', q'~Gluten-free rice flour dumplings in sweet coconut milk, served with palm sugar syrup and crushed ice for a Burmese dessert.~');
create_item(c, q'~Gluten-Free Burmese Mont Lone Yay Paw~', q'~Gluten-free rice flour balls filled with palm sugar, served in sweet coconut milk and garnished with toasted sesame seeds.~');
create_item(c, q'~Gluten-Free Burmese Tea Leaf Salad~', q'~Fermented tea leaves tossed with shredded cabbage, tomatoes, roasted peanuts, garlic chips, sesame seeds, and dried shrimp. Served gluten-free for a unique Burmese flavor.~');
create_item(c, q'~Gluten-Free Cambodian Amok~', q'~Fish fillets steamed in coconut curry with lemongrass, kaffir lime, and turmeric. Served with gluten-free jasmine rice and banana leaf for an authentic Cambodian presentation.~');
create_item(c, q'~Gluten-Free Cambodian Bai Sach Chrouk~', q'~Grilled pork marinated in coconut milk, garlic, and palm sugar, served with gluten-free rice, pickled vegetables, and cucumber slices for a Cambodian breakfast.~');
create_item(c, q'~Gluten-Free Cambodian Kuy Teav~', q'~Rice noodle soup with pork, shrimp, garlic, and fresh herbs. Flavored with lime, fish sauce, and crispy shallots for a Cambodian breakfast staple.~');
create_item(c, q'~Gluten-Free Cambodian Lok Lak~', q'~Stir-fried beef cubes in black pepper sauce, served with gluten-free rice, lettuce, tomato slices, and a zesty lime dipping sauce.~');
create_item(c, q'~Gluten-Free Cambodian Nom Krok~', q'~Mini gluten-free coconut rice cakes with crispy edges and soft centers, cooked in a clay pan and served with scallions and sweet chili sauce.~');
create_item(c, q'~Gluten-Free Cambodian Num Ansom~', q'~Sticky gluten-free rice cakes filled with banana and coconut, wrapped in banana leaves and steamed. Served as a festive Cambodian dessert.~');
create_item(c, q'~Gluten-Free Canadian Poutine~', q'~Crispy gluten-free potato fries topped with squeaky cheese curds and smothered in savory gluten-free beef gravy. A beloved Canadian comfort food, served piping hot.~');
create_item(c, q'~Gluten-Free Chicken Tikka Masala~', q'~Indian-style chicken marinated overnight in yogurt, ginger, garlic, and garam masala, then grilled and simmered in a rich tomato and cream sauce. Served with fragrant gluten-free basmati rice and garnished with fresh cilantro.~');
create_item(c, q'~Gluten-Free Chinese Almond Jelly~', q'~Silky gluten-free almond-flavored jelly served with fruit cocktail, lychee, and a drizzle of sweet syrup.~');
create_item(c, q'~Gluten-Free Chinese Congee~', q'~Creamy rice porridge simmered with chicken, ginger, and scallions. Served with gluten-free soy sauce, crispy shallots, and pickled vegetables for a comforting Chinese breakfast.~');
create_item(c, q'~Gluten-Free Chinese Egg Drop Soup~', q'~Silky soup of chicken broth and gently beaten eggs, garnished with scallions, gluten-free soy sauce, and crispy fried garlic.~');
create_item(c, q'~Gluten-Free Chinese Lion’s Head Meatballs~', q'~Large pork meatballs braised in gluten-free soy sauce, ginger, and napa cabbage. Served with steamed rice and scallions for a classic Chinese dish.~');
create_item(c, q'~Gluten-Free Chinese Lo Mai Gai~', q'~Sticky gluten-free rice steamed with chicken, mushrooms, Chinese sausage, and dried shrimp, wrapped in lotus leaves for a fragrant Chinese dim sum dish.~');
create_item(c, q'~Gluten-Free Chinese Mapo Tofu~', q'~Silky tofu cubes simmered in a spicy Sichuan peppercorn sauce with ground pork, garlic, and fermented bean paste. Served with gluten-free rice and scallions.~');
create_item(c, q'~Gluten-Free Chinese Stir-Fried Beef~', q'~Tender strips of beef wok-seared with broccoli florets, bell peppers, and snow peas in a savory gluten-free soy sauce and ginger glaze. Served over steamed gluten-free jasmine rice for a classic Chinese meal.~');
create_item(c, q'~Gluten-Free Chinese Tangyuan~', q'~Gluten-free rice flour balls filled with black sesame paste, served in sweet ginger syrup and garnished with crushed peanuts.~');
create_item(c, q'~Gluten-Free Cuban Ropa Vieja~', q'~Shredded beef slow-cooked with tomatoes, bell peppers, onions, olives, and capers. Served with gluten-free rice, black beans, and sweet fried plantains for a taste of Cuba.~');
create_item(c, q'~Gluten-Free Danish Smørrebrød~', q'~Open-faced gluten-free bread topped with smoked salmon, pickled herring, sliced radishes, and fresh dill. Finished with a dollop of horseradish cream for a Nordic delight.~');
create_item(c, q'~Gluten-Free Egyptian Basbousa~', q'~Sweet semolina cake made with gluten-free flour, soaked in orange blossom syrup and topped with toasted almonds and coconut flakes.~');
create_item(c, q'~Gluten-Free Egyptian Feteer Meshaltet~', q'~Layered gluten-free pastry filled with cheese, honey, or dates, baked until golden and flaky. Served with powdered sugar and fresh fruit for an Egyptian treat.~');
create_item(c, q'~Gluten-Free Egyptian Kahk~', q'~Gluten-free shortbread cookies filled with nuts and dusted with powdered sugar, served during Eid and Egyptian celebrations.~');
create_item(c, q'~Gluten-Free Egyptian Koshari~', q'~Layered dish of gluten-free rice, lentils, chickpeas, and crispy fried onions, topped with spicy tomato sauce and garlic vinegar. A beloved Egyptian street food.~');
create_item(c, q'~Gluten-Free Egyptian Molokhia~', q'~Jute leaf stew cooked with garlic, coriander, and chicken broth. Served with gluten-free rice, roasted chicken, and lemon wedges for a classic Egyptian meal.~');
create_item(c, q'~Gluten-Free Egyptian Om Ali~', q'~Warm gluten-free bread pudding with nuts, coconut, and raisins, baked in sweet milk and topped with golden puff pastry.~');
create_item(c, q'~Gluten-Free Egyptian Taameya~', q'~Egyptian-style falafel made from gluten-free fava beans, parsley, cilantro, and spices, fried until crispy and served with tahini sauce and pickled vegetables.~');
create_item(c, q'~Gluten-Free Ethiopian Atayef~', q'~Mini gluten-free pancakes filled with sweet cheese and crushed nuts, folded and drizzled with honey syrup. Served as a festive Ethiopian dessert.~');
create_item(c, q'~Gluten-Free Ethiopian Dabo Kolo~', q'~Crunchy gluten-free spiced snack bites made from roasted chickpea flour, seasoned with chili and garlic. Served as an Ethiopian snack.~');
create_item(c, q'~Gluten-Free Ethiopian Doro Wat~', q'~Spicy chicken stew simmered in berbere spice, onions, garlic, and ginger. Served with gluten-free injera bread and hard-boiled eggs for a traditional Ethiopian feast.~');
create_item(c, q'~Gluten-Free Ethiopian Firfir~', q'~Shredded gluten-free injera tossed in spicy berbere sauce with onions, peppers, and garlic. Served with yogurt and fresh herbs for an Ethiopian breakfast.~');
create_item(c, q'~Gluten-Free Ethiopian Genfo~', q'~Thick gluten-free porridge made from barley flour, served with spicy berbere butter and yogurt for a traditional Ethiopian breakfast.~');
create_item(c, q'~Gluten-Free Ethiopian Injera Platter~', q'~Tangy, spongy flatbread made from teff flour, served with a variety of Ethiopian stews including spicy lentil misir wot, sautéed collard greens, and a crisp tomato-onion salad. All gluten-free and bursting with authentic flavors.~');
create_item(c, q'~Gluten-Free Ethiopian Kitfo~', q'~Minced beef seasoned with chili, cardamom, and mitmita spice, served raw or lightly cooked with gluten-free injera bread and homemade cottage cheese.~');
create_item(c, q'~Gluten-Free Ethiopian Shiro~', q'~Chickpea flour stew simmered with garlic, onions, berbere spice, and tomatoes. Served with gluten-free injera bread and fresh salad for an Ethiopian meal.~');
create_item(c, q'~Gluten-Free Falafel Bowl~', q'~Middle Eastern-inspired bowl with crispy falafel made from ground chickpeas, parsley, cilantro, and spices, served atop fluffy gluten-free quinoa. Accompanied by creamy tahini sauce, pickled turnips, fresh cucumber, tomato salad, and a sprinkle of sumac.~');
create_item(c, q'~Gluten-Free Filipino Adobo~', q'~Chicken braised in a tangy blend of vinegar, gluten-free soy sauce, garlic, bay leaves, and black peppercorns. Served with steamed gluten-free jasmine rice and pickled vegetables for a true Filipino comfort dish.~');
create_item(c, q'~Gluten-Free Filipino Bibingka~', q'~Gluten-free rice cake baked with coconut milk, topped with salted egg, shredded cheese, and grated coconut. Served warm for a Filipino holiday treat.~');
create_item(c, q'~Gluten-Free Filipino Halo-Halo~', q'~Layered shaved ice dessert with sweet beans, coconut strips, jackfruit, purple yam, and gluten-free leche flan. Topped with evaporated milk and crunchy rice puffs for a colorful treat.~');
create_item(c, q'~Gluten-Free Filipino Kare-Kare~', q'~Oxtail stew in creamy peanut sauce with eggplant, green beans, and bok choy. Served with gluten-free rice and fermented shrimp paste for a Filipino classic.~');
create_item(c, q'~Gluten-Free Filipino Lechon Kawali~', q'~Crispy gluten-free pork belly, deep-fried and served with liver sauce, pickled vegetables, and steamed rice for a Filipino feast.~');
create_item(c, q'~Gluten-Free Filipino Pancit~', q'~Stir-fried gluten-free rice noodles with chicken, shrimp, cabbage, carrots, and green beans. Seasoned with gluten-free soy sauce and calamansi citrus for a festive Filipino noodle dish.~');
create_item(c, q'~Gluten-Free Filipino Sinigang~', q'~Sour tamarind soup with pork, tomatoes, green beans, and gluten-free rice. Flavored with radish, eggplant, and chili for a Filipino comfort food.~');
create_item(c, q'~Gluten-Free Filipino Turon~', q'~Gluten-free spring rolls filled with ripe banana and jackfruit, rolled in brown sugar and fried until caramelized. Served hot for a Filipino snack.~');
create_item(c, q'~Gluten-Free Finnish Karjalanpiirakka~', q'~Traditional Finnish pastries with a gluten-free rye crust, filled with creamy rice porridge and served warm with whipped egg butter.~');
create_item(c, q'~Gluten-Free Ghanaian Atadwe Milk~', q'~Creamy gluten-free tiger nut milk drink, sweetened with vanilla and served chilled over ice. A refreshing Ghanaian beverage.~');
create_item(c, q'~Gluten-Free Ghanaian Bofrot~', q'~Golden gluten-free doughnuts, crispy outside and soft inside, served with spicy pepper sauce for a Ghanaian breakfast treat.~');
create_item(c, q'~Gluten-Free Ghanaian Fufu~', q'~Smooth gluten-free cassava and plantain dough, pounded and served with spicy soup or stew, such as light soup or groundnut soup.~');
create_item(c, q'~Gluten-Free Ghanaian Groundnut Stew~', q'~Rich peanut stew with chicken, tomatoes, spinach, and ginger, simmered and served over gluten-free rice balls called omo tuo.~');
create_item(c, q'~Gluten-Free Ghanaian Kelewele~', q'~Fried plantain cubes tossed in ginger, cayenne, nutmeg, and cloves. Served hot and gluten-free as a popular Ghanaian street snack.~');
create_item(c, q'~Gluten-Free Ghanaian Nkate Cake~', q'~Crunchy gluten-free peanut brittle bars, sweetened with sugar and vanilla. Served as a Ghanaian snack or dessert.~');
create_item(c, q'~Gluten-Free Ghanaian Waakye~', q'~Gluten-free rice and beans cooked with millet leaves, served with spicy tomato stew, fried plantains, boiled eggs, and gari for a complete Ghanaian meal.~');
create_item(c, q'~Gluten-Free Greek Moussaka~', q'~Layers of roasted eggplant, spiced ground beef, and creamy béchamel sauce made with gluten-free flour. Baked until bubbling and golden, garnished with grated Parmesan.~');
create_item(c, q'~Gluten-Free Greek Salad~', q'~A refreshing Mediterranean salad of crisp cucumbers, ripe tomatoes, Kalamata olives, red onions, and creamy feta cheese. Tossed in extra virgin olive oil, oregano, and lemon juice, and served with crunchy gluten-free pita chips.~');
create_item(c, q'~Gluten-Free Hawaiian Poke Bowl~', q'~Fresh ahi tuna cubes marinated in gluten-free soy sauce, sesame oil, and scallions. Served over steamed rice with avocado, seaweed salad, pickled ginger, and toasted sesame seeds.~');
create_item(c, q'~Gluten-Free Hungarian Goulash~', q'~Traditional beef stew simmered with sweet paprika, onions, tomatoes, and bell peppers. Served with gluten-free spaetzle dumplings and garnished with sour cream and fresh parsley.~');
create_item(c, q'~Gluten-Free Indian Dhokla~', q'~Steamed gluten-free chickpea flour cakes flavored with ginger, green chilies, and mustard seeds. Garnished with fresh coriander and coconut for a Gujarati snack.~');
create_item(c, q'~Gluten-Free Indian Dosa~', q'~Crispy fermented crepes made from gluten-free rice and lentil batter, filled with spiced potato masala. Served with coconut chutney and tangy sambar for a South Indian breakfast.~');
create_item(c, q'~Gluten-Free Indian Gulab Jamun~', q'~Soft gluten-free milk dough balls fried and soaked in rose-scented sugar syrup. Served warm and garnished with pistachios for a classic Indian dessert.~');
create_item(c, q'~Gluten-Free Indian Idli~', q'~Steamed gluten-free rice cakes made from fermented rice and lentil batter. Served with coconut chutney, spicy sambar, and tomato relish for a South Indian breakfast.~');
create_item(c, q'~Gluten-Free Indian Jalebi~', q'~Crispy gluten-free spirals made from fermented rice flour batter, fried and soaked in saffron syrup. Served hot and garnished with pistachios.~');
create_item(c, q'~Gluten-Free Indian Kheer~', q'~Creamy gluten-free rice pudding flavored with cardamom, saffron, and pistachios. Served chilled or warm for a classic Indian dessert.~');
create_item(c, q'~Gluten-Free Indian Malpua~', q'~Sweet gluten-free pancakes soaked in cardamom syrup, garnished with pistachios and served warm for an Indian festival dessert.~');
create_item(c, q'~Gluten-Free Indian Pani Puri~', q'~Crispy gluten-free shells filled with spiced potatoes, chickpeas, and tangy tamarind water. Served as a popular Indian street snack with fresh coriander.~');
create_item(c, q'~Gluten-Free Indian Pav Bhaji~', q'~Spicy mashed vegetable curry made with potatoes, peas, tomatoes, and bell peppers, served with gluten-free bread rolls and chopped onions.~');
create_item(c, q'~Gluten-Free Indian Ras Malai~', q'~Soft gluten-free cheese dumplings soaked in sweetened milk flavored with cardamom, saffron, and pistachios. Served chilled for a classic Indian dessert.~');
create_item(c, q'~Gluten-Free Indian Rogan Josh~', q'~Tender lamb pieces cooked in a rich tomato and yogurt sauce with Kashmiri chili, cardamom, and cinnamon. Served with gluten-free naan and saffron rice.~');
create_item(c, q'~Gluten-Free Indian Samosa~', q'~Crispy gluten-free pastry triangles filled with spiced potatoes, peas, and cumin seeds. Served with tangy tamarind chutney and mint yogurt sauce.~');
create_item(c, q'~Gluten-Free Indonesian Satay~', q'~Grilled chicken skewers marinated in turmeric, coriander, lemongrass, and coconut milk. Served with a rich gluten-free peanut sauce, cucumber salad, and gluten-free rice cakes called lontong.~');
create_item(c, q'~Gluten-Free Iranian Faloodeh~', q'~Gluten-free rice noodles in rose water syrup, served with lime juice, crushed pistachios, and cherry syrup for a Persian summer dessert.~');
create_item(c, q'~Gluten-Free Iranian Ghormeh Sabzi~', q'~Herb stew with beef, kidney beans, and dried limes, simmered with fenugreek, parsley, and coriander. Served with gluten-free saffron rice and pickled vegetables.~');
create_item(c, q'~Gluten-Free Iranian Kebab Koobideh~', q'~Grilled ground beef skewers seasoned with onions, saffron, and sumac. Served with gluten-free rice, grilled tomatoes, and fresh herbs.~');
create_item(c, q'~Gluten-Free Iranian Kuku Sabzi~', q'~Herb-packed gluten-free frittata with parsley, cilantro, dill, scallions, and walnuts. Baked until golden and served with yogurt and fresh radishes.~');
create_item(c, q'~Gluten-Free Iranian Sholeh Zard~', q'~Saffron-infused gluten-free rice pudding with pistachios, almonds, and cinnamon. Served chilled and garnished with rose petals.~');
create_item(c, q'~Gluten-Free Iranian Tahchin~', q'~Saffron rice cake layered with tender chicken and creamy yogurt, baked until golden and crispy. Served with tart barberries and pistachios for a Persian specialty.~');
create_item(c, q'~Gluten-Free Iranian Zoolbia~', q'~Crispy gluten-free spirals made from rice flour batter, fried and soaked in saffron syrup. Served during Iranian festivals and holidays.~');
create_item(c, q'~Gluten-Free Iraqi Biryani~', q'~Fragrant gluten-free rice cooked with chicken, raisins, almonds, and aromatic spices. Served with yogurt sauce and cucumber salad for a festive Iraqi meal.~');
create_item(c, q'~Gluten-Free Iraqi Dolma~', q'~Grape leaves stuffed with gluten-free rice, ground beef, pine nuts, and fresh herbs. Simmered in tomato sauce and served with lemon wedges and yogurt.~');
create_item(c, q'~Gluten-Free Iraqi Kleicha~', q'~Gluten-free date-filled cookies flavored with cardamom, rose water, and sesame seeds. Served during Iraqi holidays and celebrations.~');
create_item(c, q'~Gluten-Free Iraqi Masgouf~', q'~Grilled river fish marinated in tamarind, garlic, and spices, cooked over open flames and served with gluten-free rice, tomato salad, and lemon wedges.~');
create_item(c, q'~Gluten-Free Iraqi Quzi~', q'~Slow-roasted lamb served over fragrant gluten-free rice with nuts, raisins, and aromatic spices. Garnished with fried onions and boiled eggs for an Iraqi feast.~');
create_item(c, q'~Gluten-Free Iraqi Samoon~', q'~Soft gluten-free bread rolls shaped like diamonds, baked until golden and served with cheese, olives, and fresh herbs for an Iraqi breakfast.~');
create_item(c, q'~Gluten-Free Iraqi Tashreeb~', q'~Lamb and vegetable stew served over torn gluten-free bread, flavored with garlic, cumin, and lemon. Garnished with fresh parsley for an Iraqi comfort dish.~');
create_item(c, q'~Gluten-Free Irish Shepherd’s Pie~', q'~Savory casserole of ground lamb and vegetables simmered in gluten-free gravy, topped with creamy mashed potatoes and baked until golden brown. Garnished with fresh chives.~');
create_item(c, q'~Gluten-Free Israeli Shakshuka~', q'~Poached eggs nestled in a spicy tomato and bell pepper sauce, seasoned with cumin, paprika, and garlic. Served with warm gluten-free pita bread and a sprinkle of fresh parsley.~');
create_item(c, q'~Gluten-Free Italian Risotto~', q'~Creamy Arborio rice slowly stirred with wild porcini mushrooms, shallots, white wine, and vegetable broth. Finished with grated Parmesan cheese, fresh thyme, and a drizzle of truffle oil for a luxurious gluten-free dish.~');
create_item(c, q'~Gluten-Free Jamaican Jerk Chicken~', q'~Chicken marinated in a bold blend of Scotch bonnet peppers, allspice, thyme, and ginger, then grilled over open flames for a smoky, spicy flavor. Served with gluten-free coconut rice and kidney beans, garnished with fresh scallions.~');
create_item(c, q'~Gluten-Free Japanese Anmitsu~', q'~Gluten-free agar jelly cubes served with sweet beans, assorted fruit, and black sugar syrup. Garnished with mochi and matcha ice cream for a Japanese dessert.~');
create_item(c, q'~Gluten-Free Japanese Chirashi~', q'~Assorted sashimi including tuna, salmon, and yellowtail artfully arranged over seasoned gluten-free sushi rice. Garnished with pickled ginger, wasabi, and shredded nori.~');
create_item(c, q'~Gluten-Free Japanese Dorayaki~', q'~Gluten-free pancakes filled with sweet red bean paste, served warm and garnished with matcha powder for a Japanese snack.~');
create_item(c, q'~Gluten-Free Japanese Mochi~', q'~Chewy gluten-free rice cakes made from sweet glutinous rice flour, filled with sweet red bean paste and dusted with potato starch. Served as a traditional Japanese dessert.~');
create_item(c, q'~Gluten-Free Japanese Okonomiyaki~', q'~Savory pancake made with gluten-free flour, shredded cabbage, and pork belly, pan-fried and topped with gluten-free okonomiyaki sauce, Japanese mayo, and bonito flakes.~');
create_item(c, q'~Gluten-Free Japanese Takoyaki~', q'~Gluten-free octopus balls made with rice flour batter, filled with diced octopus, scallions, and pickled ginger. Topped with bonito flakes, sweet sauce, and Japanese mayo.~');
create_item(c, q'~Gluten-Free Japanese Yaki Imo~', q'~Roasted Japanese sweet potatoes, caramelized and served hot with a sprinkle of sea salt. A simple, gluten-free Japanese street snack.~');
create_item(c, q'~Gluten-Free Kenyan Chapati~', q'~Soft gluten-free flatbread made from millet or rice flour, served with beef stew, sautéed vegetables, and spicy tomato relish.~');
create_item(c, q'~Gluten-Free Kenyan Githeri~', q'~Stew of gluten-free maize and beans cooked with onions, tomatoes, and spices. Served with sautéed greens and avocado for a Kenyan meal.~');
create_item(c, q'~Gluten-Free Kenyan Mandazi~', q'~Fluffy gluten-free coconut doughnuts, lightly sweetened and dusted with powdered sugar. Served with chai tea for a Kenyan treat.~');
create_item(c, q'~Gluten-Free Kenyan Matoke~', q'~Stewed plantains cooked with tomatoes, onions, beef, and spices. Served with gluten-free ugali maize porridge and sautéed greens for a Kenyan meal.~');
create_item(c, q'~Gluten-Free Kenyan Nyama Choma~', q'~Grilled beef seasoned with garlic, chili, and lemon, served with gluten-free ugali maize porridge and fresh kachumbari tomato-onion salad.~');
create_item(c, q'~Gluten-Free Kenyan Sukuma Wiki~', q'~Sautéed collard greens with onions, tomatoes, and garlic, served with gluten-free ugali maize porridge and grilled chicken thighs.~');
create_item(c, q'~Gluten-Free Kenyan Uji~', q'~Warm gluten-free millet porridge flavored with honey, cinnamon, and cardamom. Served for breakfast with fresh fruit and nuts.~');
create_item(c, q'~Gluten-Free Korean Bibimbap~', q'~Signature Korean rice bowl featuring steamed gluten-free rice topped with sautéed spinach, carrots, shiitake mushrooms, marinated beef, and a sunny-side-up egg. Served with gluten-free gochujang chili sauce and sesame seeds.~');
create_item(c, q'~Gluten-Free Korean Bulgogi~', q'~Thinly sliced beef marinated in gluten-free soy sauce, garlic, sesame oil, and pear juice, grilled and served with steamed rice and kimchi.~');
create_item(c, q'~Gluten-Free Korean Hotteok~', q'~Sweet gluten-free pancakes filled with brown sugar, cinnamon, and chopped walnuts, pan-fried until golden and served hot.~');
create_item(c, q'~Gluten-Free Korean Japchae~', q'~Sweet potato glass noodles stir-fried with marinated beef, spinach, carrots, mushrooms, and gluten-free soy sauce. Finished with sesame oil and toasted seeds.~');
create_item(c, q'~Gluten-Free Korean Kimchi Pancakes~', q'~Savory gluten-free pancakes filled with fermented kimchi, scallions, and chili. Pan-fried until crispy and served with soy dipping sauce.~');
create_item(c, q'~Gluten-Free Korean Kimchi Stew~', q'~Spicy stew of fermented kimchi, pork belly, tofu, and vegetables simmered in gluten-free gochugaru chili paste. Served with steamed rice and scallions.~');
create_item(c, q'~Gluten-Free Korean Patbingsu~', q'~Shaved ice dessert topped with sweet red beans, assorted fruit, condensed milk, and chewy gluten-free rice cakes. Served chilled for a Korean summer treat.~');
create_item(c, q'~Gluten-Free Korean Tteokbokki~', q'~Spicy gluten-free rice cakes stir-fried with fish cakes, cabbage, and scallions in a sweet and spicy gochujang sauce. Garnished with sesame seeds and boiled eggs.~');
create_item(c, q'~Gluten-Free Laotian Khao Nom Kok~', q'~Sweet gluten-free coconut and rice flour cakes, grilled and served with toasted sesame seeds and coconut milk drizzle.~');
create_item(c, q'~Gluten-Free Laotian Khao Piak Sen~', q'~Chewy gluten-free rice noodles in chicken broth with cilantro, scallions, fried garlic, and shredded chicken. Served with lime wedges and chili paste.~');
create_item(c, q'~Gluten-Free Laotian Khao Tom~', q'~Sweet gluten-free sticky rice parcels filled with coconut and mung beans, wrapped in banana leaves and steamed. Served with coconut milk drizzle.~');
create_item(c, q'~Gluten-Free Laotian Larb~', q'~Minced chicken salad tossed with lime juice, fish sauce, mint, cilantro, and toasted rice powder. Served with lettuce cups and sliced chilies for a refreshing Laotian dish.~');
create_item(c, q'~Gluten-Free Laotian Or Lam~', q'~Hearty stew of beef, eggplant, mushrooms, lemongrass, and chili, thickened with gluten-free sticky rice flour and flavored with Lao herbs.~');
create_item(c, q'~Gluten-Free Laotian Ping Gai~', q'~Grilled chicken marinated in lemongrass, garlic, and fish sauce, served with gluten-free sticky rice and spicy chili dipping sauce.~');
create_item(c, q'~Gluten-Free Lebanese Fattoush~', q'~Chopped salad of tomatoes, cucumbers, radishes, and crispy gluten-free pita chips, tossed in a tangy sumac dressing. Finished with fresh mint and parsley.~');
create_item(c, q'~Gluten-Free Lebanese Kafta~', q'~Grilled skewers of ground beef and lamb mixed with parsley, onions, and spices. Served with gluten-free tabbouleh, hummus, and grilled vegetables.~');
create_item(c, q'~Gluten-Free Lebanese Kibbeh Nayeh~', q'~Raw gluten-free bulgur and beef tartare seasoned with mint, onions, olive oil, and spices. Served with gluten-free pita, fresh vegetables, and herbs.~');
create_item(c, q'~Gluten-Free Lebanese Maamoul~', q'~Gluten-free semolina cookies filled with dates, walnuts, or pistachios, dusted with powdered sugar and served during Lebanese holidays.~');
create_item(c, q'~Gluten-Free Lebanese Mujadara~', q'~Lentils and gluten-free rice cooked with caramelized onions, cumin, and cinnamon. Served with yogurt, tomato salad, and crispy onions.~');
create_item(c, q'~Gluten-Free Lebanese Sfouf~', q'~Turmeric-infused gluten-free semolina cake topped with pine nuts and anise seeds. Served as a Lebanese tea-time treat.~');
create_item(c, q'~Gluten-Free Lebanese Shish Tawook~', q'~Grilled chicken skewers marinated in garlic, lemon, yogurt, and spices, served with gluten-free rice, garlic sauce, and pickled turnips.~');
create_item(c, q'~Gluten-Free Lebanese Tabbouleh~', q'~A vibrant salad of finely chopped parsley, mint, tomatoes, scallions, and gluten-free quinoa, dressed with fresh lemon juice and extra virgin olive oil. Light, refreshing, and full of Mediterranean flavor.~');
create_item(c, q'~Gluten-Free Malagasy Akoho Sy Voanio~', q'~Chicken simmered in coconut milk with ginger, garlic, and tomatoes, served with gluten-free rice and spicy chili paste for a Malagasy specialty.~');
create_item(c, q'~Gluten-Free Malagasy Hen’omby Ritra~', q'~Slow-cooked beef stew with garlic, ginger, tomatoes, and local Malagasy spices. Served with gluten-free rice and spicy chili paste.~');
create_item(c, q'~Gluten-Free Malagasy Koba~', q'~Steamed gluten-free rice and peanut cake wrapped in banana leaves, sweetened with honey and flavored with vanilla. Served as a Malagasy festival treat.~');
create_item(c, q'~Gluten-Free Malagasy Lasary~', q'~Pickled vegetable salad with carrots, cabbage, green beans, and onions, tossed in vinegar, chili, and fresh herbs. Served chilled as a gluten-free side dish.~');
create_item(c, q'~Gluten-Free Malagasy Mofo Akondro~', q'~Gluten-free banana fritters, crispy outside and soft inside, dusted with cinnamon sugar and served with honey for a Malagasy snack.~');
create_item(c, q'~Gluten-Free Malagasy Mofo Gasy~', q'~Sweet gluten-free rice flour pancakes flavored with coconut milk and vanilla, cooked until golden and served with honey or jam.~');
create_item(c, q'~Gluten-Free Malagasy Romazava~', q'~Beef and leafy greens simmered in a ginger and garlic broth with tomatoes, scallions, and local herbs. Served with gluten-free rice and spicy chili paste.~');
create_item(c, q'~Gluten-Free Malaysian Laksa~', q'~Spicy coconut curry soup with gluten-free rice noodles, plump shrimp, tofu puffs, bean sprouts, and boiled egg. Garnished with fresh cilantro, lime wedges, and crispy shallots for a burst of flavor.~');
create_item(c, q'~Gluten-Free Mexican Enchiladas~', q'~Corn tortillas filled with shredded chicken, sautéed onions, and roasted poblano peppers, rolled and smothered in gluten-free enchilada sauce. Topped with melted cheese, sour cream, and fresh cilantro.~');
create_item(c, q'~Gluten-Free Mongolian Airag~', q'~Fermented gluten-free mare’s milk, served chilled as a traditional Mongolian beverage during festivals and celebrations.~');
create_item(c, q'~Gluten-Free Mongolian Beef~', q'~Thinly sliced beef stir-fried with scallions, garlic, and gluten-free soy sauce. Served over steamed jasmine rice and garnished with toasted sesame seeds.~');
create_item(c, q'~Gluten-Free Mongolian Boortsog~', q'~Fried gluten-free dough cookies, lightly sweetened and served with honey or jam for a Mongolian tea-time treat.~');
create_item(c, q'~Gluten-Free Mongolian Buuz~', q'~Steamed dumplings made with gluten-free flour, filled with seasoned beef, onions, and garlic. Served with spicy dipping sauce and fresh herbs.~');
create_item(c, q'~Gluten-Free Mongolian Guriltai Shul~', q'~Beef noodle soup with gluten-free rice noodles, carrots, onions, garlic, and black pepper. Served hot and garnished with fresh herbs.~');
create_item(c, q'~Gluten-Free Mongolian Lamb Skewers~', q'~Grilled lamb skewers marinated in cumin, chili, garlic, and ginger. Served with gluten-free flatbread and spicy dipping sauce for a Mongolian street food experience.~');
create_item(c, q'~Gluten-Free Mongolian Tsuivan~', q'~Stir-fried gluten-free noodles with beef, carrots, onions, and garlic. Seasoned with gluten-free soy sauce and served with pickled vegetables.~');
create_item(c, q'~Gluten-Free Moroccan Bastilla~', q'~Savory pie made with gluten-free phyllo pastry, filled with spiced chicken, almonds, and eggs. Dusted with cinnamon and powdered sugar for a sweet-savory Moroccan specialty.~');
create_item(c, q'~Gluten-Free Moroccan Ghriba~', q'~Crumbly gluten-free almond cookies flavored with orange blossom water and dusted with powdered sugar. Served with Moroccan mint tea.~');
create_item(c, q'~Gluten-Free Moroccan Harira~', q'~Tomato-based soup with lentils, chickpeas, lamb, and gluten-free rice, seasoned with cinnamon, ginger, and saffron. Served with dates and lemon wedges.~');
create_item(c, q'~Gluten-Free Moroccan Mechoui~', q'~Slow-roasted lamb seasoned with cumin, coriander, and garlic, served with gluten-free couscous, mint sauce, and roasted vegetables.~');
create_item(c, q'~Gluten-Free Moroccan Sellou~', q'~Nutty gluten-free flour and sesame seed confection flavored with cinnamon, anise, and honey. Served during Moroccan festivities.~');
create_item(c, q'~Gluten-Free Moroccan Tagine~', q'~Slow-cooked lamb shoulder braised with dried apricots, toasted almonds, cinnamon, cumin, and saffron in a traditional Moroccan clay pot. Served over fluffy gluten-free millet and garnished with fresh coriander.~');
create_item(c, q'~Gluten-Free Moroccan Tanjia~', q'~Slow-cooked beef with preserved lemons, olives, garlic, and Moroccan spices, baked in a clay pot and served with gluten-free couscous.~');
create_item(c, q'~Gluten-Free Moroccan Zaalouk~', q'~Smoky eggplant and tomato salad seasoned with garlic, cumin, paprika, and olive oil. Served with gluten-free bread and fresh parsley for a Moroccan appetizer.~');
create_item(c, q'~Gluten-Free Mozambican Cocada~', q'~Chewy gluten-free coconut bars sweetened with condensed milk and lime zest. Served chilled for a tropical Mozambican dessert.~');
create_item(c, q'~Gluten-Free Mozambican Frango Piri Piri~', q'~Grilled chicken marinated in spicy piri piri sauce made from chili, garlic, and lemon, served with gluten-free coconut rice and fresh salad.~');
create_item(c, q'~Gluten-Free Mozambican Matapa~', q'~Cassava leaves cooked in coconut milk with peanuts, garlic, and shrimp. Served with gluten-free rice and fresh lime wedges for a Mozambican delicacy.~');
create_item(c, q'~Gluten-Free Mozambican Matata~', q'~Clam and peanut stew simmered with tomatoes, greens, and coconut milk. Served with gluten-free rice and fresh lime wedges for a Mozambican delicacy.~');
create_item(c, q'~Gluten-Free Mozambican Piri Piri Shrimp~', q'~Shrimp marinated in fiery piri piri sauce made from chili, garlic, and lemon, grilled and served with gluten-free coconut rice and fresh lime wedges.~');
create_item(c, q'~Gluten-Free Mozambican Pão de Queijo~', q'~Chewy gluten-free cheese bread balls made with tapioca flour and Parmesan cheese. Served warm for a Brazilian-inspired snack.~');
create_item(c, q'~Gluten-Free Mozambican Xima~', q'~Soft gluten-free maize porridge served with spicy chicken stew, sautéed vegetables, and fresh chili sauce for a Mozambican meal.~');
create_item(c, q'~Gluten-Free Muffin~', q'~Moist blueberry muffin made without gluten, bursting with juicy berries and topped with a crunchy streusel. Great for breakfast or snacking.~');
create_item(c, q'~Gluten-Free Nepalese Aloo Tama~', q'~Potato and bamboo shoot curry with black-eyed peas, tomatoes, and ginger. Served with gluten-free rice and spicy pickles for a Nepalese specialty.~');
create_item(c, q'~Gluten-Free Nepalese Chatamari~', q'~Gluten-free rice flour crepe topped with minced meat, eggs, tomatoes, and scallions, baked until golden and served with spicy tomato chutney.~');
create_item(c, q'~Gluten-Free Nepalese Dal Bhat~', q'~Lentil soup served with gluten-free rice, sautéed seasonal vegetables, spicy pickles, and crispy papad for a complete Nepalese meal.~');
create_item(c, q'~Gluten-Free Nepalese Dhido~', q'~Thick gluten-free buckwheat porridge served with spicy pickles, sautéed greens, and lentil soup for a traditional Nepalese meal.~');
create_item(c, q'~Gluten-Free Nepalese Momos~', q'~Steamed dumplings made with gluten-free flour, filled with minced chicken, ginger, garlic, and scallions. Served with spicy tomato achar dipping sauce.~');
create_item(c, q'~Gluten-Free Nepalese Sel Roti~', q'~Sweet, ring-shaped gluten-free rice flour donuts, crispy on the outside and soft inside. Flavored with cardamom and served with yogurt or tea.~');
create_item(c, q'~Gluten-Free Nepalese Yomari~', q'~Steamed gluten-free rice flour dumplings filled with sweet jaggery and sesame paste, shaped into fish and served during Nepalese festivals.~');
create_item(c, q'~Gluten-Free Nigerian Akara~', q'~Crispy gluten-free bean fritters flavored with onions, chili, and spices. Served with spicy tomato sauce and fresh salad for a Nigerian breakfast.~');
create_item(c, q'~Gluten-Free Nigerian Chin Chin~', q'~Crunchy gluten-free fried dough bites, lightly sweetened and spiced with nutmeg and vanilla. Served as a Nigerian snack or dessert.~');
create_item(c, q'~Gluten-Free Nigerian Egusi Soup~', q'~Melon seed soup with beef, spinach, and spices, thickened with ground egusi seeds. Served with gluten-free pounded yam and spicy pepper sauce.~');
create_item(c, q'~Gluten-Free Nigerian Jollof Rice~', q'~Spicy tomato rice cooked with chicken, bell peppers, onions, and Scotch bonnet chilies. Served with gluten-free fried plantains and a side of coleslaw.~');
create_item(c, q'~Gluten-Free Nigerian Moi Moi~', q'~Steamed gluten-free bean pudding flavored with peppers, onions, and spices. Served with rice, fried plantains, and tomato sauce for a Nigerian meal.~');
create_item(c, q'~Gluten-Free Nigerian Puff-Puff~', q'~Fluffy gluten-free fried dough balls, lightly sweetened and dusted with sugar. Served as a Nigerian street snack or dessert.~');
create_item(c, q'~Gluten-Free Nigerian Suya~', q'~Spicy grilled beef skewers coated in peanut and chili spice mix, served with gluten-free onions, tomatoes, and spicy pepper sauce.~');
create_item(c, q'~Gluten-Free Norwegian Salmon Gravlax~', q'~Norwegian salmon cured with dill, sugar, and spices, thinly sliced and served with gluten-free rye bread, mustard-dill sauce, and pickled cucumbers.~');
create_item(c, q'~Gluten-Free Pad Thai~', q'~Classic Thai street food featuring stir-fried rice noodles tossed with succulent shrimp, tender chicken, scrambled eggs, bean sprouts, and roasted peanuts in a tangy tamarind sauce. Finished with fresh lime wedges and gluten-free fish sauce for a vibrant, aromatic dish.~');
create_item(c, q'~Gluten-Free Pakistani Aloo Keema~', q'~Ground beef and potato curry simmered with tomatoes, onions, ginger, and spices. Served with gluten-free naan and fresh coriander for a Pakistani comfort dish.~');
create_item(c, q'~Gluten-Free Pakistani Chapli Kebab~', q'~Spiced beef patties with coriander, pomegranate seeds, and green chilies, pan-fried and served with gluten-free naan, yogurt sauce, and fresh salad.~');
create_item(c, q'~Gluten-Free Pakistani Firni~', q'~Smooth gluten-free rice flour custard flavored with rose water, cardamom, and garnished with sliced almonds and pistachios.~');
create_item(c, q'~Gluten-Free Pakistani Haleem~', q'~Slow-cooked stew of beef, lentils, and gluten-free grains, flavored with ginger, garlic, garam masala, and fried onions. Served with lemon wedges and fresh cilantro.~');
create_item(c, q'~Gluten-Free Pakistani Nihari~', q'~Slow-cooked beef shank stew infused with ginger, garlic, and warming spices. Served with gluten-free naan bread, fresh cilantro, and sliced green chilies for a hearty meal.~');
create_item(c, q'~Gluten-Free Pakistani Seekh Kebab~', q'~Grilled spiced beef skewers seasoned with cumin, coriander, and chili, served with gluten-free naan and mint chutney.~');
create_item(c, q'~Gluten-Free Pakistani Zarda~', q'~Sweet gluten-free rice cooked with nuts, raisins, cardamom, and colored with saffron. Served as a festive Pakistani dessert.~');
create_item(c, q'~Gluten-Free Pancakes~', q'~Fluffy pancakes made with gluten-free flour, served hot with maple syrup and fresh fruit. Light, airy, and perfect for breakfast.~');
create_item(c, q'~Gluten-Free Pasta~', q'~Pasta made from gluten-free ingredients such as rice, corn, or quinoa flour, cooked al dente and tossed with your choice of sauce. Suitable for gluten-sensitive diners without compromising on taste or texture.~');
create_item(c, q'~Gluten-Free Persian Fesenjan~', q'~Chicken simmered in a luxurious sauce of ground walnuts, pomegranate molasses, and fragrant Persian spices. Served with saffron-infused gluten-free basmati rice and toasted almond slivers.~');
create_item(c, q'~Gluten-Free Peruvian Ceviche~', q'~Fresh white fish cured in zesty lime juice, tossed with thinly sliced red onions, chopped cilantro, and fiery chili peppers. Served with gluten-free sweet potato chips and crunchy corn kernels for a true taste of Peru.~');
create_item(c, q'~Gluten-Free Pizza~', q'~Pizza made with a gluten-free crust, topped with tomato sauce, mozzarella cheese, and your choice of toppings. Baked until crisp and golden.~');
create_item(c, q'~Gluten-Free Polish Pierogi~', q'~Handmade dumplings crafted from gluten-free flour, filled with creamy mashed potatoes and sharp cheddar cheese. Boiled and then sautéed in butter with caramelized onions, served with sour cream.~');
create_item(c, q'~Gluten-Free Portuguese Bacalhau~', q'~Salted cod baked with sliced potatoes, onions, olives, and hard-boiled eggs, finished with extra virgin olive oil and fresh parsley. Served gluten-free for a taste of Portugal.~');
create_item(c, q'~Gluten-Free Russian Beet Salad~', q'~Colorful salad of roasted beets, boiled potatoes, carrots, and green peas, tossed in a creamy gluten-free mayonnaise dressing. Garnished with fresh dill and served chilled for a classic Russian zakuski.~');
create_item(c, q'~Gluten-Free Scottish Cullen Skink~', q'~Traditional Scottish chowder made with smoked haddock, diced potatoes, onions, and rich cream. Served with gluten-free oatcakes and a sprinkle of fresh parsley.~');
create_item(c, q'~Gluten-Free Senegalese Ceebu Jen~', q'~Fish and vegetable stew simmered in tomato sauce with tamarind and chili, served over gluten-free rice and garnished with parsley and lime.~');
create_item(c, q'~Gluten-Free Senegalese Mafe~', q'~Beef stew in creamy peanut sauce with carrots, potatoes, and tomatoes. Served with gluten-free rice and spicy chili paste for a West African specialty.~');
create_item(c, q'~Gluten-Free Senegalese Sombi~', q'~Creamy gluten-free rice pudding cooked with coconut milk, vanilla, and sugar. Served chilled and garnished with toasted coconut flakes.~');
create_item(c, q'~Gluten-Free Senegalese Thiakry~', q'~Sweet gluten-free millet pudding with yogurt, raisins, coconut, and vanilla. Served chilled as a Senegalese dessert.~');
create_item(c, q'~Gluten-Free Senegalese Thieboudienne~', q'~Fish and vegetables simmered in tomato sauce with tamarind and chili, served over gluten-free rice and garnished with parsley and lime.~');
create_item(c, q'~Gluten-Free Senegalese Yassa~', q'~Chicken marinated in lemon juice, caramelized onions, and Dijon mustard, grilled and served with gluten-free rice and spicy chili sauce.~');
create_item(c, q'~Gluten-Free Senegalese Yassa Poisson~', q'~Grilled fish marinated in lemon, onions, mustard, and chili, served with gluten-free rice, vegetables, and spicy sauce for a Senegalese specialty.~');
create_item(c, q'~Gluten-Free South African Bobotie~', q'~Curried ground beef and dried fruit casserole topped with a savory egg custard. Baked until golden and served with gluten-free yellow rice, chutney, and sliced bananas for a sweet-savory balance.~');
create_item(c, q'~Gluten-Free South African Bunny Chow~', q'~Hollowed gluten-free bread loaf filled with spicy chicken curry, potatoes, and carrots. Garnished with fresh cilantro and served with pickled vegetables.~');
create_item(c, q'~Gluten-Free South African Chakalaka~', q'~Spicy vegetable relish made with beans, tomatoes, onions, carrots, and bell peppers. Served with gluten-free maize bread and grilled sausage for a South African barbecue side.~');
create_item(c, q'~Gluten-Free South African Koeksisters~', q'~Twisted gluten-free doughnuts soaked in spiced syrup, crispy outside and soft inside. Served as a South African sweet treat.~');
create_item(c, q'~Gluten-Free South African Malva Pudding~', q'~Warm gluten-free sponge pudding soaked in caramel sauce, served with vanilla custard and fresh berries for a South African dessert.~');
create_item(c, q'~Gluten-Free South African Melktert~', q'~Creamy gluten-free custard tart with a cinnamon-dusted crust, baked until golden and served chilled for a classic South African dessert.~');
create_item(c, q'~Gluten-Free South African Potjiekos~', q'~Slow-cooked stew of beef, vegetables, and potatoes, flavored with bay leaves, thyme, and garlic. Served with gluten-free maize porridge for a South African feast.~');
create_item(c, q'~Gluten-Free Spanish Paella~', q'~Traditional Valencian paella with saffron-infused gluten-free rice, plump shrimp, mussels, tender chicken, and smoky chorizo. Cooked in a wide pan for a crispy socarrat and finished with fresh parsley and lemon wedges.~');
create_item(c, q'~Gluten-Free Sri Lankan Hoppers~', q'~Bowl-shaped gluten-free rice flour pancakes with crispy edges and soft centers, served with coconut sambal, spicy egg curry, and onion relish.~');
create_item(c, q'~Gluten-Free Sri Lankan Kokis~', q'~Crispy gluten-free rice flour cookies fried in coconut oil, shaped with decorative molds and served during Sri Lankan festivals.~');
create_item(c, q'~Gluten-Free Sri Lankan Kottu~', q'~Chopped gluten-free roti stir-fried with vegetables, eggs, chicken, and curry spices. Finished with green chilies and lime wedges for a Sri Lankan specialty.~');
create_item(c, q'~Gluten-Free Sri Lankan Kottu Roti~', q'~Chopped gluten-free roti stir-fried with vegetables, eggs, and chicken, seasoned with curry spices and finished with green chilies and lime wedges.~');
create_item(c, q'~Gluten-Free Sri Lankan Pol Sambol~', q'~Spicy coconut relish made with grated coconut, red chili, lime juice, and onions. Served with gluten-free hoppers and egg curry for a Sri Lankan breakfast.~');
create_item(c, q'~Gluten-Free Sri Lankan Wattalappam~', q'~Rich coconut custard flavored with cardamom, nutmeg, and jaggery, baked until set and served chilled for a Sri Lankan treat.~');
create_item(c, q'~Gluten-Free Sushi Rolls~', q'~Traditional Japanese sushi rolls crafted with seasoned short-grain sushi rice and crisp, fresh vegetables such as cucumber, avocado, and carrot, all wrapped in premium nori seaweed. Served with gluten-free tamari soy sauce, pickled ginger, and wasabi for an authentic experience.~');
create_item(c, q'~Gluten-Free Swedish Meatballs~', q'~Juicy beef and pork meatballs seasoned with nutmeg and allspice, simmered in a rich gluten-free cream gravy. Served over buttery mashed potatoes and finished with lingonberry sauce.~');
create_item(c, q'~Gluten-Free Swiss Rösti~', q'~Shredded potatoes pan-fried until golden and crisp, topped with melted Gruyère cheese and served alongside gluten-free sausage and tangy apple compote.~');
create_item(c, q'~Gluten-Free Syrian Kibbeh~', q'~Baked gluten-free bulgur and ground beef dumplings seasoned with cinnamon, allspice, and pine nuts. Served with tangy yogurt sauce and fresh mint.~');
create_item(c, q'~Gluten-Free Thai Green Curry~', q'~Fragrant coconut milk-based curry simmered with tender chicken, bamboo shoots, bell peppers, and Thai basil. Served with gluten-free jasmine rice and garnished with kaffir lime leaves and red chili slices.~');
create_item(c, q'~Gluten-Free Thai Khanom Krok~', q'~Mini coconut rice pancakes with crispy edges and creamy centers, cooked in a cast iron pan and served with scallions and sweet corn.~');
create_item(c, q'~Gluten-Free Thai Khao Niao Mamuang~', q'~Sweet gluten-free sticky rice served with ripe mango slices and creamy coconut sauce. Garnished with toasted sesame seeds for a classic Thai dessert.~');
create_item(c, q'~Gluten-Free Thai Mango Sticky Rice~', q'~Sweet coconut-infused sticky rice served with ripe mango slices, toasted sesame seeds, and a drizzle of coconut cream. A classic Thai dessert, gluten-free and refreshing.~');
create_item(c, q'~Gluten-Free Thai Som Tum~', q'~Spicy green papaya salad with shredded papaya, tomatoes, green beans, peanuts, and dried shrimp. Tossed in a tangy lime-chili dressing and served gluten-free.~');
create_item(c, q'~Gluten-Free Thai Tom Yum Soup~', q'~Hot and sour soup with shrimp, mushrooms, lemongrass, galangal, and kaffir lime leaves. Finished with fresh cilantro and gluten-free chili paste for a bold Thai flavor.~');
create_item(c, q'~Gluten-Free Thai Tub Tim Grob~', q'~Crunchy water chestnuts coated in gluten-free tapioca, served in sweet coconut milk over crushed ice. A refreshing Thai dessert.~');
create_item(c, q'~Gluten-Free Tibetan Butter Tea~', q'~Traditional Tibetan tea blended with yak butter and salt, served hot alongside gluten-free tsampa barley flour energy balls. A warming Himalayan beverage.~');
create_item(c, q'~Gluten-Free Tibetan Dre-si~', q'~Sweet gluten-free rice pudding with raisins, dates, butter, and nuts, served during Tibetan celebrations and festivals.~');
create_item(c, q'~Gluten-Free Tibetan Sha Phaley~', q'~Pan-fried gluten-free pastry filled with spiced beef, cabbage, and onions. Served with chili sauce and Tibetan pickles for a hearty snack.~');
create_item(c, q'~Gluten-Free Tibetan Shapale~', q'~Pan-fried gluten-free pastry filled with spiced beef, onions, and cabbage. Served with chili sauce and Tibetan pickles for a hearty snack.~');
create_item(c, q'~Gluten-Free Tibetan Thenthuk~', q'~Hand-pulled gluten-free noodle soup with beef, daikon, spinach, and carrots. Flavored with ginger, garlic, and Tibetan spices for a warming meal.~');
create_item(c, q'~Gluten-Free Tibetan Thukpa~', q'~Hearty Himalayan noodle soup with gluten-free rice noodles, tender beef, carrots, daikon, and spinach. Flavored with ginger, garlic, and Tibetan spices for warmth and comfort.~');
create_item(c, q'~Gluten-Free Tibetan Tsampa~', q'~Roasted gluten-free barley flour mixed with butter tea, shaped into energy balls and served as a Tibetan snack for travelers and monks.~');
create_item(c, q'~Gluten-Free Tunisian Brik~', q'~Crispy gluten-free pastry filled with a whole egg, tuna, capers, and parsley, deep-fried until golden. Served with lemon wedges and harissa for dipping.~');
create_item(c, q'~Gluten-Free Tunisian Couscous~', q'~Gluten-free millet couscous topped with slow-braised lamb, carrots, zucchini, chickpeas, and spicy harissa sauce. Garnished with fresh coriander and lemon wedges.~');
create_item(c, q'~Gluten-Free Tunisian Fricassee~', q'~Fried gluten-free rolls filled with tuna, olives, harissa, boiled eggs, and potatoes. Topped with pickled vegetables and served as a Tunisian street food.~');
create_item(c, q'~Gluten-Free Tunisian Lablabi~', q'~Spicy chickpea soup flavored with garlic, cumin, harissa, and olive oil. Served with gluten-free bread, capers, and boiled eggs for a Tunisian breakfast.~');
create_item(c, q'~Gluten-Free Tunisian Makroud~', q'~Gluten-free semolina pastries filled with dates and nuts, fried and soaked in honey syrup. Served as a Tunisian dessert during festivals.~');
create_item(c, q'~Gluten-Free Tunisian Ojja~', q'~Eggs poached in spicy tomato and bell pepper sauce, flavored with garlic, cumin, and harissa. Served with gluten-free bread for dipping.~');
create_item(c, q'~Gluten-Free Tunisian Yoyos~', q'~Gluten-free doughnuts flavored with orange zest, fried and glazed with honey syrup. Served as a Tunisian sweet treat.~');
create_item(c, q'~Gluten-Free Turkish Baklava~', q'~Delicate layers of gluten-free phyllo pastry filled with chopped walnuts and pistachios, baked and soaked in fragrant honey syrup. Finished with a sprinkle of crushed nuts.~');
create_item(c, q'~Gluten-Free Turkish Lentil Soup~', q'~Hearty red lentil soup simmered with carrots, onions, cumin, paprika, and a touch of tomato paste. Finished with a squeeze of lemon and fresh parsley, served with gluten-free flatbread.~');
create_item(c, q'~Gluten-Free Vietnamese Banh Cam~', q'~Gluten-free sesame balls filled with sweet mung bean paste, fried until golden and crispy. Served as a Vietnamese street dessert.~');
create_item(c, q'~Gluten-Free Vietnamese Banh Cuon~', q'~Steamed gluten-free rice rolls filled with ground pork, wood ear mushrooms, and shallots. Topped with fried shallots and served with fish sauce dipping sauce.~');
create_item(c, q'~Gluten-Free Vietnamese Banh Xeo~', q'~Crispy turmeric rice flour crepes filled with shrimp, pork, and bean sprouts. Served with fresh herbs, lettuce leaves, and a tangy dipping sauce for wrapping and dipping.~');
create_item(c, q'~Gluten-Free Vietnamese Banh Xeo Chay~', q'~Crispy gluten-free turmeric crepes filled with mushrooms, bean sprouts, and tofu. Served with fresh herbs, lettuce, and tangy dipping sauce for a vegetarian Vietnamese dish.~');
create_item(c, q'~Gluten-Free Vietnamese Bun Cha~', q'~Grilled pork patties and sliced pork belly served over gluten-free rice noodles, fresh herbs, pickled carrots, and a tangy dipping sauce.~');
create_item(c, q'~Gluten-Free Vietnamese Che Ba Mau~', q'~Three-color dessert of sweet beans, pandan jelly, and coconut milk, served over crushed ice and topped with candied fruit.~');
create_item(c, q'~Gluten-Free Vietnamese Goi Cuon~', q'~Fresh spring rolls wrapped in gluten-free rice paper, filled with shrimp, pork, vermicelli noodles, and fresh herbs. Served with gluten-free peanut dipping sauce.~');
create_item(c, q'~Gluten-Free Vietnamese Pho~', q'~Aromatic Vietnamese beef broth simmered for hours with star anise, cinnamon, and cloves, poured over gluten-free rice noodles. Topped with thinly sliced beef, fresh basil, cilantro, bean sprouts, jalapeños, and a squeeze of lime.~');
create_item(c, q'~Gluten-Free Zimbabwean Chikenduza~', q'~Gluten-free sponge cake squares topped with pink icing and sprinkles, a popular Zimbabwean bakery treat.~');
create_item(c, q'~Gluten-Free Zimbabwean Maputi~', q'~Popped gluten-free maize kernels, lightly salted and served as a crunchy snack. A traditional Zimbabwean street food.~');
create_item(c, q'~Gluten-Free Zimbabwean Muboora~', q'~Pumpkin leaves sautéed with onions, tomatoes, and garlic, served with gluten-free sadza maize porridge and beef stew.~');
create_item(c, q'~Gluten-Free Zimbabwean Muriwo Unedovi~', q'~Leafy greens cooked in creamy peanut sauce, served with gluten-free sadza maize porridge and grilled beef stew.~');
create_item(c, q'~Gluten-Free Zimbabwean Nyama ne Muriwo~', q'~Beef and leafy greens cooked in tomato sauce, served with gluten-free sadza maize porridge and spicy chili sauce.~');
create_item(c, q'~Gluten-Free Zimbabwean Sadza~', q'~Thick porridge made from gluten-free maize meal, served with slow-cooked beef stew, sautéed collard greens, and tomato relish.~');
create_item(c, q'~Gluten-Free Zimbabwean Sadza ne Nyama~', q'~Gluten-free maize porridge served with slow-cooked beef stew, sautéed greens, and tomato relish for a Zimbabwean feast.~');


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


    

