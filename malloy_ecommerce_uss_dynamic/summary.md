### The Breakdown

| Metric | Option 1: Static Bridge | Option 2: Dynamic Bridge |
| :--- | :--- | :--- |
| **Data Processed** | 176.95 MB | 16.2 MB |
| **Logic** | Scans all keys in the UNION ALL | Scans only the tables needed for the specific metrics |
| **Join Condition** | ON base._key_order_items = order_items.id | ON base.stage = 'order_items' |
| **Primary Advantage** | Symmetry. One key is consistent across the whole model. | Efficiency. Only "touches" the data requested. |

### Why Option 2 looks "cheaper" (16.2 MB vs 176.95 MB)

In Option 1, UNION ALL includes every column (all 8 keys) for every branch. Even if you only ask for order_count, BigQuery's optimizer often scans the entire Union subquery to build the base table before it performs the join. This is why it hits ~177 MB.

In Option 2, Malloy is doing something very clever. Because the bridge is just 8 static strings, BigQuery sees that the joins are mutually exclusive. It realizes it only needs to scan the order_items table for the revenue and the users/events tables for the coalesce key. It ignores the other 5 tables entirely.


### The "Real-Life Scenario" 

# Architecture Showdown: Static vs. Dynamic Bridge
**Scenario:** A Unified Star Schema (USS) joining two massive fact tables in BigQuery.

### The Scale
* **Table A (Orders):** ~53 Million rows.
* **Table B (Transactions):** ~1.3 Billion rows.
* **The Goal:** Aggregate metrics from both tables (e.g., Order Count and Gross Compensation) by Country and Date.

---

### Performance Comparison

| Metric | Option 1: Static Bridge (Physical Keys) | Option 2: Dynamic Bridge (Stage Strings) |
| :--- | :--- | :--- |
| **Join Logic** | `ON bridge.key = table.key` | `ON bridge.stage = 'table_name'` |
| **Data Scanned** | **89.7 GB** | **1.72 GB** |
| **Execution Path** | Scans full key columns; struggles with partition pruning. | Perfect partition pruning; ignores irrelevant data. |
| **Cost Ratio** | **52x more expensive** | **Base cost** |

---

### Why the "Dynamic Bridge" Wins at Scale

**1. The "AND" Filter Trap in Static Joins**
In a Static Bridge, every row belongs to only one stage. When you filter by date or country on both joined tables simultaneously, BigQuery’s optimizer often feels forced to scan the massive key columns of both tables to find intersections that don't actually exist. This results in the massive **89.7 GB** scan.

**2. Predicate Pushdown in Dynamic Joins**
In the Dynamic Bridge, the join condition is a simple string constant (`stage = 'table_name'`). This allows BigQuery to treat each join branch as a completely independent operation. It applies the date and country filters *before* the join, scanning only the 3 months of data required. 

**3. Resource Efficiency**
Option 2 (Dynamic) allows BigQuery to perform "Join Pruning." If a query only asks for Order counts, the Transaction table is never even touched. Option 1 often requires the engine to look at the bridge's relationship to every table regardless of the metrics requested.




---
## Why Malloy + Option 2 is a "Killer Combo"

### Intentional Fan-out, Safe Aggregation
When you join `bridge` to `order_items` on `stage = 'order_items'`, you are intentionally creating a fan-out. Malloy recognizes the primary key of the joined table and automatically wraps your `sum()` and `count()` functions in its own internal `SUM(DISTINCT ...)` or `COUNT(DISTINCT ...)` logic.

### The "Virtual" Key
By using `COALESCE` to create `_key_users`, you are providing Malloy with the "identity" of the row. Even if the join logic is "lazy" (Option 2), Malloy uses that identity to ensure that a user who appears in both an `events` row and an `order_items` row is counted correctly.

### Automatic Pruning
Because Malloy knows that the bridge-to-fact relationship is based on the `stage` name, it only executes the joins for the data you actually ask for. If your query only references `order_count`, Malloy’s compiler will literally remove the `events` join from the final SQL.
---

### Final Thoughts: The "Dynamic" Shift

For massive datasets (1B+ rows), the **Dynamic Stage Bridge** is the superior architecture for the Unified Star Schema.

* **Standard Logic:** Conventional wisdom suggests joining on IDs (Option 1), but at the billion-row scale in BigQuery, the cost of scanning those IDs becomes prohibitive.
* **The Result:** Moving to a Dynamic Stage Bridge transformed a "heavy" 90 GB query into a "light" 1.7 GB query—a **98% reduction in data processed.** (based on "Real-Life Scenario")

---
*Architecture Tip: When using Malloy/Looker (or maybe other BI tool), implement Option 2 by joining strictly on the `stage` or `source_name` dimension to unlock this level of performance.*


