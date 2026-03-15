with function split_stringm(s in varchar2, d in varchar2) return varchar2 sql_macro(table)
is
begin
return 
q'!
select regexp_substr(s, '[^'|| d||']+',1,level) as val
connect by level <= regexp_count(s,d)+1
!';
end split_stringm;

select * from split_stringm('hello from new york',' ')
/


create or replace type str as object(
val varchar2,
static function split_strings(s in varchar2, d in varchar2) return sys.odcivarchar2list pipelined,
member function split(d in varchar2) return sys.odcivarchar2list pipelined,
member function to_collection(d in varchar2) return sys.odcivarchar2list
)
/

create or replace type body str
as
static function split_strings(s in varchar2, d in varchar2) return sys.odcivarchar2list pipelined
is
cursor c is
select regexp_substr(s, '[^'|| d||']+',1,level) as val
connect by level <= regexp_count(s,d)+1;
begin
for r in c loop
    pipe row (r.val);
end loop;
end split_strings;
member function split(d in varchar2) return sys.odcivarchar2list pipelined
is


cursor c is
select regexp_substr(self.val, '[^'|| d||']+',1,level) as val
connect by level <= regexp_count(self.val,d)+1;
begin
for r in c loop
    pipe row (r.val);
end loop;


end split;

member function to_collection(d in varchar2) return sys.odcivarchar2list
is
o sys.odcivarchar2list;
begin
select regexp_substr(self.val, '[^'|| d||']+',1,level) as val
bulk collect into o
connect by level <= regexp_count(self.val,d)+1;
return o;
end to_collection;
end;
/

--member method, pipelined
select * from str('this is a sentence with words delimited by spaces').split(' ');

--member method table
select * from str('this is a sentence with words delimited by spaces').to_collection(' ');

--static method pipelined
select * from str.split_strings('this is a sentence with words delimited by spaces',' ');


create or replace function split_strings(s in varchar2, d in varchar2) return sys.odcivarchar2list pipelined
is
cursor c is
select regexp_substr(s, '[^'|| d||']+',1,level) as val
connect by level <= regexp_count(s,d)+1;
begin
for r in c loop
    pipe row (r.val);
end loop;
end split_strings;
/


select * from split_strings('this is a sentence with words delimited by spaces', ' ')
/


with base(n, str) as (
    values(1, 'Hello from New York'), (2, 'Its raining outside')
)
select b.n, w.column_value
from 
    base b
    cross apply split_strings(b.str,' ') w
/



with 
function split_words(s in varchar2, d in varchar2) return varchar2 sql_macro(table)
is
begin


end split_words;

base(n, str) as (
    values(1, 'Hello from New York'), (2, 'Its raining outside')
)
select b.n, w.column_value
from 
    base b
    cross apply split_strings(b.str,' ') w
