WITH source AS (
        SELECT *

        FROM {{ source('thelook_ecommerce', 'products') }}
)

SELECT
        id AS product_id,
        
        {# other columns #}
        cost,
        retail_price,
        department,

        brand

FROM source