{{
  config(
    materialized='table'
  )
}}


{%- set event_types =  dbt_utils.get_column_values(
    table=ref('stg_events'),
    column='event_type'
) -%}

select
    e.session_id,
    e.user_id,
    product_id,
    e.order_id,
    min(e.created_at) as session_start,
    max(e.created_at) as session_end,
    age(max(e.created_at),min(e.created_at)) as session_length,
    {%- for event_type in event_types %}
    sum(case when e.event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}_total
    {%- if not loop.last %},{% endif -%}
    {% endfor %}
from {{ ref('stg_events') }} e
group by 
    e.session_id ,
    e.user_id ,
    product_id,
     e.order_id