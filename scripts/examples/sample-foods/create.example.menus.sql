prompt creating example for menu categories and menu items
prompt dropping previous example if exists
@drop.example.menus.sql
prompt creating tables
@create.table.menu_categories.sql
@create.table.menu_items.sql
prompt loading test data
@load.table.menu_categories.sql
@load.table.menu_items.sql
prompt created example for menu categories and menu items
