selecting an ordered value from the current window


lag|lead(expr, 1, null_repl) [?ignore nulls] over (order by columns range|rows)
first_value|last_value(column) [ignore nulls] over (order by column range|rows)
nth_value(column, 3) from LAST|FIRST [ignore nulls] over (order by column range|rows)

