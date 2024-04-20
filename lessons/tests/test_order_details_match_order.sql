/*
    Checks that, for any order, that the number of line items in the order_items table
	matches the num_items_ordered column in the orders table.

    Returns all of the rows where we don't get a match

    We could run multiple checks here (e.g. check only 1 user_id per order, or that the shipped_at timestamps
	are all the same for a given order), but this is just an example of a custom test.
*/
{{ config(severity = 'warn' )}}
with order_item_counts as (
  select order_id, count(*) as order_line_count
  from {{ ref("stg_ecommerce__order_items")}}
  group by 1
)
select 
    orders.order_id,
    orders.num_items_ordered,
    order_item_counts.order_line_count

 from {{ ref("stg_ecommerce__orders") }} orders
full outer join order_item_counts on
  orders.order_id = order_item_counts.order_id
where 
orders.order_id is NULL
or order_item_counts.order_id is NULL
or order_item_counts.order_line_count != orders.num_items_ordered