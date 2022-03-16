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
  e.created_at as page_viewed_at,
  CONCAT(u.first_name , ' ' ,  last_name) as user_name,
  p.name as product_name
FROM {{ ref('stg_events') }} e
LEFT JOIN {{ ref('stg_users') }} u 
  ON u.user_id = e.user_id
LEFT JOIN {{ ref('stg_products') }} p
  ON p.product_id = e.product_id