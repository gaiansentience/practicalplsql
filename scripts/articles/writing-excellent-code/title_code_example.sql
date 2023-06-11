declare
    type t_steps is table of varchar2(100) index by pls_integer;
    l_steps t_steps := new t_steps(
        'think',
        'outline','draft','test',
        'refactor','edit','test', 
        'review','edit','test',
        '...');
begin
    for i in indices of l_steps loop
        dbms_output.put_line(l_steps(i));
    end loop;
end;
/

declare

    cursor c is
    with base (publish_ts, publish_type) as
    (
        values 
            (cast(date '2023-05-20' as timestamp),'reprint'), 
            (cast(date '2005-12-11' as timestamp),'original'),
            (cast(date '3333-03-03' as timestamp),'expiry')
    ), pivoted as
    (
        select original, reprint, expiry, (reprint - original) year to month as how_long
        from 
            base
            pivot (
                max(publish_ts) for publish_type in (
                    'reprint' as reprint,
                    'original' as original,
                    'expiry' as expiry
                )
            )
    )
    select 
        to_char(original,'fmMonth DD, YYYY') as first_published, 
        to_char(reprint,'fmMonth DD, YYYY') as reprinted,
        extract(year from how_long) as years_later,
        case 
            when reprint < expiry then 'still valid' 
            else 'outdated concept' end 
        as validity
    from pivoted;

    r c%rowtype;
    lf constant varchar2(1) := chr(10);
begin

    open c;
    fetch c into r;
    close c;
    dbms_output.put_line(
        'First published ' || r.first_published || lf
        || 'Reprinted ' || r.reprinted || lf
        || r.years_later || ' years later and ' || r.validity);
    dbms_output.put_line('Some things are timeless');
end;
/