#include "anomaly_detector.h"
#include <cmath>
#include <numeric>
#include <iostream>

AnomalyDetector::AnomalyDetector(double threshold, size_t windowSize)
    : threshold(threshold), windowSize(windowSize) {}

// Detects anomalies based on activity data
bool AnomalyDetector::detectAnomaly(const std::string& userActivity) {
    int score = calculateActivityScore(userActivity);

    // Add the score to the activity data
    activityData.push_back(score);

    // Maintain a sliding window of recent activity
    if (activityData.size() > windowSize) {
        activityData.erase(activityData.begin()); // Remove oldest score
    }

    // Ensure sufficient data for statistical analysis
    if (activityData.size() < 2) {
        std::cout << "[AnomalyDetector] Insufficient data for anomaly detection.\n";
        return false;
    }

    // Calculate the standard deviation
    double stdDeviation = calculateStandardDeviation(activityData);

    std::cout << "[AnomalyDetector] Score: " << score
        << ", Std Dev: " << stdDeviation
        << ", Threshold: " << threshold
        << ", Anomaly: " << (stdDeviation > threshold ? "Yes" : "No") << "\n";

    // Return whether the standard deviation exceeds the threshold
    return stdDeviation > threshold;
}

// Converts user activity into an integer score
int AnomalyDetector::calculateActivityScore(const std::string& userActivity) {
    // Simple heuristic: score is based on character types
    int score = 0;
    for (char c : userActivity) {
        if (std::isalpha(c)) score += 2;          // Letters contribute more
        else if (std::isdigit(c)) score += 1;     // Numbers contribute less
        else score += 3;                          // Special characters contribute the most
    }
    return score;
}

// Calculates the standard deviation of a vector of integers
double AnomalyDetector::calculateStandardDeviation(const std::vector<int>& values) {
    double mean = std::accumulate(values.begin(), values.end(), 0.0) / values.size();
    double variance = 0.0;

    for (int value : values) {
        variance += std::pow(value - mean, 2);
    }

    variance /= values.size();
    return std::sqrt(variance);
}
