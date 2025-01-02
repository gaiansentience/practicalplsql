column fmt_uuid format a36

with function format_uuid(
    p_guid in raw
) return varchar2 sql_macro(scalar)
is
begin
    return q'~
        regexp_replace(
            rawtohex(p_guid)
            ,'(.{8})(.{4})(.{4})(.{4})(.{12})'
            ,'\1-\2-\3-\4-\5')
    ~';
end format_uuid;

base as (
    select sys_guid() as uuid from dual
    connect by level <= 5
)
select uuid, format_uuid(uuid) as fmt_uuid
from base
/