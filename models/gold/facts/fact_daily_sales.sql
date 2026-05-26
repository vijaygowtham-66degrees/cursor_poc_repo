{{ config(materialized='table') }}

with daily_sales as (
    select
        date(oi.created_at) as sale_date,
        oi.product_id,
        p.category as product_category,
        p.brand as product_brand,
        p.department as product_department,
        p.distribution_center_id,
        dc.name as distribution_center_name,
        oi.status as order_status,
        count(distinct oi.order_id) as total_orders,
        count(oi.order_item_id) as total_order_items,
        count(distinct oi.customer_id) as unique_customers,
        sum(oi.sale_price) as total_revenue,
        avg(oi.sale_price) as avg_order_value,
        sum(oi.sale_price) / count(distinct oi.order_id) as revenue_per_order
    from {{ ref('stg_order_items') }} oi
    left join {{ ref('stg_products') }} p on oi.product_id = p.product_id
    left join {{ ref('stg_distribution_centers') }} dc on p.distribution_center_id = dc.distribution_center_id
    where oi.created_at is not null
    group by 1, 2, 3, 4, 5, 6, 7, 8
)

select
    sale_date,
    product_id,
    product_category,
    product_brand,
    product_department,
    distribution_center_id,
    distribution_center_name,
    order_status,
    total_orders,
    total_order_items,
    unique_customers,
    total_revenue,
    avg_order_value,
    revenue_per_order,
    current_timestamp() as created_at
from daily_sales
order by sale_date desc, total_revenue desc
