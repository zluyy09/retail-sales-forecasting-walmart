import pandas as pd, numpy as np

def wape(y_true, y_pred):
    return (abs(y_true - y_pred).sum()) / (abs(y_true).sum() + 1e-9)

def smape(y_true, y_pred):
    return 100/len(y_true) * np.sum(2*np.abs(y_pred - y_true) / (np.abs(y_true)+np.abs(y_pred)+1e-9))

def mase(y_true, y_pred, m=52):
    d = np.abs(y_true[m:] - y_true[:-m]).mean()
    return np.abs(y_true - y_pred).mean() / (d + 1e-9)
