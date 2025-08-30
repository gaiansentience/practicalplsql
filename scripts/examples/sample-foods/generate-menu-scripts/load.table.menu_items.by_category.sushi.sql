prompt loading menu items for category: Sushi
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
 

    c := 'Sushi';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Albacore Tataki~', q'~Seared albacore tuna sashimi, served with ponzu sauce and crispy onions.~');
create_item(c, q'~Asparagus Roll~', q'~Blanched asparagus spears rolled in sushi rice and nori, garnished with sesame seeds.~');
create_item(c, q'~Avocado Roll~', q'~Creamy avocado slices rolled with sushi rice and nori, garnished with sesame seeds.~');
create_item(c, q'~California Roll~', q'~Crab stick, avocado, and cucumber rolled in sushi rice and nori, topped with sesame seeds.~');
create_item(c, q'~Crab Cucumber Roll~', q'~Crab meat and cucumber rolled in sushi rice and nori, topped with tobiko.~');
create_item(c, q'~Crab Stick Nigiri~', q'~Imitation crab stick placed atop sushi rice, wrapped with a strip of nori.~');
create_item(c, q'~Crab Tempura Roll~', q'~Tempura crab, avocado, and cucumber rolled in sushi rice and nori, topped with spicy mayo.~');
create_item(c, q'~Crispy Rice Spicy Tuna~', q'~Spicy tuna tartare served atop crispy fried sushi rice squares.~');
create_item(c, q'~Cucumber Roll~', q'~Fresh cucumber strips rolled in sushi rice and nori, a refreshing vegetarian option.~');
create_item(c, q'~Dragon Roll~', q'~Tempura shrimp, cucumber, and avocado rolled in nori, topped with grilled eel and drizzled with eel sauce.~');
create_item(c, q'~Ebi Sushi~', q'~Succulent poached shrimp laid over seasoned sushi rice, garnished with a touch of wasabi.~');
create_item(c, q'~Eel Avocado Roll~', q'~Grilled eel and avocado rolled in sushi rice and nori, drizzled with sweet eel sauce.~');
create_item(c, q'~Eggplant Sushi~', q'~Grilled eggplant slices brushed with miso glaze, served atop sushi rice.~');
create_item(c, q'~Fatty Tuna Sashimi~', q'~Premium otoro tuna belly, sliced and served with wasabi and soy sauce.~');
create_item(c, q'~Hamachi Sashimi~', q'~Delicate slices of yellowtail, served with ponzu sauce and fresh jalapeño.~');
create_item(c, q'~Hokkigai Nigiri~', q'~Surf clam slices placed atop sushi rice, finished with a touch of lemon.~');
create_item(c, q'~Ikura Gunkan~', q'~Sushi rice wrapped in nori and topped with glistening salmon roe.~');
create_item(c, q'~Kampyo Roll~', q'~Sweet simmered gourd strips rolled in sushi rice and nori.~');
create_item(c, q'~King Crab Nigiri~', q'~Succulent king crab leg meat placed atop sushi rice, finished with a touch of lemon.~');
create_item(c, q'~Lobster Roll~', q'~Lobster salad, avocado, and cucumber rolled in sushi rice and nori, topped with tobiko.~');
create_item(c, q'~Mackerel Sashimi~', q'~Fresh mackerel fillets, lightly cured and served with grated ginger and scallions.~');
create_item(c, q'~Maguro Tataki~', q'~Seared tuna sashimi, served with ponzu sauce and scallions.~');
create_item(c, q'~Miso Glazed Salmon Roll~', q'~Broiled salmon glazed with miso, avocado, and cucumber rolled in sushi rice and nori.~');
create_item(c, q'~Octopus Nigiri~', q'~Tender slices of octopus placed atop seasoned sushi rice, finished with a brush of soy glaze.~');
create_item(c, q'~Oshinko Roll~', q'~Pickled radish rolled in sushi rice and nori, a crunchy and tangy vegetarian choice.~');
create_item(c, q'~Rainbow Roll~', q'~California roll topped with assorted sashimi slices: tuna, salmon, shrimp, and avocado.~');
create_item(c, q'~Saba Nigiri~', q'~Cured mackerel fillet placed atop sushi rice, garnished with ginger and scallions.~');
create_item(c, q'~Salmon Avocado Roll~', q'~Fresh salmon and creamy avocado rolled in sushi rice and nori.~');
create_item(c, q'~Salmon Mango Roll~', q'~Fresh salmon and sweet mango rolled in sushi rice and nori, topped with spicy mayo.~');
create_item(c, q'~Salmon Nigiri~', q'~Hand-pressed sushi rice topped with fresh, buttery salmon slices. Served with wasabi and soy sauce.~');
create_item(c, q'~Salmon Roe Nigiri~', q'~Sushi rice wrapped in nori and topped with bright, briny salmon roe.~');
create_item(c, q'~Salmon Sashimi~', q'~Fresh salmon fillet, expertly sliced and served with wasabi and soy sauce.~');
create_item(c, q'~Salmon Skin Roll~', q'~Crispy salmon skin, cucumber, and sprouts rolled in nori and sushi rice, topped with sweet eel sauce.~');
create_item(c, q'~Scallop Nigiri~', q'~Sweet, tender scallop slices on hand-pressed sushi rice, finished with a touch of yuzu zest.~');
create_item(c, q'~Sea Urchin Nigiri~', q'~Rich and creamy uni placed atop sushi rice, finished with a touch of wasabi.~');
create_item(c, q'~Shiitake Mushroom Roll~', q'~Marinated shiitake mushrooms, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Shiso Leaf Roll~', q'~Fresh shiso leaves, cucumber, and pickled plum rolled in sushi rice and nori.~');
create_item(c, q'~Shrimp Tempura Roll~', q'~Crunchy shrimp tempura, avocado, and cucumber rolled in sushi rice and nori, topped with spicy mayo.~');
create_item(c, q'~Snow Crab Roll~', q'~Snow crab, avocado, and cucumber rolled in sushi rice and nori, topped with spicy mayo.~');
create_item(c, q'~Soft Shell Crab Roll~', q'~Crispy fried soft shell crab, cucumber, and lettuce rolled in nori and sushi rice.~');
create_item(c, q'~Spicy Crab Avocado Roll~', q'~Spicy crab salad, avocado, and cucumber rolled in sushi rice and nori.~');
create_item(c, q'~Spicy Crab Boston Roll~', q'~Spicy crab, lettuce, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Crab Crunch Roll~', q'~Spicy crab, avocado, and cucumber rolled in nori, topped with crispy tempura flakes.~');
create_item(c, q'~Spicy Crab Dragon Roll~', q'~Spicy crab, avocado, and cucumber rolled in nori, topped with grilled eel and drizzled with eel sauce.~');
create_item(c, q'~Spicy Crab Philly Roll~', q'~Spicy crab, cream cheese, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Crab Rainbow Roll~', q'~Spicy crab, avocado, and cucumber rolled in nori, topped with assorted sashimi slices.~');
create_item(c, q'~Spicy Crab Roll~', q'~Real crab meat mixed with spicy mayo, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Spicy Crab Volcano Roll~', q'~Spicy crab, avocado, and cucumber rolled in nori, topped with baked spicy seafood and volcano sauce.~');
create_item(c, q'~Spicy Eggplant Roll~', q'~Grilled eggplant mixed with spicy sauce, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Spicy Lobster Roll~', q'~Lobster salad mixed with spicy mayo, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Spicy Octopus Roll~', q'~Chopped octopus mixed with spicy sauce, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Spicy Salmon Boston Roll~', q'~Spicy salmon, lettuce, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Salmon Crunch Roll~', q'~Spicy salmon, avocado, and cucumber rolled in nori, topped with crispy tempura flakes.~');
create_item(c, q'~Spicy Salmon Dragon Roll~', q'~Spicy salmon, avocado, and cucumber rolled in nori, topped with grilled eel and drizzled with eel sauce.~');
create_item(c, q'~Spicy Salmon Philly Roll~', q'~Spicy salmon, cream cheese, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Salmon Rainbow Roll~', q'~Spicy salmon, avocado, and cucumber rolled in nori, topped with assorted sashimi slices.~');
create_item(c, q'~Spicy Salmon Roll~', q'~Chopped salmon mixed with spicy sauce, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Spicy Salmon Tempura Roll~', q'~Spicy salmon, avocado, and cucumber rolled in nori, tempura fried and drizzled with eel sauce.~');
create_item(c, q'~Spicy Salmon Volcano Roll~', q'~Spicy salmon, avocado, and cucumber rolled in nori, topped with baked spicy seafood and volcano sauce.~');
create_item(c, q'~Spicy Scallop Roll~', q'~Chopped scallops mixed with spicy mayo, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Spicy Shrimp Boston Roll~', q'~Spicy shrimp, lettuce, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Shrimp Crunch Roll~', q'~Spicy shrimp, avocado, and cucumber rolled in nori, topped with crispy tempura flakes.~');
create_item(c, q'~Spicy Shrimp Dragon Roll~', q'~Spicy shrimp, avocado, and cucumber rolled in nori, topped with grilled eel and drizzled with eel sauce.~');
create_item(c, q'~Spicy Shrimp Philly Roll~', q'~Spicy shrimp, cream cheese, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Shrimp Rainbow Roll~', q'~Spicy shrimp, avocado, and cucumber rolled in nori, topped with assorted sashimi slices.~');
create_item(c, q'~Spicy Shrimp Roll~', q'~Chopped shrimp mixed with spicy mayo, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Spicy Shrimp Tempura Roll~', q'~Spicy shrimp, avocado, and cucumber rolled in nori, tempura fried and topped with spicy mayo.~');
create_item(c, q'~Spicy Shrimp Volcano Roll~', q'~Spicy shrimp, avocado, and cucumber rolled in nori, topped with baked spicy seafood and volcano sauce.~');
create_item(c, q'~Spicy Tuna Boston Roll~', q'~Spicy tuna, lettuce, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Tuna Crunch Roll~', q'~Spicy tuna, avocado, and cucumber rolled in nori, topped with crispy tempura flakes.~');
create_item(c, q'~Spicy Tuna Dragon Roll~', q'~Spicy tuna, avocado, and cucumber rolled in nori, topped with grilled eel and drizzled with eel sauce.~');
create_item(c, q'~Spicy Tuna Philly Roll~', q'~Spicy tuna, cream cheese, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Tuna Rainbow Roll~', q'~Spicy tuna, avocado, and cucumber rolled in nori, topped with assorted sashimi slices.~');
create_item(c, q'~Spicy Tuna Roll~', q'~Chopped tuna mixed with spicy mayo, rolled with cucumber and sushi rice in nori.~');
create_item(c, q'~Spicy Tuna Tempura Roll~', q'~Spicy tuna, avocado, and cucumber rolled in nori, tempura fried and drizzled with eel sauce.~');
create_item(c, q'~Spicy Tuna Volcano Roll~', q'~Spicy tuna, avocado, and cucumber rolled in nori, topped with baked spicy seafood and volcano sauce.~');
create_item(c, q'~Spicy Vegetable Boston Roll~', q'~Spicy vegetables, lettuce, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Vegetable Crunch Roll~', q'~Spicy vegetables, avocado, and cucumber rolled in nori, topped with crispy tempura flakes.~');
create_item(c, q'~Spicy Vegetable Dragon Roll~', q'~Spicy vegetables, avocado, and cucumber rolled in nori, topped with grilled eel and drizzled with eel sauce.~');
create_item(c, q'~Spicy Vegetable Philly Roll~', q'~Spicy vegetables, cream cheese, avocado, and cucumber rolled in nori.~');
create_item(c, q'~Spicy Vegetable Rainbow Roll~', q'~Spicy vegetables, avocado, and cucumber rolled in nori, topped with assorted sashimi slices.~');
create_item(c, q'~Spicy Vegetable Tempura Roll~', q'~Assorted tempura vegetables, avocado, and cucumber rolled in sushi rice and nori.~');
create_item(c, q'~Spicy Vegetable Volcano Roll~', q'~Spicy vegetables, avocado, and cucumber rolled in nori, topped with baked spicy seafood and volcano sauce.~');
create_item(c, q'~Spicy White Fish Roll~', q'~Chopped white fish mixed with spicy sauce, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Spicy Yellowtail Roll~', q'~Chopped yellowtail mixed with spicy sauce, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Squid Nigiri~', q'~Tender squid slices on sushi rice, finished with a brush of soy sauce.~');
create_item(c, q'~Sweet Potato Roll~', q'~Roasted sweet potato, avocado, and cucumber rolled in nori and sushi rice.~');
create_item(c, q'~Tamago Sushi~', q'~Sweet Japanese omelette layered over sushi rice and wrapped with nori.~');
create_item(c, q'~Tamagoyaki Roll~', q'~Sweet Japanese omelette, cucumber, and sushi rice rolled in nori.~');
create_item(c, q'~Tobiko Gunkan~', q'~Sushi rice wrapped in nori and topped with flying fish roe.~');
create_item(c, q'~Tuna Avocado Roll~', q'~Tuna and avocado rolled in sushi rice and nori, topped with sesame seeds.~');
create_item(c, q'~Tuna Cucumber Roll~', q'~Tuna and cucumber rolled in sushi rice and nori, a classic combination.~');
create_item(c, q'~Tuna Sashimi~', q'~Premium slices of raw tuna, expertly cut and served with shredded daikon, wasabi, and soy sauce.~');
create_item(c, q'~Unagi Roll~', q'~Grilled freshwater eel glazed with sweet soy sauce, rolled with cucumber and sushi rice in nori.~');
create_item(c, q'~Vegetable Sushi~', q'~Seasonal vegetables including bell pepper, asparagus, and avocado, rolled in sushi rice and nori.~');
create_item(c, q'~Wasabi Tobiko Roll~', q'~Cucumber and avocado roll topped with wasabi-flavored flying fish roe.~');
create_item(c, q'~White Tuna Nigiri~', q'~Buttery white tuna slices placed atop sushi rice, finished with a touch of wasabi.~');
create_item(c, q'~Yellowtail Jalapeño Roll~', q'~Yellowtail and avocado rolled in nori, topped with thinly sliced jalapeño and ponzu sauce.~');
create_item(c, q'~Yellowtail Scallion Roll~', q'~Yellowtail and scallions rolled in sushi rice and nori, garnished with sesame seeds.~');


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


    

