## WEEK 1 - Questions & Answers

## Part 1: Models

## 1 - What is our user repeat rate?
Answer: Our user repeat rate is **79.84** percent. 

SQL Query:
``` with orders_by_user as
(
  select
    user_id,
    count(distinct order_id) as orders
  from fact_orders
  group by 
    user_id
)
,

repeat_v_total_orders as (
select
    sum(case 
        when orders > 1 then 1
        end) as repeat_purchase,
    sum(case 
            when orders > 0 then 1
        end) as total_orders
from orders_by_user
)

Select ROUND((repeat_purchase/total_orders::numeric)* 100 , 2) as repeat_rate
from repeat_v_total_orders
```

## 2 (A) - What are good indicators of a user who will likely purchase again? 
Answer: It appears based on the preliminary analysis that the customers who had higher promotion discount value and lower delivery period are likely to purchase again.

SQL Query for indicators:
``` sql
with sort_orders_by_create_dt AS (
SELECT
         orders.user_id
        ,orders.order_id
        ,orders.order_placed_at
        ,orders.datedifference as days_to_deliver
        , case when orders.promo_code_name = 'NA'
                then 0
                else 1
                end AS has_promo_code
        , orders.order_total
        , COUNT(orders.order_id) OVER (PARTITION BY orders.user_id) > 1 AS is_repeat_purchaser
        , ROW_NUMBER() OVER (PARTITION BY orders.user_id ORDER BY orders.order_placed_at) AS sorted_order
    FROM fact_orders AS orders
)

--putting it all together
SELECT 
    case when is_repeat_purchaser = true
         then 'Yes'
         else 'No'
         end as is_repeat_customer
  , ROUND(AVG(order_total)::numeric, 2) AS avg_first_order_total
  , ROUND(AVG(has_promo_code::integer) * 100, 2)  AS avg_first_promo_discount
  , ROUND(AVG(days_to_deliver::integer),2) as days_to_deliver
  FROM sort_orders_by_create_dt od
  WHERE sorted_order = 1
  GROUP BY is_repeat_purchaser
```

**Results:**
| is_repeat_customer | avg_first_order_total | avg_first_promo_discount | days_to_deliver |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| No | 274.48 | 4.00 |  3.64 |
| Yes | 232.91 | 13.13 | 3.31 |

---

## 2(B) - What about indicators of users who are likely NOT to purchase again?
Answer: Customers who had low or no promotional discount and higher delivery period are not likely to purchase again.

## 2(C) - : If you had more data, what features would you want to look into to answer this question?
Answer: I would like to hear and inspect the customer satisfaction index survey data. How happy were the customers with the initial purchase and delivery? 
What category of products they purchased in initial order? 
Where are users located and what kind of plants thrive in that area. What kind of plants user ordered from greenery? What kind of plants they already own?
Depending on the climate and plants that grow in the area and the time of year purchased. We can devise a marketing campaign to covert one-time purchasers to repeat customers.

## 3 - Explain the marts models you added. Why did you organize the models in the way you did?
Answer: I have added two dimensions products and users in the core directory under marts. I did denormalize the user's dimension by combining uses and the addresses models.  Product is the replica of staging model. 
Also, I have included two facts models events and orders. Then I utilize these base facts to create marking, user order facts, and product, fact page views, models. I did include some dimensional attributes in the facts but if we need attributes, we can easily join to our dimension in the core to make them available analysis.

## 4 - What assumptions did you make about each model?
Answer: I have made the following assumptions about the models:

All user’s data resides in the user’s model. Each row in the user’s model represents a unique user.
All products are in the products model. Product id uniquely identifies each product.
All promos details and orders are in the order's model. Order id uniquely identifies each order.
User's addresses are in the user’s model. 
ZipCode should always be 5 digits long
User's email should conform to a pattern that contains @. *
Shipping and tracking_ids are not blank when the order status is 'shipped' or 'delivered'
Order_id should not be null in events of type 'checkout' or 'package_shipped'
Product_id should not be null in events of type 'add_to_cart' or 'page_view'
Primary keys are unique for each model and they are never null.

## 5 - Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
Answer: In the greenery dataset I have not encounter bad data per the test defined in the models. 

## 5 - Your stakeholders at Greenery want to understand the state of the data each day. 
##     Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
Answer: Based on test rules I would configure warnings and failures. These would trigger notifications either email or slack channel alerts to notify the stakeholder of the state of the data.