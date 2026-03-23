# analytics-malloy

This repository explores the evolution of data modeling from traditional to modern: Unified Star Schema (USS), using open-source semantic layer: Malloy.

## Purpose
The goal of the "analytics-malloy" project is experimentation with Unified Star Schema (USS) modeling, using:
* the public theLook eCommerce dataset
* Malloy

## Steps:
### 1. [Copy Traditional Looker Model as representation of Semantic Layer](./00_ecommerce_looker)
Data organization follows traditional "Views" and "Models" (star schemas) within a Looker BI tool.

### 2. [Direct Conversion to Malloy](./01_ecommerce_malloy)
The Looker logic is converted into Malloy, allowing the model to be open-source and run directly in VS Code without a Looker license.

For visibility of 2 star schemas, two models are presented as 2 separate Malloy files: `events_explore.malloy` and `order_items_explore.malloy`.

### 3. [Unified Star Schema (USS)](./02_ecommerce_unified_star_schema)
Implementation of Francesco Puppini’s Unified Star Schema. A Bridge Table connects Orders and Events into one single, searchable model instead of separate "silos."

The two separate models from the previous step are converted again into one file: `ecommerce_explore.malloy`, using the Bridge as the central table.

### 4. [Dynamic Bridge Experiment](./03_ecommerce_unified_star_schema_dynamic)
An experimental, "virtual" version of the Bridge Table. This version generates a bridge on the fly instead of building a massive physical table in the database.

---