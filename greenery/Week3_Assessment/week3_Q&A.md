## WEEK 3 - Questions & Answers

## Part 1: Create new model(s) to answer the first two questions

## 1 - What is our overall conversion rate?
**Answer**: Our overall conversion rate is **62.46** percent. 

SQL Query:
``` SELECT
  ROUND(COUNT(DISTINCT CASE 
                  WHEN is_checkout = 1
                  THEN session_id
                  ELSE NULL
                  END)::numeric / COUNT(DISTINCT session_id) * 100, 2) AS conversion_rate
FROM fact_products
```

## 2 - What is our conversion rate by product? 
**Answer**: The following table displays the conversion rate of each product.

SQL Query for product conversion:
``` sql
SELECT
  product_name,
  ROUND(COUNT(DISTINCT CASE 
                  WHEN is_checkout = 1
                  THEN session_id
                  ELSE NULL
                  END)::numeric / COUNT(DISTINCT session_id) * 100, 2) AS product_conversion_rate
FROM fact_products
GROUP BY 1
ORDER BY 2 DESC

```

**Results:**
| product_name | product_conversion_rate |
| ------------------ | ----------| 
| String of pearls | 60.94 | 
| Arrow Head | 55.56 | 
| Cactus | 54.55 | 
| ZZ Plant | 53.97 | 
| Bamboo | 53.73 | 
| Rubber Plant | 51.85 | 
| Monstera | 51.02 | 
| Calathea Makoyana | 50.94 | 
| Fiddle Leaf Fig | 50 | 
| Majesty Palm | 49.25 | 
| Aloe Vera | 49.23 | 
| Devil's Ivy | 48.89 | 
| Philodendron | 48.39 | 
| Jade Plant | 47.83 | 
| Spider Plant | 47.46 | 
| Pilea Peperomioides | 47.46 | 
| Dragon Tree | 46.77 | 
| Money Tree | 46.43 | 
| Orchid | 45.33 | 
| Bird of Paradise | 45 | 
| Ficus | 42.65 | 
| Birds Nest Fern | 42.31 | 
| Pink Anthurium | 41.89 | 
| Boston Fern | 41.27 | 
| Alocasia Polly | 41.18 | 
| Peace Lily | 40.91 | 
| Ponytail Palm | 40 | 
| Snake Plant | 39.73 | 
| Angel Wings Begonia | 39.34 | 
| Pothos | 34.43 | 

---

## 3 - Why might certain products be converting at higher/lower rates than others? Note: we don't actually have data to properly dig into this, but we can make some hypotheses.
**Answer**: The higher conversion rate can be due to several factors including our prices, discount, and the fact that plant does well in the region. 


## Part 2: Create a macro to simplify part of the model. 
**Answer**: I have created the recommended macro to aggregate the event types per session. It is applied to `int_session_agg` intermediate model.


## Part 3: Add a post hook to your project to apply grants to the role “reporting”.
**Answer**: I have added the post hook `dbt_project.yml` file. It is after greenery's model tag.

## Part 4 - Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project
**Answer**: I have used `used dbt.utils` pacakge and form it used `get_column_values` to set values of `event_type` list.
 I have used the following macro to clean up the case statement to build event type metrics.

	``` 	{%- for event_type in event_types %}
            sum(case when e.event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}_total
            {%- if not loop.last %},{% endif -%}
            {% endfor %}
	```
Also, used `dbt_utils.unique_combination_of_columns` function to check if  `combination_of_columns` ( order_id and product_id) are unique in stg_order_items table.

## Part 5 - Show (using dbt docs and the model DAGs) how you have simplified or improved a DAG using macros and/or dbt packages.
**Answer**: See the image `model_dag_week3.png' in this directory for the updated DAG.
