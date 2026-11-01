select banner_full from v$version;
--26.4.1 EE

select * from v$parameter where name like '%golden%';

select * from user_role_privs;


--connect as sys
--grant create notification directive to cloud_practicalplsql;

--enable_goldengate_replication init parameter must be true
  /*
  CREATE DIRECTIVE notification_directive_name
  FOR table_name
  NOTIFY [ ON { INSERT | UPDATE | DELETE }... ]
  USING NOTIFICATION TABLE notification_table_name
    [ TABLESPACE notification_table_tablespace_name ]
    NOTIFICATION VIEW notification_view_name
  [ WITH [ LOGGED COLUMNS ( column_name [, column_name ]... ) ]
    [ KEY ( column_name [, column_name ]... ) ] ]
  [ INCLUDING OLD VALUES | EXCLUDING OLD VALUES ]
  [ CONTEXT NAMESPACE namespace_name
      ATTRIBUTES attribute_name [ ( length ) ]
        [, attribute_name [ ( length ) ] ]... ]...
  [ ENABLE | DISABLE ]
  [ RETENTION { integer { MINUTES | HOURS | DAYS } | NONE } ];
  
  ALTER DIRECTIVE notification_directive_name
  [ ON { INSERT | UPDATE | DELETE }... ]
  [ WITH
      { LOGGED COLUMNS ( column_name [, column_name ]... )
          [ KEY { ( column_name [, column_name ]... ) | NONE } ]
      | KEY { ( column_name [, column_name ]... ) | NONE }
      }
  ]
  [ INCLUDING OLD VALUES | EXCLUDING OLD VALUES ]
  [ CONTEXT NAMESPACE namespace_name
      ATTRIBUTES attribute_name [ ( length ) ]
        [, attribute_name [ ( length ) ] ]...
  ]...
  [ ENABLE | DISABLE ]
  [ RETENTION { integer { MINUTES | HOURS | DAYS } | NONE } ];
    */
    
---outline:  create test table   create notification  insert/update/delete data with interspersed commits


create table ecosystem(
    id integer generated always as identity primary key,
    common_name varchar2(100),
    species varchar2(100),
    genus varchar2(100),
    info json,
    created date default sysdate not null,
    modified date default on null for insert and update sysdate
)
/


create directive ecosystem#notify for ecosystem
notify
using 
    notification table ecosystem#notify_log
    notification view ecosystem#notify_view
including old values
context namespace userenv
attributes current_user(128), host(128)
enable 
retention 1 minutes
/

insert into ecosystem(common_name, species, genus, info)
values 
('rose','rosie', 'rosa', json('{"role":["o2 producer","co2 consumer"]}')),
('goldfish', 'fishie', 'fishae', json('{"role":["co2 producer","o2 consumer"]}'))
/

commit;

update ecosystem
set species = 'rosaceae' where common_name = 'rose';

update ecosystem
set species = 'ithys' where common_name = 'fish';

commit;

select * from ecosystem;

select * from ecosystem#notify_log;

select * from ecosystem#notify_view;

select table_name
from user_tables
where 
    table_name like 'ECOSYSTEM%'
    or table_name like (
        select '%' || object_id || '%'
        from user_objects
        where object_type = 'TABLE' and object_name = 'ECOSYSTEM'
    );

select * from COMMIT_SCN_LOG_335799$;

select * from COMMIT_SCN_LOG_PARTITIONS_335799$;




select * from user_notification_directives;


select dbms_metadata.get_ddl('VIEW','ECOSYSTEM#NOTIFY_VIEW');

select dbms_metadata.get_ddl('TABLE','ECOSYSTEM#NOTIFY_LOG');

CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "CLOUD_PRACTICALPLSQL"."ECOSYSTEM#NOTIFY_VIEW" 
    ("ID", "OLD$ID", "COMMON_NAME", "OLD$COMMON_NAME", "SPECIES", "OLD$SPECIES", "GENUS", "OLD$GENUS", "INFO", "OLD$INFO"
    , "CONTEXT$USERENV$CURRENT_USER", "CONTEXT$USERENV$HOST", "OPCODE", "XCN", "INSTANCE_NUMBER", "USN", "SLOT", "SQN", "COMMIT_SCN") 
    DEFAULT COLLATION "USING_NLS_COMP"  AS 
SELECT /*+ USE_HASH(BT CSL) */         
    BT."ID","OLD$ID",
    BT."COMMON_NAME","OLD$COMMON_NAME",
    BT."SPECIES","OLD$SPECIES",
    BT."GENUS","OLD$GENUS",
    BT."INFO","OLD$INFO",
    BT."CONTEXT$USERENV$CURRENT_USER", 
    BT."CONTEXT$USERENV$HOST",          
    DECODE(BT.OPCODE, '1', 'INSERT', '2', 'DELETE', '3', 'UPDATE', 'INVALID') as OPCODE,         
    BT.XCN, BT.INSTANCE_NUMBER, BT.USN, BT.SLOT, BT.SQN, csl.commit_scn     
FROM
    "ECOSYSTEM#NOTIFY_LOG" BT     
    JOIN "COMMIT_SCN_LOG_335799$" csl ON BT.USN = csl.USN AND BT.SLOT = csl.slot AND BT.SQN = csl.sqn
/

select * from user_part_tables;
select * from user_tab_partitions;
select * from user_part_key_columns;


drop table ecosystem cascade constraints;  --will drop notification directive with log, view, etc
