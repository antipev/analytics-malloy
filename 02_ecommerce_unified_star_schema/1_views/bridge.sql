CREATE OR REPLACE TABLE `PROJECT.DATASET.bridge_ecommerce` AS
SELECT 
   base.`stage` as `stage`,
   base.`_key_order_items` as `_key_order_items`,
   base.`_key_users` as `_key_users`,
   base.`_key_inventory_items` as `_key_inventory_items`,
   base.`_key_products` as `_key_products`,
   base.`_key_distribution_centers` as `_key_distribution_centers`,
   base.`_key_events` as `_key_events`,
   base.`_key_event_session_facts` as `_key_event_session_facts`,
   base.`_key_event_session_funnel` as `_key_event_session_funnel`
FROM (
  SELECT * FROM ((SELECT 
   'order_items' as `stage`,
   base.`id` as `_key_order_items`,
   base.`user_id` as `_key_users`,
   base.`inventory_item_id` as `_key_inventory_items`,
   base.`product_id` as `_key_products`,
   CAST(NULL AS FLOAT64) as `_key_distribution_centers`,
   CAST(NULL AS FLOAT64) as `_key_events`,
   CAST(NULL AS string) as `_key_event_session_facts`,
   CAST(NULL AS string) as `_key_event_session_funnel`
FROM `bigquery-public-data.thelook_ecommerce.order_items` as base
))
  UNION ALL
  SELECT * FROM ((SELECT 
   'users' as `stage`,
   CAST(NULL AS FLOAT64) as `_key_order_items`,
   base.`id` as `_key_users`,
   CAST(NULL AS FLOAT64) as `_key_inventory_items`,
   CAST(NULL AS FLOAT64) as `_key_products`,
   CAST(NULL AS FLOAT64) as `_key_distribution_centers`,
   CAST(NULL AS FLOAT64) as `_key_events`,
   CAST(NULL AS string) as `_key_event_session_facts`,
   CAST(NULL AS string) as `_key_event_session_funnel`
FROM `bigquery-public-data.thelook_ecommerce.users` as base
))
  UNION ALL
  SELECT * FROM ((SELECT 
   'inventory_items' as `stage`,
   CAST(NULL AS FLOAT64) as `_key_order_items`,
   CAST(NULL AS FLOAT64) as `_key_users`,
   base.`id` as `_key_inventory_items`,
   base.`product_id` as `_key_products`,
   base.`product_distribution_center_id` as `_key_distribution_centers`,
   CAST(NULL AS FLOAT64) as `_key_events`,
   CAST(NULL AS string) as `_key_event_session_facts`,
   CAST(NULL AS string) as `_key_event_session_funnel`
FROM `bigquery-public-data.thelook_ecommerce.inventory_items` as base
))
  UNION ALL
  SELECT * FROM ((SELECT 
   'products' as `stage`,
   CAST(NULL AS FLOAT64) as `_key_order_items`,
   CAST(NULL AS FLOAT64) as `_key_users`,
   CAST(NULL AS FLOAT64) as `_key_inventory_items`,
   base.`id` as `_key_products`,
   base.`distribution_center_id` as `_key_distribution_centers`,
   CAST(NULL AS FLOAT64) as `_key_events`,
   CAST(NULL AS string) as `_key_event_session_facts`,
   CAST(NULL AS string) as `_key_event_session_funnel`
FROM `bigquery-public-data.thelook_ecommerce.products` as base
))
  UNION ALL
  SELECT * FROM ((SELECT 
   'distribution_centers' as `stage`,
   CAST(NULL AS FLOAT64) as `_key_order_items`,
   CAST(NULL AS FLOAT64) as `_key_users`,
   CAST(NULL AS FLOAT64) as `_key_inventory_items`,
   CAST(NULL AS FLOAT64) as `_key_products`,
   base.`id` as `_key_distribution_centers`,
   CAST(NULL AS FLOAT64) as `_key_events`,
   CAST(NULL AS string) as `_key_event_session_facts`,
   CAST(NULL AS string) as `_key_event_session_funnel`
FROM `bigquery-public-data.thelook_ecommerce.distribution_centers` as base
))
  UNION ALL
  SELECT * FROM ((SELECT 
   'events' as `stage`,
   CAST(NULL AS FLOAT64) as `_key_order_items`,
   base.`user_id` as `_key_users`,
   CAST(NULL AS FLOAT64) as `_key_inventory_items`,
   CAST(NULL AS FLOAT64) as `_key_products`,
   CAST(NULL AS FLOAT64) as `_key_distribution_centers`,
   base.`id` as `_key_events`,
   base.`session_id` as `_key_event_session_facts`,
   base.`session_id` as `_key_event_session_funnel`
FROM `bigquery-public-data.thelook_ecommerce.events` as base
))
  UNION ALL
  SELECT * FROM ((SELECT 
   'event_session_facts' as `stage`,
   CAST(NULL AS FLOAT64) as `_key_order_items`,
   CAST(NULL AS FLOAT64) as `_key_users`,
   CAST(NULL AS FLOAT64) as `_key_inventory_items`,
   CAST(NULL AS FLOAT64) as `_key_products`,
   CAST(NULL AS FLOAT64) as `_key_distribution_centers`,
   CAST(NULL AS FLOAT64) as `_key_events`,
   base.`Session_id` as `_key_event_session_facts`,
   base.`Session_id` as `_key_event_session_funnel`
FROM   
(SELECT 
     base.`Session_id` as `Session_id`,
     base.`Identifier` as `Identifier`,
     base.`Session_start` as `Session_start`,
     base.`Session_end` as `Session_end`,
     base.`Session_landing_page` as `Session_landing_page`,
     base.`Session_exit_page` as `Session_exit_page`
  FROM   
  (SELECT
      `Session_id__0` as `Session_id`,
      `Identifier__0` as `Identifier`,
      `Created_at__0` as `Created_at`,
      `Event_type__0` as `Event_type`,
      ANY_VALUE(CASE WHEN group_set=0 THEN `Session_start__0` END) as `Session_start`,
      ANY_VALUE(CASE WHEN group_set=0 THEN `Session_end__0` END) as `Session_end`,
      ANY_VALUE(CASE WHEN group_set=0 THEN `Session_landing_page__0` END) as `Session_landing_page`,
      ANY_VALUE(CASE WHEN group_set=0 THEN `Session_exit_page__0` END) as `Session_exit_page`
    FROM   
    (SELECT
        group_set,
        __lateral_join_bag.`Session_id__0`,
        __lateral_join_bag.`Identifier__0`,
        __lateral_join_bag.`Created_at__0`,
        __lateral_join_bag.`Event_type__0`,
        CASE WHEN group_set=0 THEN FIRST_VALUE((__lateral_join_bag.`Created_at__0`)) OVER(PARTITION BY group_set, (__lateral_join_bag.`Session_id__0`) ORDER BY (__lateral_join_bag.`Created_at__0`) ASC ) END as `Session_start__0`,
        CASE WHEN group_set=0 THEN LAST_VALUE((__lateral_join_bag.`Created_at__0`)) OVER(PARTITION BY group_set, (__lateral_join_bag.`Session_id__0`) ORDER BY (__lateral_join_bag.`Created_at__0`) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) END as `Session_end__0`,
        CASE WHEN group_set=0 THEN FIRST_VALUE((__lateral_join_bag.`Event_type__0`)) OVER(PARTITION BY group_set, (__lateral_join_bag.`Session_id__0`) ORDER BY (__lateral_join_bag.`Created_at__0`) ASC ) END as `Session_landing_page__0`,
        CASE WHEN group_set=0 THEN LAST_VALUE((__lateral_join_bag.`Event_type__0`)) OVER(PARTITION BY group_set, (__lateral_join_bag.`Session_id__0`) ORDER BY (__lateral_join_bag.`Created_at__0`) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) END as `Session_exit_page__0`
      FROM `bigquery-public-data.thelook_ecommerce.events` as base
      CROSS JOIN (SELECT row_number() OVER() -1  group_set FROM UNNEST(GENERATE_ARRAY(0,0,1)))
      LEFT JOIN UNNEST([STRUCT(base.`session_id` as `Session_id__0`,
      COALESCE(CAST(base.`user_id` AS string),base.`ip_address`) as `Identifier__0`,
      base.`created_at` as `Created_at__0`,
      base.`event_type` as `Event_type__0`)]) as __lateral_join_bag
      GROUP BY 1,2,3,4,5
      )
    
    GROUP BY 1,2,3,4
    )
   as base
  GROUP BY 1,2,3,4,5,6
  ORDER BY 3 desc NULLS LAST
  )
 as base
))
  UNION ALL
  SELECT * FROM ((SELECT 
   'event_session_funnel' as `stage`,
   CAST(NULL AS FLOAT64) as `_key_order_items`,
   CAST(NULL AS FLOAT64) as `_key_users`,
   CAST(NULL AS FLOAT64) as `_key_inventory_items`,
   CAST(NULL AS FLOAT64) as `_key_products`,
   CAST(NULL AS FLOAT64) as `_key_distribution_centers`,
   CAST(NULL AS FLOAT64) as `_key_events`,
   base.`Session_id` as `_key_event_session_facts`,
   base.`Session_id` as `_key_event_session_funnel`
FROM   
(SELECT 
     base.`session_id` as `Session_id`,
     min(CASE WHEN base.`event_type`='Product' THEN base.`created_at` END) as `Event1_time`,
     min(CASE WHEN base.`event_type`='Cart' THEN base.`created_at` END) as `Event2_time`,
     min(CASE WHEN base.`event_type`='Purchase' THEN base.`created_at` END) as `Event3_time`
  FROM `bigquery-public-data.thelook_ecommerce.events` as base
  GROUP BY 1
  ORDER BY 2 desc NULLS LAST
  )
 as base
))
) as base
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY 1 asc NULLS LAST
 
