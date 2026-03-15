prompt drop all objects
drop view if exists review_order_discounts;
drop package if exists sales_api;
drop assertion if exists customer_loyalty_fk_loyalty_discounts;
drop assertion if exists loyalty_discount_applied;
drop table if exists orders purge;
drop table if exists customer_loyalty purge;
drop table if exists customers purge;
drop table if exists loyalty_discounts purge;
drop table if exists loyalty purge;

