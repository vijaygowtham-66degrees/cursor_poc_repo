{{ config(materialized='view') }}

select * from {{ source('thelook_ecommerce', 'users') }}










