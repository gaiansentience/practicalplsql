set serveroutput on;
declare
    x vector := vector('[1,2]');
    y vector := vector('[3,4]');
    z vector;
begin

$if dbms_db_version.version >= 23 $then
    z := x + y;
    z := x - y;
    z := x * y;
    --z := x / y;
    dbms_output.put_line('Wow, vector math in Oracle 23AI Release 7!');
$else
    dbms_output.put_line('Time to upgrade!');
$end

end;
/