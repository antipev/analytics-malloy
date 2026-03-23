# 01_ecommerce_malloy

This folder contains the **Malloy** version of the eCommerce data model, converted directly from the original LookML models. 

---

## Open-Source Data Modeling
[Malloy](https://docs.malloydata.dev/documentation/) is an open-source language for describing data relationships and transformations. It is an analytical language that runs on SQL databases, providing the ability to define a semantic data model and query it. Malloy was created by the original author of Looker as a more evolved, open-source successor.

---

## Project Overview
The logic remains identical to the traditional LookML setup. By moving to Malloy, Semantic Models can be easily developed, run, and visualized directly within **VS Code, Google Cloud Shell, or GitHub Codespaces** using the Malloy extension. Since it is open-source, there is no need for a specific BI tool to explore the data.

This project retains the "Layered Structure" (Views and Models) to mimic LookerML precisely. Its specific purpose is to show—step by step—how **Unified Star Schema (Francesco Puppini)** modeling is implemented to support a Semantic Layer: a system where data elements (orders, events, products, etc.) are as easily accessible as items in a shopping cart. This architecture inherently prevents:
* **Fan Traps:** Inflated numbers caused by "Double Counting."
* **Chasm Traps:** Data explosions caused by unrelated many-to-many relationships.
* **Data Loss:** Missing records due to restrictive join types.

---

## File Structure

### 1. Views (`/views`)
These files define the dimensions and measures for each table. In Malloy, these scripts can contain different statements such as `import`, `query`, `source`, and `run`.

* **Terminology Note:** In Malloy, these are called **Sources**. A source is essentially a table plus metadata (similar to a "View" in LookerML).
* **Reusability:** The **Source** is the basic unit of reusability. It contains the table definition along with all relevant computations and relationships.

**Included View Files:**
* `distribution_centers.malloy`
* `events.malloy`
* `inventory_items.malloy`
* `order_items.malloy`
* `orders.malloy`
* `products.malloy`
* `users.malloy`

### 2. Models (`/models`)
The model files act as extended **Sources**. They import the previously created Sources (LookerML "Views") and define the join relationships. They can also contain new, model-level dimensions and measures.

* These files define the semantic relationships used for multi-table data analysis.
* Similar to LookerML, these models are the entry point for the end-user and can be explore directly in VS Code or [Published for exploration](https://docs.malloydata.dev/documentation/user_guides/publishing/publishing).

---
* Note: In Original LookerML the file `training_ecommerce.model` there are 2 explore files in one: they are not connected to each other (`explore: events`,`explore: order_items`). Therefore in Malloy for visibility purposes they are separeted on two files: `events_explore` and `events_explore`.