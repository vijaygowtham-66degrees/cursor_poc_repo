{{ config(materialized='table') }}

select
    id as distribution_center_id,
    name,
    latitude,
    longitude
from {{ ref('distribution_centers') }}










