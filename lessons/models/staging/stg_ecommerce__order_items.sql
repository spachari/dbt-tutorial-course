WITH source AS (
        SELECT *

        FROM {{ source('thelook_ecommerce', 'order_items') }}
)

SELECT
        id AS order_item_id,
        order_id,
        cast(user_id as string) user_id,
        product_id,
        inventory_item_id,
        sale_price as item_sale_price

        {# 
            ignored columns
                    status,
                    created_at,
                    shipped_at,
                    delivered_at,
                    returned_at,
        #}
FROM source
