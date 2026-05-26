{{ config(materialized='table') }}

with monthly_revenue as (
    select
        extract(year from cast(oi.created_at as date)) as year,
        extract(month from cast(oi.created_at as date)) as month,
        date_trunc(cast(oi.created_at as date), month) as month_start_date,
        p.category as product_category,
        p.distribution_center_id,
        dc.name as distribution_center_name,
        o.status as order_status,
        count(distinct oi.order_id) as total_orders,
        count(oi.order_item_id) as total_order_items,
        count(distinct oi.customer_id) as unique_customers,
        sum(oi.sale_price) as total_revenue,
        avg(oi.sale_price) as avg_order_value,
        sum(oi.sale_price) / count(distinct oi.order_id) as revenue_per_order,
        sum(oi.sale_price) / count(distinct oi.customer_id) as revenue_per_customer
    from {{ ref('stg_order_items') }} oi
    left join {{ ref('stg_orders') }} o on oi.order_id = o.order_id
    left join {{ ref('stg_products') }} p on oi.product_id = p.product_id
    left join {{ ref('stg_distribution_centers') }} dc on p.distribution_center_id = dc.distribution_center_id
    where oi.created_at is not null
    group by 1, 2, 3, 4, 5, 6, 7
)

select
    year,
    month,
    month_start_date,
    product_category,
    distribution_center_id,
    distribution_center_name,
    order_status,
    total_orders,
    total_order_items,
    unique_customers,
    total_revenue,
    avg_order_value,
    revenue_per_order,
    revenue_per_customer,
    current_timestamp() as created_at
from monthly_revenue
order by year desc, month desc, total_revenue desc