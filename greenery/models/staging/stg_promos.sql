{{
  config(
    materialized='table'
  )
}}

SELECT
promo_id,
discount,
status as promo_status
 
FROM {{ source('src_postgres', 'promos') }}