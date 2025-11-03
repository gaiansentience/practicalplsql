--serialize-sparse-vectors-plsql.sql
set serveroutput on;

--in plsql, from_vector doesnt support arguments
declare
    v vector;
    t clob;
begin

    v := to_vector('[8,[0,3,5],[11,33,77]]',*,int8,sparse);
    t := from_vector(v);
    dbms_output.put_line(t);
    
    v := to_vector('[11,0,0,33,0,77,0,0]',*,int8);
    t := from_vector(v);
    dbms_output.put_line(t);
    
end;
/
/*
[8,[0,3,5],[11,33,77]]
[11,0,0,33,0,77,0,0]
*/

--in plsql, from_vector doesnt support arguments
declare
    v vector;
    t clob;
begin
    v := to_vector('[11,0,0,33,0,77,0,0]',*,int8);
    t := from_vector(v returning clob format sparse);
    dbms_output.put_line(t);
end;
/
/*
PLS-00103: Encountered the symbol "FORMAT" when expecting one of the following:

   . ( ) @ % null range returning with default error using empty
   lax strict without pretty ascii true false absent allow
   truncate ignore extended
*/


--in plsql, use sql to use from_vector to serialize to different storage format
declare
    v vector;
    t clob;
begin
    v := to_vector('[11,0,0,33,0,77,0,0]',*,int8);
    
    select from_vector(v returning clob format sparse)
    into t;
    dbms_output.put_line('dense as sparse text: ' || t);
    
    v := to_vector('[8,[0,3,5],[11,33,77]]',*,int8, sparse);
    
    select from_vector(v returning clob format dense)
    into t;
    dbms_output.put_line('sparse as dense text: ' || t);    
end;
/
/*
dense as sparse text: [8,[0,3,5],[11,33,77]]
sparse as dense text: [11,0,0,33,0,77,0,0]
*/
