old:begin

dbms_output.put_line(q'#
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

     procedure create_item(p_category_name in varchar2, p_item_name in varchar2, p_description in varchar2, p_created_by in varchar2)
     is
        l_category_id integer := l_categories(p_category_name);
     begin     
        insert into menu_items (item_name, category_id, item_description, created_by)
        values (p_item_name, l_category_id, p_description, p_created_by);
     end create_item;

begin

    load_categories_array;
    c := '&&1';
    delete menu_items where category_id = l_categories(c);

 #');

 end;

new:begin

dbms_output.put_line(q'#
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

     procedure create_item(p_category_name in varchar2, p_item_name in varchar2, p_description in varchar2, p_created_by in varchar2)
     is
        l_category_id integer := l_categories(p_category_name);
     begin     
        insert into menu_items (item_name, category_id, item_description, created_by)
        values (p_item_name, l_category_id, p_description, p_created_by);
     end create_item;

begin

    load_categories_array;
    c := 'Desserts';
    delete menu_items where category_id = l_categories(c);

 #');

 end;

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

     procedure create_item(p_category_name in varchar2, p_item_name in varchar2, p_description in varchar2, p_created_by in varchar2)
     is
        l_category_id integer := l_categories(p_category_name);
     begin     
        insert into menu_items (item_name, category_id, item_description, created_by)
        values (p_item_name, l_category_id, p_description, p_created_by);
     end create_item;

begin

    load_categories_array;
    c := 'Desserts';
    delete menu_items where category_id = l_categories(c);

 

