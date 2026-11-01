alter session set time_zone = dbtimezone;
set serveroutput on;

drop table if exists qz_warp_bubble_trials purge;

create table if not exists qz_warp_bubble_trials(
    id number,
    fuel varchar2(20),
    start_run timestamp(9) with local time zone,
    start_bubble timestamp(9) with local time zone,
    end_bubble timestamp(9) with local time zone,
    end_run timestamp(9) with local time zone
)
/

declare

    procedure add_trial(
        i in number, f in varchar2
        , rStart in varchar2, bStart in varchar2
        , bEnd in varchar2, rEnd in varchar2)
    is
        c_fmt constant varchar2(50) := 'yyyy-mm-dd hh24:mi:ss.ff9'; 
        l_fuel varchar2(50);
    begin
        l_fuel := case f 
            when 'tLi' then 'trilithium' 
            when 'dLi' then 'dilithium' 
            when 'qTc' then 'quadrotriticale' else 'unknown' end;
        
        insert into qz_warp_bubble_trials
        set id = i, fuel = l_fuel
            , start_run = to_timestamp(rStart, c_fmt)
            , start_bubble = to_timestamp(bStart, c_fmt)
            , end_bubble = to_timestamp(bEnd, c_fmt)
            , end_run = to_timestamp(rEnd, c_fmt);
    end add_trial;
begin
    
    add_trial(1, 'tLi', '2511-10-17 09:49:53.833630316', '2511-10-17 10:03:28.631088914', '2511-10-17 10:03:28.632063765', '2511-10-17 10:31:49.012827907');
    add_trial(2, 'qTc', '2519-06-04 05:03:28.795129128', '2519-06-04 05:33:59.845593741', '2519-06-04 05:33:59.846528840', '2519-06-04 07:17:08.813194700');
    add_trial(3, 'dLi', '2517-02-15 05:26:41.902851313', '2517-02-15 05:48:04.856169852', '2517-02-15 05:48:04.857866628', '2517-02-15 08:03:38.075573676');
    add_trial(4, 'tLi', '2516-02-12 01:27:21.531348398', '2516-02-12 01:55:00.024903194', '2516-02-12 01:55:00.025451324', '2516-02-12 04:01:17.650003403');
    add_trial(5, 'qTc', '2516-10-11 20:17:34.012220130', '2516-10-11 21:06:30.215952293', '2516-10-11 21:06:30.216347451', '2516-10-11 23:37:29.825537094');
    add_trial(6, 'dLi', '2512-10-15 20:34:19.919935302', '2512-10-15 20:49:54.647933321', '2512-10-15 20:49:54.648277730', '2512-10-15 22:26:03.451545267');
    add_trial(7, 'tLi', '2513-12-03 06:16:01.825533777', '2513-12-03 08:10:41.991052979', '2513-12-03 08:10:41.992001330', '2513-12-03 09:04:32.918184651');
    add_trial(8, 'qTc', '2517-11-09 11:12:14.277597785', '2517-11-09 12:31:57.693908180', '2517-11-09 12:31:57.694232093', '2517-11-09 15:21:07.356833783');
    add_trial(9, 'dLi', '2511-12-23 23:00:30.648482367', '2511-12-23 23:08:03.973315787', '2511-12-23 23:08:03.974104301', '2511-12-23 23:56:03.628853044');
    add_trial(10, 'tLi', '2519-03-16 02:44:35.388830530', '2519-03-16 03:57:41.879721915', '2519-03-16 03:57:41.880220409', '2519-03-16 06:39:36.992596240');
    add_trial(11, 'qTc', '2511-10-23 09:51:03.224643275', '2511-10-23 10:12:27.920362171', '2511-10-23 10:12:27.920475781', '2511-10-23 12:58:49.429858712');
    add_trial(12, 'dLi', '2519-04-29 16:05:38.661040587', '2519-04-29 16:41:17.191479355', '2519-04-29 16:41:17.192081135', '2519-04-29 17:08:42.826523094');
    add_trial(13, 'tLi', '2516-11-17 13:52:23.557971374', '2516-11-17 14:03:19.462954596', '2516-11-17 14:03:19.463292570', '2516-11-17 16:06:18.350000013');
    add_trial(14, 'qTc', '2517-02-28 00:21:38.567866418', '2517-02-28 01:09:39.902861145', '2517-02-28 01:09:39.902909017', '2517-02-28 02:09:55.666833634');
    add_trial(15, 'dLi', '2518-08-02 01:27:06.587072634', '2518-08-02 02:13:55.135315617', '2518-08-02 02:13:55.135351122', '2518-08-02 04:25:34.879001577');

    commit;

end;
/

/*

select 
    id, fuel
    , extract(second from end_bubble - start_bubble) * 1e9 as bubble_ns_int
    , datediff(nanosecond, start_bubble, end_bubble) as bubble_ns_diff
    , extract(second from end_bubble - start_bubble) * 1e6 as bubble_mcs_int
    , datediff(microsecond, start_bubble, end_bubble) as bubble_mcs_diff
from qz_warp_bubble_trials    
/




*/
