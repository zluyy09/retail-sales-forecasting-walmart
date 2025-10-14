# Retail Sales Forecasting (Walmart Kaggle)

End‑to‑end project for multi‑store, multi‑department **weekly sales forecasting** using ARIMA/SARIMAX, Prophet, and XGBoost/LightGBM (global model) with deep EDA and business insights.

> Dataset: *Walmart Recruiting — Store Sales Forecasting* on Kaggle (files: `train.csv`, `stores.csv`, `features.csv`, `test.csv`).Includes weekly `Weekly_Sales` by `Store` and `Dept`, `IsHoliday`, `Temperature`, `Fuel_Price`, `CPI`, `Unemployment`, and promotion `MarkDown1..5` columns.

## Quick Start

1. Download the Kaggle dataset and place CSVs under `data/raw/`:
   - `data/raw/train.csv`
   - `data/raw/stores.csv`
   - `data/raw/features.csv`
   - (optional) `data/raw/test.csv`

2. Create a fresh environment and install deps:

```bash
python -m venv .venv && source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

3. Run the notebooks in order:
   - `notebooks/01_eda.ipynb`
   - `notebooks/02_feature_engineering_modeling.ipynb`
   - `notebooks/03_backtesting_and_model_selection.ipynb`
   - `notebooks/04_forecast_generation_and_kpis.ipynb`

4. Export `forecasts.csv` and feed curated extracts to Tableau in `dashboards/tableau/`.

## Project Highlights

- **Deep EDA**: Missingness, outliers, STL decomposition, holiday/promotion effects, cross‑store heterogeneity, macro (CPI/Unemployment) impact, and change points.
- **Feature Store**: Calendar/holiday features, promo lags/leads, rolling stats, hierarchical encodings, store meta.
- **Modeling**: SARIMAX per (Store, Dept), Prophet with regressors, and **global gradient boosting** with time‑aware CV.
- **Backtesting**: Rolling origin with *clean separation in time*; metrics: WAPE, sMAPE, MASE, bias.
- **Business KPIs**: Service level, safety stock approximation, promo ROI, markdown optimization, labor scheduling pointers.
- **Explainability**: SHAP for drivers; scenario analysis (“+10% Markdown during holidays”, “No promo”).

See `reports/eda_report.md` and `reports/model_report.md` for write‑ups
