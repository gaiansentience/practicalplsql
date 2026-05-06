--23.26.2

--validation directives for duality views
--basically triggers

--https://docs.oracle.com/en/database/oracle/oracle-database/26/jsnvu/validation-directives.html#JSNVU-GUID-C8105556-75DD-40C5-A3C7-ABBC265C1D03


CREATE (OR REPLACE) DIRECTIVE directive_name
  FOR json_relational_duality_view_name
  VALIDATE
  ON ( SELECT | INSERT | UPDATE )+
  Processing_Stage_Clause  before object|after object|on commit
  [ Validate_Enable_Clause ]  validate|novalidate|enable|disable
  USING validation_logic;
  
  
  
--validation_logic is (sql/json expression, plsql function,plsql block

--check values on insert (check constraint that only applies to inserts)
CREATE DIRECTIVE salary_less_10k FOR employee_dv
  VALIDATE
  ON INSERT
  BEFORE OBJECT
  USING json_value(new.data, '$.salary') < 10000;
  
  
CREATE OR REPLACE FUNCTION isThisSalaryOK(old_data JSON, new_data JSON)
  RETURN BOOLEAN
IS
  f BOOLEAN;
BEGIN
  IF json_value(new_data, '$.salary') < 2000 THEN
    f := false;
  ELSE
    f := true;
  END IF;

  RETURN f;
END;
/




CREATE DIRECTIVE validate_salary FOR employee_dv
  VALIDATE
  ON INSERT
  BEFORE OBJECT
  NOVALIDATE
  USING isThisSalaryOK;