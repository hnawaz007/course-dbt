{{
  config(
    materialized='table'
  )
}}

SELECT
promo_id,
discount,
status
 
FROM {{ source('src_postgres', 'promos') }}