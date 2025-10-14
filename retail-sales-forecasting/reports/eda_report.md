# EDA Summary & Insights

## Data Coverage & Granularity
- Weekly data across multiple years, keyed by `(Store, Dept, Date)`.
- Join keys validated: all train rows match `stores.csv` and `features.csv`.
- Missingness: `MarkDown1..5` are sparse and non‑random (promotions concentrated in specific stores/periods).
- `IsHoliday` marks extended holiday weeks (e.g., Super Bowl, Labor Day, Thanksgiving, Christmas).

**Business implication**: Forecast accuracy is hardest during holiday/promo peaks; we will evaluate models with special emphasis on holiday weeks to reduce stockouts or overstaffing.

## Seasonality, Trend, and Change Points
- Many departments show yearly seasonality and occasional level shifts.
- Store traffic proxies (via baseline sales) differ by `Store Type` and `Size`.
- STL decomposition suggests strong seasonal amplitude in departments like seasonal goods and groceries.

**Action**: Use hierarchical features (Store Type, Size) and seasonality flags; allow model to learn **heterogeneous** patterns by store.

## Macroeconomic & Local Effects
- `CPI` and `Unemployment` correlate with sales in price‑sensitive departments (negative elasticity during high CPI).
- `Temperature` has **nonlinear** relationship (extremes reduce traffic).

**Action**: Include spline‑like or binned Temperature, interact Temperature×Dept category.

## Promotions & Markdown Effects
- Markdown features show **lead/lag effects** (lift often starts the week before and decays after). 
- Effects vary by department; in some departments promotions cannibalize future weeks.

**Action**: Create *lag/lead windows* and rolling aggregates; evaluate promo ROI by department and avoid over‑promotion where post‑promo dips are severe.

## Cross‑Store Heterogeneity
- WAPE by store spans a wide range; tail stores drive overall error.
- Clustering stores by seasonal profile reveals groups (college‑town vs suburb vs tourist corridor).

**Action**: Consider model ensembling with store‑cluster‑specific hyperparameters or features.

## Anomalies
- Outliers align with extreme holidays/weather or data issues.
- Winsorization or robust loss can stabilize global model training.

---

## Key Takeaways for the Business
1. **Holiday‑driven volatility** is the biggest risk to service level; focus modeling and safety stock here.
2. **Markdown timing** matters more than amount in several departments; best practice is a **staggered lead**.
3. **Macro sensitivity** varies by category; essential goods less elastic than discretionary.
4. **Store segmentation** improves accuracy and enables targeted actions (labor, inventory, promo).
