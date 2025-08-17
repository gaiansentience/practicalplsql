prompt loading menu categories
prompt script generated: 2025-08-17 21:10:29

set feedback on;
set serveroutput on;

declare
    l_count number;

    procedure create_category(
        p_name in menu_categories.category_name%type, 
        p_desc in menu_categories.category_description%type, 
        p_user in varchar2 default 'sample') 
    is
    begin
        insert into menu_categories(
            category_name, category_description, created_by
        ) values (
            p_name, p_desc, p_user);
    end create_category;
begin


    --delete menu_items;
    --dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items');

    delete menu_categories;  
    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu categories');
 


create_category(q'~Appetizers~', q'~Starters to whet your appetite~');
create_category(q'~Beverages~', q'~Drinks to complement your meal~');
create_category(q'~Breakfast~', q'~Morning meals to start your day~');
create_category(q'~Desserts~', q'~Sweet treats to end your meal~');
create_category(q'~Entrees~', q'~Hearty and filling main dishes~');
create_category(q'~Gluten-Free~', q'~Options for gluten-sensitive diners~');
create_category(q'~Pastas~', q'~Tasty pasta dishes with rich sauces~');
create_category(q'~Pizzas~', q'~Delicious pizzas with various toppings~');
create_category(q'~Salads~', q'~Fresh and healthy salads~');
create_category(q'~Sandwiches~', q'~Quick and easy sandwiches~');
create_category(q'~Seafood~', q'~Fresh seafood dishes~');
create_category(q'~Soups~', q'~Warm and comforting soups~');
create_category(q'~Sushi~', q'~Sushi and Sashimi platters~');
create_category(q'~Vegan~', q'~Healthy and tasty vegan dishes~');
create_category(q'~Vegetarian~', q'~Delicious vegetarian options~');


    select count(*) into l_count 
    from menu_categories;

    dbms_output.put_line('Created ' || l_count || ' menu categories');

    commit;

exception
    when others then
        dbms_output.put_line('Error creating categories: ' || sqlerrm);
        rollback;
end;
/


    

