{{
  config(
    materialized='table'
  )
}}

SELECT
  p.product_id,
  p.product_name,
  p.price,
  p.inventory
FROM {{ ref('stg_products') }} p