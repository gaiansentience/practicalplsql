set pagesize 0;

drop table if exists test_staging purge;
drop table if exists test_target purge;

create table test_staging(
    id number primary key,
    n_val number not null,
    s_val varchar2(100),
    d_val date
)
/

create table test_target(
    id number primary key,
    n_val number not null,
    s_val varchar2(100),
    d_val date
)
/

insert into test_staging
by name
select 
    level as id
    , to_number(mod(level,10)||mod(level,7)) as n_val
    , lpad(chr(64 + mod(level,26)), 100, chr(64 + mod(level,26))) as s_val
    , sysdate + numtodsinterval(level/3.14, 'day') as d_val
connect by level < 100
/

commit;


with
function get_insert_statements(src_table in dbms_tf.table_t) return varchar2 sql_macro(table)
is
    l_cols varchar2(4000);
    l_vals varchar2(4000);
    l_col varchar2(128);
begin
    for c in 1..src_table.column.count loop
        l_col := src_table.column(c).description.name;
        l_cols := l_cols || case when c > 1 then ',' end || l_col;
        l_vals := l_vals || '|| fmt('||l_col||case when c = 1 then ',false'end||')';
    end loop;
    return
    replace(replace(replace(
        q'!
with
    function comma(leading_comma in boolean default true) return varchar2
    is
    begin
        return case when leading_comma then ',' end;
    end comma;
    function fmt(n in number, leading_comma in boolean default true) return varchar2
    is
    begin
        return comma(leading_comma)
            || case when n is null then 'null' else n end;
    end fmt;
    function fmt(s in varchar2, leading_comma in boolean default true) return varchar2
    is
    begin
        return comma(leading_comma)
            || case when s is null then 'null' else '''' || s || '''' end;
    end fmt;
    function fmt(d in date, leading_comma in boolean default true) return varchar2
    is
    begin
        return comma(leading_comma)
            || case when d is null then 'null' 
                else 'to_date(''' || to_char(d, 'yyyy-mm-dd hh24:mi:ss') || ''',''yyyy-mm-dd hh24:mi:ss'')' end;
    end fmt;

        select 'insert into ##TABLE## (##COLS##) VALUES('
        ##VALS##
        || ');' as stmt from src_table
        !'
        , '##COLS##', l_cols), '##TABLE##', src_table.table_name), '##VALS##',l_vals)
        ;
end get_insert_statements;        
select * from get_insert_statements(test_staging);
/
