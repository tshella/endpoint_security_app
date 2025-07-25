import pandas as pd
from src.api_clients import fetch_virustotal_data, fetch_xforce_data

def fetch_and_save_data(indicator, indicator_type="url"):
    # Fetch data from APIs
    virustotal_data = fetch_virustotal_data(indicator, indicator_type)
    xforce_data = fetch_xforce_data(indicator, indicator_type)

    # Process and save
    if virustotal_data:
        vt_df = pd.DataFrame([{
            "source": "VirusTotal",
            "indicator": indicator,
            "malicious": virustotal_data.get("attributes", {}).get("last_analysis_stats", {}).get("malicious", 0)
        }])
        vt_df.to_csv("data/raw/virustotal_data.csv", mode="a", index=False, header=False)

    if xforce_data:
        xf_df = pd.DataFrame([{
            "source": "IBM X-Force",
            "indicator": indicator,
            "malicious": xforce_data.get("score", 0)
        }])
        xf_df.to_csv("data/raw/xforce_data.csv", mode="a", index=False, header=False)
