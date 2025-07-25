import pickle

def predict(features, model_path):
    with open(model_path, 'rb') as f:
        model = pickle.load(f)
    return model.predict([features])
