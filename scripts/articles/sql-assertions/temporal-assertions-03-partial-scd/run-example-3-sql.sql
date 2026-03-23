spool run-example-3-sql-results.txt

prompt running example with sql only
@example-3-01-tables.sql
@example-3-02-assertion.sql
@example-3-03-view.sql
--TODO: remove the package deployment after example-3-05-tests-sql.sql is updated to remove dependency
@example-3-04-package.sql
@example-3-05-tests-sql.sql
@example-3-06-drop-all.sql

spool off