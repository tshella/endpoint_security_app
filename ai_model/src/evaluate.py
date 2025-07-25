import pandas as pd
from sklearn.metrics import classification_report
import pickle

def evaluate_model(data_path, model_path):
    data = pd.read_csv(data_path)
    X = data[['hash_length']]
    y = data['is_threat']
    with open(model_path, 'rb') as f:
        model = pickle.load(f)
    predictions = model.predict(X)
    print(classification_report(y, predictions))
