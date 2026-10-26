# AI Assistance and Human-in-the-Loop Verification Log

## Part A prompt: q13 rep performance against target

**Role:** You are a careful business analyst and SQL developer preparing auditable sales reports for the Big Billion Days analytics desk.

**Task:** Write q13 to report each representative's performance against monthly target. Return exactly `rep_name`, `order_month`, `monthly_target`, `revenue`, `performance_tier`, in that order. Group by rep, month and monthly target; sort by rep name then month.

**Context:** Use SQLite. `reps` columns: `rep_id`, `rep_name`, `region`, `monthly_target`. `customers` columns: `customer_id`, `first_name`, `last_name`, `city`, `region`, `age`, `rep_id`. `orders` columns: `order_id`, `customer_id`, `item`, `quantity`, `amount`, `status`, `order_month`. Join `reps` to `customers` through `rep_id`, then `customers` to `orders` through `customer_id`. Revenue means SUM of `amount` for completed orders only.

**Constraints:** Use completed orders only. `performance_tier` is `Below Target` when revenue is below target, `On Target` when revenue is at least target but below 1.1 times target, and `Above Target` otherwise. No `WITH` clauses and no stored procedures. Do not filter on aggregate aliases in `WHERE` or `GROUP BY`; write aggregate expressions out in full.

**Format:** Return raw SQL only, with inline comments. No Markdown fences or explanatory prose.

## Scenario D1 — defect table
| Defect | Classification | Explanation | Fix |
|---|---|---|---|
| `sales` table does not exist. | fake method/function | The supplied schema has `orders`, `customers`, `reps`, `products`, not `sales`. | Query `orders` and join `customers` for region. |
| `region_name` and `total_sales` do not exist. | fake method/function | Real fields are `customers.region` and `orders.amount`. | Use `c.region` and `SUM(o.amount)`. |
| Aggregate is in `WHERE`. | logic error | `WHERE` filters rows before aggregation; aggregate conditions belong in `HAVING`. | Use `WHERE o.status = 'completed'` and `HAVING SUM(o.amount) > 80000`. |
| Unsupported 38% month-over-month claim. | phantom statistic | q11 reports North at INR 53,500 in 2026-09 and INR 41,300 in 2026-10. | Calculate the change from q11 and report the actual result. |

## Scenario D1 — corrected SQL and result
Saved as `sql/d1_corrected.sql` and executed against the supplied seed using SQLite.

```sql
-- Which regions generated more than INR 80,000 in completed-order revenue?
SELECT c.region, SUM(o.amount) AS sales
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY sales DESC;
```

| region | sales |
| --- | --- |
| North | 119300 |
| South | 82500 |

North's q11 revenue was INR 53,500 in 2026-09 and INR 41,300 in 2026-10. Calculation: `((41,300 - 53,500) / 53,500) × 100 = -22.8%`.

**The actual change was -22.8% (a decline). The assistant's claim of 38% growth is contradicted by the data.**

## Scenario D1 — human-in-the-loop protocol

**Specification:** I defined the business question as completed-order revenue by customer region, retaining regions with revenue greater than INR 80,000 and sorting highest to lowest. This uses the assignment's revenue definition and threshold.

**Execution:** I ran the corrected SQL against the seed loaded from `sql/00_schema_and_seed.sql` in SQLite. It returned exactly North = INR 119,300 and South = INR 82,500.

**Inspection:** I checked the real schema and confirmed `orders`, `customers`, `orders.amount`, `orders.status` and `customers.region` exist. I checked that completed-order filtering occurs in `WHERE` and aggregate threshold filtering occurs in `HAVING`.

**Verification:** I compared the corrected output to the q11 report and recalculated North's change from INR 53,500 to INR 41,300, which is -22.8%. The output contains the required two rows and matches the assignment's expected values.

**Decision:** **Reject the original answer** because it uses a nonexistent table and columns, puts an aggregate in `WHERE`, and makes a 38% growth claim contradicted by q11. **Accept the corrected version** because it runs on the supplied seed, returns exactly North (119300) and South (82500), filters to completed orders and uses `HAVING` for the aggregate threshold.

## Scenario D2 — five-part diagnostic prompt

**Role:** You are a spreadsheet troubleshooting analyst.

**Task:** Diagnose why an exact-match lookup cannot find an item that appears to be present, and give a minimal formula correction.

**Context:** Formula: `=VLOOKUP(G2, $A$2:$C$10, 3, FALSE)`. `orders!G2` contains ` Smart Watch` with a leading space. The `products` tab occupies `A1:C10`; row 1 contains headers, item names are in column A and unit prices in column C. The lookup range begins at row 2.

**Constraints:** Keep exact matching (`FALSE`), return the third lookup column, do not modify product data to hide the issue, and identify whitespace as a possible cause.

**Format:** State the root cause, repaired formula and a short explanation.

**Root cause:** The leading space means the lookup key ` Smart Watch` is not an exact match for `Smart Watch` in the products table.

**Repaired formula:** `=VLOOKUP(TRIM(G2),products!$A$2:$C$10,3,FALSE)`

`TRIM` removes the leading space before the exact-match lookup.

## Part C — skeptical-analyst check

### Prompt
**Role:** Act as a skeptical senior analyst independent of the person making the recommendation.

**Task:** Challenge my first Part C recommendation. Identify unstated assumptions, request evidence of cause rather than correlation, and suggest a low-cost test before promotional spend is scaled.

**Context:** Completed revenue is INR 346,200 across 106 units. North revenue is INR 119,300; North Electronics is INR 73,400; South Home is INR 43,800. Monthly totals: September INR 98,300, October INR 93,100, November INR 154,800.

**Constraints:** Do not treat high revenue as proof a promotion caused it. Include at least three assumptions, a figure or check for each, and consider seasonality, stock, discounting and order volume. Do not invent causal evidence missing from the dataset.

**Format:** Return a table with `Assumption`, `Evidence/check`, `What would confirm or weaken it`, followed by a short scale-or-test conclusion.

### Assumptions and checks
| Assumption | Figure or check | What would confirm or weaken it |
|---|---|---|
| A North Electronics promotion would create incremental sales rather than shift purchases. | North Electronics generated INR 73,400; North overall fell from INR 53,500 in September to INR 41,300 in October. | Compare a test with a similar untreated region/category and track both Electronics and total North revenue. |
| More demand can be fulfilled without stock constraints. | The dataset has no inventory or stock-out field. | Check inventory, stock-out days, fulfilment and cancellations before increasing stock; this dataset alone cannot verify capacity. |
| November's peak is repeatable and caused by a campaign rather than seasonality or mix. | November revenue INR 154,800 vs October INR 93,100; no campaign or discount fields exist. | Compare campaign calendars, discounts, product mix and comparable periods; use a controlled or staggered test. |
| Higher revenue means higher profit. | Cost of goods, margin and discount data are absent. | Add cost/margin data and compare incremental gross profit, not revenue alone. |

**Conclusion:** The dataset supports descriptive trends, not causal claims. Run a measured, limited test and monitor completed-order revenue, units, margin and stock-outs before scaling.

## Disclosure
AI assistance was used to draft and check SQL and documentation. The queries and outputs were executed against the supplied synthetic seed using SQLite. Tableau Public was not built or published; the dashboard specification is text-only as allowed by the brief.
