drop table if exists recipes purge
/

CREATE TABLE if not exists recipes (
    id NUMBER generated always as identity primary key
    , name VARCHAR2(100) not null unique
    , doc VARCHAR2(4000)
    , embedding VECTOR(*,*)
    , embedding_model varchar2(50)
    , embedding_q vector(*,*)
)
/

--truncate table recipes preserve storage

declare

    procedure insert_recipe(p_name in varchar2, p_details in varchar2)
    is
    begin
        insert into recipes(name,doc) values (p_name, p_details);
    end insert_recipe;

begin

execute immediate 'truncate table recipes';

insert_recipe('Grilled Cheese Sandwiches', 'Cheddar Cheese and Tomato slices on whole wheat bread.  Toasted lightly for a quick and delicious lunch');
insert_recipe('Miso Soup', 'Miso with tofu cubes and sliced green onions are the perfect complement to dinner.');
insert_recipe('Spaghetti Bowl', 'Classic spaghetti noodles topped with basil marinara sauce and parmesan cheese.');
insert_recipe('Spaghetti with Meatballs', 'Classic spaghetti noodles topped with basil marinara sauce and parmesan cheese and plant based meatballs.');
insert_recipe('Buckwheat Pancakes', 'Heart Healthy Buckwheat pancakes with maple syrup to start your day the high carb way!');
insert_recipe('Curried Tofu', 'Tofu, vegetables and a light curry sauce served over rice is a nutritious and easy to prepare meal anytime');
insert_recipe('Raspberry Tarts', 'Pureed fresh raspberries in a folded pie crust are a great finish for any meal.');
insert_recipe('Pumpkin Muffins', 'Traditional Pumpkin Bread recipe made into delicious muffins.  Not too sweet and somewhat healthy.  Perfect with morning coffee.');
insert_recipe('Banana Bread', 'Banana bread with walnuts and raisins is a healthy and nutritious snack with just the right sweetness.');
insert_recipe('Oatmeal Cookies', 'Homestyle cookies that are reminiscent of breakfast on a winter day.  Oatmeal and raisins with flour, oil and egg equivalent.  Baked freshly for a special treat');
insert_recipe('Strawberry Pie', 'Sliced Strawberries in a light syrup with a flaky pie crust are a great dessert option');
insert_recipe('Chocolate Cake', 'Dark chocolate, lots of sugar and creamy frosting make this the ultimate cake.');
insert_recipe('Granola', 'Rolled Oats, Cashew Nuts, Raisins coated with Maple Syrup and lightly toasted.  Served with soymilk and sliced bananas for a quick breakfast');
insert_recipe('Banana, Mango and Blueberry Smoothie', 'Bananas, Frozen Mango and fresh blueberries blended to perfection for a sweet smoothie treat');
insert_recipe('Shepherd''s Pie', 'Potatoes, gravy and plant based meat in a casserole.  Hearty comfort food at it''s best');



commit;



end;
/

