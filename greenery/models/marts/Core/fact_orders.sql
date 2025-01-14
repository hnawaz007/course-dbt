{{
  config(
    materialized='table'
  )
}}

SELECT
  o.order_id,
  o.user_id,
  o.order_placed_at,
  o.order_cost,
  o.order_total,
  o.shipping_cost,
  COALESCE(o.shipping_service, 'NA') as shipping_service,
  COALESCE(pc.promo_id, 'NA')  AS promo_code_name,
  COALESCE(pc.discount, 0) AS promo_code_discount,
  COALESCE(pc.promo_status, 'NA') AS promo_status,
  COALESCE(o.order_status, 'NA') AS order_status,
  COALESCE(EXTRACT(DAY FROM delivered_at - o.order_placed_at ),0) AS DateDifference
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_promos') }} pc
  ON o.promo_id = pc.promo_id