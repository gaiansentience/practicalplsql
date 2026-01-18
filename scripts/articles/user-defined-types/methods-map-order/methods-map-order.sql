--user defined types (simple with scalar attributes, nested objects, nested tables of scalar, nested tables of objects)

set serveroutput on;

--user defined type constructors to simplify constructing complex types

--static vs member methods

create or replace type t_string as object(
    s varchar2(4000 char)
)
/

--need to provide arguments to the default constructor for all attributes
declare 
    hi t_string := new t_string();
begin
    
    dbms_output.put_line(hi.s);

end;
/

--null is sufficient
declare 
    hi t_string := new t_string(NULL);
begin
    
    dbms_output.put_line(nvl(hi.s,'its null'));

end;
/


declare 
    hi t_string := new t_string('hello world');
begin
    
    dbms_output.put_line(hi.s);

end;
/


declare 
    hi t_string;
begin

    hi := new t_string('hello world');
    
    dbms_output.put_line(hi.s);

    hi := new t_string('goodnight moon');
    
    dbms_output.put_line(hi.s);

    hi.s := 'hello world';
    
    dbms_output.put_line(hi.s);

end;
/

--add a default constructor
create or replace type t_string as object(
    s varchar2(4000 char),
    constructor function t_string return self as result
)
/

create or replace type body t_string
as
    constructor function t_string return self as result
    is
    begin
        --property will be null at first
        self.s := 'attribute set by user defined constructor';
        return;
    end t_string;
end;
/

set serveroutput on;
declare 
    hi t_string;
begin

    hi := new t_string();

    dbms_output.put_line(nvl(hi.s,'its null'));

    hi := new t_string(null);

    dbms_output.put_line(nvl(hi.s,'its null'));

    
    hi.s := 'hello world';
    
    dbms_output.put_line(hi.s);

end;
/

--overriding the default constructor
--data type of constructor matches, but parameter name is different
create or replace type t_string as object(
    s varchar2(4000 char),
    constructor function t_string(
        x in varchar2
    ) return self as result
)
/

create or replace type body t_string
as
    constructor function t_string(
        x in varchar2
    ) return self as result
    is
    begin
        --property will be null at first
        self.s := x || '(set by user defined constructor)';
        return;
    end t_string;
end;
/

set serveroutput on;
declare 
    hi t_string;
begin

    hi := new t_string(s =>'hello world');

    dbms_output.put_line(nvl(hi.s,'its null'));

    hi := new t_string(x =>'hello world');

    dbms_output.put_line(nvl(hi.s,'its null'));

    hi := new t_string('hello world');

    dbms_output.put_line(nvl(hi.s,'its null'));

    hi := new t_string(null);

    dbms_output.put_line(nvl(hi.s,'its null'));

    
    hi.s := 'hello world';
    
    dbms_output.put_line(hi.s);

end;
/


--data type of constructor matches, but parameter name is different
create or replace type t_string as object(
    s varchar2(4000 char),
    constructor function t_string(
        s in varchar2
    ) return self as result
)
/

create or replace type body t_string
as
    constructor function t_string(
        s in varchar2
    ) return self as result
    is
    begin
        --property will be null at first
        self.s := s || '(set by user defined constructor)';
        return;
    end t_string;
end;
/

set serveroutput on;
declare 
    hi t_string;
begin

    hi := new t_string(s =>'hello world');

    dbms_output.put_line(nvl(hi.s,'its null'));

    hi := new t_string('hello world');

    dbms_output.put_line(nvl(hi.s,'its null'));


    hi := new t_string(null);

    dbms_output.put_line(nvl(hi.s,'its null'));

    
    hi.s := 'hello world';
    
    dbms_output.put_line(hi.s);

end;
/


--creating defaults with constructors

create or replace type t_string as object(
    s varchar2(4000 char),
    constructor function t_string(
        s in varchar2 default 'my default'
    ) return self as result
)
/

create or replace type body t_string
as
    constructor function t_string(
        s in varchar2 default 'my default'
    ) return self as result
    is
    begin
        --property will be null at first
        self.s := s || '(set by user defined constructor)';
        return;
    end t_string;
end;
/

set serveroutput on;
declare 
    hi t_string;
begin

    hi := new t_string(s =>'hello world');

    dbms_output.put_line(nvl(hi.s,'its null'));

    hi := new t_string();

    dbms_output.put_line(nvl(hi.s,'its null'));


    hi := new t_string(null);

    dbms_output.put_line(nvl(hi.s,'its null'));

    
    hi.s := 'hello world';
    
    dbms_output.put_line(hi.s);

end;
/



--map/order methods

--helper methods for objects with nested table attributes

--type inheritance

--overloaded methods

--overriding methods

--constructing nested table with mixed inherited types


--type evolution




--accessing nested types from python client, java client
    --java uses indexed attributes only for accessing nested objects
    --??? python??? 

--accessing nested cursors from client





--parsing json into types:

--json_value or json table returning UDT types

--json parsing into subtypes...
--if json exists (subtype attribute) then json_value returning subtype else json_value returning supertype



--parsing nested table of subtypes into json
