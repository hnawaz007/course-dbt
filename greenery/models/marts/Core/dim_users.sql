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
  u.address,
  u.zipcode,
  u.state,
  u.country
FROM {{ ref('int_users') }} u