## WEEK 1 - Questions & Answers

### 1 - How many users do we have?
**_Answer: We have **130** unique users in our system._**

SQL Query:
``` sql
select 
  count(distinct user_id)
from stg_users
```

### 2 - On average, how many orders do we receive per hour?
Answer: We receive **7** orders per hour.

SQL Query:
``` sql
with avg_order_per_hr as (
    SELECT 
        date_trunc('hour', created_at) as created_hour,
        count(distinct order_id) as order_count
 FROM stg_orders
  GROUP BY
    date_trunc('hour', created_at)
)

select 
    avg(order_count) as avg_order_count
from avg_order_per_hr
```

## 3 - On average, how long does an order take from being placed to being delivered?
Answer: The average duration for order completion is **3 days, 21 hours and 24 minutes**

SQL Query:
``` sql
with avg_delivery_time as (
    SELECT 
    order_id as order_id,
    created_at  as created_at,
    delivered_at  as delivered_at
 FROM stg_orders
 where status = 'delivered'
)

select 
    avg(delivered_at - created_at) as difference_btwn
from avg_delivery_time
```

### 4 - How many users have only made one purchase? Two purchases? Three+ purchases?
Answer: We have **25** users who made only one purchase. **28** users made two purchases while **71** users made three or more purchases.
| # purchases     | # users |
|-----------------|---------|
|            1    |       25|
|            2    |       28|
|           3 plus|       71|

SQL Query:
``` sql

with orders_by_user as
(
  select
    user_id,
    count(distinct order_id) as orders
  from stg_orders
  group by 
    user_id
)

select
  case 
    when orders = 1 then '1'
    when orders = 2 then '2'
    when orders >= 3 then '3'
  end as orders,
  count(distinct user_id)
from orders_by_user
group by 
  case 
    when orders = 1 then '1'
    when orders = 2 then '2'
    when orders >= 3 then '3'
  end
```

### 5 - On average, how many unique sessions do we have per hour?
Answer: We have **16** unique sessions per hour.

SQL Query:
``` sql
with avg_session_count as (
    SELECT 
        count(distinct session_id) as session_count,
        date_trunc('hour', created_at) as created_hr
 FROM stg_events
  GROUP BY
    date_trunc('hour', created_at)
)

select 
    avg(session_count) session_avg
from avg_session_count
where session_count > 0
```
