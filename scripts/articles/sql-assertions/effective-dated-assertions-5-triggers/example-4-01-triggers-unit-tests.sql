set serveroutput on;
--testing effective dated triggers (inserts and updates should be equivalent)

    insert into loyalty_discounts
    set
        (status = 'New', discount_min = 0, changed_by = 'start')
        , (status = 'Preferred', discount_min = 0.05, changed_by = 'start')
        , (status = 'Elite', discount_min = 0.10, changed_by = 'start');


    insert into loyalty_discounts set status = 'New', discount_min = 0.01, changed_by = 'editor';
        
    insert into loyalty_discounts set status = 'Preferred', discount_min = 0.055, changed_by = 'editor';
    
    insert into loyalty_discounts set status = 'Elite', discount_min = 0.11, changed_by = 'editor';


select * from loyalty_discounts order by status, effective;

--updates 
--must set effective date  .. use 
--must only update if expires is null -- can be added to trigger.. can only update the current record
update loyalty_discounts set discount_min = discount_min + 0.01, effective = sysdate, changed_by = 'test'
where expires is null;





truncate table loyalty_discounts;

--normal testing.  all customers start at new, progress to higher levels
--use insert of new status level to update the period

insert into customers set (customer_name = 'test-n'), (customer_name = 'test-p'), (customer_name = 'test-e');

commit;

insert into customer_loyalty set 
    (customer_name = 'test-n', status = 'New')
   ,  (customer_name = 'test-p',status = 'New')
    , (customer_name = 'test-e', status = 'New');

commit;

insert into customer_loyalty set 
    (customer_name = 'test-n', status = 'Preferred')
   ,  (customer_name = 'test-p',status = 'Preferred')
    , (customer_name = 'test-e', status = 'Preferred');


insert into customer_loyalty set 
    (customer_name = 'test-n', status = 'Elite')
   ,  (customer_name = 'test-p',status = 'Elite')
    , (customer_name = 'test-e', status = 'Elite');


select * from customer_loyalty order by customer_name, effective;

--use update statements to change status

update customer_loyalty set status = 'New', effective = sysdate
where expires is null;

update customer_loyalty set status = 'Preferred', effective = sysdate
where  expires is null;

update customer_loyalty set status = 'Elite', effective = sysdate
where expires is null;


commit;

--try to set a customer expire date --trigger allows???? --customer ends up with no active row (definition of active is open ended)
--to prevent, dont allow user inserts to set expire date or dont allow any inserts to set expire dates???
--????is this a valid use case
insert into customer_loyalty set customer_name = 'test-e', status = 'Preferred', effective = sysdate, expires = sysdate + 10;

---if expires date is set, next effective record needs to start from max expires date
insert into customer_loyalty set customer_name = 'test-e', status = 'Elite', effective = (select max(expires) from customer_loyalty where customer_name = 'test-e');

--do update without filter on null expired = error
update customer_loyalty set status = 'Preferred', effective = sysdate
where customer_name = 'test-n';



commit;

truncate table customer_loyalty;

truncate table customers;

-- cannot update expired records at all - done
--todo:  trigger disallows user setting expires date - done
--todo:  test user defining effective date ranges...  cannot  set expire dates.. must enter each new period by effective date only