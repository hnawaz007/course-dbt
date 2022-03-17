{{
  config(
    materialized='table'
  )
}}

SELECT
    address_id
    , address
    , LPAD(zipcode::text, 5, '0') AS zipcode
    , state
    , country
 
FROM {{ source('src_postgres', 'addresses') }}