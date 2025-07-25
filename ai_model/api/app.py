from flask import Flask, request, jsonify
import pickle

app = Flask(__name__)

@app.route("/predict", methods=["POST"])
def predict():
    data = request.json
    features = [data['hash_length']]
    with open("models/threat_model.pkl", "rb") as f:
        model = pickle.load(f)
    prediction = model.predict([features])
    return jsonify({"is_threat": bool(prediction[0])})

if __name__ == "__main__":
    app.run(debug=True)
