{{
  config(
    materialized='table'
  )
}}
select
    promo_id,
    discount,
    status as promo_status
from {{ source('postgres', 'promos') }}