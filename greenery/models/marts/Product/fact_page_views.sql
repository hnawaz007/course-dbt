{{
  config(
    materialized='table'
  )
}}

SELECT
  e.session_id,
  e.order_id,
  --e.page_url,
  session_start,
  session_end,
  session_length,
  page_view_total,
  add_to_cart_total,
  checkout_total,
  package_shipped_total,
  CONCAT(u.first_name , ' ' ,  last_name) as user_name,
  p.product_name
FROM {{ ref('int_session_agg') }} e
LEFT JOIN {{ ref('stg_users') }} u 
  ON u.user_id = e.user_id
LEFT JOIN {{ ref('stg_products') }} p
  ON p.product_id = e.product_id