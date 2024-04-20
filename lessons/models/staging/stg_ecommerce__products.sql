{{ config(tags=["my_tag", "my_other_tag"]) }}

WITH source AS (
        SELECT *

        FROM {{ source('thelook_ecommerce', 'products') }}
)

SELECT
        id AS product_id,
        
        {# other columns #}
        cost,
        retail_price,
        department

FROM source