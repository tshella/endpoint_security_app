import requests
import time
from src.config import VIRUSTOTAL_API_KEY, VIRUSTOTAL_BASE_URL, IBM_XFORCE_API_KEY, IBM_XFORCE_API_SECRET, IBM_XFORCE_BASE_URL

# VirusTotal API client
def fetch_virustotal_data(indicator, indicator_type="url"):
    url = f"{VIRUSTOTAL_BASE_URL}/{indicator_type}/{indicator}"
    headers = {"x-apikey": VIRUSTOTAL_API_KEY}

    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    elif response.status_code == 429:  # Rate limit exceeded
        time.sleep(15)
        return fetch_virustotal_data(indicator, indicator_type)
    else:
        print(f"VirusTotal Error: {response.status_code} - {response.text}")
        return None

# IBM X-Force API client
def fetch_xforce_data(indicator, indicator_type="url"):
    url = f"{IBM_XFORCE_BASE_URL}/{indicator_type}/{indicator}"
    auth = (IBM_XFORCE_API_KEY, IBM_XFORCE_API_SECRET)
    response = requests.get(url, auth=auth)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"IBM X-Force Error: {response.status_code} - {response.text}")
        return None
