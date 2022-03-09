{{
  config(
    materialized='table'
  )
}}

SELECT
order_id,
product_id,
quantity
 
FROM {{ source('src_postgres', 'order_items') }}