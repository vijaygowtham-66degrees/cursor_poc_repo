{{ config(materialized='table') }}

with customer_metrics as (
    select
        u.customer_id,
        u.first_name,
        u.last_name,
        u.email,
        u.state,
        u.country,
        u.gender,
        u.age,
        u.traffic_source,
        min(cast(o.created_at as date)) as first_order_date,
        max(cast(o.created_at as date)) as last_order_date,
        count(distinct o.order_id) as total_orders,
        count(oi.order_item_id) as total_items_purchased,
        sum(oi.sale_price) as total_spent,
        avg(oi.sale_price) as avg_order_value,
        count(distinct date(cast(o.created_at as date))) as active_days,
        count(distinct oi.product_id) as unique_products_purchased,
        count(distinct p.category) as unique_categories_purchased,
        case 
            when count(distinct o.order_id) = 1 then 'New Customer'
            when count(distinct o.order_id) between 2 and 5 then 'Regular Customer'
            when count(distinct o.order_id) between 6 and 10 then 'Frequent Customer'
            else 'VIP Customer'
        end as customer_segment,
        case 
            when sum(oi.sale_price) < 100 then 'Low Value'
            when sum(oi.sale_price) between 100 and 500 then 'Medium Value'
            when sum(oi.sale_price) between 500 and 1000 then 'High Value'
            else 'Premium Value'
        end as value_segment
    from {{ ref('stg_users') }} u
    left join {{ ref('stg_orders') }} o on u.customer_id = o.customer_id
    left join {{ ref('stg_order_items') }} oi on o.order_id = oi.order_id
    left join {{ ref('stg_products') }} p on oi.product_id = p.product_id
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9
)

select
    customer_id,
    first_name,
    last_name,
    email,
    state,
    country,
    gender,
    age,
    traffic_source,
    first_order_date,
    last_order_date,
    total_orders,
    total_items_purchased,
    total_spent,
    avg_order_value,
    active_days,
    unique_products_purchased,
    unique_categories_purchased,
    customer_segment,
    value_segment,
    current_timestamp() as created_at
from customer_metrics
order by total_spent desc
