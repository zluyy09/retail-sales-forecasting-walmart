from pathlib import Path
import pandas as pd

def load_raw(path='../data/raw'):
    p = Path(path)
    train = pd.read_csv(p/'train.csv')
    stores = pd.read_csv(p/'stores.csv')
    features = pd.read_csv(p/'features.csv')
    for df in (train, features):
        df['Date'] = pd.to_datetime(df['Date'])
    return train, stores, features
