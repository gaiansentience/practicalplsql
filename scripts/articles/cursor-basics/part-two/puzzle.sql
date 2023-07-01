set serveroutput on;
prompt Challenge: Iterate Multiple Cursors With One For Loop Without Using Union
create table birthdays (
    person varchar2(50),
    birth_date date);

create table events (
    event_name varchar2(50),
    event_date date);
    
begin
    insert into birthdays values ('Martin Luther King, Jr', date '1929-01-15');
    insert into birthdays values ('Edgar Frank Codd', date '1923-08-19');
    insert into birthdays values ('Frida Kahlo', date '1907-07-06');    
    insert into birthdays values ('Ludwig Wittgenstein', date '1889-04-26');
    insert into birthdays values ('Mohandas K Ghandhi', date '1869-10-02');
    insert into events values ('Valentina Tereshkova Was The First Woman In Space', '1963-06-16');
    insert into events values ('Neil Armstrong Walked On The Moon', '1969-07-20');
    insert into events values ('Oracle Corporation Was Founded', '1977-06-16');
    insert into events values ('Oracle 23c Free Announced', '2023-04-03');
    commit;
end;
/

declare

    cursor c_birthdays is
        select person || ' was born.', birth_date 
        from birthdays 
        order by birth_date;
        
    cursor c_events is
        select event_name, event_date 
        from events 
        order by event_date;
        
    type t_reminders is table of c_events%rowtype;
    l_birthdays t_reminders;
    l_events t_reminders;
    l_reminders t_reminders;
begin
    
    open c_birthdays;
    fetch c_birthdays bulk collect into l_birthdays;
    close c_birthdays;
    
    open c_events;
    fetch c_events bulk collect into l_events;
    close c_events;
    
    l_reminders := l_birthdays multiset union l_events;
    
$if dbms_db_version.version < 21 $then    
    for i in 1..l_reminders.count loop
$else
    for i in indices of l_reminders loop
$end
        dbms_output.put_line(to_char(l_reminders(i).event_date, 'fmMonth DD, YYYY":  "') || l_reminders(i).event_name);
    end loop;
    
end;
/

drop table birthdays purge;
drop table events purge;

/*Script Results:
Challenge: Iterate Multiple Cursors With One For Loop Without Using Union
October 2, 1869:  Mohandas K Ghandhi was born.
April 26, 1889:  Ludwig Wittgenstein was born.
July 6, 1907:  Frida Kahlo was born.
August 19, 1923:  Edgar Frank Codd was born.
January 15, 1929:  Martin Luther King, Jr was born.
June 16, 1963:  Valentina Tereshkova Was The First Woman In Space
July 20, 1969:  Neil Armstrong Walked On The Moon
June 16, 1977:  Oracle Corporation Was Founded
April 3, 2023:  Oracle 23c Free Announced
*/