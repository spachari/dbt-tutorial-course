{% set all_columns = adapter.get_columns_in_relation(ref('orders')) %}

{% set output_list = [] %}
SELECT
{%- for col in all_columns %}
    {%- if col.name.startswith('total') %}
        {{ col.name.upper() }}{% if not loop.last %},{% endif %}
        {{ output_list.append(col.name.upper()) }}
    {%- endif %}
{%- endfor %}
{{ ref('orders')}}

{{output_list}}

{# get all values from a column in a table. table should be loaded #}
{% set values = dbt_utils.get_column_values(
    ref('orders'), 'order_status') 
%}

{{ values }}