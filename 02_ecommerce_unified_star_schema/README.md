# 02_ecommerce_unified_star_schema

This folder demonstrates the implementation of the **Unified Star Schema (USS)**. 

[The previous step](../01_ecommerce_malloy/README.md) featured separate "Explorers" for Orders and Events. This stage eliminates those silos by introducing a **Bridge Table**, allowing for queries across the entire eCommerce ecosystem from a single point of entry.

### How it works:
1. **The Staging:** Every table (Orders, Events, Users, etc.) is transformed into a "Stage."
2. **The Keys:** Each "Stage" identifies its own primary keys and any relevant foreign keys.
3. **The Union:** All "Stages" are stacked (Unioned) into one central table.

This results in a single **"ecommerce_explore"** for calculating cross-functional metrics—such as *Orders per Web Session* (Conversion)—without the risk of double-counting or data loss.

---

## Implementation in Malloy
To maintain accessibility within the [Google BigQuery Public Dataset](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce), Malloy is used to imitate a physical Bridge table (`bridge.malloy`).

In a production environment, a physical table unioning all 8 stages would typically be built directly in the Data Warehouse (`bridge.sql`).

---

## File Structure

* **1_views/**: Contains individual Malloy sources and the `bridge.malloy` union logic.
* **2_models/**: Contains `ecommerce_explore.malloy`, the final unified semantic layer.


