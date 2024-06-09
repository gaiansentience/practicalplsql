declare
    l_row_differences boolean := true;
    l_whats_next varchar2(100);
    l_try_json boolean := true;
    function show_column_differences(p_use_json in boolean)
    return varchar2
    is
    begin
        return case p_use_json
                when true then 'try dynamic unpivot'
                else 'struggle to find dynamic solution'
            end;
    end show_column_differences;
begin
    if l_row_differences then
        l_whats_next := show_column_differences(l_try_json);
        dbms_output.put_line(l_whats_next);
    end if;
end;
/