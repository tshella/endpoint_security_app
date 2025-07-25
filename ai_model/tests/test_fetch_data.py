import unittest
from src.fetch_data import fetch_and_save_data

class TestFetchData(unittest.TestCase):
    def test_fetch_and_save_data(self):
        fetch_and_save_data("example.com", "domain")
        # Add assertions to validate the saved file
