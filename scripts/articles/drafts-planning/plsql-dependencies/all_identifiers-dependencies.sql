select lpad('.',(level - 1)*4,'.') || name as fmt_name, sys_connect_by_path(i.name,'/') as namePath,i.* 
from user_identifiers i
connect by prior usage_id = usage_context_id and prior object_name = object_name -- 'P_FGD_0001'
start with 
--usage_context_id = 0 --view full hierarchy
name = 'P_FGD_0001' --and type = 'PROCEDURE' --and usage = 'DEFINITION'
order siblings by usage_id
/
select * from all_identifiers; --or dba_identifiers
select * from all_statements;  --or dba_statements


with base as (
select 'REGIONS_API' as package_name, 'UPDATE_RECORD' as method_name
from dual
), dependency_base as (
    SELECT OBJECT_NAME, USAGE, USAGE_ID, USAGE_CONTEXT_ID, NAME, type, LINE, COL
    FROM ALL_IDENTIFIERS
    WHERE OBJECT_NAME = (select package_name from base) 
    and owner = user and declared_owner = user
    and usage not in ('DECLARATION','SAVEPOINT','COMMIT','ROLLBACK') and type in ('COLUMN','TABLE', 'PROCEDURE', 'FUNCTION','REFCURSOR')
    UNION
    SELECT OBJECT_NAME, TYPE usage, USAGE_ID, USAGE_CONTEXT_ID, 'Statement' name, 'Statement' type,LINE, COL 
    FROM ALL_STATEMENTS
    WHERE OBJECT_NAME = (select package_name from base) 
    and TYPE not in ('SAVEPOINT','COMMIT','ROLLBACK')
)

SELECT connect_by_root object_name || '.' || connect_by_root name as definition
    , usage_context_id, USAGE_ID
    , LPAD(' ', 2*(level-1)) || TO_CHAR(USAGE) || ' ' || NAME usages, usage, object_name, name, type, LINE, COL
FROM dependency_base
START WITH usage = 'DEFINITION' and name = (select method_name from base) 
CONNECT BY PRIOR USAGE_ID = USAGE_CONTEXT_ID
/
