create table if not exists my_customers(
    customer_id integer not null,
    name varchar2(50) not null
);

create table if not exists my_customer_contacts(
    customer_id integer not null,
    email varchar2(255) not null,
    is_primary boolean default false not null
);

create assertion my_customers_pk check (
    all (select rowid, customer_id from my_customers) a
    satisfy (
        not exists (
            select 'another customer has the same id'
            from my_customers c
            where c.customer_id = a.customer_id and c.rowid <> a.rowid
        )
    )
)
/

create assertion my_customers_u_name check (
    all (select customer_id, name from my_customers) a
    satisfy (
        not exists (
            select 'another customer with same name'
            from my_customers c
            where c.name = a.name and c.customer_id <> a.customer_id
        )
    )
)
/

create assertion my_customer_contacts_fk_my_customer check (
    all (select customer_id from my_customer_contacts) a
    satisfy (
        exists (
            select 'customer exists'
            from my_customers c
            where c.customer_id = a.customer_id
        )
    )
)
/

create assertion my_customer_contacts_pk check (
    all (select rowid, customer_id, email from my_customer_contacts) a
    satisfy (
        not exists (
            select 'another contact row with the same customer id and email'
            from my_customer_contacts c
            where c.customer_id = a.customer_id and c.email = a.email and c.rowid <> a.rowid
        )
    )
)
/

create assertion only_one_primary_contact_per_customer check (
    all (select customer_id, email from my_customer_contacts where is_primary) a
    satisfy (
        not exists (
            select 'another primary contact for the same customer'
            from my_customer_contacts c
            where c.customer_id = a.customer_id and c.email <> a.email and c.is_primary
        )    
    )
)
/


insert into my_customers set customer_id = 1, name = 'ABC';

insert into my_customer_contacts
set customer_id = 1, email = 'ted@abc.com', is_primary = true;

insert into my_customer_contacts
set customer_id = 1, email = 'tina@abc.com', is_primary = false;

insert into my_customers set customer_id = 1, name = 'XYZ';

insert into my_customers set customer_id = 2, name = 'ABC';

insert into my_customer_contacts
set customer_id = 2, email = 'amy@xyz.com', is_primary = true;

insert into my_customer_contacts
set customer_id = 1, email = 'lois@abc.com', is_primary = true;


drop assertion if exists my_customers_pk;
drop assertion if exists my_customers_nn;
drop assertion if exists my_customers_u_name;
drop assertion if exists my_customer_contacts_fk_my_customer;
drop assertion if exists my_customer_contacts_pk;
drop assertion if exists only_one_primary_contact_per_customer;

drop table if exists my_customer_contacts purge;
drop table if exists my_customers purge;

/*
1 row inserted.
1 row inserted.
1 row inserted.

SQL Error: ORA-08601: SQL assertion (MY_CUSTOMERS_PK) violated.
SQL Error: ORA-08601: SQL assertion (MY_CUSTOMERS_U_NAME) violated.
SQL Error: ORA-08601: SQL assertion (MY_CUSTOMER_CONTACTS_FK_MY_CUSTOMER) violated.
SQL Error: ORA-08601: SQL assertion (ONLY_ONE_PRIMARY_CONTACT_PER_CUSTOMER) violated.
*/
