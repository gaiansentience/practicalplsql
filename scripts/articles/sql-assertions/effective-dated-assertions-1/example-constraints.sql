create table my_customers(
    customer_id integer constraint my_customers_pk primary key,
    name varchar2(50) not null constraint my_customers_u_name unique
);

create table my_customer_contacts(
    customer_id constraint my_customer_contacts_fk_my_customer references my_customers(customer_id) not null,
    email varchar2(255) not null,
    is_primary boolean default false not null,
    constraint my_customer_contacts_pk
        primary key (customer_id, email),
    primary_contact invisible as (case when is_primary then customer_id end) virtual,
    constraint only_one_primary_contact_per_customer unique (primary_contact)
);

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

drop table my_customer_contacts;
drop table my_customers;

/*
1 row inserted.
1 row inserted.
1 row inserted.

ORA-00001: unique constraint (MY_CUSTOMERS_PK) violated on table MY_CUSTOMERS columns (CUSTOMER_ID)
ORA-03301: (ORA-00001 details) row with column values (CUSTOMER_ID:1) already exists

ORA-00001: unique constraint (MY_CUSTOMERS_U_NAME) violated on table MY_CUSTOMERS columns (NAME)
ORA-03301: (ORA-00001 details) row with column values (NAME:'ABC') already exists

ORA-02291: integrity constraint (MY_CUSTOMER_CONTACTS_FK_MY_CUSTOMER) violated - parent key not found

ORA-00001: unique constraint (ONLY_ONE_PRIMARY_CONTACT_PER_CUSTOMER) violated on table MY_CUSTOMER_CONTACTS columns (PRIMARY_CONTACT)
ORA-03301: (ORA-00001 details) row with column values (PRIMARY_CONTACT:1) already exists
*/
