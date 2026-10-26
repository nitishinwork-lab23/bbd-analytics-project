# Tableau Public Dashboard Specification

## Data source
Connect to `data/orders_clean.csv` (63 completed-order rows). Keep `order_month` as text in `YYYY-MM` format.

| Field | Classification |
|---|---|
| `order_id` | Dimension |
| `order_month` | Dimension |
| `clean_first_name` | Dimension |
| `clean_last_name` | Dimension |
| `region` | Dimension |
| `rep_name` | Dimension |
| `item` | Dimension |
| `category` | Dimension |
| `unit_price` | Measure |
| `quantity` | Measure |
| `amount` | Measure |
| `revenue_calc` | Measure |
| `status` | Dimension |

## KPI cards
- **Total Revenue:** SUM(`amount`) = **INR 346,200**. This equals Part A q05 `total_revenue`.
- **Total Units Sold:** SUM(`quantity`) = **106**.

## Chart sheets

### Revenue by Region
- Chart type: bar chart.
- Rows: `region`; Columns: SUM(`amount`); Colour: `region`.
- Reason: bars make regional revenue ranking and differences easy to compare.
| region | revenue |
| --- | --- |
| East | 69500 |
| North | 119300 |
| South | 82500 |
| West | 74900 |

### Revenue by Category
- Chart type: bar chart.
- Rows: `category`; Columns: SUM(`amount`); Colour: `category`.
- Reason: bars compare category contributions on the same numeric scale.
| category | revenue |
| --- | --- |
| Apparel | 77500 |
| Electronics | 142300 |
| Home | 126400 |

### Revenue Trend by Month and Category
- Chart type: line chart.
- Columns: `order_month` (ordered 2026-09, 2026-10, 2026-11); Rows: SUM(`amount`); Colour: `category`.
- Reason: one line per category reveals month-to-month direction and changes.
| order_month | Apparel | Electronics | Home | Total |
| --- | --- | --- | --- | --- |
| 2026-09 | 24700 | 43000 | 30600 | 98300 |
| 2026-10 | 30600 | 49900 | 12600 | 93100 |
| 2026-11 | 22200 | 49400 | 83200 | 154800 |

### Region x Category Detail
- Chart type: text table.
- Rows: `region`; Columns: `category`; Text/colour: SUM(`amount`).
- Reason: the crosstab exposes exact values for checking the comparison charts.
| region | Apparel | Electronics | Home | Total |
| --- | --- | --- | --- | --- |
| East | 10600 | 21400 | 37500 | 69500 |
| North | 19400 | 73400 | 26500 | 119300 |
| South | 10000 | 28700 | 43800 | 82500 |
| West | 37500 | 18800 | 18600 | 74900 |

## Dashboard layout
Stack vertically in this order: KPI cards; category filter; trend chart; region and category comparison charts side by side; detail table. Use a vertical outer container, horizontal container for the KPI cards, and horizontal container for the comparison charts. Place the `category` filter in the top band directly below the KPI cards and apply it to all four worksheets using this data source. With **Use as Filter** enabled on Revenue by Region, clicking a region bar filters the trend, category comparison and detail table to that region.

## Visualization summary
Completed orders generated INR 346,200 across 106 units. North leads regions with INR 119,300, followed by South with INR 82,500. Electronics leads categories at INR 142,300, followed by Home at INR 126,400 and Apparel at INR 77,500. Monthly revenue was INR 98,300 in September, INR 93,100 in October and INR 154,800 in November 2026.

## Summary analysis
1. **Region comparison:** North generated INR 119,300 versus South at INR 82,500, a difference of INR 36,800.
2. **Category comparison:** Electronics generated INR 142,300, which is INR 15,900 above Home's INR 126,400.
3. **Monthly change:** Revenue fell from INR 98,300 in September to INR 93,100 in October, then rose to INR 154,800 in November. October was INR 5,200 below September; November was INR 61,700 above October.
4. **North monthly caution:** North revenue fell from INR 53,500 in September to INR 41,300 in October (-22.8%). These data contradict a 38% growth claim for that period.

## Recommendations
1. **North × Electronics:** test a targeted, time-limited promotion; North Electronics revenue is INR 73,400. Compare completed-order revenue and units against a comparable baseline before scaling.
2. **South × Home:** review stock and campaign placement; South Home revenue is INR 43,800. Check inventory and stock-out rates, and judge success by completed-order revenue and stock-outs.
3. **November peak:** investigate before repeating a campaign; November revenue was INR 154,800 versus INR 93,100 in October. Compare campaign exposure, product mix, order counts and discounts; track incremental revenue and margin.

## Reconciliation
| Measure | Value (INR) |
|---|---:|
| Total Revenue KPI | 346200 |
| Sum of Revenue by Region | 346200 |
| Sum of Revenue by Category | 346200 |
| Part B pivot grand total | 346200 |

All four totals reconcile to INR 346,200.
