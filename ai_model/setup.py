from setuptools import setup, find_packages

setup(
    name="threat_intelligence",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        "pandas",
        "scikit-learn",
        "flask"
    ],
)
