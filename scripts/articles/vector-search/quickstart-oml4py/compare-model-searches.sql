--compare-model-searches.sql
set serveroutput on;
declare

    cursor c_models is
    select model_name 
    from user_mining_models
    order by model_name;

    procedure update_embeddings(p_model_name in varchar2)
    is
        l_sql varchar2(1000);
    begin
    
        l_sql := q'[
            update recipes g
            set 
                embedding = vector_embedding(##model_name## using g.doc as data), 
                embedding_model = '##model_name##'        
        ]';
        
        l_sql := replace(l_sql, '##model_name##', p_model_name);
        
        execute immediate l_sql;
        
        commit;
    
    end update_embeddings;
    
    procedure run_search(p_search_expression in varchar2, p_model_name in varchar2)
    is
        l_sql varchar2(1000);
        rc sys_refcursor;
        type t_rec is record(
            ranking number
            , name varchar2(100)
            , doc varchar2(1000)
        );
        r t_rec;
    begin
        update_embeddings(p_model_name);
        dbms_output.put_line(lpad('-', 50, '-'));
        dbms_output.put_line('Mining Model: ' || p_model_name);
        dbms_output.put_line('Search Expression: ' || p_search_expression);
        
        l_sql := q'[
            select rownum as ranking, name, doc
            from
                (
                select name, doc
                from recipes g
                order by 
                    vector_distance(
                        g.embedding
                        , vector_embedding(##model_name## using :search_expression as data)
                        , euclidean)
                fetch first 3 rows only
                )
        ]';
        
        l_sql := replace(l_sql, '##model_name##', p_model_name);
        
        open rc for l_sql using p_search_expression;
        loop
            fetch rc into r;
            exit when rc%notfound;
            dbms_output.put_line(r.ranking || '-' || r.name);
        end loop;
        close rc;
    exception
        when others then
            dbms_output.put_line('Vector Distance Error, model ' || p_model_name || chr(10) || sqlerrm);
    end run_search;

begin
    
    for r in c_models loop
        
        run_search('yummy dessert', r.model_name);
    end loop;
    
end;
/

/*
--------------------------------------------------
Mining Model: ALL_MINILM_L12_V2
Search Expression: yummy dessert
1-Strawberry Pie
2-Raspberry Tarts
3-Oatmeal Cookies
--------------------------------------------------
Mining Model: ALL_MINILM_L6_V2
Search Expression: yummy dessert
1-Strawberry Pie
2-Raspberry Tarts
3-Grilled Cheese Sandwiches
--------------------------------------------------
Mining Model: ALL_MPNET_BASE_V2
Search Expression: yummy dessert
1-Strawberry Pie
2-Raspberry Tarts
3-Grilled Cheese Sandwiches
--------------------------------------------------
Mining Model: BERT_TINY
Search Expression: yummy dessert
1-Miso Soup
2-Curried Tofu
3-Grilled Cheese Sandwiches
--------------------------------------------------
Mining Model: BGE_BASE_EN_V1_5
Search Expression: yummy dessert
1-Raspberry Tarts
2-Strawberry Pie
3-Oatmeal Cookies
--------------------------------------------------
Mining Model: BGE_MICRO_V2
Search Expression: yummy dessert
1-Raspberry Tarts
2-Strawberry Pie
3-Grilled Cheese Sandwiches
--------------------------------------------------
Mining Model: BGE_SMALL_EN_V1_5
Search Expression: yummy dessert
1-Strawberry Pie
2-Oatmeal Cookies
3-Raspberry Tarts
--------------------------------------------------
Mining Model: CLINICAL_BERT
Search Expression: yummy dessert
1-Miso Soup
2-Strawberry Pie
3-Raspberry Tarts
--------------------------------------------------
Mining Model: DISTILUSE_BASE_MULTILINGUAL_CASED_V2
Search Expression: yummy dessert
1-Strawberry Pie
2-Raspberry Tarts
3-Grilled Cheese Sandwiches
--------------------------------------------------
Mining Model: E5_BASE_V2
Search Expression: yummy dessert
1-Raspberry Tarts
2-Strawberry Pie
3-Grilled Cheese Sandwiches
--------------------------------------------------
Mining Model: E5_SMALL_V2
Search Expression: yummy dessert
1-Raspberry Tarts
2-Strawberry Pie
3-Grilled Cheese Sandwiches
--------------------------------------------------
Mining Model: FINBERT
Search Expression: yummy dessert
1-Grilled Cheese Sandwiches
2-Raspberry Tarts
3-Strawberry Pie
--------------------------------------------------
Mining Model: GTE_BASE
Search Expression: yummy dessert
1-Strawberry Pie
2-Raspberry Tarts
3-Oatmeal Cookies
--------------------------------------------------
Mining Model: GTE_SMALL
Search Expression: yummy dessert
1-Strawberry Pie
2-Oatmeal Cookies
3-Raspberry Tarts
--------------------------------------------------
Mining Model: GTE_TINY
Search Expression: yummy dessert
1-Strawberry Pie
2-Raspberry Tarts
3-Oatmeal Cookies
--------------------------------------------------
Mining Model: MULTILINGUAL_E5_SMALL
Search Expression: yummy dessert
1-Grilled Cheese Sandwiches
2-Strawberry Pie
3-Raspberry Tarts
--------------------------------------------------
Mining Model: MULTI_QA_MINILM_L6_COS_V1
Search Expression: yummy dessert
1-Strawberry Pie
2-Grilled Cheese Sandwiches
3-Raspberry Tarts
--------------------------------------------------
Mining Model: STELLA_BASE_EN_V2
Search Expression: yummy dessert
1-Strawberry Pie
2-Oatmeal Cookies
3-Grilled Cheese Sandwiches


PL/SQL procedure successfully completed.

*/
