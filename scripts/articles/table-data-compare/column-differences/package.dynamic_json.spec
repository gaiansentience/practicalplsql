--package.dynamic_json.spec

create or replace package dynamic_json
authid current_user
as

    subtype json_document_type is $if dbms_db_version.version >= 21 $then json $else clob $end ;

    subtype unpivot_datatype is varchar2(20);
    c_varchar2_100  constant unpivot_datatype := 'varchar2(100)';
    c_varchar2_1000 constant unpivot_datatype := 'varchar2(100)';
    c_varchar2_4000 constant unpivot_datatype := 'varchar2(4000)';
    c_clob          constant unpivot_datatype := 'clob';
    c_number        constant unpivot_datatype := 'number';

    subtype json_format is varchar2(10);
    c_array_simple    constant json_format := 'simple';
    c_array_nested    constant json_format := 'nested';
    c_array_simple_id constant json_format := 'simple_id';
    c_array_nested_id constant json_format := 'nested_id';
            
    type column_value is record(
        row#id       number,
        column#key   varchar2(64),
        column#value varchar2(4000));
    
    type column_values is table of column_value;
    
    procedure set_bulk_limit_rows(
        bulk_limit_rows in positiven default 100
    );
    
    procedure set_unpivot_to_datatype(
        unpivot_to_datatype in unpivot_datatype default c_varchar2_4000
    );
    
    function unpivot_json_array(
        jdoc           in json_document_type,
        row_identifier in varchar2 default null,        
        array_path     in varchar2 default null    
    ) return column_values pipelined;
        
    procedure debug_unpivot_json_array(
        jdoc                  in json_document_type,
        row_identifier        in varchar2 default null,        
        array_path            in varchar2 default null,
        dataguide_columns     in boolean default true,
        json_table_expression in boolean default true,
        unpivot_expression    in boolean default true
    );

    function test_jdoc(
        format_option in json_format default c_array_simple
    ) return json_document_type;
    
end dynamic_json;
/
