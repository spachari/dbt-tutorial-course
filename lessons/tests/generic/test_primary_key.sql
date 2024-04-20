{#
	This test is basically a "not_null" and "unique"
	rolled into one.

	It fails if a column is NULL or occurs more than once
#}


{% test primary_key(model, column_name) %}

With validation as (
    select {{ column_name }} as primary_key,
    count(*) as occurances
    from {{model}}
    group by 1
)

select * from validation 
where 
primary_key is null
or occurances > 1

{% endtest %}