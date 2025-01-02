--table-macro-06-split-strings.sql

column detail_item format a12
column id format 99
set null (null)

with

    function p_split_strings(
        p_data in dbms_tf.table_t
        , p_delim_column in dbms_tf.columns_t
        , p_value_alias in dbms_tf.columns_t
    ) return varchar2 sql_macro(table)
    is
    l_sql varchar2(4000);
    begin
    
        l_sql := q'~
            select b.*, s.##split_value_alias##
            from
                p_data b
                outer apply 
                (
                    select ##split_value_alias##
                    from
                        (
                        select 
                            regexp_substr(
                                b.##delimited_values##
                                ,'[^,]+'
                                ,1
                                , x.pos) as ##split_value_alias##
                        from 
                            (
                            select level as pos 
                            from dual 
                            connect by level <= 
                                length(
                                    regexp_replace(
                                        b.##delimited_values##
                                        , '[^,]')
                                    ) + 1
                            ) x
                        )
                    where ##split_value_alias## is not null
                ) s
            ~';
        
        l_sql := replace(l_sql, '##split_value_alias##', p_value_alias(1));
        l_sql := replace(l_sql, '##delimited_values##', p_delim_column(1));    
        return l_sql;
    end p_split_strings;

base (id, detail_list) as (
    select 1, 'aa,bb,cc,' from dual union all
    select 2, 'xxx,yyyy,,zzzz' from dual union all
    select 3, null from dual
)
select s.* 
from p_split_strings(base, columns(detail_list), columns(detail_item)) s
/

/*
 ID DETAIL_LIST    DETAIL_ITEM 
--- -------------- ------------
  1 aa,bb,cc,      aa          
  1 aa,bb,cc,      bb          
  1 aa,bb,cc,      cc          
  2 xxx,yyyy,,zzzz xxx         
  2 xxx,yyyy,,zzzz yyyy        
  2 xxx,yyyy,,zzzz zzzz        
  3 (null)         (null)    
*/