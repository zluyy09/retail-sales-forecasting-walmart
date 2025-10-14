# Modeling & Backtesting Summary

## Problem Definition
- Forecast `Weekly_Sales` for each `(Store, Dept)` one to several weeks ahead.
- Prioritize accuracy during holiday weeks and high‑variance departments.

## Baselines
- Naive (last week), Seasonal naive (last year same week), Moving Average.

## Candidate Models
1. **SARIMAX** per series with exogenous regressors (holidays, markdowns, macro).
2. **Prophet** with regressors for seasonality/holiday handling and change points.
3. **Global GBM** (XGBoost/LightGBM) across all series with time‑aware features.

## Validation
- **Rolling Origin** (expand‑window, fixed horizon) with 5+ folds.
- Metrics: WAPE (a.k.a. MAE / sum(actual)), sMAPE, MASE, Bias.

## Findings (template)
- Global GBM dominates in non‑seasonal departments; SARIMAX competitive where strong periodicity exists.
- Combining forecasts via weighted average reduces holiday-week variance.

## Business KPIs
- Translate forecast error to **service level** and **safety stock** deltas.
- Compute **Promo ROI**: incremental margin during promo net of post‑promo dip.

## Next Steps
- Hierarchical reconciliation (bottom‑up) to align Dept → Store totals.
- Scenario planning UI for planners (promo timing/amount, holiday toggles).
