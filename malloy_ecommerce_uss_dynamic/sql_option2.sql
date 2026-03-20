SELECT 
   COALESCE((users_0.`id`),order_items_0.`user_id`,events_0.`user_id`) as `_key_users`,
   count(distinct order_items_0.`order_id`) as `order_count`,
   COALESCE(CAST(((
      SUM(DISTINCT ROUND(CAST(COALESCE(order_items_0.`sale_price`, 0) AS NUMERIC)*1, 9) + (cast(cast(concat('0x', substr(to_hex(md5(CAST((order_items_0.`id`) AS STRING))), 1, 15)) as int64) as numeric) * 4294967296 + cast(cast(concat('0x', substr(to_hex(md5(CAST((order_items_0.`id`) AS STRING))), 16, 8)) as int64) as numeric)) * 0.000000001)
      - SUM(DISTINCT (cast(cast(concat('0x', substr(to_hex(md5(CAST((order_items_0.`id`) AS STRING))), 1, 15)) as int64) as numeric) * 4294967296 + cast(cast(concat('0x', substr(to_hex(md5(CAST((order_items_0.`id`) AS STRING))), 16, 8)) as int64) as numeric)) * 0.000000001)
    )/1) AS FLOAT64),0) as `total_revenue`
FROM (
  SELECT 'order_items'          AS stage
  UNION ALL
  SELECT 'users'                AS stage
  UNION ALL
  SELECT 'inventory_items'      AS stage
  UNION ALL
  SELECT 'products'             AS stage
  UNION ALL
  SELECT 'distribution_centers' AS stage
  UNION ALL
  SELECT 'events'               AS stage
  UNION ALL
  SELECT 'session_facts'        AS stage 
  UNION ALL
  SELECT 'event_session_funnel' AS stage 
) as base
 LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS order_items_0
  ON base.`stage`='order_items'
 LEFT JOIN `bigquery-public-data.thelook_ecommerce.users` AS users_0
  ON base.`stage`='users'
 LEFT JOIN `bigquery-public-data.thelook_ecommerce.events` AS events_0
  ON base.`stage`='events'
GROUP BY 1
ORDER BY 2 desc NULLS LAST