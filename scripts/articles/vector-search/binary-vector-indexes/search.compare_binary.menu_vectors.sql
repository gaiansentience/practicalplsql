--search.compare_binary.menu_vectors.sql
set serveroutput on;

declare
    type t_list is table of varchar2(100);
    l_searches t_list;      
    l_columns t_list;
    l_metrics t_list;
begin
    l_searches := t_list(
        'a decadent dessert would be tasty'
        , 'what kinds of healthy lunch options are there?'
        );
        
    l_columns := t_list('embedding', 'embedding1');
    l_metrics := t_list('cosine','euclidean','manhattan');
    
    <<searches>>
    for s in values of l_searches loop
    
        <<models>>
        for c in values of l_columns loop
        
            <<float_metrics>>
            for m in values of l_metrics loop
                search_compare_menu_vectors(s, 3, m, c, p_use_binary => false);
            end loop float_metrics;
            
            search_compare_menu_vectors(s, 3, 'hamming', c, p_use_binary => true);
            search_compare_menu_vectors(s, 3, 'jaccard', c, p_use_binary => true);  
            
        end loop models;
    
    end loop searches;
    
end;
/

