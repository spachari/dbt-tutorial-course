{% set my_list = ['user_id', 'created_at'] %}
select
{%- for column in my_list %}
{{ column }}{% if not loop.last %},{% endif %}
{%- endfor %}