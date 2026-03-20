# analytics-malloy

This repository explores the evolution of data modeling from traditional to modern: Unified Star Schema (USS), using open-source semantic layers: Malloy.

## Purpose
The goal of this "analytics-malloy" project is to experiment with the Unified Star Schema (USS) modeling, using:
* the public theLook eCommerce dataset
* Malloy

## Steps:
### 1. Copy Traditional Looker Model as representation of Semantic Layer
It shows how data is traditionally organized into "Views" and "Models" (star schemas) within a Looker BI tool.

### 2. Direct Conversion to Malloy
The same Looker logic, but converted into Malloy. This allows the model to be open-source and run directly in VS Code without needing a Looker license.

For visibility of 2 star schemas: two models are presented as 2 separate Malloy files: `events_explore.malloy`, `order_items_explore.malloy`.

### 3. Unified Star Schema (USS)
Implementation of Francesco Puppini’s Unified Star Schema. Instead of separate "silos" for Orders and Events, we use a Bridge Table to connect everything into one single, searchable model.

So two separate models from previous step got converted again in one file: `ecommerce_explore.malloy`. However, at this time it uses Bridge as central table.

### 4. Dynamic Bridge Experiment
An experimental, "virtual" version of the Bridge Table. Instead of building a massive physical table in the database, this version generates a bridge on the fly.

---