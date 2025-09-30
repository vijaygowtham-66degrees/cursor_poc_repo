
-- Use the `ref` function to select from other models
-- This model demonstrates model dependencies and aggregations

{{ config(materialized='view') }}

select 
    created_year,
    count(*) as total_users,
    count(distinct email_username) as unique_usernames,
    min(created_at) as first_created,
    max(created_at) as last_created,
    -- BigQuery-specific functions
    array_agg(name order by created_at) as names_by_creation,
    string_agg(name, ', ' order by name) as all_names
from {{ ref('my_first_dbt_model') }}
group by created_year
order by created_year
