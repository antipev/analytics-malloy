# 03_ecommerce_unified_star_schema_dynamic

This folder introduces an experimental approach: the **Dynamic Unified Star Schema**. 

While [the previous step](../02_ecommerce_unified_star_schema/README.md) utilized a physical Bridge table (which works as expected to link all tables) containing rows from each connected table to "stack" every possible ID, this model virtualizes that relationship. 

---

### How it works:
Instead of pre-processing a massive Bridge table in the Data Warehouse or creating the view approach found in [recent research regarding LLM-driven schema virtualization](https://medium.com/@irregularbi/how-i-virtualized-a-unified-star-schema-using-llm-7e69cd40a734), this approach generates the Bridge on the fly using a simple two-row SQL source. 

The Bridge is defined as a two-row (or depending on how many facts you want to link) SQL block within `bridge.malloy`:

```malloy
source: bridge is bigquery.sql("""
  SELECT "events"      AS stage
  UNION ALL
  SELECT "order_items" AS stage
""") extend {
  primary_key: stage
}
```

#### During the on-the-fly SQL execution:

1. The two-row Bridge INTENTIONALLY creates a **Controlled Fan-Out** to bridge the gap between `events` and `order_items`.

2. The BI engine only selects dimensions and metrics from the fact tables explicitly called in a query. If a second table is not requested, it is not processed, preventing unnecessary data scanning and **Controlled Fan-Out**.

3. Using `##! experimental {join_types}`, the model performs `full joins` across dim tables. This is necessary to mimic original Unified Star Schema behavior: to prevent Data Loss from dim tables, enabling the selection of all dimensions even if no orders or events occurred (for example, to run analysis on unsold items, etc.). At the same time, this keeps table "explosion" limited to the original number of rows of the fact tables. 

4. Dimensions are joined using logic like `coalesce(order_items.User_id, events.User_id)`, ensuring the model only selects IDs that exist in the active fact tables.



# OBSERVATIONS

## Option 1: BRIDGE MALLOY/SQL EXAMPLE:

### MALLOY:
run: ecommerce_explore -> {
  group_by: products.Id
  aggregate: order_items.order_count
  having: order_items.order_count ~ f`0`
}

### SQL
SELECT 
   products_0.`id` as `Id`,
   count(distinct order_items_0.`order_id`) as `order_count`
FROM `PROJECT.DATASET.bridge_ecommerce`as base
 LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` AS products_0
  ON base.`_key_products`=products_0.`id`
 LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS order_items_0
  ON base.`_key_order_items`=order_items_0.`id`
GROUP BY 1
HAVING (count(distinct order_items_0.`order_id`)) = 0
ORDER BY 2 desc NULLS LAST

## //Bytes processed 9.72 MB, Bytes billed 30 MB. Elapsed time 376 ms.
## Bytes processed to CREATE BRIDGE 208.84 MB, Bytes billed 209 MB. Elapsed time 23.66 sec //


## Option 2: DYNAMIC BRIDGE SQL EXAMPLE:

### MALLOY:
run: ecommerce_explore -> {
  group_by: products.Id
  aggregate: order_items.order_count
  having: order_items.order_count ~ f`0`
}

### SQL
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



## Comparison Summary(1)

| Metric                     | Option 1 (Physical Bridge) | Option 2 (Dynamic Bridge)    |
| :---                       | :---                       | :---                         |
| **Query Execution Time**   | 376 ms                     | 533 ms                       |
| **Data Processed (Query)** | 9.72 MB (30 MB billed)     | 10.46 MB (30 MB billed)      |
| **Upfront Processing**     | 208.84 MB (Build Table)    | 0 MB (Virtual)               |
| **Maintenance**            | Requires ETL/Refresh       | Zero Maintenance             |
| **Scalability**            | Fixed to pre-built IDs     | Adapts to active fact tables |


## Additional tests different case:
Table 1: 1.4 Billion rows, 3.15 TB  (logical bytes)
Table 2: 57  Million rows, 77.57 GB (logical bytes)
Physical Bridge: UNION of ID from Table 1 and table 2
Physical Bridge: 2 rows

| Metric                     | Option 1 (Physical Bridge) | Option 2 (c)    |
| :---                       | :---                       | :---                         |
| **Query Execution Time**   | 11 sec                     | 15 sec                       |
| **Data Processed (Query)** | 96.5 GB (96.5 GB billed)   | 1.48 GB (1.48 GB billed)     |
| **Upfront Processing**     | 90.13 GB (Build Table)     | 0 MB (Virtual)               |
| **Maintenance**            | Requires ETL/Refresh       | Zero Maintenance             |
| **Scalability**            | Fixed to pre-built IDs     | Adapts to active fact tables |

**(1)** Note: Performance benchmarks may vary based on query complexity and data distribution. It is recommended to run local execution tests to determine the optimal balance between upfront processing costs and real-time query efficiency for your specific use case. 