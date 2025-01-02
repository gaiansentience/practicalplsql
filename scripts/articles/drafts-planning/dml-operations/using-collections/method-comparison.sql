alter session disable parallel dml;
set serveroutput on;
declare
l_start timestamp;
l_ids udt_numbers_nt;
procedure show_timing(p_start in timestamp, p_msg in varchar2 default null) is begin dbms_output.put_line(to_char(localtimestamp - p_start) || case when p_msg is not null then '   ' end || p_msg); end show_timing;
procedure reset_timing(p_start out timestamp) is begin p_start := localtimestamp; end reset_timing;

procedure use_forall
is
l_overall timestamp := localtimestamp;
l_fetch timestamp;
l_delete timestamp;
begin

reset_timing(l_fetch);
    select order_dtl_id bulk collect into l_ids from order_details
    where mod(order_id,42) = 0 and mod(order_dtl_id,3) = 0;
--show_timing(l_fetch, l_ids.count || ' dtls found');

reset_timing(l_delete);
    forall i in indices of l_ids
    delete from order_details 
    where order_dtl_id = l_ids(i);
show_timing(l_delete, 'delete using forall ' || sql%rowcount || ' rows deleted');

--show_timing(l_overall, 'overall timing' );
rollback;

end use_forall;

procedure use_unnest
is
l_overall timestamp := localtimestamp;
l_fetch timestamp;
l_delete timestamp;
begin

reset_timing(l_fetch);
    select order_dtl_id bulk collect into l_ids from order_details
    where mod(order_id,42) = 0 and mod(order_dtl_id,3) = 0;
--show_timing(l_fetch, l_ids.count || ' dtls found');

reset_timing(l_delete);
    delete from order_details 
    where order_dtl_id in (select column_value from table(l_ids) );
show_timing(l_delete, 'delete using subquery unnest ' || sql%rowcount || ' rows deleted');

--show_timing(l_overall, 'overall timing' );
rollback;

end use_unnest;

procedure use_sql
is
l_overall timestamp := localtimestamp;
--l_fetch timestamp;
l_delete timestamp;
begin


reset_timing(l_delete);

    delete from order_details 
    where order_dtl_id in (
    select order_dtl_id 
    from order_details
    where mod(order_id,42) = 0 and mod(order_dtl_id,3) = 0);

show_timing(l_delete, 'delete using sql only ' || sql%rowcount || ' rows deleted');

--show_timing(l_overall, 'overall timing' );
rollback;

end use_sql;


procedure use_cursor
is
l_overall timestamp := localtimestamp;
l_fetch timestamp;
l_delete timestamp;
i number := 0;
cursor c is 
    select order_dtl_id --bulk collect into l_ids
    from order_details
    where mod(order_id,42) = 0 and mod(order_dtl_id,3) = 0;
begin
reset_timing(l_delete);



for r in c loop 

    delete from order_details 
    where order_dtl_id = r.order_dtl_id;
    i := i + 1;
end loop;

show_timing(l_delete, 'delete using cursor  ' || i || ' rows deleted');

rollback;

end use_cursor;


begin

use_cursor;

use_forall;

use_unnest;

use_sql;

end;
/