## Unified Star Schema vs. Traditional Silos

### The Traditional Problem (Siloed Explorers)
In a traditional modeling approach, **Order Items** and **Events** live in different "Explorers." 

### The USS Advantage (Cross-Functional Measures)
By using a **Bridge (Option 1 or 2)**, you break down the walls between these tables. Since the Bridge acts as a "Universal Fact Table," you can define **Cross-Measures** natively in Malloy.


# Option 1: BRIDGE MALLOY/SQL EXAMPLE:

## MALLOY:
run: ecommerce_explore -> {
  group_by: products.Id
  aggregate: order_items.order_count
  having: order_items.order_count ~ f`0`
}

## SQL
SELECT 
   products_0.`id` as `Id`,
   count(distinct order_items_0.`order_id`) as `order_count`
FROM `my-1-st-project-training.dbt_maksim_ml_analytical.bridge_ecommerce`as base
 LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` AS products_0
  ON base.`_key_products`=products_0.`id`
 LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS order_items_0
  ON base.`_key_order_items`=order_items_0.`id`
GROUP BY 1
HAVING (count(distinct order_items_0.`order_id`)) = 0
ORDER BY 2 desc NULLS LAST

## //Bytes processed 9.72 MB, Bytes billed 30 MB. Elapsed time 376 ms.
## Bytes processed to CREATE BRIDGE 208.84 MB, Bytes billed 209 MB. Elapsed time 23.66 sec //


# Option 2: DYNAMIC BRIDGE SQL EXAMPLE:

## MALLOY:
run: ecommerce_explore -> {
  group_by: products.Id
  aggregate: order_items.order_count
  having: order_items.order_count ~ f`0`
}

## SQL
SELECT 
   products_0.`id` as `Id`,
   count(distinct order_items_0.`order_id`) as `order_count`
FROM (
  SELECT  "events"      AS stage,
  UNION ALL
  SELECT  "order_items" AS stage

) as base
 LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS order_items_0
  ON base.`stage`='order_items'
 FULL JOIN `bigquery-public-data.thelook_ecommerce.inventory_items` AS inventory_items_0
  ON order_items_0.`inventory_item_id`=inventory_items_0.`id`
 FULL JOIN `bigquery-public-data.thelook_ecommerce.products` AS products_0
  ON inventory_items_0.`product_id`=products_0.`id`
GROUP BY 1
HAVING (count(distinct order_items_0.`order_id`)) = 0
ORDER BY 2 desc NULLS LAST

## //Bytes processed 10.46 MB, Bytes billed 30 MB. Elapsed time 533 ms//






# 02_ecommerce_unified_star_schema

This folder demonstrates the implementation of the **Unified Star Schema (USS)**. 

[In the previous step](../01_ecommerce_malloy/README.md), we had separate "Explorers" for Orders and Events. Here, we break down those walls by introducing a **Bridge Table**, allowing us to query across the entire eCommerce ecosystem from a single point of entry.

### How it works:
1. **The Staging:** Every table (Orders, Events, Users, etc.) is transformed into a "Stage"
2. **The Keys:** Each "Stage" identifies its own primary keys and any foreign keys it relates to.
3. **The Union:** All "Stage" are stacked (Unioned) into one central table.

This results in a single **"ecommerce_explore"** where you can calculate cross-functional metrics—like *Orders per Web Session* (Conversion) —without any risk of double-counting or data loss.

---

## Implementation in Malloy
To keep this project accessible and strictly within the [Google BigQuery Public Dataset](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce), we use Malloy to "imitate" a physical Bridge table (`bridge.malloy`).

In a production environment, you would build a physical table (unions all 8 stages) in your DWH (`bridge.sql`). 

---


























# Unified Star Schema vs. Traditional Silos

## The Problem: Fragmented "Star Schemas"

In traditional data modeling (Standard Star Schemas), your data is often stuck in separate "Silos." Even if you have conformed dimensions, Order Items and Events usually live in different "Explorers" (Star Schemas) because they have different grains (one row per sale vs. one row per event).

To answer a cross-functional question like:
"What is the order conversion rate for every 100 web sessions?"


You are usually forced into "Data Munging"—writing SQL with CTEs and Aggregations based on selected dimnesion, creating derived tables/addiitonal views, or using "Merged Results" in BI tool itself. 
________________________________________


## The USS Advantage: The Puppini Bridge
Instead of building separate Star Schemas, the Unified Star Schema (USS) introduces a Bridge Table at the center of your model.
Think of the Bridge as a "Universal Connector." It contains the unique keys from every table in your warehouse, grouped by a "Stage" column. This transforms your data from a collection of disconnected silos into a single, searchable matrix.
By using the Bridge, you can define Cross-Measures natively in Malloy that pull data from completely different fact tables in one go:
Code snippet
// One measure that "talks" to two separate silos
measure: event_propensity is 
  events.event_count / nullif(order_items.order_count, 0)
The Result: You stop worrying about "Fan Traps" or "Chasm Traps." The Bridge handles the connectivity, allowing you to focus on the business logic while Malloy generates the optimized SQL to traverse the paths for you.
