--4.3-trunc-increments-change.sql

set serveroutput on;
declare
    
    function make_change(
        p_purchase in number
        , p_payment in number
    ) return varchar2
    is
        l_balance number(6,2);
        l_change varchar2(100);
        type curr_r is record(
            unit_count integer
            , unit_value number
            , unit_name varchar2(20)
            );
        type curr_aa is table of curr_r index by pls_integer;
        l_change_aa curr_aa;
        procedure how_many(
            p_unit in number
            , p_total in out number
            , p_count out number)
        is
        begin
            p_count := incremental_trunc(p_total, p_unit) / p_unit;
            p_total := p_total - (p_count * p_unit);
        end how_many;
    begin
        l_balance := p_payment - p_purchase;
        
        if l_balance < 0 then l_change := 'No change, balance due is ' || l_balance;
        elsif l_balance = 0 then l_change := 'No Change, payment is exact amount';
        else
        
            l_change_aa := curr_aa(
                curr_r(0, 10, 'ten')
                , curr_r(0, 5, 'five')
                , curr_r(0, 1, 'one')
                , curr_r(0, 25/100, 'quarter')
                , curr_r(0, 10/100, 'dime')
                , curr_r(0, 5/100, 'nickel')
                , curr_r(0, 1/100, 'cent'));

            for i in 1..l_change_aa.count loop
                how_many(l_change_aa(i).unit_value, l_balance, l_change_aa(i).unit_count);
                l_change := l_change 
                    || case when l_change_aa(i).unit_count > 0 
                        then l_change_aa(i).unit_count || ' ' || l_change_aa(i).unit_name 
                            || case when l_change_aa(i).unit_count > 1 then 's' end
                            || ', ' end;
            end loop;

            l_change := rtrim(l_change, ', ');

        end if;
        
        return p_payment || ' paid - ' || p_purchase || ' due = ' || (p_payment - p_purchase)
            || '.  Change:  ' || l_change || '.';
        
    end make_change;
begin
    dbms_output.put_line(make_change(42.42, 50));
    dbms_output.put_line(make_change(7.13, 20));
    dbms_output.put_line(make_change(3.51, 10));
    dbms_output.put_line(make_change(11.17, 20));
    dbms_output.put_line(make_change(3.50, 3.50));
    dbms_output.put_line(make_change(7.77, 5));
end;
/

/*
50 paid - 42.42 = 7.58.  Change:  1 five, 2 ones, 2 quarters, 1 nickel, 3 cents.
20 paid - 7.13 = 12.87.  Change:  1 ten, 2 ones, 3 quarters, 1 dime, 2 cents.
10 paid - 3.51 = 6.49.  Change:  1 five, 1 one, 1 quarter, 2 dimes, 4 cents.
20 paid - 11.17 = 8.83.  Change:  1 five, 3 ones, 3 quarters, 1 nickel, 3 cents.
*/