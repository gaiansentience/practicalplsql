


    with base as (
        select 
            level + 96 as ascii#
            , chr(level + 96) as letter
            , round(dbms_random.value(-100, 100),6) as val
        connect by level <= 26
    ), cbase as (
        select upper(letter) as c, val from base
        where ascii# between 97 and 100
    ), vbase as (
        select letter as v, val from base
        where ascii# between 118 and 122
    ), jbase as (
        select json_arrayagg(jset) as jdoc
        from (
            select json_object('constants' value json_arrayagg(json_object(c value val))) as jset from cbase
            union all
            select json_object('variables' value json_arrayagg(json_object(v value val))) as jset from vbase
            )
    ), vlist as (
        select cast(collect(v) as sys.odcivarchar2list) as v_list, cast(collect(val)  as sys.odcinumberlist) as v_val_list
        from vbase
    ), clist as (
        select cast(collect(c) as sys.odcivarchar2list) as c_list, cast(collect(val) as sys.odcinumberlist) as c_val_list
        from cbase
    )
    select
        cursor (select v, val from vbase) as cur_vars
        , cursor (select c, val from cbase) as cur_const
        , (select jdoc from jbase) as jdoc
        , (select v_list from vlist) as vars_list
        , (select v_val_list from vlist) as vars_val_list
        , (select c_list from clist) as const_list
        , (select c_val_list from clist) as const_val_list
/

set serveroutput on;
declare 
    cursor c is
    with base as (
        select 
            level + 96 as ascii#
            , chr(level + 96) as letter
            , round(dbms_random.value(-100, 100),6) as val
        connect by level <= 26
    ), cbase as (
        select upper(letter) as c, val from base
        where ascii# between 97 and 100
    ), vbase as (
        select letter as v, val from base
        where ascii# between 118 and 122
    ), jbase as (
        select json_arrayagg(jset returning json) as jdoc
        from (
            select json_object('constants' value json_arrayagg(json_object(c value val))) as jset from cbase
            union all
            select json_object('variables' value json_arrayagg(json_object(v value val))) as jset from vbase
            )
    )
    select
        cursor (select v, val from vbase) as cur_vars
        , cursor (select c, val from cbase) as cur_const
        , (select jdoc from jbase) as jdoc
;        

rc_vars sys_refcursor;
rc_const sys_refcursor;
n varchar2(1);
v number;
j json;
procedure p(s in varchar2) is begin dbms_output.put_line(s); end p;
begin

dbms_random.seed('einstein');

    open c;
    fetch c into rc_vars, rc_const, j;

        p('fetching variables cursor rows');
        loop
            fetch rc_vars into n, v;
            exit when rc_vars%notfound;
            p(n || ' = '||v);
        end loop;
        p('fetching contants cursor rows');
        loop
            fetch rc_const into n, v;
            exit when rc_const%notfound;
            p(n || ' = '||v);
        end loop;
    close c;
    p('serialized json document from main cursor');
    p(json_serialize(j));

end;
/

declare 
    cursor c is
    with base as (
        select 
            level + 96 as ascii#
            , chr(level + 96) as letter
            , round(dbms_random.value(-100, 100),6) as val
        connect by level <= 26
    ), cbase as (
        select upper(letter) as c, val from base
        where ascii# between 97 and 100
    ), vbase as (
        select letter as v, val from base
        where ascii# between 118 and 122
    ), jbase as (
        select json_arrayagg(jset returning json) as jdoc
        from (
            select json_object('constants' value json_arrayagg(json_object(c value val))) as jset from cbase
            union all
            select json_object('variables' value json_arrayagg(json_object(v value val))) as jset from vbase
            )
    ), vlist as (
        select cast(collect(v) as sys.odcivarchar2list) as v_list, cast(collect(val)  as sys.odcinumberlist) as v_val_list
        from vbase
    ), clist as (
        select cast(collect(c) as sys.odcivarchar2list) as c_list, cast(collect(val) as sys.odcinumberlist) as c_val_list
        from cbase
    )
    select
        cursor (select v, val from vbase) as cur_vars
        , cursor (select c, val from cbase) as cur_const
        , (select jdoc from jbase) as jdoc
        , (select v_list from vlist) as vars_list
        , (select v_val_list from vlist) as vars_val_list
        , (select c_list from clist) as const_list
        , (select c_val_list from clist) as const_val_list
;        

rc_vars sys_refcursor;
rc_const sys_refcursor;
n varchar2(1);
v number;
j json;
vars_list sys.odcivarchar2list;
const_list sys.odcivarchar2list;
vars_val_list sys.odcinumberlist;
const_val_list sys.odcinumberlist;
procedure p(s in varchar2) is begin dbms_output.put_line(s); end p;
begin

dbms_random.seed('einstein');

    open c;
    fetch c into rc_vars, rc_const, j, vars_list, vars_val_list, const_list, const_val_list;
        --loops for cv_variables?
        p('fetching variables cursor rows');
        loop
            fetch rc_vars into n, v;
            exit when rc_vars%notfound;
            p(n || ' = '||v);
        end loop;
        p('fetching contants cursor rows');
        loop
            fetch rc_const into n, v;
            exit when rc_const%notfound;
            p(n || ' = '||v);
        end loop;
    close c;
    p('serialized json document from main cursor');
    p(json_serialize(j));
    p('var list count=' || vars_list.count);
    p('const list count=' || const_list.count);

end;
/

DECLARE
   CURSOR all_in_one_cur
   IS
      SELECT l.city,
             CURSOR (SELECT d.department_name,
                            CURSOR (SELECT e.last_name
                                      FROM plch_employees e
                                     WHERE e.department_id = d.department_id)
                               AS ename
                       FROM plch_departments d
                      WHERE l.location_id = d.location_id)
                AS dname
        FROM plch_locations l
       ORDER BY l.city;

   department_cur   SYS_REFCURSOR;
   employee_cur     SYS_REFCURSOR;

   l_city           plch_locations.city%TYPE;
   l_dname          plch_departments.department_name%TYPE;
   l_ename          plch_employees.last_name%TYPE;
BEGIN
   OPEN all_in_one_cur;

   LOOP
      FETCH all_in_one_cur INTO l_city, department_cur;
      EXIT WHEN all_in_one_cur%NOTFOUND;

      OPEN department_cur;

      LOOP
         FETCH department_cur INTO l_dname, employee_cur;
         EXIT WHEN department_cur%NOTFOUND;

         OPEN employee_cur;

         LOOP
            FETCH employee_cur INTO l_ename;
            EXIT WHEN employee_cur%NOTFOUND;

            DBMS_OUTPUT.put_line (l_city || ' ' || l_dname || ' ' || l_ename);
         END LOOP;

         CLOSE employee_cur;
      END LOOP;

      CLOSE department_cur;
   END LOOP;

   CLOSE all_in_one_cur;

END;
/

/* END-CHOICE*/

/* START-CLEANUP Code to remove all objects created for quiz */


DROP TABLE plch_locations
/

DROP TABLE plch_departments
/

DROP TABLE plch_employees
/

/* END-CLEANUP*/