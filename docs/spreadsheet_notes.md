# Spreadsheet Cleaning and Pivot Notes

## Setup
- Selected spreadsheet tool: Google Sheets. CSVs and calculations in this repository were independently reproduced with SQLite and Python for reproducibility; no workbook is included.
- Tabs: `orders`, `products`, and `completed_orders`.
- `orders`: 90 data rows imported from `data/orders_enriched.csv`, plus header.
- `products`: paste `SELECT item, category, unit_price FROM products ORDER BY item` with header into `A1:C10`; item is column A, category B, unit price C.
- Keep `order_month` as plain text and verify values remain like `2026-09`.
- Filter `status = completed`, sort `amount` descending, then copy the 63 visible rows as values into `completed_orders`; remove raw name columns and arrange the 13 columns in the exported CSV order.
- Missing-key test outside the data: `=XLOOKUP("Mystery Item",$A$2:$A$10,$C$2:$C$10,"UNKNOWN_ITEM")` returns `UNKNOWN_ITEM`.
- D2 repair: `=VLOOKUP(TRIM(G2),products!$A$2:$C$10,3,FALSE)`.

## Formulas in the first data row
Assuming `orders` uses q09 order: `order_id`, `order_month`, `first_name`, `last_name`, `region`, `rep_name`, `item`, `quantity`, `amount`, `status` in columns A:J, added columns are appended:
- `clean_first_name`: `=PROPER(TRIM(C2))`
- `clean_last_name`: `=PROPER(TRIM(D2))`
- `category`: `=VLOOKUP(G2,products!$A$2:$C$10,2,FALSE)`
- `unit_price`: `=XLOOKUP(G2,products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")`
- `revenue_calc`: `=N2*H2` (with the original q09 columns A:J and added columns K:O, `unit_price` is N and `quantity` is H).

## Aggregate block on `completed_orders`
| Metric | Result |
|---|---:|
| COUNT of amount | 63 |
| SUM of amount | 346200 |
| AVERAGE of amount | 5495.24 |
| MIN of amount | 1100 |
| MAX of amount | 15600 |

## Pivot table (i): SUM of amount by category and region
| category | East | North | South | West | Grand Total |
| --- | --- | --- | --- | --- | --- |
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| Grand Total | 69500 | 119300 | 82500 | 74900 | 346200 |

## Pivot table (ii): SUM of amount and COUNT of order_id by month
| order_month | SUM of amount | COUNT of order_id |
| --- | --- | --- |
| 2026-09 | 98300 | 19 |
| 2026-10 | 93100 | 20 |
| 2026-11 | 154800 | 24 |
| Grand Total | 346200 | 63 |

## Reconciliation
| Metric | Spreadsheet | Part A q05 | Match/Mismatch |
|---|---:|---:|---|
| COUNT | 63 | 63 | Match |
| SUM | 346200 | 346200 | Match |
| AVERAGE | 5495.24 | 5495.24 | Match |

## Data validation
- q02 missing amounts are on order IDs 1001, 1010, 1064. They are pending orders. Do not impute an unknown amount as zero; none is needed to compute completed-order revenue.
- Numeric fields include `order_id`, `quantity`, `unit_price`, `amount`, and `revenue_calc`; `order_month` remains text in `YYYY-MM` form.
- No duplicate completed `order_id` values exist.
- Largest completed amount is INR 15600; order IDs 1061, 1065, 1069, 1077 tie at that value.
- Handover decision: keep raw names unchanged in `orders` and use separate cleaned columns for traceability; document any future missing-value treatment rather than silently imputing.
