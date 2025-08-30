prompt loading menu items for category: Pastas
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
 

    c := 'Pastas';
    delete menu_items 
    where category_id = l_categories(c);

    dbms_output.put_line('Deleted ' || sql%rowcount || ' existing menu items for category: ' || c);

 


create_item(c, q'~Beef Stroganoff Fettuccine~', q'~Fettuccine pasta tossed with tender beef strips, mushrooms, onions, and a rich sour cream sauce. Finished with fresh dill.~');
create_item(c, q'~Bolognese Pasta~', q'~Pasta served with a hearty, slow-simmered meat sauce made from ground beef, tomatoes, onions, carrots, celery, and Italian herbs.~');
create_item(c, q'~Buffalo Chicken Mac~', q'~Elbow macaroni baked in a spicy buffalo cheese sauce with shredded chicken, topped with blue cheese crumbles and scallions.~');
create_item(c, q'~Cajun Chicken Penne~', q'~Penne pasta tossed with blackened chicken breast, bell peppers, onions, and a creamy Cajun-spiced sauce. Finished with scallions and parmesan.~');
create_item(c, q'~Cajun Shrimp Linguine~', q'~Linguine pasta tossed with Cajun-spiced shrimp, bell peppers, onions, and a creamy tomato sauce.~');
create_item(c, q'~Carbonara di Zucchini~', q'~Spaghetti tossed in a creamy sauce made from sautéed zucchini, eggs, pecorino romano, and crispy pancetta. Finished with cracked black pepper.~');
create_item(c, q'~Chicken Alfredo~', q'~Tender grilled chicken breast served over fettuccine pasta coated in a rich, creamy Alfredo sauce made with butter, cream, and parmesan cheese.~');
create_item(c, q'~Chicken Marsala Fettuccine~', q'~Fettuccine pasta tossed with sautéed chicken breast, mushrooms, and a rich Marsala wine sauce.~');
create_item(c, q'~Chicken Parmesan Penne~', q'~Penne pasta topped with crispy breaded chicken, marinara sauce, and melted mozzarella and parmesan cheeses.~');
create_item(c, q'~Chicken Piccata Spaghetti~', q'~Spaghetti tossed with sautéed chicken breast, capers, lemon juice, and parsley in a light white wine sauce.~');
create_item(c, q'~Chicken Tikka Masala Pasta~', q'~Penne pasta tossed with grilled chicken in a creamy tomato tikka masala sauce, finished with cilantro and toasted cumin seeds.~');
create_item(c, q'~Chicken and Artichoke Linguine~', q'~Linguine pasta tossed with grilled chicken, artichoke hearts, sun-dried tomatoes, and a lemon garlic sauce.~');
create_item(c, q'~Chicken and Broccoli Alfredo~', q'~Fettuccine pasta tossed with grilled chicken, steamed broccoli, and a rich Alfredo sauce.~');
create_item(c, q'~Chicken and Broccoli Fusilli~', q'~Fusilli pasta tossed with grilled chicken, steamed broccoli, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Broccoli Linguine~', q'~Linguine pasta tossed with grilled chicken, steamed broccoli, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Broccoli Penne~', q'~Penne pasta tossed with grilled chicken, steamed broccoli, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Mushroom Penne~', q'~Penne pasta tossed with sautéed chicken, mushrooms, garlic, and a creamy white wine sauce.~');
create_item(c, q'~Chicken and Mushroom Tagliatelle~', q'~Tagliatelle pasta tossed with sautéed chicken, mushrooms, garlic, and a creamy white wine sauce.~');
create_item(c, q'~Chicken and Roasted Red Pepper Penne~', q'~Penne pasta tossed with grilled chicken, roasted red peppers, spinach, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Spinach Alfredo~', q'~Fettuccine pasta tossed with grilled chicken, sautéed spinach, and a creamy Alfredo sauce.~');
create_item(c, q'~Chicken and Spinach Cannelloni~', q'~Cannelloni tubes filled with chicken, spinach, and ricotta, baked in a tomato cream sauce.~');
create_item(c, q'~Chicken and Spinach Fusilli~', q'~Fusilli pasta tossed with grilled chicken, sautéed spinach, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Spinach Linguine~', q'~Linguine pasta tossed with grilled chicken, sautéed spinach, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Spinach Penne~', q'~Penne pasta tossed with grilled chicken, sautéed spinach, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Sun-Dried Tomato Farfalle~', q'~Bowtie pasta tossed with grilled chicken, sun-dried tomatoes, spinach, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Sun-Dried Tomato Fusilli~', q'~Fusilli pasta tossed with grilled chicken, sun-dried tomatoes, spinach, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Sun-Dried Tomato Linguine~', q'~Linguine pasta tossed with grilled chicken, sun-dried tomatoes, spinach, and a creamy garlic sauce.~');
create_item(c, q'~Chicken and Sun-Dried Tomato Penne~', q'~Penne pasta tossed with grilled chicken, sun-dried tomatoes, spinach, and a creamy garlic sauce.~');
create_item(c, q'~Coconut Curry Rice Noodles~', q'~Rice noodles tossed in a creamy coconut curry sauce with tofu, bell peppers, snap peas, and Thai basil.~');
create_item(c, q'~Eggplant Parmesan Spaghetti~', q'~Spaghetti topped with crispy breaded eggplant slices, marinara sauce, and melted mozzarella and parmesan cheeses.~');
create_item(c, q'~Fettuccine Alfredo~', q'~Fettuccine pasta tossed in a luxurious Alfredo sauce made from butter, heavy cream, and parmesan cheese. Creamy, rich, and comforting.~');
create_item(c, q'~Gluten-Free Chickpea Penne Primavera~', q'~Chickpea penne pasta tossed with a medley of seasonal vegetables, garlic, and extra virgin olive oil. Finished with fresh basil and vegan parmesan.~');
create_item(c, q'~Gnocchi~', q'~Soft, pillowy potato dumplings tossed in a savory tomato sauce with garlic, basil, and a touch of olive oil. Served hot and topped with grated parmesan cheese and cracked black pepper.~');
create_item(c, q'~Greek Orzo Salad~', q'~Orzo pasta tossed with cherry tomatoes, cucumber, Kalamata olives, feta cheese, red onion, and oregano vinaigrette.~');
create_item(c, q'~Italian Sausage Orecchiette~', q'~Orecchiette pasta tossed with crumbled Italian sausage, broccoli rabe, garlic, and red pepper flakes. Finished with grated pecorino.~');
create_item(c, q'~Italian Seafood Linguine~', q'~Linguine pasta tossed with shrimp, scallops, calamari, and mussels in a garlic white wine sauce.~');
create_item(c, q'~Japanese Udon Noodle Soup~', q'~Thick udon noodles served in a savory dashi broth with shiitake mushrooms, scallions, nori, and a soft-boiled egg.~');
create_item(c, q'~Japanese Yakisoba~', q'~Wheat noodles stir-fried with cabbage, carrots, onions, and shiitake mushrooms in a sweet-savory yakisoba sauce. Garnished with pickled ginger and nori flakes.~');
create_item(c, q'~Korean Japchae~', q'~Sweet potato glass noodles stir-fried with beef strips, spinach, carrots, mushrooms, and onions in a soy-sesame sauce. Garnished with toasted sesame seeds.~');
create_item(c, q'~Lasagna~', q'~Layered pasta dish with sheets of pasta, rich meat sauce, creamy béchamel, and melted mozzarella and parmesan cheeses. Baked until bubbly and golden.~');
create_item(c, q'~Lemon Garlic Shrimp Linguine~', q'~Linguine pasta tossed with succulent shrimp, sautéed in olive oil, garlic, lemon zest, and fresh parsley. Finished with a splash of white wine and cracked pepper.~');
create_item(c, q'~Lemon Ricotta Tortellini~', q'~Cheese tortellini tossed in a zesty lemon ricotta sauce with fresh peas and mint.~');
create_item(c, q'~Lobster Ravioli~', q'~Delicate pasta pockets filled with lobster meat, ricotta, and herbs, served in a creamy tomato-vodka sauce with a touch of tarragon.~');
create_item(c, q'~Mac and Cheese~', q'~Elbow macaroni baked in a creamy cheese sauce made from cheddar and parmesan, topped with buttery breadcrumbs and baked until golden.~');
create_item(c, q'~Moroccan Harissa Pasta~', q'~Fusilli pasta tossed with roasted vegetables, chickpeas, and a spicy harissa tomato sauce. Garnished with preserved lemon and fresh mint.~');
create_item(c, q'~Pasta Puttanesca~', q'~Spaghetti tossed in a robust tomato sauce with olives, capers, anchovies, garlic, and red pepper flakes. Finished with fresh parsley.~');
create_item(c, q'~Pasta alla Abruzzese~', q'~Spaghetti alla chitarra tossed with lamb ragù, tomatoes, and pecorino cheese.~');
create_item(c, q'~Pasta alla Barese~', q'~Orecchiette pasta tossed with sausage, broccoli rabe, garlic, and chili flakes.~');
create_item(c, q'~Pasta alla Basilicata~', q'~Orecchiette pasta tossed with sausage, broccoli rabe, garlic, and chili flakes.~');
create_item(c, q'~Pasta alla Bolognese Bianca~', q'~Tagliatelle pasta tossed with a white Bolognese sauce made from ground veal, pork, and beef, simmered with milk and white wine.~');
create_item(c, q'~Pasta alla Boscaiola~', q'~Penne pasta tossed with sautéed mushrooms, pancetta, peas, and a creamy tomato sauce.~');
create_item(c, q'~Pasta alla Calabrese~', q'~Spaghetti tossed with spicy Calabrian chili, garlic, anchovies, and toasted breadcrumbs.~');
create_item(c, q'~Pasta alla Calabria~', q'~Fileja pasta tossed with spicy nduja sausage, tomatoes, and pecorino cheese.~');
create_item(c, q'~Pasta alla Campania~', q'~Paccheri pasta tossed with seafood, tomatoes, garlic, and parsley.~');
create_item(c, q'~Pasta alla Campidanese~', q'~Malloreddus pasta tossed with sausage, saffron, tomatoes, and pecorino cheese.~');
create_item(c, q'~Pasta alla Carrettiera~', q'~Spaghetti tossed with garlic, chili flakes, parsley, and toasted breadcrumbs in extra virgin olive oil.~');
create_item(c, q'~Pasta alla Emilia~', q'~Tortellini pasta filled with pork, prosciutto, and parmesan, served in a rich broth.~');
create_item(c, q'~Pasta alla Friulana~', q'~Cjarsons pasta filled with potatoes, herbs, and raisins, served in a butter and smoked ricotta sauce.~');
create_item(c, q'~Pasta alla Genovese~', q'~Ziti pasta tossed with slow-cooked beef and onions in a rich Genovese sauce, finished with grated parmesan.~');
create_item(c, q'~Pasta alla Gricia~', q'~Rigatoni tossed with crispy guanciale, pecorino romano, and black pepper in a light olive oil sauce.~');
create_item(c, q'~Pasta alla Lazio~', q'~Bucatini pasta tossed with guanciale, pecorino romano, and black pepper in a light olive oil sauce.~');
create_item(c, q'~Pasta alla Liguria~', q'~Trofie pasta tossed with basil pesto, green beans, and potatoes.~');
create_item(c, q'~Pasta alla Livornese~', q'~Spaghetti tossed with tuna, tomatoes, olives, capers, and chili flakes in a savory sauce.~');
create_item(c, q'~Pasta alla Luciana~', q'~Spaghetti tossed with octopus, tomatoes, olives, capers, and chili flakes in a savory sauce.~');
create_item(c, q'~Pasta alla Marche~', q'~Vincisgrassi lasagna layered with meat ragù, mushrooms, béchamel, and parmesan cheese.~');
create_item(c, q'~Pasta alla Milanese~', q'~Risotto alla Milanese made with Arborio rice, saffron, and parmesan cheese.~');
create_item(c, q'~Pasta alla Molise~', q'~Cavatelli pasta tossed with broccoli, garlic, chili flakes, and olive oil.~');
create_item(c, q'~Pasta alla Napoletana~', q'~Spaghetti tossed in a classic Neapolitan tomato sauce with garlic, basil, and olive oil.~');
create_item(c, q'~Pasta alla Norma~', q'~Rigatoni pasta tossed with roasted eggplant, tomato sauce, garlic, and fresh basil. Topped with grated ricotta salata and a drizzle of olive oil.~');
create_item(c, q'~Pasta alla Piemontese~', q'~Agnolotti pasta filled with roasted meat, served in a sage butter sauce with parmesan.~');
create_item(c, q'~Pasta alla Pugliese~', q'~Orecchiette pasta tossed with broccoli rabe, garlic, chili flakes, and toasted breadcrumbs.~');
create_item(c, q'~Pasta alla Romagna~', q'~Cappelletti pasta filled with cheese and herbs, served in a chicken broth.~');
create_item(c, q'~Pasta alla Romagnola~', q'~Garganelli pasta tossed with prosciutto, peas, cream, and parmesan cheese.~');
create_item(c, q'~Pasta alla Romana~', q'~Bucatini pasta tossed with guanciale, pecorino romano, and black pepper in a light olive oil sauce.~');
create_item(c, q'~Pasta alla Sarda~', q'~Fregola pasta tossed with sardines, wild fennel, pine nuts, and raisins in a tomato sauce.~');
create_item(c, q'~Pasta alla Sardegna~', q'~Fregola pasta tossed with clams, saffron, tomatoes, and parsley.~');
create_item(c, q'~Pasta alla Sicilia~', q'~Busiate pasta tossed with Sicilian pesto made from almonds, tomatoes, basil, and garlic.~');
create_item(c, q'~Pasta alla Siciliana~', q'~Penne pasta tossed with roasted eggplant, capers, olives, and a spicy tomato sauce.~');
create_item(c, q'~Pasta alla Sorrentina~', q'~Gnocchi baked in a tomato sauce with mozzarella, basil, and parmesan cheese until golden and bubbly.~');
create_item(c, q'~Pasta alla Toscana~', q'~Pappardelle pasta tossed with wild boar ragù, tomatoes, red wine, and rosemary.~');
create_item(c, q'~Pasta alla Trapanese~', q'~Busiate pasta tossed in a Sicilian almond-tomato pesto with garlic, basil, and pecorino.~');
create_item(c, q'~Pasta alla Triestina~', q'~Jota soup with pasta, beans, sauerkraut, and smoked pork.~');
create_item(c, q'~Pasta alla Umbria~', q'~Strangozzi pasta tossed with black truffle, garlic, and olive oil.~');
create_item(c, q'~Pasta alla Valdostana~', q'~Lasagna sheets layered with fontina cheese, ham, and béchamel sauce, baked until golden.~');
create_item(c, q'~Pasta alla Veneta~', q'~Bigoli pasta tossed with anchovy sauce, onions, and parsley.~');
create_item(c, q'~Pasta alla Zozzona~', q'~Rigatoni tossed with sausage, pancetta, tomato sauce, eggs, and pecorino romano.~');
create_item(c, q'~Penne Arrabbiata~', q'~Penne pasta tossed in a spicy tomato sauce made with garlic, crushed red pepper flakes, and extra virgin olive oil. Garnished with fresh parsley.~');
create_item(c, q'~Pesto Farfalle with Sun-Dried Tomatoes~', q'~Bowtie pasta tossed in basil pesto with sun-dried tomatoes, toasted pine nuts, and shaved parmesan.~');
create_item(c, q'~Pesto Pasta~', q'~Al dente pasta tossed with vibrant basil pesto sauce, made from fresh basil, garlic, pine nuts, parmesan cheese, and extra virgin olive oil. Garnished with more cheese and pine nuts.~');
create_item(c, q'~Pumpkin Sage Ravioli~', q'~Handmade ravioli stuffed with roasted pumpkin, nutmeg, and sage, served in a brown butter sauce with toasted walnuts and crispy sage leaves.~');
create_item(c, q'~Ravioli~', q'~Tender pasta pockets stuffed with a creamy blend of ricotta cheese and spinach, gently simmered and served with a rich tomato basil sauce. Finished with a sprinkle of parmesan and fresh herbs.~');
create_item(c, q'~Saffron Seafood Risotto~', q'~Arborio rice simmered with saffron, white wine, shrimp, scallops, and mussels. Finished with lemon zest and fresh dill.~');
create_item(c, q'~Seafood Fra Diavolo~', q'~Spaghetti tossed with a spicy tomato sauce, loaded with mussels, shrimp, calamari, and clams. Finished with fresh basil and a drizzle of olive oil.~');
create_item(c, q'~Seitan Bolognese~', q'~Hearty Italian pasta dish with seitan crumbles simmered in a rich tomato sauce with garlic, onions, carrots, and Italian herbs. Served over spaghetti.~');
create_item(c, q'~Singapore Curry Noodles~', q'~Rice vermicelli noodles stir-fried with shrimp, chicken, egg, bean sprouts, and bell peppers in a fragrant curry sauce.~');
create_item(c, q'~Spaghetti Carbonara~', q'~Classic Italian pasta dish with al dente spaghetti tossed in a creamy sauce made from eggs, grated pecorino romano cheese, crispy pancetta, and freshly cracked black pepper. Served hot and garnished with extra cheese.~');
create_item(c, q'~Spanish Chorizo Paella Pasta~', q'~Orzo pasta cooked with Spanish chorizo, saffron, bell peppers, peas, and tomatoes. Finished with fresh parsley.~');
create_item(c, q'~Spicy Sichuan Dan Dan Noodles~', q'~Wheat noodles served in a spicy, numbing Sichuan pepper sauce with ground pork, pickled mustard greens, and scallions.~');
create_item(c, q'~Spicy Thai Drunken Noodles~', q'~Wide rice noodles stir-fried with chicken, bell peppers, onions, Thai basil, and chilies in a savory soy sauce.~');
create_item(c, q'~Thai Peanut Noodle Bowl~', q'~Rice noodles tossed in a spicy peanut sauce with shredded carrots, bell peppers, bean sprouts, and roasted peanuts. Served with lime wedges and cilantro.~');
create_item(c, q'~Tofu and Peanut Noodles~', q'~Rice noodles tossed with crispy tofu, shredded vegetables, and a creamy peanut sauce. Topped with chopped peanuts and fresh cilantro.~');
create_item(c, q'~Tofu and Pineapple Fried Rice~', q'~Stir-fried jasmine rice with tofu cubes, sweet pineapple, peas, carrots, and cashews in a savory soy sauce. Garnished with scallions and cilantro.~');
create_item(c, q'~Truffle Mushroom Tagliatelle~', q'~Fresh tagliatelle pasta tossed with sautéed wild mushrooms, white truffle oil, garlic, and shallots, finished with a sprinkle of chives and shaved parmesan.~');
create_item(c, q'~Tuscan White Bean Pasta~', q'~Rigatoni tossed with cannellini beans, garlic, rosemary, sun-dried tomatoes, and spinach in a light olive oil sauce.~');
create_item(c, q'~Vegan Alfredo Zucchini Noodles~', q'~Spiralized zucchini noodles tossed in a creamy cashew Alfredo sauce with sautéed mushrooms and spinach. Garnished with nutritional yeast and fresh basil.~');
create_item(c, q'~Vegan Avocado Pesto Pasta~', q'~Linguine tossed in a creamy avocado-basil pesto sauce with cherry tomatoes and toasted pine nuts.~');
create_item(c, q'~Vegan Broccoli Alfredo~', q'~Fettuccine pasta tossed in a vegan Alfredo sauce made from cashews and nutritional yeast, with steamed broccoli florets.~');
create_item(c, q'~Vegan Cashew Cream Penne~', q'~Penne pasta tossed in a silky cashew cream sauce with sautéed mushrooms, spinach, and roasted garlic. Garnished with fresh parsley.~');
create_item(c, q'~Vegan Creamy Avocado Linguine~', q'~Linguine tossed in a creamy avocado sauce with cherry tomatoes, arugula, and toasted pine nuts.~');
create_item(c, q'~Vegan Creamy Avocado Pesto Pasta~', q'~Linguine tossed in a creamy avocado-basil pesto sauce with cherry tomatoes and pine nuts.~');
create_item(c, q'~Vegan Creamy Cauliflower Mac~', q'~Elbow macaroni tossed in a creamy cauliflower cashew cheese sauce with steamed broccoli.~');
create_item(c, q'~Vegan Creamy Lemon Asparagus Pasta~', q'~Penne pasta tossed in a creamy lemon cashew sauce with roasted asparagus and peas.~');
create_item(c, q'~Vegan Creamy Lemon Broccoli Fusilli~', q'~Fusilli pasta tossed in a creamy lemon cashew sauce with steamed broccoli and peas.~');
create_item(c, q'~Vegan Creamy Lemon Broccoli Linguine~', q'~Linguine pasta tossed in a creamy lemon cashew sauce with steamed broccoli and peas.~');
create_item(c, q'~Vegan Creamy Lemon Broccoli Pasta~', q'~Fusilli pasta tossed in a creamy lemon cashew sauce with steamed broccoli and peas.~');
create_item(c, q'~Vegan Creamy Lemon Broccoli Penne~', q'~Penne pasta tossed in a creamy lemon cashew sauce with steamed broccoli and peas.~');
create_item(c, q'~Vegan Creamy Lemon Dill Pasta~', q'~Penne pasta tossed in a creamy cashew lemon dill sauce with sautéed zucchini and peas.~');
create_item(c, q'~Vegan Creamy Lemon Spinach Pasta~', q'~Fusilli pasta tossed in a creamy lemon cashew sauce with sautéed spinach and peas.~');
create_item(c, q'~Vegan Creamy Roasted Garlic Fusilli~', q'~Fusilli pasta tossed in a creamy roasted garlic cashew sauce with sautéed mushrooms.~');
create_item(c, q'~Vegan Creamy Roasted Garlic Linguine~', q'~Linguine pasta tossed in a creamy roasted garlic cashew sauce with sautéed mushrooms.~');
create_item(c, q'~Vegan Creamy Roasted Garlic Penne~', q'~Penne pasta tossed in a creamy roasted garlic cashew sauce with sautéed mushrooms.~');
create_item(c, q'~Vegan Creamy Roasted Red Pepper Fusilli~', q'~Fusilli pasta tossed in a creamy roasted red pepper cashew sauce with sautéed spinach.~');
create_item(c, q'~Vegan Creamy Roasted Red Pepper Linguine~', q'~Linguine pasta tossed in a creamy roasted red pepper cashew sauce with sautéed spinach.~');
create_item(c, q'~Vegan Creamy Roasted Red Pepper Penne~', q'~Penne pasta tossed in a creamy roasted red pepper cashew sauce with sautéed spinach.~');
create_item(c, q'~Vegan Creamy Spinach Alfredo~', q'~Fettuccine pasta tossed in a creamy cashew Alfredo sauce with sautéed spinach.~');
create_item(c, q'~Vegan Creamy Spinach Lemon Fusilli~', q'~Fusilli pasta tossed in a creamy lemon cashew sauce with sautéed spinach and peas.~');
create_item(c, q'~Vegan Creamy Spinach Lemon Linguine~', q'~Linguine pasta tossed in a creamy lemon cashew sauce with sautéed spinach and peas.~');
create_item(c, q'~Vegan Creamy Spinach Lemon Pasta~', q'~Penne pasta tossed in a creamy lemon cashew sauce with sautéed spinach and peas.~');
create_item(c, q'~Vegan Creamy Spinach Lemon Penne~', q'~Penne pasta tossed in a creamy lemon cashew sauce with sautéed spinach and peas.~');
create_item(c, q'~Vegan Creamy Spinach Mushroom Pasta~', q'~Penne pasta tossed in a creamy cashew sauce with sautéed spinach and mushrooms.~');
create_item(c, q'~Vegan Creamy Spinach Orzo~', q'~Orzo pasta tossed in a creamy cashew sauce with sautéed spinach, garlic, and lemon zest.~');
create_item(c, q'~Vegan Creamy Sun-Dried Tomato Pasta~', q'~Fusilli pasta tossed in a creamy sun-dried tomato cashew sauce with spinach and basil.~');
create_item(c, q'~Vegan Creamy Tomato Basil Fusilli~', q'~Fusilli pasta tossed in a creamy tomato basil cashew sauce with roasted garlic.~');
create_item(c, q'~Vegan Creamy Tomato Basil Linguine~', q'~Linguine pasta tossed in a creamy tomato basil cashew sauce with roasted garlic.~');
create_item(c, q'~Vegan Creamy Tomato Basil Penne~', q'~Penne pasta tossed in a creamy tomato basil cashew sauce with roasted garlic.~');
create_item(c, q'~Vegan Creamy Tomato Spinach Fusilli~', q'~Fusilli pasta tossed in a creamy tomato cashew sauce with sautéed spinach.~');
create_item(c, q'~Vegan Creamy Tomato Spinach Linguine~', q'~Linguine pasta tossed in a creamy tomato cashew sauce with sautéed spinach.~');
create_item(c, q'~Vegan Creamy Tomato Spinach Pasta~', q'~Fusilli pasta tossed in a creamy tomato cashew sauce with sautéed spinach.~');
create_item(c, q'~Vegan Creamy Tomato Spinach Penne~', q'~Penne pasta tossed in a creamy tomato cashew sauce with sautéed spinach.~');
create_item(c, q'~Vegan Lemon Asparagus Pasta~', q'~Penne pasta tossed with roasted asparagus, lemon zest, garlic, and a creamy cashew sauce. Garnished with fresh parsley.~');
create_item(c, q'~Vegan Lemon Garlic Angel Hair~', q'~Angel hair pasta tossed with roasted garlic, lemon zest, olive oil, and steamed broccoli florets.~');
create_item(c, q'~Vegan Mediterranean Orzo~', q'~Orzo pasta tossed with roasted eggplant, cherry tomatoes, olives, and a lemon-herb vinaigrette.~');
create_item(c, q'~Vegan Miso Sesame Soba~', q'~Buckwheat soba noodles tossed in a miso-sesame dressing with edamame, shredded carrots, and scallions.~');
create_item(c, q'~Vegan Mushroom Stroganoff~', q'~Egg-free noodles tossed in a creamy mushroom stroganoff sauce with caramelized onions and fresh dill.~');
create_item(c, q'~Vegan Pumpkin Alfredo~', q'~Fettuccine pasta tossed in a creamy pumpkin Alfredo sauce with sautéed mushrooms and sage.~');
create_item(c, q'~Vegan Roasted Beet Ravioli~', q'~Handmade ravioli filled with roasted beets and vegan ricotta, served in a sage brown butter sauce.~');
create_item(c, q'~Vegan Roasted Cauliflower Penne~', q'~Penne pasta tossed with roasted cauliflower, garlic, lemon zest, and a creamy tahini sauce.~');
create_item(c, q'~Vegan Roasted Garlic Alfredo~', q'~Fettuccine pasta tossed in a creamy roasted garlic cashew Alfredo sauce with sautéed mushrooms.~');
create_item(c, q'~Vegan Roasted Red Pepper Fusilli~', q'~Fusilli pasta tossed in a creamy roasted red pepper sauce with sautéed spinach and garlic. Garnished with fresh basil.~');
create_item(c, q'~Vegan Smoky Chipotle Mac~', q'~Elbow macaroni tossed in a smoky chipotle cashew cheese sauce with roasted corn and black beans.~');
create_item(c, q'~Vegan Spinach Cannelloni~', q'~Cannelloni tubes filled with a creamy blend of spinach, tofu ricotta, and fresh herbs, baked in a tangy tomato basil sauce and topped with vegan mozzarella.~');
create_item(c, q'~Vegan Sweet Potato Gnocchi~', q'~Handmade sweet potato gnocchi tossed in a sage brown butter sauce with toasted pecans and crispy kale.~');
create_item(c, q'~Vegan Thai Green Curry Noodles~', q'~Rice noodles tossed in a fragrant Thai green curry sauce with tofu, bamboo shoots, and Thai basil.~');
create_item(c, q'~Vegan Thai Red Curry Noodles~', q'~Rice noodles tossed in a spicy Thai red curry sauce with tofu, bell peppers, and Thai basil.~');
create_item(c, q'~Vegan Tomato Basil Spaghetti~', q'~Spaghetti tossed in a slow-simmered tomato basil sauce with garlic and olive oil. Garnished with fresh basil.~');


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


    

