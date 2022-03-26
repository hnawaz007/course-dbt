{{
  config(
    materialized='table'
  )
}}


SELECT
      e.session_id
    , e.user_id
    , COALESCE(e.product_id, oi.product_id) AS product_id
    , p.product_name
    , p.price
    , p.inventory
    , {{has_col_vals(ref('stg_events'),'event_type')}}
FROM {{ ref('stg_events') }} e
LEFT JOIN {{ ref('stg_order_items') }} oi
    ON e.order_id = oi.order_id
LEFT JOIN {{ ref('stg_products') }} p
    ON COALESCE(e.product_id, oi.product_id) = p.product_id
{{ dbt_utils.group_by(n=6) }}