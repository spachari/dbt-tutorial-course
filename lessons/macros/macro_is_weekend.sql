{%- macro is_weekend(column_name) -%}
    EXTRACT(DAYOFWEEK FROM DATE({{column_name}})) in (1, 7)
{%- endmacro -%}