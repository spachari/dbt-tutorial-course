with order_item_measures as (
    select
    order_id,
		SUM(item_sale_price) AS total_sale_price,
		SUM(product_cost) AS total_product_cost,
		SUM(item_profit) AS total_profit,
		SUM(item_discount) AS total_discount,
		
		{# {%- set departments = ['Men', 'Women'] %} #}
		{%- set departments = dbt_utils.get_column_values(table=ref("int_ecommerce__order_items_products"), column = 'product_department') -%}
		{%- for department in departments %}
		SUM(if(product_department = '{{ department }}', item_sale_price, 0)) as total_sale_price_{{ department.lower() }}s_wear{{"," if not loop.last }}
		{%- endfor %}
    from {{ ref("int_ecommerce__order_items_products") }}
    group by 1
)

select 
    --Dimensions from our orders table
    orders.order_id,
    orders.created_at AS order_created_at,
	{{ is_weekend('orders.created_at') }} as order_was_created_on_weekend,
	orders.shipped_at AS order_shipped_at,
	{{ is_weekend('orders.shipped_at') }} as order_was_shipped_on_weekend,
	orders.delivered_at AS order_delivered_at,
	orders.returned_at AS order_returned_at,
	orders.status AS order_status,
	orders.num_items_ordered,

    {# data on order level #}
    om.total_sale_price,
	om.total_product_cost,
	om.total_profit,
	om.total_discount,

	{%- for department in departments %}
	total_sale_price_{{ department.lower() }}s_wear,
	{%- endfor %}
	TIMESTAMP_DIFF(orders.created_at, user_data.first_order_created_at, DAY) as days_since_first_order
    
from {{ ref("stg_ecommerce__orders") }} as orders
left join order_item_measures om
on orders.order_id = om.order_id
left join {{ ref("int_ecommerce__first_order_created")}} as user_data
on user_data.user_id = orders.user_id