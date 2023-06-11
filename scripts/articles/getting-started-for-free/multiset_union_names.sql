set serveroutput on;
declare

$if dbms_db_version.version >= 23 $then

    cursor c_names(p_named_after in varchar2) is
        with base (id, name, named_after) as
        ( 
            values
            (1,'april','month'),
            (2,'may', 'month'),
            (3,'june', 'month'),
            (4,'julie', 'month'),
            (5, 'summer', 'season'),
            (6, 'spring', 'season'),
            (7, 'thor', 'weekday'),
            (8, 'freya', 'weekday')
        )
        select id, name, named_after 
        from base
        where named_after = p_named_after;
    
    type t_names is table of c_names%rowtype;
    
    l_month t_names;
    l_weekday t_names;
    l_season t_names;
    l_all t_names;

$end

begin

$if dbms_db_version.version >= 23 $then

    open c_names('month');
    fetch c_names bulk collect into l_month;
    close c_names;
    
    open c_names('weekday');
    fetch c_names bulk collect into l_weekday;
    close c_names;
    
    open c_names('season');
    fetch c_names bulk collect into l_season;
    close c_names;
    
    l_all := l_weekday multiset union l_month multiset union l_season;
    
    for i in indices of l_all loop
        dbms_output.put_line(l_all(i).name || ' is named after ' || l_all(i).named_after);
    end loop;

$else
    dbms_output.put_line('Install 23 Free Developer Preview to run this script :)');
$end

end;
/