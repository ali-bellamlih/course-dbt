{{
  config(
    materialized='table'
  )
}}

SELECT 
    address_id,
    address,
    country,
    state,
    zipcode
FROM {{ source('postgres', 'addresses') }}