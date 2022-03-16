{{
  config(
    materialized='table'
  )
}}

SELECT
  e.event_id,
  e.session_id,
  e.user_id,
  e.product_id,
  e.order_id,
  e.event_type,
  e.page_url,
  e.page_viewed_at,
  CONCAT(u.first_name , ' ' ,  last_name) as user_name,
  p.product_name
FROM {{ ref('fact_events') }} e
LEFT JOIN {{ ref('dim_users') }} u 
  ON u.user_id = e.user_id
LEFT JOIN {{ ref('dim_products') }} p
  ON p.product_id = e.product_id