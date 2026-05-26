{{ config(materialized='table') }}

select
    id as customer_id,
    first_name,
    last_name,
    email,
    age,
    gender,
    state,
    street_address,
    postal_code,
    city,
    country,
    latitude,
    longitude,
    traffic_source,
    cast(created_at as timestamp) as created_at
from {{ ref('users') }}
