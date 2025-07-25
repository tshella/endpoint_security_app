import pandas as pd

def preprocess_data():
    # Combine data from VirusTotal and X-Force
    vt_data = pd.read_csv("data/raw/virustotal_data.csv")
    xf_data = pd.read_csv("data/raw/xforce_data.csv")
    combined = pd.concat([vt_data, xf_data])

    # Feature engineering
    combined["malicious_score"] = combined["malicious"]
    combined["source_encoded"] = combined["source"].factorize()[0]

    # Save to processed dataset
    combined.to_csv("data/processed/training_data.csv", index=False)
