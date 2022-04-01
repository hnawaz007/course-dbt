SELECT 
e.session_id,
e.user_id,
e.product_id,
e.order_id,
CONCAT(u.first_name , ' ' ,  last_name) as user_name,
p.product_name
session_start,
session_end,
session_length,
case when page_view_total = 1 Or add_to_cart_total = 1 or checkout_total = 1
     then 1
     else NULL
     end as total_sessions_fnl,
case when add_to_cart_total = 1 or checkout_total = 1
     then 1
     else NULL
     end as total_sessions_cart_to_checkout_fnl,
case when checkout_total = 1
     then 1
     else NULL
     end as total_sessions_checkout_fnl
FROM {{ ref('int_session_agg') }} e
LEFT JOIN {{ ref('stg_users') }} u 
  ON u.user_id = e.user_id
LEFT JOIN {{ ref('stg_products') }} p
  ON p.product_id = e.product_id