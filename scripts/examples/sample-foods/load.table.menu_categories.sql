set serveroutput on;

declare
    l_count number;
     procedure create_category(p_name in varchar2, p_description in varchar2, p_created_by in varchar2) 
     is
     begin
          insert into menu_categories (category_name, category_description, created_by)
          values (p_name, p_description, p_created_by);
     end;
begin

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
     

exception
     when others then
          dbms_output.put_line('Error creating categories: ' || sqlerrm);
          rollback;
end;
/
