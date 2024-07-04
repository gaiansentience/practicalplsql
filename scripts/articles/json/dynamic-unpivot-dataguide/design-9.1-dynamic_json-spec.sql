prompt design-9.1-dynamic_json-spec.sql

create or replace package dynamic_json
authid current_user
as
        
    type column_value is record(
        row#id number,
        column#key varchar2(64),
        column#value varchar2(4000));
    
    type column_values is table of column_value;

    function unpivot_json_array(
        jdoc in $if dbms_db_version.version >= 21 $then json $else clob $end ,
        row_identifier in varchar2 default null,        
        array_path in varchar2 default null    
    ) return column_values 
    pipelined;

end dynamic_json;
/
