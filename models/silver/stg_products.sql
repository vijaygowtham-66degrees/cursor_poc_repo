{{ config(materialized='table') }}

select
    id as product_id,
    cast(cost as numeric) as cost,
    category,
    name,
    brand,
    cast(retail_price as numeric) as retail_price,
    department,
    sku,
    distribution_center_id
from {{ ref('products') }}
