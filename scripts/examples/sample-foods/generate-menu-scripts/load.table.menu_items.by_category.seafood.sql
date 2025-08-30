prompt loading menu items for category: Seafood
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
 

    c := 'Seafood';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Afghan Fish Korma~', q'~Fish fillet simmered in creamy yogurt sauce with cardamom, cinnamon, and coriander. Served with naan.~');
create_item(c, q'~Afghan Fried Trout with Dill~', q'~Pan-fried trout fillet seasoned with dill, coriander, and lemon. Served with saffron rice.~');
create_item(c, q'~Alaskan King Crab Legs~', q'~Steamed king crab legs served with drawn butter, lemon wedges, and roasted corn on the cob.~');
create_item(c, q'~Argentinian Grilled Patagonian Toothfish~', q'~Patagonian toothfish steak grilled with chimichurri sauce, served with roasted potatoes and arugula salad.~');
create_item(c, q'~Argentinian Paella de Mariscos~', q'~Saffron rice cooked with shrimp, mussels, squid, and fish, flavored with paprika and bell peppers.~');
create_item(c, q'~Australian Barramundi with Lemon Myrtle~', q'~Barramundi fillet grilled with native lemon myrtle, served with roasted sweet potato and macadamia pesto.~');
create_item(c, q'~Bahraini Fish Biryani~', q'~Spiced basmati rice layered with marinated fish, fried onions, and mint. Served with raita.~');
create_item(c, q'~Bahraini Fish Muhammar~', q'~Sweet saffron rice with fried fish, raisins, and caramelized onions.~');
create_item(c, q'~Bangladeshi Fish Bhuna~', q'~Fish fillet cooked in spicy tomato gravy with ginger, garlic, and green chili. Served with rice.~');
create_item(c, q'~Bangladeshi Ilish Bhapa~', q'~Hilsa fish steamed with mustard paste, green chili, and turmeric. Served with rice.~');
create_item(c, q'~Bangladeshi Prawn Malai Curry~', q'~Jumbo prawns cooked in creamy coconut sauce with cardamom, cinnamon, and green chili. Served with basmati rice.~');
create_item(c, q'~Barbadian Flying Fish Cutter~', q'~Fried flying fish fillet in a salt bread roll with lettuce, tomato, and spicy pepper sauce.~');
create_item(c, q'~Bolivian Trucha a la Plancha~', q'~Lake trout fillet pan-seared with garlic and parsley, served with quinoa salad and roasted potatoes.~');
create_item(c, q'~Brazilian Moqueca de Camarão~', q'~Shrimp stewed in coconut milk, tomatoes, onions, bell peppers, and dendê oil. Served with rice and farofa.~');
create_item(c, q'~Brazilian Vatapá de Camarão~', q'~Shrimp stew with coconut milk, peanuts, cashews, bread, and dendê oil. Served with rice.~');
create_item(c, q'~Burmese Mohinga~', q'~Rice noodle soup with catfish, lemongrass, banana stem, and chickpea flour, garnished with boiled egg and cilantro.~');
create_item(c, q'~Cambodian Amok Trey~', q'~Fish fillet steamed in banana leaf with coconut milk, lemongrass, kaffir lime, and turmeric curry paste.~');
create_item(c, q'~Cameroonian Ndolé with Shrimp~', q'~Shrimp cooked in bitterleaf stew with peanuts, onions, and spices. Served with plantains.~');
create_item(c, q'~Canadian Maple-Glazed Salmon~', q'~Wild salmon fillet glazed with pure maple syrup, Dijon mustard, and cracked pepper. Served with wild rice pilaf.~');
create_item(c, q'~Caribbean Jerk Swordfish~', q'~Swordfish steak marinated in spicy jerk seasoning with allspice, Scotch bonnet peppers, and thyme, then grilled and served with mango salsa.~');
create_item(c, q'~Chilean Caldillo de Congrio~', q'~Conger eel soup with potatoes, carrots, onions, and fresh herbs in a tomato-wine broth. Served with crusty bread.~');
create_item(c, q'~Chilean Mariscal~', q'~Cold seafood salad with mussels, clams, shrimp, and squid tossed in lime juice, cilantro, and onions.~');
create_item(c, q'~Chinese Salt and Pepper Squid~', q'~Tender squid pieces tossed in salt, Sichuan peppercorns, and chili, lightly fried and served with scallions.~');
create_item(c, q'~Chinese Steamed Ginger Grouper~', q'~Fresh grouper fillet steamed with ginger, scallions, soy sauce, and sesame oil. Served with jasmine rice.~');
create_item(c, q'~Colombian Arroz con Camarones~', q'~Saffron rice cooked with shrimp, peas, carrots, and bell peppers. Served with fried plantains.~');
create_item(c, q'~Costa Rican Casado with Tilapia~', q'~Grilled tilapia served with black beans, rice, fried plantains, salad, and corn tortillas.~');
create_item(c, q'~Crab Cakes~', q'~Pan-seared crab cakes made with lump crab meat, herbs, and spices, served with a zesty remoulade sauce and a side of mixed greens.~');
create_item(c, q'~Cuban Mojo Grilled Lobster~', q'~Lobster tail marinated in citrus-garlic mojo, grilled and served with black bean salad and fried plantains.~');
create_item(c, q'~Djiboutian Fish Skewers~', q'~Fish chunks marinated in cumin, coriander, and chili, skewered and grilled. Served with rice.~');
create_item(c, q'~Djiboutian Yemeni Fish~', q'~Fish fillet cooked in tomato sauce with cumin, coriander, and chili. Served with flatbread.~');
create_item(c, q'~Dominican Pescado con Coco~', q'~Red snapper cooked in coconut milk with bell peppers, onions, garlic, and cilantro. Served with rice.~');
create_item(c, q'~Ecuadorian Encocado de Pescado~', q'~Fresh snapper cooked in coconut sauce with onions, bell peppers, cilantro, and achiote. Served with rice and patacones.~');
create_item(c, q'~Egyptian Samak Mashwi~', q'~Grilled sea bass marinated in cumin, coriander, garlic, and lemon. Served with rice and tahini sauce.~');
create_item(c, q'~Emirati Fish Machboos~', q'~Spiced rice with fried fish, tomatoes, and baharat spice blend. Served with salad.~');
create_item(c, q'~Emirati Jasheed~', q'~Shredded shark cooked with onions, garlic, turmeric, and dried limes. Served with rice.~');
create_item(c, q'~Eritrean Asa Tibsi~', q'~Pan-fried fish fillet with berbere spice, onions, tomatoes, and green chili. Served with injera.~');
create_item(c, q'~Eritrean Fish Zigni~', q'~Fish fillet cooked in spicy berbere tomato sauce with onions and garlic. Served with injera.~');
create_item(c, q'~Ethiopian Berbere-Spiced Tilapia~', q'~Tilapia fillet coated in spicy berbere seasoning, pan-seared and served with injera and lentil salad.~');
create_item(c, q'~Filipino Kinilaw na Tanigue~', q'~Raw Spanish mackerel marinated in vinegar, ginger, onions, chili, and coconut milk. Served chilled.~');
create_item(c, q'~Filipino Sinigang na Hipon~', q'~Shrimp simmered in a tangy tamarind broth with tomatoes, radish, eggplant, and water spinach. Served with steamed rice.~');
create_item(c, q'~Finnish Salmon Pie~', q'~Savory pie filled with salmon, leeks, potatoes, and dill in a buttery crust. Served with cucumber salad.~');
create_item(c, q'~Fish Tacos~', q'~Soft corn tortillas filled with grilled or battered fish, topped with crunchy cabbage slaw, fresh pico de gallo, creamy avocado, and a drizzle of tangy lime crema.~');
create_item(c, q'~Fish and Chips~', q'~Crispy battered fish fillet fried until golden, served with thick-cut fries, tartar sauce, and a wedge of lemon. A classic pub favorite.~');
create_item(c, q'~French Bouillabaisse~', q'~Classic Provençal seafood stew featuring mussels, clams, sea bass, and shrimp simmered in saffron-infused broth with fennel, leeks, and tomatoes. Served with rouille and toasted baguette.~');
create_item(c, q'~French Sole Meunière~', q'~Dover sole fillet pan-fried in brown butter, lemon, and parsley. Served with steamed potatoes.~');
create_item(c, q'~Ghanaian Fried Tilapia with Shito~', q'~Whole tilapia deep-fried and served with spicy shito pepper sauce and banku.~');
create_item(c, q'~Greek Grilled Octopus~', q'~Tender octopus marinated in olive oil, oregano, and lemon, then char-grilled and served with fava bean purée and capers.~');
create_item(c, q'~Greek Psari Plaki~', q'~Baked fish fillet with tomatoes, onions, garlic, olive oil, and fresh herbs. Served with lemon potatoes.~');
create_item(c, q'~Grilled Salmon~', q'~Fresh salmon fillet marinated in lemon, garlic, and herbs, then grilled to perfection. Served with seasonal vegetables and a wedge of lemon.~');
create_item(c, q'~Grilled Shrimp Skewers~', q'~Juicy shrimp marinated in garlic, lemon, and herbs, threaded onto skewers with colorful bell peppers, onions, and cherry tomatoes, then grilled until lightly charred. Served with a zesty dipping sauce.~');
create_item(c, q'~Guadeloupean Accras de Morue~', q'~Salted cod fritters seasoned with scallions, parsley, and hot pepper. Served with spicy dipping sauce.~');
create_item(c, q'~Haitian Poisson Gros Sel~', q'~Whole fish marinated in lime, garlic, and Scotch bonnet, then simmered with tomatoes, onions, and bell peppers. Served with rice and beans.~');
create_item(c, q'~Hawaiian Ahi Poke Bowl~', q'~Diced yellowfin tuna tossed with soy sauce, sesame oil, seaweed, avocado, and pickled ginger. Served over sushi rice.~');
create_item(c, q'~Hong Kong Steamed Scallops with Garlic~', q'~Fresh scallops steamed with minced garlic, vermicelli noodles, and soy sauce. Garnished with scallions.~');
create_item(c, q'~Icelandic Plokkfiskur~', q'~Traditional fish stew with poached cod, potatoes, onions, and béchamel sauce. Served with rye bread.~');
create_item(c, q'~Indian Bengali Fish Paturi~', q'~Fish fillet marinated in mustard paste, wrapped in banana leaf, and steamed. Served with rice.~');
create_item(c, q'~Indian Bengali Mustard Fish Curry~', q'~Rohu fish cooked in pungent mustard sauce with turmeric, green chili, and nigella seeds. Served with rice.~');
create_item(c, q'~Indian Goan Fish Curry~', q'~Firm kingfish cooked in a tangy coconut curry with tamarind, mustard seeds, curry leaves, and Goan spices. Served with basmati rice.~');
create_item(c, q'~Indian Kerala Meen Pollichathu~', q'~Pearl spot fish marinated in chili, turmeric, and coconut, wrapped in banana leaf and grilled.~');
create_item(c, q'~Indonesian Pepes Ikan~', q'~Fish fillet marinated in turmeric, lemongrass, and chili, wrapped in banana leaf and steamed. Served with rice.~');
create_item(c, q'~Iranian Fish Koofteh~', q'~Fish and herb meatballs simmered in tomato sauce with turmeric and dried lime. Served with rice.~');
create_item(c, q'~Iranian Sabzi Polo Mahi~', q'~Herbed rice with fried white fish, flavored with dill, parsley, and fenugreek. Served with pickled vegetables.~');
create_item(c, q'~Iraqi Fish Tashreeb~', q'~Fish fillet cooked in tomato broth with chickpeas, garlic, and cumin, served over torn flatbread.~');
create_item(c, q'~Iraqi Masgouf~', q'~Butterflied carp marinated in tamarind, salt, and spices, slow-grilled over open flame. Served with salad and bread.~');
create_item(c, q'~Israeli Fish Schnitzel~', q'~Breaded and fried fish fillet served with Israeli salad and tahini sauce.~');
create_item(c, q'~Israeli Gefilte Fish~', q'~Poached fish dumplings made from whitefish and carp, served with horseradish and carrot.~');
create_item(c, q'~Israeli Grilled St. Peter's Fish~', q'~Whole tilapia grilled with za'atar, olive oil, and lemon. Served with tabbouleh salad.~');
create_item(c, q'~Italian Branzino al Forno~', q'~Whole Mediterranean sea bass oven-roasted with lemon, rosemary, garlic, and olive oil. Served with roasted potatoes and seasonal vegetables.~');
create_item(c, q'~Italian Fritto Misto di Mare~', q'~Assorted seafood—calamari, shrimp, anchovies—lightly battered and fried. Served with lemon wedges and aioli.~');
create_item(c, q'~Ivory Coast Poisson Braisé~', q'~Grilled tilapia marinated in garlic, ginger, and chili, served with attiéké and spicy tomato sauce.~');
create_item(c, q'~Jamaican Escovitch Fish~', q'~Fried red snapper topped with spicy pickled vegetables, carrots, onions, and Scotch bonnet peppers. Served with festival bread.~');
create_item(c, q'~Japanese Miso-Glazed Black Cod~', q'~Tender black cod fillet marinated in sweet miso, sake, and mirin, then broiled until caramelized. Served with pickled ginger and steamed rice.~');
create_item(c, q'~Japanese Saba Shioyaki~', q'~Mackerel fillet seasoned with sea salt and grilled, served with grated daikon and lemon.~');
create_item(c, q'~Jordanian Fish Mansaf~', q'~Fish fillet cooked in jameed yogurt sauce with rice, almonds, and parsley.~');
create_item(c, q'~Jordanian Siyyadiyeh~', q'~Rice pilaf with fried fish, almonds, and raisins, flavored with cinnamon and allspice.~');
create_item(c, q'~Kenyan Coconut Fish Curry~', q'~Tilapia fillet simmered in coconut milk with tomatoes, ginger, garlic, and coriander. Served with ugali.~');
create_item(c, q'~Korean Godeungeo Gui~', q'~Grilled mackerel marinated in soy sauce, garlic, and ginger, served with kimchi and rice.~');
create_item(c, q'~Korean Spicy Braised Mackerel~', q'~Mackerel fillets braised in gochujang chili paste, soy sauce, garlic, ginger, and daikon radish. Served with steamed rice.~');
create_item(c, q'~Kuwaiti Fish Murabyan~', q'~Shrimp and rice cooked with turmeric, cumin, and dried lime. Served with salad.~');
create_item(c, q'~Kuwaiti Zubaidi Meshwi~', q'~Grilled silver pomfret marinated in turmeric, garlic, and lemon. Served with rice and pickles.~');
create_item(c, q'~Laotian Mok Pa~', q'~Fish fillet mixed with herbs, lemongrass, and chili, wrapped in banana leaf and steamed. Served with sticky rice.~');
create_item(c, q'~Lebanese Grilled Calamari~', q'~Whole calamari marinated in garlic, lemon, and olive oil, grilled and served with fattoush salad.~');
create_item(c, q'~Lebanese Samke Harra~', q'~Spicy baked fish fillet with tahini, pine nuts, chili, and coriander. Served with rice pilaf.~');
create_item(c, q'~Lebanese Sayadieh~', q'~Spiced rice with fried fish fillet, caramelized onions, pine nuts, and tahini sauce.~');
create_item(c, q'~Louisiana Crawfish Étouffée~', q'~Crawfish tails simmered in a rich roux-based sauce with bell peppers, celery, onions, and Cajun spices. Served over rice.~');
create_item(c, q'~Macanese African Chicken with Prawns~', q'~Grilled chicken and prawns in spicy peanut-coconut sauce with paprika and chili. Served with rice.~');
create_item(c, q'~Malagasy Fish Lasary~', q'~Fish fillet cooked with tomatoes, onions, and green beans, served with rice and spicy lasary salad.~');
create_item(c, q'~Malagasy Romazava with Tilapia~', q'~Tilapia simmered in broth with leafy greens, ginger, garlic, and tomatoes. Served with rice.~');
create_item(c, q'~Malaysian Sambal Stingray~', q'~Stingray fillet grilled in banana leaf with spicy sambal chili paste, served with calamansi lime.~');
create_item(c, q'~Maldivian Mas Riha~', q'~Tuna curry with coconut milk, curry leaves, chili, and onions. Served with roshi flatbread.~');
create_item(c, q'~Maldivian Tuna Cutlets~', q'~Spiced tuna and potato croquettes, breaded and fried. Served with chili sauce.~');
create_item(c, q'~Mauritian Fish Curry~', q'~Fish fillet simmered in tomato curry with turmeric, cumin, and coriander. Served with rice.~');
create_item(c, q'~Mauritian Vindaye Poisson~', q'~Fish fillet marinated in mustard, turmeric, garlic, and vinegar, then sautéed and served with rice.~');
create_item(c, q'~Mexican Veracruz-Style Red Snapper~', q'~Red snapper fillet baked in tomato sauce with olives, capers, jalapeños, and fresh herbs. Served with rice.~');
create_item(c, q'~Moroccan Chermoula Grilled Sardines~', q'~Whole sardines marinated in chermoula—a blend of cilantro, parsley, garlic, cumin, paprika, and lemon—then grilled and served with preserved lemon salad.~');
create_item(c, q'~Moroccan Fish Tagine~', q'~Sea bream cooked in a clay pot with tomatoes, olives, preserved lemon, saffron, and chermoula spices.~');
create_item(c, q'~Nepalese Fish Curry with Timur~', q'~Fish fillet cooked in tomato gravy with timur (Sichuan pepper), ginger, garlic, and coriander.~');
create_item(c, q'~Nepalese Fish Sekuwa~', q'~Fish fillet marinated in cumin, coriander, ginger, and chili, skewered and grilled. Served with achar pickle.~');
create_item(c, q'~New England Clam Bake~', q'~Steamed clams, lobster, mussels, corn, and potatoes cooked with seaweed and herbs. Served with drawn butter.~');
create_item(c, q'~New Zealand Green-Lipped Mussels~', q'~Steamed green-lipped mussels with garlic, white wine, parsley, and lemon. Served with sourdough bread.~');
create_item(c, q'~Nigerian Catfish Pepper Soup~', q'~Catfish chunks simmered in spicy broth with scent leaves, ginger, garlic, and chili peppers.~');
create_item(c, q'~Norwegian Fish Soup~', q'~Creamy soup with cod, salmon, shrimp, root vegetables, and fresh herbs. Served with rustic bread.~');
create_item(c, q'~Omani Fish Madrouba~', q'~Fish and rice porridge cooked with turmeric, cumin, and dried lime. Served with pickles.~');
create_item(c, q'~Omani Kingfish Majboos~', q'~Kingfish cooked with spiced rice, dried limes, and saffron. Served with tomato chutney.~');
create_item(c, q'~Pacific Island Poisson Cru~', q'~Raw tuna marinated in lime juice and coconut milk with cucumber, tomato, and scallions. Served chilled.~');
create_item(c, q'~Pacific Northwest Cedar-Planked Salmon~', q'~Salmon fillet roasted on a cedar plank with brown sugar, mustard, and dill. Served with grilled asparagus.~');
create_item(c, q'~Pakistani Fish Biryani~', q'~Spiced basmati rice layered with marinated fish, fried onions, and mint. Served with raita.~');
create_item(c, q'~Pakistani Fish Karahi~', q'~Boneless fish cooked in tomato, ginger, garlic, green chili, and garam masala. Served with naan bread.~');
create_item(c, q'~Pakistani Fish Tikka~', q'~Fish chunks marinated in yogurt, chili, turmeric, and garam masala, skewered and grilled. Served with naan.~');
create_item(c, q'~Palestinian Fish Maqluba~', q'~Layered rice casserole with fried fish, eggplant, tomatoes, and spices. Served with yogurt sauce.~');
create_item(c, q'~Palestinian Sayadiyah~', q'~Spiced rice with fried fish, caramelized onions, and pine nuts. Served with yogurt sauce.~');
create_item(c, q'~Paraguayan Surubí a la Parrilla~', q'~Grilled surubí catfish steak with chimichurri, served with mandioca fries and salad.~');
create_item(c, q'~Peruvian Ceviche Mixto~', q'~A refreshing mix of sea bass, shrimp, and calamari cured in lime juice with red onions, cilantro, rocoto chili, and sweet potato.~');
create_item(c, q'~Peruvian Chupe de Camarones~', q'~Creamy shrimp chowder with potatoes, corn, peas, eggs, and cheese. Served with crusty bread.~');
create_item(c, q'~Peruvian Tiradito de Corvina~', q'~Thinly sliced corvina dressed in spicy yellow chili sauce, garnished with sweet potato and corn.~');
create_item(c, q'~Polish Herring in Cream Sauce~', q'~Pickled herring fillets tossed in a creamy sauce with onions, apples, and dill. Served with rye bread.~');
create_item(c, q'~Portuguese Bacalhau à Brás~', q'~Shredded salted cod sautéed with onions, potatoes, eggs, and parsley. Served with olives.~');
create_item(c, q'~Puerto Rican Bacalaítos~', q'~Crispy salted cod fritters seasoned with garlic, cilantro, and annatto. Served with garlic aioli.~');
create_item(c, q'~Qatari Fish Salona~', q'~Fish stew with tomatoes, potatoes, carrots, and spices. Served with rice.~');
create_item(c, q'~Qatari Machbous Samak~', q'~Spiced rice with fried fish, tomatoes, and baharat spice blend. Served with salad.~');
create_item(c, q'~Russian Salmon Kulebyaka~', q'~Salmon, mushrooms, rice, and dill wrapped in flaky pastry and baked until golden. Served with sour cream sauce.~');
create_item(c, q'~San Francisco Cioppino~', q'~Hearty seafood stew with Dungeness crab, shrimp, scallops, mussels, and fish in tomato-wine broth. Served with garlic bread.~');
create_item(c, q'~Saudi Arabian Fish Kabsa~', q'~Spiced rice with fried fish, raisins, almonds, and baharat spice blend. Served with salad.~');
create_item(c, q'~Saudi Arabian Samak Mashwi~', q'~Grilled grouper marinated in cumin, coriander, and lemon, served with saffron rice.~');
create_item(c, q'~Seafood Linguine~', q'~Linguine pasta tossed with a medley of fresh seafood including shrimp, scallops, and mussels, sautéed in a white wine, garlic, and tomato sauce. Finished with parsley and a squeeze of lemon.~');
create_item(c, q'~Seafood Risotto~', q'~Creamy Arborio rice risotto cooked slowly with white wine, garlic, and a medley of fresh seafood such as shrimp, scallops, and mussels. Finished with parsley and lemon.~');
create_item(c, q'~Senegalese Thieboudienne~', q'~Red snapper cooked with tomato, vegetables, and broken rice, flavored with tamarind and chili.~');
create_item(c, q'~Seychellois Grilled Red Snapper~', q'~Red snapper marinated in garlic, ginger, and chili, grilled and served with coconut rice.~');
create_item(c, q'~Seychellois Octopus Curry~', q'~Tender octopus cooked in coconut curry with tomatoes, ginger, garlic, and chili. Served with rice.~');
create_item(c, q'~Shrimp Scampi~', q'~Succulent shrimp sautéed in garlic butter and white wine sauce, tossed with linguine pasta and finished with fresh parsley and a squeeze of lemon.~');
create_item(c, q'~Somali Bariis Iskukaris with Fish~', q'~Spiced rice with fried fish, raisins, and vegetables, flavored with xawaash spice blend.~');
create_item(c, q'~Somali Fish Stew with Coconut~', q'~Fish fillet simmered in coconut milk with tomatoes, ginger, garlic, and coriander. Served with rice.~');
create_item(c, q'~South African Cape Malay Pickled Fish~', q'~Kingklip fillet marinated in turmeric, curry, vinegar, and onions. Served chilled with bread.~');
create_item(c, q'~Spanish Bacalao a la Vizcaína~', q'~Salted cod fillet braised in a rich tomato and red pepper sauce with onions, garlic, and olives. Served with crusty bread.~');
create_item(c, q'~Spanish Pulpo a la Gallega~', q'~Tender octopus slices drizzled with olive oil and sprinkled with smoked paprika and sea salt. Served with boiled potatoes.~');
create_item(c, q'~Sri Lankan Ambul Thiyal~', q'~Tuna chunks simmered in sour goraka, black pepper, chili, and curry leaves. Served with red rice.~');
create_item(c, q'~Sri Lankan Fish Cutlets~', q'~Spiced fish and potato croquettes, breaded and fried. Served with chili sauce.~');
create_item(c, q'~Sudanese Asida with Fish Stew~', q'~Cornmeal porridge served with spicy fish stew made with tomatoes, garlic, and chili.~');
create_item(c, q'~Sudanese Fish Tagine~', q'~Fish fillet cooked in tomato sauce with cumin, coriander, and chili. Served with rice.~');
create_item(c, q'~Swedish Gravlax~', q'~Cured salmon with dill, sugar, and salt, thinly sliced and served with mustard-dill sauce and crispbread.~');
create_item(c, q'~Syrian Fish Kibbeh~', q'~Fish and bulgur croquettes stuffed with pine nuts and spices, fried and served with tahini sauce.~');
create_item(c, q'~Syrian Samak Harra~', q'~Spicy baked fish fillet with tahini, pine nuts, chili, and coriander. Served with rice pilaf.~');
create_item(c, q'~Taiwanese Three-Cup Squid~', q'~Squid stir-fried with equal parts soy sauce, rice wine, and sesame oil, with basil, garlic, and chili.~');
create_item(c, q'~Tanzanian Grilled Prawns Pili Pili~', q'~Jumbo prawns marinated in pili pili chili sauce, grilled and served with coconut rice.~');
create_item(c, q'~Thai Green Curry Snapper~', q'~Fresh snapper simmered in aromatic Thai green curry with coconut milk, lemongrass, kaffir lime leaves, and Thai basil. Served with jasmine rice.~');
create_item(c, q'~Thai Pla Rad Prik~', q'~Crispy fried whole snapper topped with spicy chili-garlic sauce, served with jasmine rice.~');
create_item(c, q'~Trinidadian Curry Crab and Dumplings~', q'~Blue crab simmered in fragrant curry sauce with coconut milk, served with soft flour dumplings.~');
create_item(c, q'~Turkish Grilled Sea Bream~', q'~Whole sea bream marinated in olive oil, garlic, and sumac, grilled and served with bulgur pilaf and roasted vegetables.~');
create_item(c, q'~Turkish Hamsili Pilav~', q'~Anchovy-studded rice pilaf with pine nuts, currants, and dill, baked until golden.~');
create_item(c, q'~Uruguayan Grilled Corvina~', q'~Corvina fillet grilled with lemon and olive oil, served with roasted vegetables and potato salad.~');
create_item(c, q'~Venezuelan Coconut Fish Stew~', q'~Firm grouper simmered in coconut milk with bell peppers, tomatoes, cilantro, and garlic. Served with rice.~');
create_item(c, q'~Vietnamese Cha Ca La Vong~', q'~Grilled turmeric-marinated catfish served with dill, scallions, peanuts, and rice noodles.~');
create_item(c, q'~Vietnamese Tamarind Prawn Hotpot~', q'~Jumbo prawns simmered in a clay pot with tamarind, pineapple, tomatoes, and fresh herbs. Served with vermicelli noodles.~');
create_item(c, q'~Yemeni Fish Maraq~', q'~Fish soup with tomatoes, potatoes, carrots, and spices. Served with flatbread.~');
create_item(c, q'~Yemeni Sayadiah~', q'~Rice pilaf with spiced fish, tomatoes, and cumin, garnished with fried onions.~');


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


    

