--package.dynamic_json.spec

create or replace package dynamic_json
authid current_user
as

    subtype json_document_type is $if dbms_db_version.version >= 21 $then json $else clob $end ;

            
    type column_value is record(
        column#name   varchar2(64),
        column#value varchar2(4000));
    
    type column_values is table of column_value;
    
    function unpivot_json_row(
        jdoc           in json_document_type
    ) return column_values pipelined;
    
end dynamic_json;
/
