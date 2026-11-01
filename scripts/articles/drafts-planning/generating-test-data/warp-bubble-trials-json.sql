
    with jbase as (
    select
        to_clob('[')


 || to_clob(q'!{"ID":1,"FUEL":"trilithium","START_DT":"2511-10-17","START_TM":"09:49:53.833630316","WARMUP_NS":814797458598,"BUBBLE_NS":974851,"COOLDOWN_NS":1700380764142}!' || ',')
 || to_clob(q'!{"ID":2,"FUEL":"quadrotriticale","START_DT":"2519-06-04","START_TM":"05:03:28.795129128","WARMUP_NS":1831050464613,"BUBBLE_NS":935099,"COOLDOWN_NS":6188966665860}!' || ',')
 || to_clob(q'!{"ID":3,"FUEL":"dilithium","START_DT":"2517-02-15","START_TM":"05:26:41.902851313","WARMUP_NS":1282953318539,"BUBBLE_NS":1696776,"COOLDOWN_NS":8133217707048}!' || ',')
 || to_clob(q'!{"ID":4,"FUEL":"trilithium","START_DT":"2516-02-12","START_TM":"01:27:21.531348398","WARMUP_NS":1658493554796,"BUBBLE_NS":548130,"COOLDOWN_NS":7577624552079}!' || ',')
 || to_clob(q'!{"ID":5,"FUEL":"quadrotriticale","START_DT":"2516-10-11","START_TM":"20:17:34.012220130","WARMUP_NS":2936203732163,"BUBBLE_NS":395158,"COOLDOWN_NS":9059609189643}!' || ',')
 || to_clob(q'!{"ID":6,"FUEL":"dilithium","START_DT":"2512-10-15","START_TM":"20:34:19.919935302","WARMUP_NS":934727998019,"BUBBLE_NS":344409,"COOLDOWN_NS":5768803267537}!' || ',')
 || to_clob(q'!{"ID":7,"FUEL":"trilithium","START_DT":"2513-12-03","START_TM":"06:16:01.825533777","WARMUP_NS":6880165519202,"BUBBLE_NS":948351,"COOLDOWN_NS":3230926183321}!' || ',')
 || to_clob(q'!{"ID":8,"FUEL":"quadrotriticale","START_DT":"2517-11-09","START_TM":"11:12:14.277597785","WARMUP_NS":4783416310395,"BUBBLE_NS":323913,"COOLDOWN_NS":10149662601690}!' || ',')
 || to_clob(q'!{"ID":9,"FUEL":"dilithium","START_DT":"2511-12-23","START_TM":"23:00:30.648482367","WARMUP_NS":453324833420,"BUBBLE_NS":788514,"COOLDOWN_NS":2879654748743}!' || ',')
 || to_clob(q'!{"ID":10,"FUEL":"trilithium","START_DT":"2519-03-16","START_TM":"02:44:35.388830530","WARMUP_NS":4386490891385,"BUBBLE_NS":498494,"COOLDOWN_NS":9715112375831}!' || ',')
 || to_clob(q'!{"ID":11,"FUEL":"quadrotriticale","START_DT":"2511-10-23","START_TM":"09:51:03.224643275","WARMUP_NS":1284695718896,"BUBBLE_NS":113610,"COOLDOWN_NS":9981509382931}!' || ',')
 || to_clob(q'!{"ID":12,"FUEL":"dilithium","START_DT":"2519-04-29","START_TM":"16:05:38.661040587","WARMUP_NS":2138530438768,"BUBBLE_NS":601780,"COOLDOWN_NS":1645634441959}!' || ',')
 || to_clob(q'!{"ID":13,"FUEL":"trilithium","START_DT":"2516-11-17","START_TM":"13:52:23.557971374","WARMUP_NS":655904983222,"BUBBLE_NS":337974,"COOLDOWN_NS":7378886707443}!' || ',')
 || to_clob(q'!{"ID":14,"FUEL":"quadrotriticale","START_DT":"2517-02-28","START_TM":"00:21:38.567866418","WARMUP_NS":2881334994727,"BUBBLE_NS":47872,"COOLDOWN_NS":3615763924617}!' || ',')
 || to_clob(q'!{"ID":15,"FUEL":"dilithium","START_DT":"2518-08-02","START_TM":"01:27:06.587072634","WARMUP_NS":2808548242983,"BUBBLE_NS":35505,"COOLDOWN_NS":7899743650455}!' || ',')

        || to_clob(']') as jdoc
    )
    select jt.id, jt.fuel, jt.start_date || ' ' || jt.start_tm as start_ts_char, jt.warmup_ns, jt.bubble_ns, js.cooldown_ns
    from jbase j,
        json_table(j.jdoc, '$[*]' columns(
            id path '$.ID.number(),
            fuel path '$.FUEL.string(),
            start_date path '$.START_DT.string(),
            start_tm path '$.START_TM.string(),
            warmup_ns path '$.WARMUP_NS.number(),
            bubble_ns path '$.BUBBLE_NS.number(),
            cooldown_ns path '$.COOLDOWN_NS.number()
        )) jt
    order by jt.id
    /
    

