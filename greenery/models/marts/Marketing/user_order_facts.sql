{{
  config(
    materialized='table'
  )
}}

SELECT
  u.user_id,
  u.email,
  u.first_name,
  u.last_name,
  u.created_at,
  TO_DATE(u.created_at::TEXT,'YYYY-MM-DD')  AS registered_date,
  ua.address,
  ua.zipcode,
  ua.state,
  ua.country,
  SUM(o.order_cost) AS order_cost,
  SUM(o.order_total) AS order_total
FROM {{ ref('stg_users') }} u
LEFT JOIN {{ ref('stg_addresses') }} ua
  ON u.address_id = ua.address_id
LEFT JOIN {{ ref('stg_orders') }} o
  ON o.user_id = u.user_id
Where order_total > 0
GROUP BY
  u.user_id,
  u.email,
  u.first_name,
  u.last_name,
  u.created_at,
  TO_DATE(u.created_at::TEXT,'YYYY-MM-DD')  ,
  ua.address,
  ua.zipcode,
  ua.state,
  ua.country