set feedback off;
set define off;
set serveroutput on;
declare
    l_raw_links varchar2(32000);
    c_divider constant varchar2(20) := '##START-ENTRY##';
    subtype t_str is varchar2(4000);
    c_project constant t_str := 'TITLE';
    c_github constant t_str := 'GITHUB';
    c_website constant t_str := 'WEBSITE';
    type t_dtl is record(offset number, next_offset number, length number, contents t_str);
    type t_dtls is table of t_dtl index by t_str;
    type t_lnks is table of t_dtls index by t_str;
    l_parser t_dtls;
    l_os_links t_lnks;
    l_offset number;
    l_next_item number;
    l_item t_str;
begin

l_raw_links := 
q'[##START-ENTRY##
Source Code For PracticalPlsql.org Articles By Anthony Harper
https://practicalplsql.org/
https://github.com/gaiansentience/practicalplsql
##START-ENTRY##
Tools and Examples For PL/SQL API Development and Administration.
https://practicalplsql.org/
https://github.com/gaiansentience/oracle-architect-tools
##START-ENTRY##
Oracle PL/SQL API: Event Management Demo
https://practicalplsql.org/
https://github.com/gaiansentience/oracle-events-system-demo
##START-ENTRY##
Oracle APEX on GitHub
https://apex.oracle.com/en/
https://github.com/oracle/apex.git
##START-ENTRY##
oracle-db-examples
https://www.oracle.com/database/technologies/
https://github.com/oracle-samples/oracle-db-examples
##START-ENTRY##
Oracle Database Sample Schemas
https://docs.oracle.com/en/database/oracle/oracle-database/21/comsc/index.html
https://github.com/oracle-samples/db-sample-schemas
##START-ENTRY##
Oracle Database Sample Schemas 23c
https://docs.oracle.com/en/database/oracle/oracle-database/23/
https://github.com/oracle-samples/db-sample-schemas/releases
##START-ENTRY##
Oracle Database Tools
https://github.com/oracle/oracle-db-tools
https://github.com/oracle/oracle-db-tools
##START-ENTRY##
Oracle LiveLabs: A Collection of Open Source Repositories From Oracle
https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/home
https://github.com/oracle-livelabs
##START-ENTRY##
Oracle LiveLabs: Analytics-AI
https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/home
https://github.com/oracle-livelabs/analytics-ai
##START-ENTRY##
Oracle Livelabs: Database
https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/home
https://github.com/oracle-livelabs/database
##START-ENTRY##
Oracle LiveLabs: University
https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/home
https://github.com/oracle-livelabs/university
##START-ENTRY##
Oracle PL/SQL Utility Library
https://github.com/mortenbra/alexandria-plsql-utils
https://github.com/mortenbra/alexandria-plsql-utils
##START-ENTRY##
Code generator for Oracle PL/SQL based on a simple markup language
https://github.com/mortenbra/quick-plsql
https://github.com/mortenbra/quick-plsql
##START-ENTRY##
oracle-base.com scripts
https://oracle-base.com/dba/scripts
https://github.com/oraclebase/dba
##START-ENTRY##
Tales From A Lazy Fat DBA: My Oracle DB Scripts
https://fatdba.com/
https://github.com/fatdba/Oracle-Database-Scripts
##START-ENTRY##
SQL scripts for Oracle Database Tuning
https://github.com/bobbydurrett/OracleDatabaseTuningSQL
https://github.com/bobbydurrett/OracleDatabaseTuningSQL
##START-ENTRY##
Common PL/SQL utility scripts
https://github.com/OraOpenSource/oos-utils
https://github.com/OraOpenSource/oos-utils
##START-ENTRY##
PL/JSON
https://pljson.github.io/pljson/
https://github.com/pljson/pljson
##START-ENTRY##
Liquibase extension to add improved Oracle support
https://github.com/liquibase/liquibase-oracle
https://github.com/liquibase/liquibase-oracle
##START-ENTRY##
OakAcademy: Oracle Basic SQL
https://github.com/OakAcademy/Oracle.git
https://github.com/OakAcademy/Oracle.git
##START-ENTRY##
ReneNyffenegger: oracle-patterns
https://github.com/ReneNyffenegger/oracle-patterns
https://github.com/ReneNyffenegger/oracle-patterns
##START-ENTRY##
ReneNyffenegger: Creating Excel workbooks (xlsx) with PL/SQL
https://github.com/ReneNyffenegger/xlsx_writer-Oracle
https://github.com/ReneNyffenegger/xlsx_writer-Oracle
##START-ENTRY##
Source code for "Practical Oracle SQL" by Kim Berg Hansen
https://link.springer.com/book/10.1007/978-1-4842-5617-6
https://github.com/Apress/practical-oracle-sql
##START-ENTRY##
Example of a basic blockchain within the Oracle Database
https://github.com/Dani3lSun/oracle-blockchain
https://github.com/Dani3lSun/oracle-blockchain
##START-ENTRY##
Source code for "Expert Oracle Database Architecture" by Thomas Kyte
https://link.springer.com/book/10.1007/978-1-4302-2947-6
https://github.com/Apress/exp-oracle-db-architecture
##START-ENTRY##
Source code for "Expert Oracle Database Architecture" by Thomas Kyte and Darl Kuhn
https://link.springer.com/book/10.1007/978-1-4302-6299-2
https://github.com/Apress/exp-oracle-db-architecture-14
##START-ENTRY##
Logger is used by Oracle developers to instrument their PL/SQL code
https://github.com/OraOpenSource/Logger
https://github.com/OraOpenSource/Logger
##START-ENTRY##
utPLSQL: Testing Framework for PL/SQL
https://www.utplsql.org/about.html
https://github.com/utPLSQL/utPLSQL
##START-ENTRY##
Oracle PL/SQL Package for Microsoft Word Documents Generation
https://github.com/zorantica/plsql-word
https://github.com/zorantica/plsql-word
##START-ENTRY##
PLSQL_LEXER 2.2.0: A PL/SQL package to solve real-world language problems
https://github.com/method5/plsql_lexer
https://github.com/method5/plsql_lexer
##START-ENTRY##
The Complete PL/SQL Bootcamp : "Beginner to Advanced PL/SQL"
https://www.udemy.com/course/plsql-beginner-to-advanced-become-a-perfect-plsql-developer/
https://github.com/blackdogcode/OraclePLSQL
##START-ENTRY##
ExcelGen - An Oracle PL/SQL Generator for MS Excel Files
https://github.com/mbleron/ExcelGen
https://github.com/mbleron/ExcelGen
##START-ENTRY##
PL/SQL package written by Anton Scheffer which allows us to export Excel XLSX files from an Oracle Database.
https://github.com/sokolsaiti/as_xlsx
https://github.com/sokolsaiti/as_xlsx
##START-ENTRY##
ORACLE PLSQL LOGGER: A super simple logger used in PLSQL procedure, package and functions...
https://github.com/matitaweb/oracle-plsql-logger
https://github.com/matitaweb/oracle-plsql-logger
##START-ENTRY##
Oracle PL/SQL General Utilities Module
https://github.com/BrenPatF/oracle_plsql_utils
https://github.com/BrenPatF/oracle_plsql_utils
##START-ENTRY##
Expert SQL & PL/SQL Book : Advice from the Experts (Oracle Press) Sample Code
https://www.amazon.com/gp/product/1259640973/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=1259640973&linkCode=as2&tag=brendantierne-20&linkId=KICPN2S7XXCS6MY5
https://github.com/Oralytics/SQL-and-PLSQL-from-the-Experts-Sample-code
##START-ENTRY##
Oracle PL/SQL API Demos: Demonstrating Oracle PL/SQL API procedures for getting and setting database data, with code timing, message logging and unit testing
https://github.com/BrenPatF/oracle_plsql_api_demos
https://github.com/BrenPatF/oracle_plsql_api_demos
##START-ENTRY##
Oracle PLSQL: Scripts PLSQL DW
https://github.com/eniltonsp/Oracle-PLSQL
https://github.com/eniltonsp/Oracle-PLSQL
##START-ENTRY##
Oracle PL/SQL utility code
https://github.com/scott-swank/plsql-util
https://github.com/scott-swank/plsql-util
##START-ENTRY##
PL/SQL Logger: Simple and effective logger framework for Oracle Database
https://github.com/ValeriyTyutyunnik/plsql-logger
https://github.com/ValeriyTyutyunnik/plsql-logger
##START-ENTRY##
wtPLSQL - Whitebox Testing for PL/SQL
https://github.com/wtPLSQL/wtPLSQL
https://github.com/wtPLSQL/wtPLSQL
##START-ENTRY##
Trivadis PL/SQL & SQL Coding Guidelines
https://trivadis.github.io/plsql-and-sql-coding-guidelines/v4.2/
https://github.com/Trivadis/plsql-and-sql-coding-guidelines
##START-ENTRY##
Source code for "Modern Oracle Database Programming: Level Up Your Skill Set to Oracle's Latest and Most Powerful Features in SQL, PL/SQL, and JSON" by Alex Nuijten and Patrick Barel
https://github.com/Apress/modern-oracle-database-programming
https://github.com/Apress/modern-oracle-database-programming
##START-ENTRY##
Title: (From Github About)
Website: (From GitHub About: Use Github URL if not provided)
GitUrl: (Github URL)
]';

--l_total_length := length(l_raw_links);
--dbms_output.put_line('total length='||l_total_length);
l_offset := 1 + length(c_divider);

loop
    l_next_item := instr(l_raw_links, c_divider, l_offset);
    exit when l_next_item = 0;

    l_item := substr(l_raw_links, l_offset, l_next_item - l_offset);
    
    l_parser(c_project).offset := 2;
    l_parser(c_project).next_offset := instr(l_item,chr(10),l_parser(c_project).offset);
    l_parser(c_project).length := l_parser(c_project).next_offset - l_parser(c_project).offset;
    l_parser(c_project).contents := substr(l_item, l_parser(c_project).offset, l_parser(c_project).length);
    
    l_parser(c_website).offset := l_parser(c_project).next_offset + 1;
    l_parser(c_website).next_offset := instr(l_item,chr(10),l_parser(c_website).offset);
    l_parser(c_website).length := l_parser(c_website).next_offset - l_parser(c_website).offset;
    l_parser(c_website).contents := substr(l_item, l_parser(c_website).offset, l_parser(c_website).length);
    
    l_parser(c_github).offset := l_parser(c_website).next_offset + 1;
    l_parser(c_github).next_offset := instr(l_item,chr(10),l_parser(c_github).offset);
    l_parser(c_github).length := l_parser(c_github).next_offset - l_parser(c_github).offset;
    l_parser(c_github).contents := substr(l_item, l_parser(c_github).offset, l_parser(c_github).length);
    
    l_os_links(l_parser(c_github).contents) := l_parser;
    
    l_offset := l_next_item + length(c_divider);
end loop;

for i_entry in indices of l_os_links loop
    dbms_output.put_line(l_os_links(i_entry)(c_project).contents);
    dbms_output.put_line(l_os_links(i_entry)(c_github).contents);
    if l_os_links(i_entry)(c_github).contents <> l_os_links(i_entry)(c_website).contents then
        dbms_output.put_line('More Info at ' || l_os_links(i_entry)(c_website).contents);
    end if;
    dbms_output.put_line(null);
end loop;

end;
/