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

    c := 'Pizzas';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 
create_item(c, q'~BBQ Chicken Pizza~', q'~Pizza topped with tangy barbecue sauce, grilled chicken, red onions, mozzarella, and cheddar cheese. Baked until the crust is crisp and the cheese is bubbly.~');
create_item(c, q'~Chicken Pesto Pizza~', q'~A gourmet pizza with a base of basil pesto sauce, topped with grilled chicken breast slices, sun-dried tomatoes, mozzarella, and parmesan cheese. Baked until golden and garnished with fresh basil.~');
create_item(c, q'~Four Cheese Pizza~', q'~A decadent pizza with a blend of mozzarella, cheddar, parmesan, and gorgonzola cheeses, melted over a thin, crispy crust and finished with a sprinkle of herbs.~');
create_item(c, q'~Hawaiian Pizza~', q'~Pizza with a sweet and savory combination of sliced ham and juicy pineapple chunks, topped with mozzarella cheese and tomato sauce.~');
create_item(c, q'~Margherita Pizza~', q'~A traditional Neapolitan pizza featuring a thin, chewy crust topped with tangy tomato sauce, slices of fresh mozzarella cheese, and fragrant basil leaves. Baked in a hot oven until the cheese is bubbly and the crust is golden.~');
create_item(c, q'~Pepperoni Pizza~', q'~Classic pizza with a crispy crust, tangy tomato sauce, gooey mozzarella cheese, and generous slices of spicy pepperoni. Baked until the edges are golden and the cheese is bubbling.~');
create_item(c, q'~Sausage Pizza~', q'~A hearty pizza featuring Italian sausage crumbles, roasted red and green peppers, onions, mozzarella cheese, and a robust tomato sauce on a traditional pizza crust. Finished with a sprinkle of oregano.~');
create_item(c, q'~Seafood Pizza~', q'~A gourmet pizza topped with shrimp, calamari, and mussels, along with tomato sauce, mozzarella cheese, and fresh herbs. Baked until the seafood is tender.~');
create_item(c, q'~Spinach and Ricotta Pizza~', q'~Pizza topped with creamy ricotta cheese, sautéed spinach, mozzarella, and a hint of garlic, baked until golden and delicious.~');
create_item(c, q'~Tofu Sushi Rolls~', q'~Nori rolls filled with seasoned sushi rice, marinated tofu strips, avocado, cucumber, and carrots. Served with soy sauce, pickled ginger, and wasabi.~');
create_item(c, q'~Veggie Pizza~', q'~A hand-tossed pizza crust topped with tangy tomato sauce, mozzarella cheese, and a medley of fresh vegetables such as bell peppers, mushrooms, onions, olives, and spinach. Baked until the crust is crisp and the cheese is bubbly.~');


    select count(*) into l_count 
    from menu_items
    where category_id = l_categories(c);

    dbms_output.put_line('Created ' || l_count || ' menu items for category: ' || c);    

    commit;
    
    dbms_output.put_line('finished block');

exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/


    

