{{ config(materialized='table') }}

select
    id as inventory_item_id,
    product_id,
    cast(created_at as timestamp) as created_at,
    cast(sold_at as timestamp) as sold_at,
    cast(cost as numeric) as cost,
    product_category,
    product_name,
    product_brand,
    cast(product_retail_price as numeric) as product_retail_price,
    product_department,
    product_sku,
    product_distribution_center_id as distribution_center_id
from {{ ref('inventory_items') }}
