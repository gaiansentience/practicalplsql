--1-create-test-functions.sql

prompt create function variants: basic, udf, deterministic, scalar macro

create or replace function f_basic(
    n in number
) return number
is
begin 
    return n * n; 
end f_basic;
/

create or replace function f_udf(
    n in number
) return number
is
    pragma udf;
begin 
    return n * n; 
end f_udf;
/

create or replace function f_deterministic(
    n in number
) return number deterministic
is
begin 
    return n * n; 
end f_deterministic;
/

create or replace function f_macro(
    n in number
) return varchar2 sql_macro(scalar)
is
begin 
    return 'n * n'; 
end f_macro;
/
