import pandas as pd
from sklearn.ensemble import RandomForestClassifier
import pickle

def train_model(data_path, model_path, vectorizer_path):
    data = pd.read_csv(data_path)
    X = data[['hash_length']]
    y = data['is_threat']
    model = RandomForestClassifier(random_state=42)
    model.fit(X, y)
    with open(model_path, 'wb') as f:
        pickle.dump(model, f)
    print("Model trained and saved.")
