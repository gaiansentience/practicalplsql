prompt loading menu items for category: Soups
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
 

    c := 'Soups';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Avgolemono Soup~', q'~Traditional Greek chicken and rice soup enriched with eggs and lemon juice, creating a silky, tangy broth. Garnished with fresh dill.~');
create_item(c, q'~Beef Stew~', q'~Hearty stew with chunks of beef, potatoes, carrots, and onions, slow-cooked in a rich, savory broth until the meat is tender and the flavors are deep.~');
create_item(c, q'~Borscht~', q'~Eastern European beet soup with tender beef, cabbage, potatoes, carrots, and onions. Served hot with a dollop of sour cream and fresh dill.~');
create_item(c, q'~Cabbage Roll Soup~', q'~Deconstructed Eastern European cabbage rolls in a tomato broth with ground beef, rice, cabbage, carrots, and herbs.~');
create_item(c, q'~Caldo Verde~', q'~Portuguese soup with potatoes, collard greens, chorizo sausage, and onions simmered in a flavorful broth. Served with crusty bread.~');
create_item(c, q'~Chicken Enchilada Soup~', q'~Mexican-inspired soup with shredded chicken, black beans, corn, tomatoes, and enchilada sauce. Topped with cheese and tortilla strips.~');
create_item(c, q'~Chicken Mull~', q'~Southern American chicken soup with milk, onions, celery, and crumbled saltine crackers. Creamy and comforting.~');
create_item(c, q'~Chicken Noodle Soup~', q'~Comforting soup with tender chicken pieces, egg noodles, carrots, celery, and onions, simmered in a savory broth and seasoned with herbs.~');
create_item(c, q'~Chicken Pozole Rojo~', q'~Mexican hominy soup with shredded chicken, guajillo chili broth, radishes, cabbage, and lime. Garnished with fresh cilantro.~');
create_item(c, q'~Chicken Tortilla Soup~', q'~Mexican soup with shredded chicken, tomatoes, corn, black beans, and crispy tortilla strips in a spicy, smoky broth. Topped with avocado and cheese.~');
create_item(c, q'~Chicken and Barley Soup~', q'~Hearty soup with tender chicken, pearl barley, carrots, celery, onions, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Chicken and Chickpea Soup~', q'~Mediterranean-inspired soup with tender chicken, chickpeas, tomatoes, carrots, celery, and cumin in a savory broth.~');
create_item(c, q'~Chicken and Corn Soup~', q'~Chinese-style soup with shredded chicken, sweet corn kernels, egg ribbons, and scallions in a light, savory broth.~');
create_item(c, q'~Chicken and Dumpling Soup~', q'~Southern-style soup with tender chicken, fluffy dumplings, carrots, celery, and onions in a rich, savory broth.~');
create_item(c, q'~Chicken and Lentil Soup~', q'~Hearty soup with tender chicken, green lentils, carrots, celery, onions, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Chicken and Mushroom Soup~', q'~Savory soup with tender chicken, mushrooms, onions, garlic, and fresh thyme simmered in a rich broth.~');
create_item(c, q'~Chicken and Potato Soup~', q'~Savory soup with tender chicken, Yukon gold potatoes, carrots, celery, and onions simmered in a rich broth.~');
create_item(c, q'~Chicken and Rice Soup~', q'~Classic comfort soup with tender chicken, long-grain rice, carrots, celery, and onions simmered in a savory broth.~');
create_item(c, q'~Chicken and Sausage Gumbo~', q'~Louisiana-style soup with chicken, smoked sausage, okra, bell peppers, and Cajun spices in a rich, dark roux-based broth.~');
create_item(c, q'~Chicken and Spinach Soup~', q'~Light soup with tender chicken, fresh spinach, carrots, celery, and onions simmered in a savory broth.~');
create_item(c, q'~Chicken and Sweet Potato Soup~', q'~Savory soup with tender chicken, roasted sweet potatoes, carrots, celery, and onions simmered in a rich broth.~');
create_item(c, q'~Chicken and Vegetable Barley Soup~', q'~Hearty soup with tender chicken, pearl barley, carrots, celery, onions, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Chicken and Vegetable Borscht~', q'~Eastern European beet soup with tender chicken, cabbage, potatoes, carrots, onions, and fresh dill.~');
create_item(c, q'~Chicken and Vegetable Broccoli Soup~', q'~Smooth, creamy soup made from fresh broccoli, tender chicken, onions, and garlic. Finished with a swirl of cream.~');
create_item(c, q'~Chicken and Vegetable Broccoli and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, roasted parsnips, tender chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Chicken and Vegetable Broccoli, Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, Yukon gold potatoes, roasted parsnips, tender chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Chicken and Vegetable Broccoli, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, roasted pumpkin, parsnips, tender chicken, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Chicken and Vegetable Broccoli, Spinach, Sweet Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, spinach, roasted sweet potatoes, roasted parsnips, tender chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Chicken and Vegetable Broccoli, Spinach, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, spinach, roasted parsnips, tender chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Chicken and Vegetable Broccoli, Sweet Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, roasted sweet potatoes, roasted parsnips, tender chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Chicken and Vegetable Carrot Ginger Soup~', q'~Smooth, vibrant soup made from roasted carrots, tender chicken, fresh ginger, onions, and coconut milk. Finished with fresh chives.~');
create_item(c, q'~Chicken and Vegetable Carrot Soup~', q'~Smooth, vibrant soup made from roasted carrots, tender chicken, onions, and coconut milk. Finished with fresh chives.~');
create_item(c, q'~Chicken and Vegetable Cauliflower Soup~', q'~Smooth, velvety soup made from roasted cauliflower, tender chicken, onions, and garlic. Finished with truffle oil.~');
create_item(c, q'~Chicken and Vegetable Chowder~', q'~Rich, creamy soup with tender chicken, potatoes, carrots, celery, corn, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Chicken and Vegetable Laksa~', q'~Malaysian coconut curry noodle soup with tender chicken, rice noodles, bean sprouts, and fresh herbs in a spicy, aromatic broth.~');
create_item(c, q'~Chicken and Vegetable Lentil Soup~', q'~Hearty soup with tender chicken, green lentils, carrots, celery, onions, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Chicken and Vegetable Minestrone~', q'~Italian soup with tender chicken, seasonal vegetables, beans, pasta, and tomatoes simmered in a savory broth.~');
create_item(c, q'~Chicken and Vegetable Mulligatawny~', q'~Anglo-Indian soup with tender chicken, lentils, apples, carrots, and curry spices simmered in a creamy broth. Served with rice.~');
create_item(c, q'~Chicken and Vegetable Noodle Soup~', q'~Classic soup with tender chicken, egg noodles, carrots, celery, onions, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Chicken and Vegetable Parsnip Soup~', q'~Smooth, sweet soup made from roasted parsnips, tender chicken, onions, garlic, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Chicken and Vegetable Potato Soup~', q'~Savory soup with tender chicken, Yukon gold potatoes, carrots, celery, and onions simmered in a rich broth.~');
create_item(c, q'~Chicken and Vegetable Potato, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from Yukon gold potatoes, roasted pumpkin, parsnips, tender chicken, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Chicken and Vegetable Potato, Spinach, and Parsnip Soup~', q'~Smooth, sweet soup made from Yukon gold potatoes, fresh spinach, roasted parsnips, tender chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Chicken and Vegetable Pozole Rojo~', q'~Mexican hominy soup with shredded chicken, guajillo chili broth, radishes, cabbage, and lime. Garnished with fresh cilantro.~');
create_item(c, q'~Chicken and Vegetable Pumpkin Soup~', q'~Creamy soup with tender chicken, roasted pumpkin, onions, garlic, and warming spices. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Chicken and Vegetable Pumpkin and Parsnip Soup~', q'~Smooth, sweet soup made from roasted pumpkin, parsnips, tender chicken, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Chicken and Vegetable Pumpkin and Sweet Potato Soup~', q'~Smooth, velvety soup made from roasted pumpkin, sweet potatoes, tender chicken, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Chicken and Vegetable Quinoa Soup~', q'~Andean-inspired soup with tender chicken, quinoa, potatoes, carrots, peas, corn, and fresh herbs simmered in a light broth.~');
create_item(c, q'~Chicken and Vegetable Sambar~', q'~South Indian soup with tender chicken, lentils, carrots, potatoes, and sambar spices simmered in a tangy broth.~');
create_item(c, q'~Chicken and Vegetable Soup~', q'~Classic soup with tender chicken, carrots, celery, potatoes, green beans, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Chicken and Vegetable Spinach Soup~', q'~Light soup with tender chicken, fresh spinach, carrots, celery, and onions simmered in a savory broth.~');
create_item(c, q'~Chicken and Vegetable Spinach and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, roasted parsnips, tender chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Chicken and Vegetable Spinach, Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, Yukon gold potatoes, roasted parsnips, tender chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Chicken and Vegetable Spinach, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, roasted pumpkin, parsnips, tender chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Chicken and Vegetable Spinach, Sweet Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, roasted sweet potatoes, roasted parsnips, tender chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Chicken and Vegetable Sweet Corn Soup~', q'~Chinese-style soup with shredded chicken, sweet corn kernels, egg ribbons, and scallions in a light, savory broth.~');
create_item(c, q'~Chicken and Vegetable Sweet Potato Soup~', q'~Savory soup with tender chicken, roasted sweet potatoes, carrots, celery, and onions simmered in a rich broth.~');
create_item(c, q'~Chicken and Vegetable Sweet Potato and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, parsnips, tender chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Chicken and Vegetable Sweet Potato, Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, Yukon gold potatoes, roasted parsnips, tender chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Chicken and Vegetable Sweet Potato, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, pumpkin, parsnips, tender chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Chicken and Vegetable Sweet Potato, Spinach, and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, fresh spinach, roasted parsnips, tender chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Chicken and Vegetable Tom Yum~', q'~Thai hot and sour soup with tender chicken, mushrooms, tomatoes, lemongrass, galangal, kaffir lime leaves, and chili.~');
create_item(c, q'~Chicken and Vegetable Tomato Basil Soup~', q'~Smooth, creamy soup made from ripe tomatoes, tender chicken, onions, garlic, and fresh basil. Finished with a swirl of cream.~');
create_item(c, q'~Chicken and Vegetable Tomato Soup~', q'~Classic creamy tomato soup with tender chicken, onions, garlic, and herbs, simmered and blended until smooth. Served hot with a swirl of cream.~');
create_item(c, q'~Chicken and Vegetable Zucchini Soup~', q'~Smooth, delicate soup made from fresh zucchini, tender chicken, onions, garlic, and fresh basil. Finished with a swirl of cream.~');
create_item(c, q'~Chicken and White Bean Soup~', q'~Hearty soup with tender chicken, cannellini beans, carrots, celery, onions, and fresh rosemary simmered in a savory broth.~');
create_item(c, q'~Chicken and Wild Rice Soup~', q'~Hearty soup with roasted chicken, wild rice, carrots, celery, mushrooms, and fresh herbs in a savory broth.~');
create_item(c, q'~Chilled Avocado Soup~', q'~Creamy, refreshing soup made from ripe avocados, cucumber, lime juice, and fresh cilantro. Served cold, vegan and gluten-free.~');
create_item(c, q'~Chorba Frik~', q'~Algerian wheat and lamb soup with tomatoes, chickpeas, celery, and North African spices. Hearty and aromatic.~');
create_item(c, q'~Chupe de Camarones~', q'~Peruvian shrimp chowder with potatoes, corn, peas, evaporated milk, and aji amarillo chili. Rich, creamy, and spicy.~');
create_item(c, q'~Clam Chowder~', q'~Creamy soup made with tender clams, diced potatoes, onions, and celery, simmered in a rich, savory broth with a hint of smoky bacon. Served with oyster crackers.~');
create_item(c, q'~Cream of Asparagus Soup~', q'~Delicate soup made from fresh asparagus, leeks, potatoes, and cream. Finished with lemon zest and chive oil.~');
create_item(c, q'~Cream of Broccoli Soup~', q'~Smooth, creamy soup made from fresh broccoli, onions, garlic, and vegetable stock. Finished with a swirl of cream.~');
create_item(c, q'~Cream of Mushroom Soup~', q'~Rich, creamy soup made from sautéed mushrooms, onions, garlic, and fresh thyme. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Avocado Soup~', q'~Smooth, refreshing soup made from ripe avocados, cucumber, lime juice, and fresh cilantro. Served cold, vegan and gluten-free.~');
create_item(c, q'~Creamy Broccoli and Cauliflower Soup~', q'~Smooth, creamy soup made from fresh broccoli, cauliflower, onions, and garlic. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Broccoli and Cheddar Soup~', q'~Smooth, creamy soup made from fresh broccoli, onions, garlic, and sharp cheddar cheese. Finished with crispy bacon.~');
create_item(c, q'~Creamy Broccoli and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, roasted parsnips, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Creamy Broccoli and Potato Soup~', q'~Smooth, creamy soup made from fresh broccoli, Yukon gold potatoes, onions, and garlic. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Broccoli and Pumpkin Soup~', q'~Smooth, creamy soup made from fresh broccoli, roasted pumpkin, onions, and garlic. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Broccoli and Spinach Soup~', q'~Smooth, creamy soup made from fresh broccoli, spinach, onions, and garlic. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Broccoli, Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, Yukon gold potatoes, roasted parsnips, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Creamy Broccoli, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, roasted pumpkin, parsnips, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Creamy Broccoli, Spinach, Sweet Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, spinach, roasted sweet potatoes, roasted parsnips, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Broccoli, Spinach, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, spinach, roasted parsnips, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Broccoli, Sweet Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, roasted sweet potatoes, roasted parsnips, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Creamy Carrot Ginger Soup~', q'~Smooth, vibrant soup made from roasted carrots, fresh ginger, onions, and coconut milk. Vegan and gluten-free.~');
create_item(c, q'~Creamy Carrot and Coriander Soup~', q'~Smooth, vibrant soup made from roasted carrots, fresh coriander, onions, and coconut milk. Vegan and gluten-free.~');
create_item(c, q'~Creamy Carrot and Sweet Potato Soup~', q'~Smooth, vibrant soup made from roasted carrots, sweet potatoes, onions, and coconut milk. Vegan and gluten-free.~');
create_item(c, q'~Creamy Cauliflower Soup~', q'~Smooth, velvety soup made from roasted cauliflower, garlic, onions, and vegetable stock. Finished with truffle oil.~');
create_item(c, q'~Creamy Cauliflower and Broccoli Soup~', q'~Smooth, creamy soup made from roasted cauliflower, fresh broccoli, onions, and garlic. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Cauliflower and Cheese Soup~', q'~Rich, velvety soup made from roasted cauliflower, onions, garlic, and sharp cheddar cheese. Finished with crispy croutons.~');
create_item(c, q'~Creamy Cauliflower and Potato Soup~', q'~Smooth, velvety soup made from roasted cauliflower, Yukon gold potatoes, onions, and garlic. Finished with truffle oil.~');
create_item(c, q'~Creamy Cauliflower and Spinach Soup~', q'~Smooth, velvety soup made from roasted cauliflower, fresh spinach, onions, and garlic. Finished with truffle oil.~');
create_item(c, q'~Creamy Celery Root Soup~', q'~Delicate soup made from celery root, potatoes, onions, and cream. Finished with chive oil and toasted hazelnuts.~');
create_item(c, q'~Creamy Corn Chowder~', q'~Rich, creamy soup with sweet corn kernels, potatoes, onions, celery, and crispy bacon. Finished with fresh chives.~');
create_item(c, q'~Creamy Leek and Potato Soup~', q'~French-inspired creamy soup with Yukon gold potatoes, leeks, onions, and fresh thyme. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Mushroom and Barley Soup~', q'~Hearty soup with sautéed mushrooms, pearl barley, onions, garlic, and fresh thyme simmered in a savory broth.~');
create_item(c, q'~Creamy Mushroom and Spinach Soup~', q'~Rich, velvety soup made from sautéed mushrooms, fresh spinach, onions, garlic, and cream. Finished with Parmesan cheese.~');
create_item(c, q'~Creamy Parsnip Soup~', q'~Smooth, sweet soup made from roasted parsnips, onions, garlic, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Creamy Pea Soup~', q'~Smooth, vibrant soup made from sweet green peas, onions, garlic, and cream. Finished with crispy prosciutto.~');
create_item(c, q'~Creamy Potato Soup~', q'~Classic comfort soup with Yukon gold potatoes, onions, garlic, and cream. Finished with crispy bacon and chives.~');
create_item(c, q'~Creamy Potato and Broccoli Soup~', q'~Smooth, creamy soup made from Yukon gold potatoes, fresh broccoli, onions, and garlic. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Potato and Carrot Soup~', q'~Smooth, velvety soup made from Yukon gold potatoes, roasted carrots, onions, and cream. Finished with fresh chives.~');
create_item(c, q'~Creamy Potato and Leek Soup~', q'~French-inspired creamy soup with Yukon gold potatoes, leeks, onions, and fresh thyme. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Potato and Parsnip Soup~', q'~Smooth, sweet soup made from Yukon gold potatoes, roasted parsnips, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Creamy Potato and Pumpkin Soup~', q'~Smooth, velvety soup made from Yukon gold potatoes, roasted pumpkin, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Creamy Potato and Spinach Soup~', q'~Smooth, velvety soup made from Yukon gold potatoes, fresh spinach, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Potato, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from Yukon gold potatoes, roasted pumpkin, parsnips, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Creamy Potato, Spinach, and Parsnip Soup~', q'~Smooth, sweet soup made from Yukon gold potatoes, fresh spinach, roasted parsnips, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Pumpkin Soup~', q'~Smooth, creamy soup made from roasted pumpkin, onions, garlic, and warming spices. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Creamy Pumpkin and Parsnip Soup~', q'~Smooth, sweet soup made from roasted pumpkin, parsnips, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Creamy Pumpkin and Sweet Potato Soup~', q'~Smooth, velvety soup made from roasted pumpkin, sweet potatoes, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Creamy Spinach Soup~', q'~Smooth, velvety soup made from fresh spinach, leeks, potatoes, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Spinach and Artichoke Soup~', q'~Smooth, velvety soup made from fresh spinach, artichoke hearts, onions, garlic, and cream. Finished with Parmesan cheese.~');
create_item(c, q'~Creamy Spinach and Cauliflower Soup~', q'~Smooth, velvety soup made from fresh spinach, roasted cauliflower, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Spinach and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, roasted parsnips, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Spinach and Potato Soup~', q'~Smooth, velvety soup made from fresh spinach, Yukon gold potatoes, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Spinach and Pumpkin Soup~', q'~Smooth, velvety soup made from fresh spinach, roasted pumpkin, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Spinach, Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, Yukon gold potatoes, roasted parsnips, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Spinach, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, roasted pumpkin, parsnips, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Spinach, Sweet Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, roasted sweet potatoes, roasted parsnips, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Sweet Corn and Potato Soup~', q'~Rich, creamy soup with sweet corn kernels, Yukon gold potatoes, onions, celery, and crispy bacon. Finished with fresh chives.~');
create_item(c, q'~Creamy Sweet Potato Soup~', q'~Smooth, velvety soup made from roasted sweet potatoes, onions, garlic, and warming spices. Finished with toasted pecans.~');
create_item(c, q'~Creamy Sweet Potato and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, parsnips, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Creamy Sweet Potato, Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, Yukon gold potatoes, roasted parsnips, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Creamy Sweet Potato, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, pumpkin, parsnips, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Creamy Sweet Potato, Spinach, and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, fresh spinach, roasted parsnips, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Creamy Tomato Basil Soup~', q'~Smooth, creamy soup made from ripe tomatoes, onions, garlic, and fresh basil. Finished with a swirl of cream.~');
create_item(c, q'~Creamy Tomato and Red Pepper Soup~', q'~Smooth, creamy soup made from fire-roasted tomatoes and red bell peppers, onions, and garlic. Finished with basil oil.~');
create_item(c, q'~Creamy White Bean Soup~', q'~Smooth, hearty soup made from cannellini beans, garlic, onions, celery, and rosemary. Finished with extra virgin olive oil.~');
create_item(c, q'~Creamy Zucchini Soup~', q'~Smooth, delicate soup made from fresh zucchini, leeks, potatoes, and cream. Finished with basil oil.~');
create_item(c, q'~Creamy Zucchini and Basil Soup~', q'~Smooth, delicate soup made from fresh zucchini, onions, garlic, and fresh basil. Finished with a swirl of cream.~');
create_item(c, q'~Cullen Skink~', q'~Scottish smoked haddock soup with potatoes, onions, and cream. Smoky, creamy, and deeply satisfying.~');
create_item(c, q'~Fish Head Curry Soup~', q'~Singaporean soup with fish head, okra, eggplant, tomatoes, and curry spices simmered in a tangy, spicy broth.~');
create_item(c, q'~French Onion Soup~', q'~Caramelized onions simmered in rich beef broth, topped with toasted baguette slices and melted Gruyère cheese. Served bubbling hot.~');
create_item(c, q'~Gazpacho Andaluz~', q'~Chilled Spanish soup made from ripe tomatoes, cucumbers, bell peppers, onions, garlic, and olive oil. Refreshing and vibrant, served cold.~');
create_item(c, q'~Green Pea and Mint Soup~', q'~Vibrant vegan soup made from sweet green peas, fresh mint, onions, and vegetable stock. Served hot or chilled.~');
create_item(c, q'~Harira~', q'~Moroccan soup with tomatoes, lentils, chickpeas, lamb, and aromatic spices like cinnamon and ginger. Finished with fresh cilantro and lemon.~');
create_item(c, q'~Hungarian Goulash Soup~', q'~Beef and vegetable soup with paprika, potatoes, carrots, and bell peppers simmered in a rich, spicy broth.~');
create_item(c, q'~Italian Wedding Soup~', q'~Savory chicken broth with mini pork and beef meatballs, tender greens, carrots, celery, and tiny pasta pearls. Finished with Parmesan.~');
create_item(c, q'~Khao Soi~', q'~Northern Thai coconut curry noodle soup with chicken, crispy egg noodles, pickled mustard greens, and shallots. Spicy and aromatic.~');
create_item(c, q'~Kimchi Jjigae~', q'~Korean spicy stew with kimchi, pork belly, tofu, scallions, and gochugaru chili flakes simmered in a robust broth.~');
create_item(c, q'~Laksa Lemak~', q'~Malaysian coconut curry noodle soup with rice noodles, shrimp, tofu puffs, bean sprouts, and boiled egg in a spicy, aromatic broth.~');
create_item(c, q'~Lentil Soup~', q'~Hearty and nourishing soup made with tender lentils simmered with aromatic vegetables such as carrots, celery, onions, garlic, and tomatoes. Seasoned with herbs and spices for a comforting, protein-rich meal.~');
create_item(c, q'~Lobster Bisque~', q'~Luxurious French soup with lobster meat, cognac, cream, tomatoes, and aromatic vegetables. Silky, rich, and deeply flavorful.~');
create_item(c, q'~Matzo Ball Soup~', q'~Jewish comfort soup with fluffy matzo balls floating in golden chicken broth, carrots, celery, and fresh dill.~');
create_item(c, q'~Minestrone Soup~', q'~Hearty Italian soup filled with seasonal vegetables, beans, pasta, and tomatoes, simmered in a savory broth and seasoned with herbs. Served with crusty bread.~');
create_item(c, q'~Miso Soup~', q'~Traditional Japanese soup with a savory miso broth, soft tofu cubes, seaweed, and scallions. Light, warming, and perfect as a starter.~');
create_item(c, q'~Miso Udon Soup~', q'~Japanese soup with thick udon noodles, savory miso broth, shiitake mushrooms, wakame seaweed, and scallions. Vegetarian-friendly.~');
create_item(c, q'~Mulligatawny Soup~', q'~Anglo-Indian soup with chicken, lentils, apples, carrots, and curry spices simmered in a creamy broth. Served with rice.~');
create_item(c, q'~Oxtail Soup~', q'~Rich Indonesian soup with tender oxtail, potatoes, carrots, tomatoes, and aromatic spices. Served with steamed rice and sambal.~');
create_item(c, q'~Pho Ga~', q'~Vietnamese chicken noodle soup with rice noodles, tender chicken, star anise-infused broth, fresh herbs, bean sprouts, and lime wedges.~');
create_item(c, q'~Potato Leek Soup~', q'~French-inspired creamy soup with Yukon gold potatoes, leeks, onions, and fresh thyme. Finished with a swirl of cream.~');
create_item(c, q'~Pozole Verde~', q'~Mexican green hominy soup with shredded chicken, tomatillos, poblano peppers, and fresh cilantro. Garnished with radishes and lettuce.~');
create_item(c, q'~Pumpkin Coconut Soup~', q'~Creamy vegan soup made from roasted pumpkin, coconut milk, ginger, lemongrass, and lime. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Pumpkin Soup~', q'~Creamy soup made from roasted pumpkin, onions, garlic, and warming spices, blended until smooth and finished with a swirl of cream and toasted seeds.~');
create_item(c, q'~Rasam~', q'~South Indian tangy tomato and tamarind soup with black pepper, cumin, garlic, and curry leaves. Vegan and gluten-free.~');
create_item(c, q'~Roasted Red Pepper Soup~', q'~Smooth, creamy soup made from fire-roasted red bell peppers, tomatoes, onions, and garlic. Finished with basil oil.~');
create_item(c, q'~Sambar~', q'~South Indian lentil and vegetable soup flavored with tamarind, curry leaves, mustard seeds, and sambar powder. Vegan and gluten-free.~');
create_item(c, q'~Seafood Bouillabaisse~', q'~French Provençal fish stew with mussels, shrimp, white fish, tomatoes, fennel, saffron, and garlic. Served with rouille and crusty bread.~');
create_item(c, q'~Shorbat Adas~', q'~Middle Eastern lentil soup with red lentils, onions, carrots, cumin, and lemon juice. Vegan, hearty, and warming.~');
create_item(c, q'~Sinigang na Baboy~', q'~Filipino pork soup with tamarind broth, tomatoes, daikon, eggplant, and green beans. Sour, savory, and comforting.~');
create_item(c, q'~Sopa de Ajo~', q'~Spanish garlic soup with rustic bread, poached egg, smoked paprika, and serrano ham simmered in a savory broth.~');
create_item(c, q'~Sopa de Lima~', q'~Yucatecan chicken soup with lime-infused broth, shredded chicken, crispy tortilla strips, tomatoes, and bell peppers. Garnished with fresh lime wedges.~');
create_item(c, q'~Sopa de Mani~', q'~Bolivian peanut soup with shredded chicken, potatoes, carrots, peas, and rice in a creamy, nutty broth. Garnished with shoestring potatoes.~');
create_item(c, q'~Sopa de Quinoa~', q'~Andean quinoa soup with potatoes, carrots, peas, corn, and fresh herbs simmered in a light vegetable broth. Vegan and gluten-free.~');
create_item(c, q'~Spicy Black Bean Soup~', q'~Mexican-inspired vegan soup with black beans, tomatoes, onions, jalapeños, cumin, and lime. Garnished with avocado and cilantro.~');
create_item(c, q'~Spicy Chorizo and Potato Soup~', q'~Spanish soup with smoky chorizo sausage, potatoes, onions, garlic, and paprika simmered in a rich broth.~');
create_item(c, q'~Split Pea Soup~', q'~Classic soup with green split peas, smoked ham, carrots, celery, and onions simmered until creamy and thick.~');
create_item(c, q'~Sweet Corn Soup~', q'~Chinese-style vegetarian soup with sweet corn kernels, carrots, peas, and egg ribbons in a light, savory broth.~');
create_item(c, q'~Thai Coconut Soup~', q'~Tom Kha Gai: Thai soup with chicken, coconut milk, galangal, lemongrass, kaffir lime leaves, mushrooms, and chili. Finished with fresh cilantro.~');
create_item(c, q'~Tofu Miso Soup~', q'~A light Japanese soup with silken tofu cubes, wakame seaweed, and scallions in a savory miso broth. Served hot as a comforting starter.~');
create_item(c, q'~Tofu Pho~', q'~A fragrant Vietnamese noodle soup with rice noodles, silken tofu, bean sprouts, fresh herbs, and a savory, aromatic broth infused with star anise and cinnamon.~');
create_item(c, q'~Tofu and Kimchi Stew~', q'~A spicy Korean jjigae with tofu cubes, kimchi, mushrooms, and scallions simmered in a rich, flavorful broth. Served bubbling hot with steamed rice.~');
create_item(c, q'~Tom Yum Goong~', q'~Spicy Thai soup with shrimp, lemongrass, kaffir lime leaves, galangal, mushrooms, and chili paste in a tangy broth. Finished with fresh cilantro.~');
create_item(c, q'~Tomato Soup~', q'~Classic creamy tomato soup made from ripe tomatoes, onions, garlic, and herbs, simmered and blended until smooth. Served hot with a swirl of cream.~');
create_item(c, q'~Turkey Wild Rice Soup~', q'~Hearty soup with roasted turkey, wild rice, carrots, celery, mushrooms, and fresh herbs in a savory broth.~');
create_item(c, q'~Vegetable Barley Soup~', q'~Hearty vegan soup with pearl barley, carrots, celery, tomatoes, green beans, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Vegetarian Avgolemono~', q'~Greek lemon and rice soup with vegetable broth, eggs, lemon juice, and fresh dill. Vegetarian and gluten-free.~');
create_item(c, q'~Vegetarian Borscht~', q'~Eastern European beet soup with cabbage, potatoes, carrots, onions, and fresh dill. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Caldo Verde~', q'~Portuguese soup with potatoes, collard greens, onions, and smoked paprika simmered in a flavorful vegetable broth. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Chicken Mull~', q'~Southern American soup with plant-based chicken, milk, onions, celery, and crumbled saltine crackers. Creamy and comforting.~');
create_item(c, q'~Vegetarian Chicken Tortilla Soup~', q'~Mexican soup with plant-based chicken, tomatoes, corn, black beans, and crispy tortilla strips in a spicy, smoky broth.~');
create_item(c, q'~Vegetarian Chicken and Lentil Soup~', q'~Hearty soup with plant-based chicken, green lentils, carrots, celery, onions, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Vegetarian Chicken and Rice Soup~', q'~Classic comfort soup with plant-based chicken, long-grain rice, carrots, celery, and onions simmered in a savory broth.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Barley Soup~', q'~Hearty soup with plant-based chicken, pearl barley, carrots, celery, onions, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Broccoli and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, roasted parsnips, plant-based chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Broccoli, Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, Yukon gold potatoes, roasted parsnips, plant-based chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Broccoli, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, roasted pumpkin, parsnips, plant-based chicken, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Broccoli, Spinach, Sweet Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, spinach, roasted sweet potatoes, roasted parsnips, plant-based chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Broccoli, Spinach, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, spinach, roasted parsnips, plant-based chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Broccoli, Sweet Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh broccoli, roasted sweet potatoes, roasted parsnips, plant-based chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Carrot Soup~', q'~Smooth, vibrant soup made from roasted carrots, plant-based chicken, onions, and coconut milk. Finished with fresh chives.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Cauliflower Soup~', q'~Smooth, velvety soup made from roasted cauliflower, plant-based chicken, onions, and garlic. Finished with truffle oil.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Lentil Soup~', q'~Hearty soup with plant-based chicken, green lentils, carrots, celery, onions, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Minestrone~', q'~Italian soup with plant-based chicken, seasonal vegetables, beans, pasta, and tomatoes simmered in a savory broth.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Noodle Soup~', q'~Classic soup with plant-based chicken, egg noodles, carrots, celery, onions, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Parsnip Soup~', q'~Smooth, sweet soup made from roasted parsnips, plant-based chicken, onions, garlic, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Potato, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from Yukon gold potatoes, roasted pumpkin, parsnips, plant-based chicken, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Potato, Spinach, and Parsnip Soup~', q'~Smooth, sweet soup made from Yukon gold potatoes, fresh spinach, roasted parsnips, plant-based chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Pumpkin Soup~', q'~Creamy soup with plant-based chicken, roasted pumpkin, onions, garlic, and warming spices. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Pumpkin and Parsnip Soup~', q'~Smooth, sweet soup made from roasted pumpkin, parsnips, plant-based chicken, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Pumpkin and Sweet Potato Soup~', q'~Smooth, velvety soup made from roasted pumpkin, sweet potatoes, plant-based chicken, onions, and cream. Finished with toasted pumpkin seeds.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Soup~', q'~Classic soup with plant-based chicken, carrots, celery, potatoes, green beans, and fresh herbs simmered in a savory broth.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Spinach Soup~', q'~Light soup with plant-based chicken, fresh spinach, carrots, celery, and onions simmered in a savory broth.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Spinach and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, roasted parsnips, plant-based chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Spinach, Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, Yukon gold potatoes, roasted parsnips, plant-based chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Spinach, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, roasted pumpkin, parsnips, plant-based chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Spinach, Sweet Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from fresh spinach, roasted sweet potatoes, roasted parsnips, plant-based chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Sweet Corn Soup~', q'~Chinese-style soup with plant-based chicken, sweet corn kernels, egg ribbons, and scallions in a light, savory broth.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Sweet Potato and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, parsnips, plant-based chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Sweet Potato, Potato, and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, Yukon gold potatoes, roasted parsnips, plant-based chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Sweet Potato, Pumpkin, and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, pumpkin, parsnips, plant-based chicken, onions, and cream. Finished with crispy sage leaves.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Sweet Potato, Spinach, and Parsnip Soup~', q'~Smooth, sweet soup made from roasted sweet potatoes, fresh spinach, roasted parsnips, plant-based chicken, onions, and cream. Finished with nutmeg and Parmesan.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Tomato Soup~', q'~Classic creamy tomato soup with plant-based chicken, onions, garlic, and herbs, simmered and blended until smooth. Served hot with a swirl of cream.~');
create_item(c, q'~Vegetarian Chicken and Vegetable Zucchini Soup~', q'~Smooth, delicate soup made from fresh zucchini, plant-based chicken, onions, garlic, and fresh basil. Finished with a swirl of cream.~');
create_item(c, q'~Vegetarian Chupe de Camarones~', q'~Peruvian chowder with potatoes, corn, peas, evaporated milk, and aji amarillo chili. Rich, creamy, and spicy.~');
create_item(c, q'~Vegetarian Cullen Skink~', q'~Scottish soup with smoked tofu, potatoes, onions, and cream. Smoky, creamy, and deeply satisfying.~');
create_item(c, q'~Vegetarian French Onion Soup~', q'~Caramelized onions simmered in rich vegetable broth, topped with toasted baguette slices and melted Gruyère cheese. Served bubbling hot.~');
create_item(c, q'~Vegetarian Goulash Soup~', q'~Hungarian soup with potatoes, carrots, bell peppers, onions, and paprika simmered in a rich, spicy broth. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Harira~', q'~Moroccan soup with tomatoes, lentils, chickpeas, celery, and aromatic spices. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Hot and Sour Soup~', q'~Chinese soup with tofu, bamboo shoots, mushrooms, and wood ear fungus in a tangy, spicy broth. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Khao Soi~', q'~Northern Thai coconut curry noodle soup with tofu, crispy egg noodles, pickled mustard greens, and shallots. Spicy and aromatic.~');
create_item(c, q'~Vegetarian Kimchi Jjigae~', q'~Korean spicy stew with kimchi, tofu, mushrooms, and scallions simmered in a robust broth. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Laksa~', q'~Malaysian coconut curry noodle soup with tofu, rice noodles, bean sprouts, and fresh herbs in a spicy, aromatic broth. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Minestrone~', q'~Italian soup with seasonal vegetables, beans, pasta, and tomatoes simmered in a savory broth. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Mulligatawny~', q'~Indian-inspired soup with lentils, carrots, apples, coconut milk, and curry spices. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Pho~', q'~Vietnamese noodle soup with rice noodles, tofu, mushrooms, bok choy, bean sprouts, and aromatic spices in a savory vegetable broth.~');
create_item(c, q'~Vegetarian Potato Leek Soup~', q'~French-inspired creamy soup with Yukon gold potatoes, leeks, onions, and fresh thyme. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Pozole Verde~', q'~Mexican green hominy soup with tomatillos, poblano peppers, and fresh cilantro. Garnished with radishes and lettuce. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Rasam~', q'~South Indian tangy tomato and tamarind soup with black pepper, cumin, garlic, and curry leaves. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Sambar~', q'~South Indian lentil and vegetable soup flavored with tamarind, curry leaves, mustard seeds, and sambar powder. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Shorbat Adas~', q'~Middle Eastern lentil soup with red lentils, onions, carrots, cumin, and lemon juice. Vegan, hearty, and warming.~');
create_item(c, q'~Vegetarian Sopa de Ajo~', q'~Spanish garlic soup with rustic bread, poached egg, smoked paprika, and serrano ham simmered in a savory broth. Vegetarian-friendly.~');
create_item(c, q'~Vegetarian Sopa de Fideo~', q'~Mexican noodle soup with thin vermicelli, tomatoes, onions, garlic, and carrots simmered in a savory vegetable broth.~');
create_item(c, q'~Vegetarian Tom Kha~', q'~Thai coconut soup with tofu, mushrooms, lemongrass, galangal, kaffir lime leaves, and chili. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Tom Yum~', q'~Thai hot and sour soup with mushrooms, tomatoes, lemongrass, galangal, kaffir lime leaves, and chili. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Tortilla Soup~', q'~Mexican soup with tomatoes, black beans, corn, bell peppers, and crispy tortilla strips in a spicy, smoky broth. Vegan and gluten-free.~');
create_item(c, q'~Vegetarian Vegetable Barley Soup~', q'~Hearty vegan soup with pearl barley, carrots, celery, tomatoes, green beans, and fresh herbs simmered in a savory broth.~');


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


    

