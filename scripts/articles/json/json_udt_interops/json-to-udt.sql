drop type t_worldviews_nt;
drop type t_worldview;
drop type t_concepts_nt;
drop type t_concept;
drop type t_inquiries_nt;
drop type t_inquiry;
drop type t_inquiry_tests_nt;
drop type t_inquiry_test;
drop type t_inquiry_test_measures_nt;
drop type t_inquiry_test_measure;




with jbase as (
select
q'!
{"conceptDetails":[
    {"conceptId":1,"inquiryDetails":
        [
            {"inquiryCode":"aaa",
            "testDetails": [
                {"testCode":"qrs","measureDetails": [{"measureCode":"xxx","measureValue":"hello"},{"measureCode":"yyy","measureValue":"sun"}]},
                {"testCode":"rrq","measureDetails": [{"measureCode":"yyy","measureValue":"goodnight"},{"measureCode":"yyy","measureValue":"moon"}]}
                ]
            },
            {"inquiryCode":"bbb",
            "testDetails": [{"testCode":"abc","measureDetails":[{"measureCode":"nnn","measureValue":"dark"},{"measureCode":"mmm","measureValue":"night"}]}
                ]
            }
        ]
    },
    {"conceptId":2,"inquiryDetails":
        [
            {"inquiryCode":"ccc",
            "testDetails": [
                {"testCode":"dde","measureDetails": [{"measureCode":"zzz","measureValue":"calm"},{"measureCode":"yyy","measureValue":"seas"}]}
                ]
            },
            {"inquiryCode":"ddd",
            "testDetails": [{"testCode":"gfg","measureDetails":[{"measureCode":"www","measureValue":"stormy"},{"measureCode":"mmm","measureValue":"day"}]}
                ]
            }
        ]
    }            
]
}
!'
 as jdoc
from dual

), concepts_base as (
    select json_value(j.jdoc format json, '$.conceptDetails' returning t_concepts_nt) as concepts_collection from jbase j
--) select r.* from concepts_base r;
--
--select json_value(j.jdoc format json, '$.conceptDetails' returning t_concepts_nt) as x from jbase j --19.30 fails when inlined or used in cte.. fixed in 26.4
--/

), concept_base as (
select
    --j.jconcept,
    json_value(j.jconcept format json, '$' returning t_concept) as concept_object
from jbase b,
    json_table(b.jdoc format json, '$.conceptDetails[*]' columns (
        jconcept format json path '$'
    )
) j
--) select r.concept_object, r.concept_object."conceptId" from concept_base r;  
), inquiry_base as (
select
    j."conceptId",
    --j.jinquiry
    json_value(j.jinquiry format json, '$' returning t_inquiry) as inquiry_object
from jbase b,
json_table(b.jdoc format json, '$.conceptDetails[*]' columns(
    "conceptId" path '$.conceptId.number()',
    nested path '$.inquiryDetails[*]' columns(
        jinquiry format json path '$'
    )
)) j

--) select * from inquiry_base; --works
), test_base as (
select
    j.*
from jbase b,
json_table(b.jdoc format json, '$.conceptDetails[*]' columns (
    --jconcept format json path '$',
    "conceptId" path '$.conceptId',
    nested path '$.inquiryDetails[*]' columns (
        --jinquiry format json path '$',
        "inquiryCode" path '$.inquiryCode',        
        nested path '$.testDetails[*]' columns (
            "testCode" path '$.testCode',
            nested path '$.measureDetails[*]' columns (
                "measureCode" path '$.measureCode',
                "measureValue" path '$.measureValue'
            )
        )
    )
)) j

--        ), use_concepts_base as (
--        select r."conceptId", c."inquiryCode", cr."testCode", d.*
--        from concepts_base rw,
--            table(rw.concepts_collection) r,
--            table(r."inquiryDetails") c,
--            table(c."testDetails") cr,
--            table(cr."measureDetails") d
--        --) select * from use_concepts_base;
), use_concept_base as (
select r.concept_object."conceptId" as "conceptId" , c."inquiryCode", cr."testCode", tt.*
from concept_base r ,
    table( r.concept_object."inquiryDetails") c,
    table (c."testDetails") cr,
    table(cr."measureDetails") tt
--) select * from use_concept_base;
), use_inquiry_base as (
select b."conceptId", b.inquiry_object."inquiryCode" as "inquiryCode"
    --, b.inquiry_object."testDetails"
    , t."testCode"
    , tt.*
from inquiry_base b,
table (b.inquiry_object."testDetails") t,
table (t."measureDetails") tt
--) select * from use_inquiry_base;
)
select * from test_base j
/



create or replace type t_inquiry_test_measure as object(
    "measureCode" varchar2(100),
    "measureValue" varchar2(100)
)
/

create or replace type t_inquiry_test_measures_nt as table of t_inquiry_test_measure
/

create or replace type t_inquiry_test as object(
    "testCode" varchar2(100),
    "measureDetails" t_inquiry_test_measures_nt
)
/

create or replace type t_inquiry_tests_nt as table of t_inquiry_test
/

create or replace type t_inquiry as object(
    "inquiryCode" varchar2(100),
    "testDetails" t_inquiry_tests_nt
)
/

create or replace type t_inquiries_nt as table of t_inquiry
/

create or replace type t_concept as object( 
    "conceptId" number,
    "inquiryDetails" t_inquiries_nt
)
/

create or replace type t_concepts_nt as table of t_concept
/


create or replace type t_worldview as object(
    "worldviewId" number,
    "worldviewName" varchar2(100),
    "conceptDetails" t_concepts_nt
)
/

create or replace type t_worldviews_nt as table of t_worldview
/