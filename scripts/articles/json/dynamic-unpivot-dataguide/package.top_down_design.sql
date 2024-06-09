--design the package specification first for top down development
--expose inner procedure for generating dynamic json_table query
create or replace package dynamic_json_table authid current_user 
as

    --record type to represent the metadata of the json row
    
    --collection type of metadata records
    
    --a function to convert the json dataguide to the metadata collection
    
    --a function to convert the json to json_table sql
    
    --record type for pipelined rows
    
    --collection type for return type of the pipelined function
    
    type r_column is record(
        column_name varchar2(100)
        , column_type varchar2(100)
        , column_path varchar2(1000)
    );
        
    type t_columns is table of r_column index by pls_integer;
    
    type r_attributes is record (
        "object#id" number
        , "object#key" varchar2(1000)
        , "object#value" varchar2(4000)
    );
    
    type t_attributes is table of r_attributes;
    
    function get_columns(
        p_jdoc in clob
        , p_object_id in varchar2 default 'id'
        , p_rows_path in varchar2 default null
    ) return t_columns;
    
    function get_sql(
        p_jdoc in clob
        , p_object_id in varchar2 default 'id'
        , p_rows_path in varchar2 default null
    ) return varchar2;
    
    function unpivot_json(
        p_jdoc in clob
        , p_object_id in varchar2 default 'id'
        , p_rows_path in varchar2 default null
    ) return t_attributes pipelined;

end dynamic_json_table;
