
/*
    Welcome to your first dbt model!
    This is a simple example model for BigQuery.
    
    This model demonstrates:
    - Basic dbt configuration
    - BigQuery-compatible SQL syntax
    - Data quality testing
*/

{{ config(
    materialized='table',
    partition_by={
        "field": "created_at",
        "data_type": "timestamp",
        "granularity": "day"
    },
    cluster_by=["id"]
) }}

with source_data as (
    select 
        1 as id,
        'Alice' as name,
        'alice@example.com' as email,
        current_timestamp() as created_at
    union all
    select 
        2 as id,
        'Bob' as name,
        'bob@example.com' as email,
        current_timestamp() as created_at
    union all
    select 
        3 as id,
        'Charlie' as name,
        'charlie@example.com' as email,
        current_timestamp() as created_at
)

select 
    id,
    name,
    email,
    created_at,
    -- Add some derived fields
    upper(name) as name_upper,
    split(email, '@')[offset(0)] as email_username,
    extract(year from created_at) as created_year
from source_data
where id is not null
