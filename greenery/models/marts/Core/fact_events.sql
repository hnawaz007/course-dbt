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
  e.created_at as page_viewed_at
FROM {{ ref('stg_events') }} e
  
