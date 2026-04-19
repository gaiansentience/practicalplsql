create or replace trigger loyalty_discounts_trigger_c
for insert or update or delete on loyalty_discounts
compound trigger

    --rows cannot be deleted - direct check
    --effective date cannot be updated - functional check, if updating effective date, trigger expires row and creates a new period
    --expired rows cannot be updated
    --when user inserts a new effective row, trigger expires previous effective row
    --user updates of current effective row are converted to expirations and trigger inserts new row

    type t_change is record(
        status loyalty_discounts.status%type,
        discount_min loyalty_discounts.discount_min%type,
        effective loyalty_discounts.effective%type,
        expires loyalty_discounts.expires%type default null,
        changed_by loyalty_discounts.changed_by%type,
        action_needed varchar2(20)
        );
        
    type t_changes is table of t_change index by pls_integer;
    
    l_rows t_changes;
    l_row t_change;
    l_inserts t_changes;
    l_updates t_changes;
    
    before statement is
    begin
        if deleting then
            raise_application_error(-20101, 'deletes are not allowed for this table');
        end if;
    end before statement;
    
    before each row is
    begin
        if updating then
            if :old.expires is not null then
                raise_application_error(-20101,'Cannot update expired records');
            end if;
    
            dbms_output.put_line('before row updating: changed_by=' || :new.changed_by);
            if instr(:new.changed_by, '#TRG#') > 0 then
                --updates by trigger will only set expire date
                :new.changed_by := replace(:new.changed_by,'#TRG#');
                :new.discount_min := :old.discount_min;
                :new.effective := :old.effective;            
            else
                --user updates are converted to inserts by trigger
                --capture the values in the change record    
                l_row := t_change(:new.status, :new.discount_min, :new.effective, null, :new.changed_by || '#TRG#', 'INSERT');
                l_inserts(l_inserts.count + 1) := l_row;
                --set the row values back to original values except for expire which is set to effective date from the update
                :new.discount_min := :old.discount_min;
                :new.expires := l_row.effective; --:new.effective
                :new.effective := :old.effective;            
                :new.changed_by := :old.changed_by;
            end if;
            
        elsif inserting then
            if :new.expires is not null then
                raise_application_error(-20101, 'cannot insert with expire dates');
            end if;
            
            dbms_output.put_line('before row inserting: changed_by=' || :new.changed_by);
            if instr(:new.changed_by, '#TRG#') > 0 then
                --inserts by trigger are converted from user updates  
                :new.changed_by := replace(:new.changed_by,'#TRG#');         
            else
                --inserts by user must be matched by update by trigger of previous effective record
                l_row := t_change(:new.status,:new.discount_min, :new.effective, :new.expires, :new.changed_by || '#TRG#', 'UPDATE');
                l_updates(l_updates.count + 1) := l_row;        
            end if;
                  
        end if;
    end before each row;
    
    after statement is
    begin
    --  forall approach gets mutating table error
    if l_inserts.count > 0 then
        dbms_output.put_line('after statement ' || l_inserts.count || ' trigger inserts to process');
        forall i in indices of l_inserts
            insert into loyalty_discounts(status, discount_min, effective, changed_by)
            select l_inserts(i).status, l_inserts(i).discount_min, l_inserts(i).effective, l_inserts(i).changed_by
            where not exists (
                select 'discount already exists' 
                from loyalty_discounts 
                where status = l_inserts(i).status and discount_min = l_inserts(i).discount_min and effective = l_inserts(i).effective);
    end if;
        
    if l_updates.count > 0 then
        dbms_output.put_line('after statement ' || l_updates.count || ' trigger updates to process');
        forall i in indices of l_updates
            update loyalty_discounts
            set expires = l_updates(i).effective, changed_by = l_updates(i).changed_by
            where status = l_updates(i).status and effective < l_updates(i).effective and expires is null;
    end if;    
/* row by row approach        
dbms_output.put_line(l_rows.count || ' trigger rows to process');
        for r in values of l_rows loop
            case r.action_needed 
            when 'INSERT' then
                dbms_output.put_line('inserting');
                --inserting a new effective record when user attempted an update of existing record
                insert into loyalty_discounts(status, discount_min, effective, changed_by)
                select r.status, r.discount_min, r.effective, r.changed_by
                where not exists (
                    select 'discount already exists' 
                    from loyalty_discounts 
                    where status = r.status and discount_min = r.discount_min and effective = r.effective);
            
            when 'UPDATE' then
                dbms_output.put_line('updating');
                --updating the previous discount to account for a user insert
                --record has values from new insert
                update loyalty_discounts
                set expires = r.effective, changed_by = r.changed_by
                where status = r.status and effective < r.effective and expires is null;
            end case;
        end loop;
*/
    end after statement;
    
end loyalty_discounts_trigger_c;
/

create or replace trigger customer_loyalty_trigger_c
for insert or update or delete on customer_loyalty
compound trigger

    --rows cannot be deleted
    --effective date cannot be updated
    --expired rows cannot be updated
    --when user inserts a new effective row, trigger expires previous effective row
    --user updates of current effective row are converted to expirations and trigger inserts new row

    type t_change is record(
        customer_name customer_loyalty.customer_name%type,
        status customer_loyalty.status%type,
        effective customer_loyalty.effective%type,
        expires customer_loyalty.expires%type default null,
        changed_by customer_loyalty.changed_by%type,
        action_needed varchar2(20));
        
    type t_changes is table of t_change index by pls_integer;
    
    l_rows t_changes;
    l_row t_change;

    before statement is
    begin
        if deleting then
            raise_application_error(-20101, 'deletes are not allowed for this table');
        end if;
    end before statement;

    before each row is
    begin
        if updating then
            if :old.expires is not null then
                raise_application_error(-20101,'Cannot update expired records');
            end if;
    
            dbms_output.put_line('before row updating: ' || :new.changed_by);
            if instr(:new.changed_by, '#TRG#') > 0 then
                --updates by trigger will only set expire date
                :new.changed_by := replace(:new.changed_by,'#TRG#');
                :new.status := :old.status;
                :new.effective := :old.effective;            
            else
                --other updates are converted to inserts by trigger
                --capture the values in the change record        
                l_row := t_change(:new.customer_name, :new.status, :new.effective, null, :new.changed_by || '#TRG#', 'INSERT');
                l_rows(l_rows.count + 1) := l_row;
                --set the row values back to original values and expire the record as of the effective date of the update
                :new.status := :old.status;
                :new.expires := l_row.effective;  --:new.effective
                :new.effective := :old.effective;
                :new.changed_by := :old.changed_by;        
            end if;
            
        elsif inserting then
            if :new.expires is not null then
                raise_application_error(-20101, 'cannot set expire dates');
            end if;    
            dbms_output.put_line('before row inserting: ' || :new.changed_by);
            if instr(:new.changed_by, '#TRG#') > 0 then
                --inserts by trigger are converted updates  
                :new.changed_by := replace(:new.changed_by,'#TRG#');         
            else
                --inserts by user must be matched by update by trigger of previous effective record
                l_row := t_change(:new.customer_name,:new.status, :new.effective, :new.expires, :new.changed_by || '#TRG#', 'UPDATE');
                l_rows(l_rows.count + 1) := l_row;        
            end if;
                  
        end if;
    end before each row;
    
    after statement is
    begin
        dbms_output.put_line(l_rows.count || ' trigger changes to process');
        for r in values of l_rows loop
            case r.action_needed 
            when 'INSERT' then
                dbms_output.put_line('inserting');
                --trigger is inserting a new effective record when user attempted an update of existing record
                insert into customer_loyalty(customer_name, status, effective, changed_by)
                select r.customer_name, r.status, r.effective, r.changed_by
                where not exists (
                    select 'status already exists' 
                    from customer_loyalty 
                    where customer_name = r.customer_name and status = r.status and effective = r.effective);
            
            when 'UPDATE' then
                dbms_output.put_line('updating');
                --updating the previous status to account for a user insert
                --record has values from the new insert by user
                update customer_loyalty
                set expires = r.effective, changed_by = r.changed_by
                where customer_name = r.customer_name and effective < r.effective and expires is null;
            end case;
        end loop;
    end after statement;

end customer_loyalty_trigger_c;
/
