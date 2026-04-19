--insert.roles_and_staff.sql

set serveroutput on;

begin
    insert into univ_roles (role_name)
    values 
        ('admin'), ('assistant'), ('secretary')
        , ('chair'), ('faculty')
        , ('fellow'), ('intern');
    
    insert into univ_staff (staff_name)
    values 
        ('Pascal'), ('Descartes'), ('Wittgenstein')
        , ('Joyce'), ('Picasso'), ('Newton')
        , ('Moore'), ('Russell'), ('James')
        , ('Kirk'), ('Pike'), ('Jones');
    
    commit;
end;
/
