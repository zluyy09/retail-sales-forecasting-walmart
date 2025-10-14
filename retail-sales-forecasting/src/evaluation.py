import numpy as np
from .utils import wape, smape, mase

def evaluate(y_true, y_pred, metrics=('wape','smape','mase')):
    out = {}
    for m in metrics:
        if m=='wape': out[m] = wape(y_true, y_pred)
        if m=='smape': out[m] = smape(y_true, y_pred)
        if m=='mase': out[m] = mase(y_true, y_pred)
    return out
