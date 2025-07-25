import unittest
from src.api_clients import fetch_virustotal_data, fetch_xforce_data

class TestAPIClients(unittest.TestCase):
    def test_fetch_virustotal_data(self):
        result = fetch_virustotal_data("example.com", "domain")
        self.assertIsNotNone(result)

    def test_fetch_xforce_data(self):
        result = fetch_xforce_data("example.com", "domain")
        self.assertIsNotNone(result)
