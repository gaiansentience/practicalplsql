
set serveroutput on;


declare
    subtype plLang is json;
    subtype plSqlCode is clob;
    myDef plLang;
    myCode plsqlCode;
    type paramDef is record(
        n varchar2(100),
        d varchar2(20),
        t varchar2(100)
    );
    type paramDefs is table of paramDef;
    function pgen(s in plLang) return plsqlcode
    is
    jp plLang;
    p paramDefs;
    c plsqlcode;
    lf constant varchar2(1) := chr(10);
    isFunction boolean := false;
    mName varchar2(100);
    begin
    mName := json_value(s, '$.methodName');
    isFunction := json_value(s, '$.isFunction' returning boolean);
    --dbms_output.put_line(mName ||' is a '|| case when isFunction then 'function' else 'procedure' end);
    
    c := case when isFunction then 'function' else 'procedure' end || ' ' || mName;

    p := json_value(s,'$.params' returning paramdefs);
    
    if isFunction and p.count > 1 or not isfunction then
    c := c || '(' || lf;
    for i in 1..p.count loop
        if not isFunction or i > 1 then
        --dbms_output.put_line(p(i).n || ' ' || p(i).d || ' ' || p(i).t);
        c := c || p(i).n || ' ' || p(i).d || ' ' || p(i).t || case when i <> p.count then ',' end || lf;
        end if;
    end loop;
    c := c || ')' || lf;
    end if;
    
    c := c || case when isFunction then 'return ' || p(1).t || lf end;

    c := c || 'is' || lf;
    c := c || 'begin' || lf;
    c := c || json_value(s,'$.implementation' returning varchar2) || lf;
    c := c || 'end;' || lf;
    
    return c;
        
    
    end pgen;
    
begin

    myDef := 
json('
{
"methodName":"test",
"isFunction":true,
"isPublic":true,
"params":[
{"n":"retVal","d":"return","t":"number"},
{"n":"x","d":"in","t":"number"},
{"n":"y","d":"in","t":"number"}
],
"variables":[{"n":"l_ret","isConstant":false,"t":"number"}],
"implementation":"return x * y;",
"exceptions":[]
}
');

    myCode := pgen(mydef);
    
    dbms_output.put_Line(myCode);

end;
/


select

json_query(
json('
{
"methodName":"test",
"isFunction":true,
"isPublic":true,
"params":[
{"n":"retVal","d":"return","t":"number"},
{"n":"x","d":"in","t":"number"},
{"n":"y","d":"in","t":"number"}
],
"variables":[{"n":"l_ret","isConstant":false,"t":"number"}],
"implementation":"return x * y;",
"exceptions":[]
}
'),
'$.params' returning clob pretty)
/