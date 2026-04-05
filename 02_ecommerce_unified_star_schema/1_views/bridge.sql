CREATE OR REPLACE TABLE `PROJECT.DATASET.bridge_ecommerce` AS
SELECT 
   base.`stage` as `stage`,
   base.`_pbk_order_items` as `_pbk_order_items`,
   base.`_pbk_users` as `_pbk_users`,
   base.`_pbk_inventory_items` as `_pbk_inventory_items`,
   base.`_pbk_products` as `_pbk_products`,
   base.`_pbk_distribution_centers` as `_pbk_distribution_centers`,
   base.`_pbk_events` as `_pbk_events`,
   base.`_pbk_event_session_facts` as `_pbk_event_session_facts`,
   base.`_pbk_event_session_funnel` as `_pbk_event_session_funnel`,
   base.`_pbk_orders` as `_pbk_orders`
FROM (
  SELECT * FROM (
    SELECT 
      'order_items' as `stage`,
      base.`id` as `_pbk_order_items`,
      base.`user_id` as `_pbk_users`,
      base.`inventory_item_id` as `_pbk_inventory_items`,
      base.`product_id` as `_pbk_products`,
      CAST(NULL AS FLOAT64) as `_pbk_distribution_centers`,
      CAST(NULL AS FLOAT64) as `_pbk_events`,
      CAST(NULL AS string) as `_pbk_event_session_facts`,
      CAST(NULL AS string) as `_pbk_event_session_funnel`,
      base.`order_id` as `_pbk_orders`
    FROM `bigquery-public-data.thelook_ecommerce.order_items` as base
  )
  UNION ALL
  SELECT * FROM (
    SELECT 
      'users' as `stage`,
      CAST(NULL AS FLOAT64) as `_pbk_order_items`,
      base.`id` as `_pbk_users`,
      CAST(NULL AS FLOAT64) as `_pbk_inventory_items`,
      CAST(NULL AS FLOAT64) as `_pbk_products`,
      CAST(NULL AS FLOAT64) as `_pbk_distribution_centers`,
      CAST(NULL AS FLOAT64) as `_pbk_events`,
      CAST(NULL AS string) as `_pbk_event_session_facts`,
      CAST(NULL AS string) as `_pbk_event_session_funnel`,
      CAST(NULL AS FLOAT64) as `_pbk_orders`
    FROM `bigquery-public-data.thelook_ecommerce.users` as base
  )
  UNION ALL
  SELECT * FROM (
    SELECT 
      'inventory_items' as `stage`,
      CAST(NULL AS FLOAT64) as `_pbk_order_items`,
      CAST(NULL AS FLOAT64) as `_pbk_users`,
      base.`id` as `_pbk_inventory_items`,
      base.`product_id` as `_pbk_products`,
      base.`product_distribution_center_id` as `_pbk_distribution_centers`,
      CAST(NULL AS FLOAT64) as `_pbk_events`,
      CAST(NULL AS string) as `_pbk_event_session_facts`,
      CAST(NULL AS string) as `_pbk_event_session_funnel`,
      CAST(NULL AS FLOAT64) as `_pbk_orders`
    FROM `bigquery-public-data.thelook_ecommerce.inventory_items` as base
  )
  UNION ALL
  SELECT * FROM (
    SELECT 
      'products' as `stage`,
      CAST(NULL AS FLOAT64) as `_pbk_order_items`,
      CAST(NULL AS FLOAT64) as `_pbk_users`,
      CAST(NULL AS FLOAT64) as `_pbk_inventory_items`,
      base.`id` as `_pbk_products`,
      base.`distribution_center_id` as `_pbk_distribution_centers`,
      CAST(NULL AS FLOAT64) as `_pbk_events`,
      CAST(NULL AS string) as `_pbk_event_session_facts`,
      CAST(NULL AS string) as `_pbk_event_session_funnel`,
      CAST(NULL AS FLOAT64) as `_pbk_orders`
    FROM `bigquery-public-data.thelook_ecommerce.products` as base
  )
  UNION ALL
  SELECT * FROM (
    SELECT 
      'distribution_centers' as `stage`,
      CAST(NULL AS FLOAT64) as `_pbk_order_items`,
      CAST(NULL AS FLOAT64) as `_pbk_users`,
      CAST(NULL AS FLOAT64) as `_pbk_inventory_items`,
      CAST(NULL AS FLOAT64) as `_pbk_products`,
      base.`id` as `_pbk_distribution_centers`,
      CAST(NULL AS FLOAT64) as `_pbk_events`,
      CAST(NULL AS string) as `_pbk_event_session_facts`,
      CAST(NULL AS string) as `_pbk_event_session_funnel`,
      CAST(NULL AS FLOAT64) as `_pbk_orders`
    FROM `bigquery-public-data.thelook_ecommerce.distribution_centers` as base
  )
  UNION ALL
  SELECT * FROM (
    SELECT 
      'events' as `stage`,
      CAST(NULL AS FLOAT64) as `_pbk_order_items`,
      base.`user_id` as `_pbk_users`,
      CAST(NULL AS FLOAT64) as `_pbk_inventory_items`,
      CAST(NULL AS FLOAT64) as `_pbk_products`,
      CAST(NULL AS FLOAT64) as `_pbk_distribution_centers`,
      base.`id` as `_pbk_events`,
      base.`session_id` as `_pbk_event_session_facts`,
      base.`session_id` as `_pbk_event_session_funnel`,
      CAST(NULL AS FLOAT64) as `_pbk_orders`
    FROM `bigquery-public-data.thelook_ecommerce.events` as base
  )
  UNION ALL
  SELECT * FROM (
    SELECT 
      'event_session_facts' as `stage`,
      CAST(NULL AS FLOAT64) as `_pbk_order_items`,
      CAST(NULL AS FLOAT64) as `_pbk_users`,
      CAST(NULL AS FLOAT64) as `_pbk_inventory_items`,
      CAST(NULL AS FLOAT64) as `_pbk_products`,
      CAST(NULL AS FLOAT64) as `_pbk_distribution_centers`,
      CAST(NULL AS FLOAT64) as `_pbk_events`,
      base.`session_id` as `_pbk_event_session_facts`,
      base.`session_id` as `_pbk_event_session_funnel`,
      CAST(NULL AS FLOAT64) as `_pbk_orders`
    FROM (
      SELECT session_id FROM `bigquery-public-data.thelook_ecommerce.events` GROUP BY 1
    ) as base
  )
  UNION ALL
  SELECT * FROM (
    SELECT 
      'event_session_funnel' as `stage`,
      CAST(NULL AS FLOAT64) as `_pbk_order_items`,
      CAST(NULL AS FLOAT64) as `_pbk_users`,
      CAST(NULL AS FLOAT64) as `_pbk_inventory_items`,
      CAST(NULL AS FLOAT64) as `_pbk_products`,
      CAST(NULL AS FLOAT64) as `_pbk_distribution_centers`,
      CAST(NULL AS FLOAT64) as `_pbk_events`,
      base.`session_id` as `_pbk_event_session_facts`,
      base.`session_id` as `_pbk_event_session_funnel`,
      CAST(NULL AS FLOAT64) as `_pbk_orders`
    FROM (
      SELECT session_id FROM `bigquery-public-data.thelook_ecommerce.events` GROUP BY 1
    ) as base
  )
  UNION ALL
  SELECT * FROM (
    SELECT 
      'orders' as `stage`,
      CAST(NULL AS FLOAT64) as `_pbk_order_items`,
      base.`user_id` as `_pbk_users`,
      CAST(NULL AS FLOAT64) as `_pbk_inventory_items`,
      CAST(NULL AS FLOAT64) as `_pbk_products`,
      CAST(NULL AS FLOAT64) as `_pbk_distribution_centers`,
      CAST(NULL AS FLOAT64) as `_pbk_events`,
      CAST(NULL AS string) as `_pbk_event_session_facts`,
      CAST(NULL AS string) as `_pbk_event_session_funnel`,
      base.`order_id` as `_pbk_orders`
    FROM `bigquery-public-data.thelook_ecommerce.orders` as base
  )
) as base
GROUP BY 1,2,3,4,5,6,7,8,9,10
ORDER BY 1 asc