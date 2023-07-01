set serveroutput on;
declare
    subtype t_string is varchar2(20);
    type t_entry is record(author t_string, subject t_string);
    l_article t_entry;
begin
    l_article.author := 'Anthony Harper';
    l_article.subject := 'Beginnings';
    dbms_output.put_line(l_article.author);
    dbms_output.put_line(l_article.subject);
end;
/