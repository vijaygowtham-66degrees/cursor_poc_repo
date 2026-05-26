{{ config(materialized='table') }}

select
    id as order_item_id,
    order_id,
    user_id as customer_id,
    product_id,
    inventory_item_id,
    status,
    cast(created_at as timestamp) as created_at,
    cast(shipped_at as timestamp) as shipped_at,
    cast(delivered_at as timestamp) as delivered_at,
    cast(returned_at as timestamp) as returned_at,
    cast(sale_price as numeric) as sale_price
from {{ ref('order_items') }}
