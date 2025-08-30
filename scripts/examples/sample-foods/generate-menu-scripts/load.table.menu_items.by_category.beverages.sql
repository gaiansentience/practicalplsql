prompt loading menu items for category: Beverages
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
 

    c := 'Beverages';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Agua Fresca de Sandía~', q'~Mexican watermelon drink blended with fresh watermelon, lime juice, and a touch of sugar, served over ice for a refreshing summer treat.~');
create_item(c, q'~Almond Horchata~', q'~Spanish-inspired dairy-free drink made from ground almonds, rice, cinnamon, and vanilla, blended and served over ice.~');
create_item(c, q'~Apple Cider~', q'~Fresh-pressed apple juice spiced with cinnamon and cloves, served hot or cold. Gluten-free and vegan.~');
create_item(c, q'~Atole~', q'~Traditional Mexican hot beverage made from masa harina, piloncillo, cinnamon, and vanilla, thickened to a creamy consistency and served steaming hot.~');
create_item(c, q'~Ayran~', q'~Turkish savory yogurt drink made by whisking yogurt, water, and salt until frothy. Served chilled, perfect for hot days.~');
create_item(c, q'~Black Sesame Soy Latte~', q'~Asian-inspired latte made with espresso, steamed soy milk, and black sesame syrup, topped with toasted sesame seeds.~');
create_item(c, q'~Brazilian Guaraná Soda~', q'~Lightly carbonated soda made from Amazonian guaraná berries, offering a unique fruity flavor and natural caffeine boost.~');
create_item(c, q'~Bubble Tea~', q'~Taiwanese milk tea shaken with chewy tapioca pearls, sweetened with brown sugar syrup, and served with a wide straw. Available in assorted flavors.~');
create_item(c, q'~Café Bombón~', q'~Spanish espresso layered with sweetened condensed milk, creating a visually striking and deliciously sweet coffee treat.~');
create_item(c, q'~Café Cubano~', q'~Cuban espresso brewed with sugar, creating a thick, sweet crema. Served in a small cup for a bold pick-me-up.~');
create_item(c, q'~Café au Lait~', q'~French-style coffee made with equal parts brewed coffee and steamed milk, served in a large bowl for a comforting morning ritual.~');
create_item(c, q'~Café de Olla~', q'~Mexican spiced coffee brewed in a clay pot with cinnamon sticks and piloncillo (unrefined cane sugar), imparting earthy and sweet notes.~');
create_item(c, q'~Cantaloupe Agua Fresca~', q'~Mexican-style drink made by blending fresh cantaloupe with water, lime juice, and sugar, served over ice.~');
create_item(c, q'~Cappuccino~', q'~Classic Italian coffee drink with equal parts espresso, steamed milk, and frothy milk foam. Served hot and dusted with cocoa powder.~');
create_item(c, q'~Carrot Orange Juice~', q'~Freshly pressed juice combining sweet carrots and tangy oranges, packed with vitamin C and beta-carotene. Vegan and gluten-free.~');
create_item(c, q'~Chai Latte~', q'~Spiced black tea steamed with milk and sweetened with honey, topped with a sprinkle of cinnamon. Comforting and aromatic.~');
create_item(c, q'~Chicha Morada~', q'~Peruvian purple corn drink simmered with pineapple, cinnamon, cloves, and lime juice. Served cold, naturally gluten-free.~');
create_item(c, q'~Chrysanthemum Tea~', q'~Chinese herbal tea brewed from dried chrysanthemum flowers, lightly sweetened and served hot or cold. Delicate and caffeine-free.~');
create_item(c, q'~Coconut Blackberry Lemonade~', q'~Lemonade infused with coconut water and fresh blackberries, served over ice for a bold, tropical twist.~');
create_item(c, q'~Coconut Blackberry Smoothie~', q'~Blended coconut milk, blackberries, and chia seeds, served chilled for a creamy, vegan-friendly treat.~');
create_item(c, q'~Coconut Blueberry Lemonade~', q'~Lemonade infused with coconut water and fresh blueberries, served over ice for a vibrant, tropical twist.~');
create_item(c, q'~Coconut Blueberry Smoothie~', q'~Blended coconut milk, blueberries, and chia seeds, served chilled for a creamy, vegan-friendly treat.~');
create_item(c, q'~Coconut Chai~', q'~Spiced black tea brewed with coconut milk, cardamom, cinnamon, and ginger, served hot for a creamy, aromatic twist.~');
create_item(c, q'~Coconut Kiwi Agua Fresca~', q'~Refreshing blend of coconut water, kiwi puree, and lime juice, served over ice.~');
create_item(c, q'~Coconut Kiwi Lemonade~', q'~Lemonade infused with coconut water and fresh kiwi, served over ice for a tart, tropical twist.~');
create_item(c, q'~Coconut Kiwi Smoothie~', q'~Blended coconut milk, kiwi, and chia seeds, served chilled for a creamy, vegan-friendly treat.~');
create_item(c, q'~Coconut Lemon Smoothie~', q'~Blended coconut milk, lemon juice, and oat milk, served chilled for a tangy, creamy treat.~');
create_item(c, q'~Coconut Lemonade~', q'~Classic lemonade infused with coconut water, served over ice for a hydrating, tropical twist.~');
create_item(c, q'~Coconut Lemonade Smoothie~', q'~Blended coconut milk, lemonade, and oat milk, served chilled for a tangy, creamy treat.~');
create_item(c, q'~Coconut Lychee Cooler~', q'~Coconut water blended with lychee juice and lime, served over ice for a sweet, exotic refreshment.~');
create_item(c, q'~Coconut Mango Agua Fresca~', q'~Refreshing blend of coconut water, mango puree, and lime juice, served over ice.~');
create_item(c, q'~Coconut Mango Lemonade~', q'~Lemonade infused with coconut water and ripe mango, served over ice for a sweet, tropical twist.~');
create_item(c, q'~Coconut Mango Smoothie~', q'~Blended coconut milk, mango, and chia seeds, served chilled for a creamy, vegan-friendly treat.~');
create_item(c, q'~Coconut Matcha Frappe~', q'~Iced Japanese matcha blended with coconut milk and ice, topped with toasted coconut flakes for a creamy, tropical treat.~');
create_item(c, q'~Coconut Matcha Latte~', q'~Japanese matcha whisked with steamed coconut milk, lightly sweetened and topped with toasted coconut.~');
create_item(c, q'~Coconut Orange Agua Fresca~', q'~Refreshing blend of coconut water, orange juice, and lime, served over ice.~');
create_item(c, q'~Coconut Passionfruit Lemonade~', q'~Lemonade infused with coconut water and passionfruit, served over ice for a tangy, tropical twist.~');
create_item(c, q'~Coconut Passionfruit Smoothie~', q'~Blended coconut milk, passionfruit, and chia seeds, served chilled for a creamy, vegan-friendly treat.~');
create_item(c, q'~Coconut Peach Agua Fresca~', q'~Refreshing blend of coconut water, peach puree, and lime juice, served over ice.~');
create_item(c, q'~Coconut Peach Lemonade~', q'~Lemonade infused with coconut water and ripe peach, served over ice for a sweet, tropical twist.~');
create_item(c, q'~Coconut Peach Smoothie~', q'~Blended coconut milk, peach, and chia seeds, served chilled for a creamy, vegan-friendly treat.~');
create_item(c, q'~Coconut Pineapple Agua Fresca~', q'~Refreshing blend of coconut water, pineapple juice, and lime, served over ice for a tropical twist.~');
create_item(c, q'~Coconut Pineapple Lemonade~', q'~Lemonade infused with coconut water and fresh pineapple juice, served over ice for a sweet, tropical twist.~');
create_item(c, q'~Coconut Pineapple Smoothie~', q'~Blended coconut milk, pineapple, and chia seeds, served chilled for a creamy, vegan-friendly treat.~');
create_item(c, q'~Coconut Raspberry Lemonade~', q'~Lemonade infused with coconut water and fresh raspberries, served over ice for a tangy, tropical twist.~');
create_item(c, q'~Coconut Raspberry Smoothie~', q'~Blended coconut milk, raspberries, and chia seeds, served chilled for a creamy, vegan-friendly treat.~');
create_item(c, q'~Coconut Rose Smoothie~', q'~Blended coconut milk, rose water, banana, and chia seeds, served chilled for a floral, creamy treat.~');
create_item(c, q'~Coconut Strawberry Smoothie~', q'~Blended coconut milk, strawberries, and chia seeds, served chilled for a creamy, vegan-friendly treat.~');
create_item(c, q'~Coconut Water~', q'~Pure, naturally sweet water extracted from young green coconuts. Hydrating and packed with electrolytes, served chilled.~');
create_item(c, q'~Coconut Watermelon Agua Fresca~', q'~Coconut water blended with fresh watermelon and lime, served over ice for a hydrating summer drink.~');
create_item(c, q'~Cranberry Spritzer~', q'~Tart cranberry juice blended with sparkling water and a hint of lime, served over ice for a refreshing, low-calorie beverage.~');
create_item(c, q'~Cucumber Basil Lemonade~', q'~Fresh cucumber and basil muddled with lemon juice and simple syrup, topped with sparkling water and served over ice.~');
create_item(c, q'~Cucumber Mint Cooler~', q'~Fresh cucumber juice blended with mint leaves, lime, and sparkling water. Light, hydrating, and vegan-friendly.~');
create_item(c, q'~Elderflower Fizz~', q'~Sparkling beverage made with elderflower syrup, lemon juice, and soda water. Light, floral, and gluten-free.~');
create_item(c, q'~Espresso~', q'~A strong, concentrated shot of Italian coffee brewed under pressure, served in a small cup. Rich, bold, and aromatic.~');
create_item(c, q'~Falooda~', q'~Indian dessert drink with rose syrup, vermicelli noodles, basil seeds, milk, and ice cream. Colorful, sweet, and texturally unique.~');
create_item(c, q'~Ginger Beer~', q'~Spicy, non-alcoholic fermented beverage made from ginger root, sugar, and lemon juice. Served chilled and naturally gluten-free.~');
create_item(c, q'~Ginger Lemongrass Tea~', q'~Herbal infusion of fresh ginger root and lemongrass, steeped and served hot or iced. Zesty and caffeine-free.~');
create_item(c, q'~Golden Milk~', q'~Ayurvedic turmeric latte made with steamed milk, turmeric, ginger, cinnamon, and honey. Anti-inflammatory and comforting, served hot.~');
create_item(c, q'~Herbal Tea~', q'~Caffeine-free tea brewed from a blend of dried herbs, flowers, and fruits. Served hot or iced, with a variety of flavors available.~');
create_item(c, q'~Honeydew Melon Juice~', q'~Fresh honeydew melon blended with lime juice and a touch of honey, served chilled for a naturally sweet refreshment.~');
create_item(c, q'~Horchata~', q'~Mexican rice milk drink blended with cinnamon, vanilla, and sweetened with sugar. Served chilled over ice, naturally dairy-free and vegan.~');
create_item(c, q'~Hot Chocolate~', q'~A decadent drink made from rich cocoa powder and steamed milk, sweetened to perfection and topped with a generous swirl of whipped cream and chocolate shavings. Perfect for warming up on a chilly day.~');
create_item(c, q'~Iced Coffee~', q'~Freshly brewed coffee chilled and poured over ice, served with your choice of milk or sweetener. A refreshing pick-me-up for any time of day.~');
create_item(c, q'~Iced Tea~', q'~Refreshing black tea brewed and chilled over ice, served with a slice of lemon and a touch of sweetness. A classic, thirst-quenching beverage ideal for hot weather.~');
create_item(c, q'~Japanese Plum Soda~', q'~Sparkling soda made with umeboshi (pickled Japanese plums), simple syrup, and soda water. Sweet, tart, and unique.~');
create_item(c, q'~Japanese Yuzu Lemonade~', q'~Citrusy lemonade made with Japanese yuzu juice, simple syrup, and sparkling water. Bright, aromatic, and thirst-quenching.~');
create_item(c, q'~Kashmiri Kahwa~', q'~Fragrant green tea from Kashmir infused with saffron, cardamom, cinnamon, and almonds. Served hot, perfect for cold evenings.~');
create_item(c, q'~Kombucha~', q'~Fermented tea beverage made with black or green tea, sugar, and a symbiotic culture of bacteria and yeast (SCOBY). Slightly effervescent and tangy, available in various flavors.~');
create_item(c, q'~Lassi~', q'~Indian yogurt-based drink blended with water, sugar, and cardamom. Available sweet or salty, and sometimes flavored with mango or rosewater.~');
create_item(c, q'~Lemonade~', q'~Refreshing beverage made from freshly squeezed lemons, pure cane sugar, and cold water, served over ice with a slice of lemon.~');
create_item(c, q'~Lychee Soda~', q'~Sparkling beverage made with sweet lychee juice, soda water, and a hint of lime. Exotic and refreshing.~');
create_item(c, q'~Mango Coconut Smoothie~', q'~Blended mango, coconut milk, and ice, topped with toasted coconut flakes. Vegan and gluten-free.~');
create_item(c, q'~Mango Lassi~', q'~Indian yogurt drink blended with ripe mango, cardamom, and a touch of honey. Creamy, sweet, and cooling.~');
create_item(c, q'~Margarita~', q'~A refreshing cocktail crafted with premium tequila, freshly squeezed lime juice, and orange-flavored triple sec, shaken with ice and served in a salt-rimmed glass. Garnished with a lime wedge for a zesty finish.~');
create_item(c, q'~Masala Chai~', q'~Traditional Indian spiced tea brewed with black tea leaves, cardamom, cinnamon, ginger, cloves, and milk. Aromatic and warming, perfect for chilly mornings.~');
create_item(c, q'~Matcha Latte~', q'~A soothing beverage made by whisking finely ground Japanese matcha green tea powder with steamed milk, creating a creamy, frothy drink with a vibrant green color and earthy, slightly sweet flavor.~');
create_item(c, q'~Matcha Lemonade~', q'~Japanese matcha green tea whisked with fresh lemon juice and simple syrup, served over ice for a vibrant, tangy refreshment.~');
create_item(c, q'~Moroccan Mint Tea~', q'~Green tea steeped with fresh mint leaves and sweetened with sugar, poured from a height for a frothy finish. A symbol of Moroccan hospitality.~');
create_item(c, q'~Mulled Wine~', q'~Non-alcoholic version of classic European winter beverage, made with grape juice, orange peel, cinnamon, cloves, and star anise, served warm.~');
create_item(c, q'~Pandan Iced Latte~', q'~Southeast Asian-inspired latte featuring espresso, steamed milk, and fragrant pandan syrup, served over ice for a unique twist.~');
create_item(c, q'~Papaya Milk~', q'~Taiwanese-style drink made by blending ripe papaya with milk and ice, creating a creamy, fruity beverage.~');
create_item(c, q'~Peach Iced Tea~', q'~Black tea brewed and chilled with ripe peach puree, sweetened and served over ice. Fruity and aromatic.~');
create_item(c, q'~Persian Doogh~', q'~Savory Persian yogurt drink mixed with water, salt, and dried mint, served cold and frothy.~');
create_item(c, q'~Pineapple Ginger Juice~', q'~Tropical juice blend of fresh pineapple and spicy ginger root, sweetened lightly and served chilled.~');
create_item(c, q'~Pomegranate Mojito~', q'~Virgin mojito made with muddled mint, lime, pomegranate juice, and sparkling water. Tart, sweet, and refreshing.~');
create_item(c, q'~Rooibos Latte~', q'~South African red bush tea steamed with milk and honey, caffeine-free and packed with antioxidants. Served hot or iced.~');
create_item(c, q'~Rose Lemonade~', q'~Delicate lemonade infused with rose water and garnished with edible rose petals. Floral, refreshing, and vegan-friendly.~');
create_item(c, q'~Sahlab~', q'~Middle Eastern hot drink made from orchid root flour, milk, sugar, and orange blossom water, topped with cinnamon and chopped pistachios.~');
create_item(c, q'~Salep~', q'~Turkish winter drink made from powdered orchid tubers, milk, sugar, and cinnamon. Thick, creamy, and fragrant.~');
create_item(c, q'~Sangria Mocktail~', q'~Non-alcoholic Spanish punch made with grape juice, orange juice, chopped fruits, and a splash of sparkling water. Fruity and festive.~');
create_item(c, q'~Sicilian Blood Orange Soda~', q'~Sparkling Italian soda made with Sicilian blood orange juice, offering a sweet-tart flavor and vibrant color.~');
create_item(c, q'~Sikhye~', q'~Korean sweet rice drink made by fermenting cooked rice and malt, served chilled with floating grains of rice. Mildly sweet and refreshing.~');
create_item(c, q'~Smoothie~', q'~A thick, blended beverage made from fresh fruit, yogurt, and juice or milk. Served chilled and packed with vitamins and flavor.~');
create_item(c, q'~Soursop Banana Smoothie~', q'~Soursop pulp blended with ripe banana and oat milk, served chilled for a creamy, vegan-friendly beverage.~');
create_item(c, q'~Soursop Blackberry Juice~', q'~Soursop pulp blended with fresh blackberries and lime juice, served chilled for a bold, vitamin-rich beverage.~');
create_item(c, q'~Soursop Blackberry Lemonade~', q'~Lemonade infused with soursop pulp and fresh blackberries, served over ice for a bold, tropical twist.~');
create_item(c, q'~Soursop Blackberry Smoothie~', q'~Blended soursop pulp, blackberries, and almond milk, served chilled for a bold, creamy treat.~');
create_item(c, q'~Soursop Blueberry Lemonade~', q'~Lemonade infused with soursop pulp and fresh blueberries, served over ice for a vibrant, tropical twist.~');
create_item(c, q'~Soursop Blueberry Smoothie~', q'~Blended soursop pulp, blueberries, and coconut milk, served chilled for a vibrant, antioxidant-rich treat.~');
create_item(c, q'~Soursop Coconut Smoothie~', q'~Creamy smoothie made from soursop pulp, coconut milk, and ice, blended until silky and tropical.~');
create_item(c, q'~Soursop Ginger Juice~', q'~Soursop pulp blended with fresh ginger root, lime juice, and honey, served chilled for a spicy tropical refreshment.~');
create_item(c, q'~Soursop Juice~', q'~Tropical Caribbean drink made from soursop fruit pulp, blended with water and a touch of sugar. Creamy, fragrant, and vitamin-rich.~');
create_item(c, q'~Soursop Kiwi Juice~', q'~Soursop pulp blended with kiwi fruit and lime juice, served chilled for a tart, vitamin-rich beverage.~');
create_item(c, q'~Soursop Kiwi Lemonade~', q'~Lemonade infused with soursop pulp and fresh kiwi, served over ice for a tart, tropical twist.~');
create_item(c, q'~Soursop Kiwi Smoothie~', q'~Blended soursop pulp, kiwi, and almond milk, served chilled for a tart, creamy treat.~');
create_item(c, q'~Soursop Lemon Smoothie~', q'~Blended soursop pulp, lemon juice, and oat milk, served chilled for a tangy, creamy treat.~');
create_item(c, q'~Soursop Lemonade~', q'~Tropical lemonade made with soursop pulp, fresh lemon juice, and a touch of agave syrup, served over ice.~');
create_item(c, q'~Soursop Mango Juice~', q'~Soursop pulp blended with ripe mango and lime juice, served chilled for a sweet, tropical beverage.~');
create_item(c, q'~Soursop Mango Lemonade~', q'~Lemonade infused with soursop pulp and ripe mango, served over ice for a sweet, tropical twist.~');
create_item(c, q'~Soursop Mango Smoothie~', q'~Blended soursop pulp, mango, and oat milk, served chilled for a sweet, creamy treat.~');
create_item(c, q'~Soursop Mint Cooler~', q'~Soursop juice blended with fresh mint leaves, lime, and sparkling water. Light, tangy, and vegan-friendly.~');
create_item(c, q'~Soursop Orange Juice~', q'~Soursop pulp blended with fresh orange juice and a touch of honey, served over ice for a sweet, tangy refreshment.~');
create_item(c, q'~Soursop Orange Lemonade~', q'~Lemonade infused with soursop pulp and fresh orange juice, served over ice for a tangy, tropical twist.~');
create_item(c, q'~Soursop Orange Smoothie~', q'~Blended soursop pulp, orange juice, and almond milk, served chilled for a tangy, creamy treat.~');
create_item(c, q'~Soursop Passionfruit Juice~', q'~Tropical blend of soursop pulp and passionfruit juice, sweetened and served chilled.~');
create_item(c, q'~Soursop Peach Juice~', q'~Soursop pulp blended with ripe peach and lime juice, served chilled for a sweet, vitamin-rich beverage.~');
create_item(c, q'~Soursop Peach Lemonade~', q'~Lemonade infused with soursop pulp and ripe peach, served over ice for a sweet, tropical twist.~');
create_item(c, q'~Soursop Peach Smoothie~', q'~Blended soursop pulp, peach, and oat milk, served chilled for a sweet, creamy treat.~');
create_item(c, q'~Soursop Pineapple Juice~', q'~Tropical blend of soursop pulp and fresh pineapple juice, sweetened lightly and served over ice.~');
create_item(c, q'~Soursop Pineapple Lemonade~', q'~Lemonade infused with soursop pulp and fresh pineapple juice, served over ice for a sweet, tropical twist.~');
create_item(c, q'~Soursop Pineapple Smoothie~', q'~Blended soursop pulp, pineapple, and coconut milk, served chilled for a creamy, tropical treat.~');
create_item(c, q'~Soursop Raspberry Smoothie~', q'~Blended soursop pulp, raspberries, and almond milk, served chilled for a fruity, creamy treat.~');
create_item(c, q'~Soursop Strawberry Lemonade~', q'~Lemonade infused with soursop pulp and fresh strawberries, served over ice for a tangy, tropical twist.~');
create_item(c, q'~Soursop Strawberry Smoothie~', q'~Blended soursop pulp, strawberries, and almond milk, served chilled for a fruity, creamy treat.~');
create_item(c, q'~Spiced Pumpkin Latte~', q'~Espresso steamed with milk, pumpkin puree, cinnamon, nutmeg, and clove, topped with whipped cream and pumpkin seeds.~');
create_item(c, q'~Tamarind Agua Fresca~', q'~Mexican tamarind drink made by steeping tamarind pods, straining, and sweetening with sugar. Served chilled over ice.~');
create_item(c, q'~Tamarind Juice~', q'~Sweet and tangy beverage made from tamarind pulp, sugar, and water. Popular in Latin America and Southeast Asia.~');
create_item(c, q'~Taro Bubble Tea~', q'~Creamy Taiwanese milk tea flavored with sweet taro root and chewy tapioca pearls, served cold with a wide straw.~');
create_item(c, q'~Teh Tarik~', q'~Malaysian pulled tea made by pouring strong black tea and condensed milk back and forth between two containers, creating a frothy top.~');
create_item(c, q'~Thai Iced Tea~', q'~Sweet and creamy orange-hued tea made with strong black tea, star anise, and condensed milk, served over ice. A classic Thai refreshment.~');
create_item(c, q'~Turkish Coffee~', q'~Finely ground coffee simmered in a cezve with sugar and cardamom, served unfiltered in a small cup. Rich, thick, and aromatic, with grounds settling at the bottom.~');
create_item(c, q'~Ube Milkshake~', q'~Filipino-inspired shake made with purple yam (ube), milk, and ice cream, blended until creamy and vibrantly colored.~');
create_item(c, q'~Vietnamese Egg Coffee~', q'~Rich Vietnamese coffee topped with a creamy, sweet foam made from whipped egg yolks and condensed milk. Served hot in a small cup.~');
create_item(c, q'~Vietnamese Iced Coffee~', q'~Strong Vietnamese coffee brewed with a phin filter, poured over ice and sweetened with condensed milk. Bold and creamy.~');
create_item(c, q'~Yerba Mate~', q'~South American herbal infusion made from dried yerba mate leaves, traditionally served in a hollowed gourd and sipped through a metal straw (bombilla).~');


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


    

