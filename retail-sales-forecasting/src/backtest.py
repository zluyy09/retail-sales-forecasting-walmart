import numpy as np, pandas as pd
from lightgbm import LGBMRegressor
from .evaluation import evaluate

def rolling_origin(df, X_cols, y_col='Weekly_Sales', step_days=7, horizon_days=28, start_frac=0.5, end_frac=0.9):
    dates = sorted(df['Date'].unique())
    scores = []
    for split in dates[int(len(dates)*start_frac): int(len(dates)*end_frac): 5]:
        tr = df['Date'] <= split
        va = (df['Date'] > split) & (df['Date'] <= split + np.timedelta64(horizon_days,'D'))
        tr_df, va_df = df[tr].dropna(subset=X_cols+[y_col]), df[va].dropna(subset=X_cols+[y_col])
        if len(va_df) < 1000: 
            continue
        model = LGBMRegressor(n_estimators=1000, learning_rate=0.03, num_leaves=64, random_state=42)
        model.fit(tr_df[X_cols], tr_df[y_col])
        pred = model.predict(va_df[X_cols])
        scores.append(evaluate(va_df[y_col].values, pred))
    return pd.DataFrame(scores)
