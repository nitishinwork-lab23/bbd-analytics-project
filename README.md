# Big Billion Days Regional Performance Review — SQL, Spreadsheet, Dashboard and AI-Verified Analysis

## Tools and implementation
- **SQL compiler:** SQLite in the local Python SQLite engine for reproducible execution.
- **SQL dialect:** SQLite.
- **Spreadsheet tool:** Google Sheets is the selected spreadsheet tool for the documented workflow; CSVs and calculations were independently reproduced with SQLite/Python.
- **Tableau Public dashboard:** No. A rebuild-ready specification is in `docs/dashboard_spec.md`; no Tableau workbook was built or published.

## Three most important findings
Completed orders total INR 346,200 across 63 orders and 106 units. North is the largest region at INR 119,300, followed by South at INR 82,500; Electronics is the largest category at INR 142,300. Monthly revenue was INR 98,300 in September, INR 93,100 in October and INR 154,800 in November 2026. North revenue declined from INR 53,500 in September to INR 41,300 in October (-22.8%), contradicting the unsupported claim of 38% growth. Revenue throughout means completed orders only.

## File index
| File | Part / purpose |
|---|---|
| `README.md` | Overall project, tools, findings, index and assumptions |
| `sql/00_schema_and_seed.sql` | Part A schema and seed |
| `sql/q01.sql` | Part A pending orders |
| `sql/q02.sql` | Part A missing amounts |
| `sql/q03.sql` | Part A five biggest completed orders |
| `sql/q04.sql` | Part A target customer segment |
| `sql/q05.sql` | Part A headline KPIs |
| `sql/q06.sql` | Part A orders by status |
| `sql/q07.sql` | Part A strong products |
| `sql/q08.sql` | Part A customer profile by region |
| `sql/q09.sql` | Part A enriched order-level fact table; source for Part B |
| `sql/q10.sql` | Part A customers who never ordered |
| `sql/q11.sql` | Part A region/month report; evidence for Part D |
| `sql/q12.sql` | Part A product contribution tiers |
| `sql/q13.sql` | Part A rep performance against target; referenced in Part D prompt |
| `sql/d1_corrected.sql` | Part D corrected D1 query |
| `results/query_results.md` | Part A seed counts and query outputs; Part D D1 output |
| `data/orders_enriched.csv` | Part A q09 output, all 90 orders |
| `data/orders_clean.csv` | Part B cleaned completed orders; Part C data source |
| `docs/spreadsheet_notes.md` | Part B formulas, pivots, validation and reconciliation |
| `docs/dashboard_spec.md` | Part C KPIs, charts, narrative and reconciliation |
| `docs/ai_log.md` | Part D prompts, defects, verification protocol and skeptical analysis |

## Assumptions and scope
- SQLite was selected from the permitted dialects and executed against the seed embedded in the brief.
- Google Sheets is the selected spreadsheet tool; the repository includes the CSV exports and documented formulas, not a workbook.
- Tableau Public was not built or published; the brief permits a text-only dashboard specification.
- Revenue means `SUM(amount)` for `status = 'completed'`; pending and disputed orders are excluded.
- Completed rows are sorted by `amount` descending, then `order_id` ascending for deterministic ties.
- Names are cleaned in separate columns using `TRIM` and `PROPER`, leaving original names auditable.
- Missing amounts are not imputed; the three missing amounts belong to pending orders.
