create table insert_test(
    val number,
    pos number,
    des varchar2(10)
    );
    
    
insert into insert_test (val,pos, des)
values (1,1,'x'), (2,2,'y'), (3,3,'z');


insert into insert_test
set (val,pos) = (4,4), des = 'q';


insert into insert_test(val, pos, des)
by position
select 5,4,'n';


insert into insert_test(val, pos,des)
by name
select 4 as pos, 'm' as des, 9 as val
from dual;


drop table insert_test;