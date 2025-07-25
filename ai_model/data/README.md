# Threat Intelligence System

This project leverages AI/ML to identify, predict, and prevent security threats based on known indicators like hashes, IPs, and domains.

## Features
- AI/ML-based threat detection and classification
- REST API for real-time threat detection
- Integration with existing threat intelligence feeds

## Setup Instructions
1. Install dependencies: `pip install -r requirements.txt`
2. Train the model: `python src/train_model.py`
3. Start the API: `python api/app.py`
4. Run tests: `pytest tests/`

## Directory Structure
- `data`: Contains training datasets.
- `models`: Saved models.
- `notebooks`: Jupyter notebooks for exploration.
- `src`: Core application logic.
- `api`: API endpoints.
- `tests`: Unit and integration tests.
