set serveroutput on;
declare
    l_sql clob;
    l_sql_expanded clob;
begin

    l_sql := 'select * from row_compare_union_cte(products_source, products_target, columns(product_id))';
    
    dbms_utility.expand_sql_text(l_sql, l_sql_expanded);
    
    dbms_output.put_line(l_sql_expanded);

end;
/


/*
--expand sql text does not show the CTE expressions (has two selects against each table)
SELECT "A1"."ROW_SOURCE" "ROW_SOURCE","A1"."PRODUCT_ID" "PRODUCT_ID","A1"."CODE" "CODE","A1"."NAME" "NAME","A1"."DESCRIPTION" "DESCRIPTION","A1"."STYLE" "STYLE","A1"."UNIT_MSRP" "UNIT_MSRP" 
FROM  (
    SELECT "A4"."ROW_SOURCE" "ROW_SOURCE","A4"."PRODUCT_ID" "PRODUCT_ID","A4"."CODE" "CODE","A4"."NAME" "NAME","A4"."DESCRIPTION" "DESCRIPTION","A4"."STYLE" "STYLE","A4"."UNIT_MSRP" "UNIT_MSRP" 
    FROM  
        (
        SELECT "A5"."ROW_SOURCE" "ROW_SOURCE","A5"."PRODUCT_ID" "PRODUCT_ID","A5"."CODE" "CODE","A5"."NAME" "NAME","A5"."DESCRIPTION" "DESCRIPTION","A5"."STYLE" "STYLE","A5"."UNIT_MSRP" "UNIT_MSRP" 
        FROM ( 
                (
                SELECT 'source' "ROW_SOURCE","A10"."PRODUCT_ID" "PRODUCT_ID","A10"."CODE" "CODE","A10"."NAME" "NAME","A10"."DESCRIPTION" "DESCRIPTION","A10"."STYLE" "STYLE","A10"."UNIT_MSRP" "UNIT_MSRP" 
                FROM (
                    SELECT "A12"."PRODUCT_ID" "PRODUCT_ID","A12"."CODE" "CODE","A12"."NAME" "NAME","A12"."DESCRIPTION" "DESCRIPTION","A12"."STYLE" "STYLE","A12"."UNIT_MSRP" "UNIT_MSRP" 
                    FROM (
                        SELECT "A3"."PRODUCT_ID" "PRODUCT_ID","A3"."CODE" "CODE","A3"."NAME" "NAME","A3"."DESCRIPTION" "DESCRIPTION","A3"."STYLE" "STYLE","A3"."UNIT_MSRP" "UNIT_MSRP" 
                        FROM "PRACTICALPLSQL"."PRODUCTS_SOURCE" "A3"
                        ) "A12"
                    ) "A10"
                ) MINUS (
                SELECT 'source' "ROW_SOURCE","A9"."PRODUCT_ID" "PRODUCT_ID","A9"."CODE" "CODE","A9"."NAME" "NAME","A9"."DESCRIPTION" "DESCRIPTION","A9"."STYLE" "STYLE","A9"."UNIT_MSRP" "UNIT_MSRP" 
                FROM (
                    SELECT "A11"."PRODUCT_ID" "PRODUCT_ID","A11"."CODE" "CODE","A11"."NAME" "NAME","A11"."DESCRIPTION" "DESCRIPTION","A11"."STYLE" "STYLE","A11"."UNIT_MSRP" "UNIT_MSRP" 
                    FROM (
                        SELECT "A2"."PRODUCT_ID" "PRODUCT_ID","A2"."CODE" "CODE","A2"."NAME" "NAME","A2"."DESCRIPTION" "DESCRIPTION","A2"."STYLE" "STYLE","A2"."UNIT_MSRP" "UNIT_MSRP" 
                        FROM "PRACTICALPLSQL"."PRODUCTS_TARGET" "A2"
                        ) "A11"
                    ) "A9"
                ) UNION ALL (
                    (
                    SELECT 'target' "ROW_SOURCE","A8"."PRODUCT_ID" "PRODUCT_ID","A8"."CODE" "CODE","A8"."NAME" "NAME","A8"."DESCRIPTION" "DESCRIPTION","A8"."STYLE" "STYLE","A8"."UNIT_MSRP" "UNIT_MSRP" 
                    FROM  (
                        SELECT "A11"."PRODUCT_ID" "PRODUCT_ID","A11"."CODE" "CODE","A11"."NAME" "NAME","A11"."DESCRIPTION" "DESCRIPTION","A11"."STYLE" "STYLE","A11"."UNIT_MSRP" "UNIT_MSRP" 
                        FROM  (
                            SELECT "A2"."PRODUCT_ID" "PRODUCT_ID","A2"."CODE" "CODE","A2"."NAME" "NAME","A2"."DESCRIPTION" "DESCRIPTION","A2"."STYLE" "STYLE","A2"."UNIT_MSRP" "UNIT_MSRP" 
                            FROM "PRACTICALPLSQL"."PRODUCTS_TARGET" "A2"
                            ) "A11"
                        ) "A8"
                ) MINUS (
                SELECT 'target' "ROW_SOURCE","A7"."PRODUCT_ID" "PRODUCT_ID","A7"."CODE" "CODE","A7"."NAME" "NAME","A7"."DESCRIPTION" "DESCRIPTION","A7"."STYLE" "STYLE","A7"."UNIT_MSRP" "UNIT_MSRP" 
                FROM  (
                    SELECT "A12"."PRODUCT_ID" "PRODUCT_ID","A12"."CODE" "CODE","A12"."NAME" "NAME","A12"."DESCRIPTION" "DESCRIPTION","A12"."STYLE" "STYLE","A12"."UNIT_MSRP" "UNIT_MSRP" 
                    FROM  (
                        SELECT "A3"."PRODUCT_ID" "PRODUCT_ID","A3"."CODE" "CODE","A3"."NAME" "NAME","A3"."DESCRIPTION" "DESCRIPTION","A3"."STYLE" "STYLE","A3"."UNIT_MSRP" "UNIT_MSRP" 
                        FROM "PRACTICALPLSQL"."PRODUCTS_SOURCE" "A3"
                        ) "A12"
                    ) "A7"
                )
                )
            ) "A5" 
    ORDER BY "A5"."PRODUCT_ID","A5"."ROW_SOURCE"
    ) "A4"
) "A1"
*/