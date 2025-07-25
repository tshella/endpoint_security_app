#include "threat_detection.h"
#include <iostream>
#include <vector>
#include <string>
#include <unordered_set>
#include <regex>
#include <numeric>
#include <cmath>

// Known threat patterns for pattern-based detection
const std::unordered_set<std::string> knownThreatPatterns = {
    "malicious_pattern1", "malicious_pattern2", "<script>", "eval("
};

// Helper function to calculate standard deviation
double calculateStandardDeviation(const std::vector<int>& values) {
    double mean = std::accumulate(values.begin(), values.end(), 0.0) / values.size();
    double variance = 0.0;
    for (int value : values) {
        variance += std::pow(value - mean, 2);
    }
    variance /= values.size();
    return std::sqrt(variance);
}

// Main threat detection function
bool ThreatDetection::detectThreat(const std::string& data) {
    int score = 0;

    // Pattern-Based Detection
    if (patternBasedDetection(data)) {
        alertAdmin("Pattern-based threat detected.");
        score += 3;
    }

    // Behavioral Analysis
    if (behavioralAnalysis(data)) {
        alertAdmin("Behavioral anomaly detected in data.");
        score += 2;
    }

    // Heuristic Analysis
    if (heuristicAnalysis(data)) {
        alertAdmin("Heuristic-based threat detected.");
        score += 1;
    }

    return score >= 3; // Trigger alert if cumulative score is high enough
}

// Pattern-Based Detection
bool ThreatDetection::patternBasedDetection(const std::string& data) {
    for (const auto& pattern : knownThreatPatterns) {
        if (data.find(pattern) != std::string::npos) {
            std::cout << "Detected known threat pattern: " << pattern << std::endl;
            return true;
        }
    }
    return false;
}

// Behavioral Analysis
bool ThreatDetection::behavioralAnalysis(const std::string& data) {
    std::vector<int> keywordFrequencies;
    for (const auto& pattern : knownThreatPatterns) {
        int frequency = 0;
        size_t pos = data.find(pattern);
        while (pos != std::string::npos) {
            frequency++;
            pos = data.find(pattern, pos + 1);
        }
        keywordFrequencies.push_back(frequency);
    }

    double stdDeviation = calculateStandardDeviation(keywordFrequencies);
    const double threshold = 2.0;
    return stdDeviation > threshold;
}

// Heuristic Analysis
bool ThreatDetection::heuristicAnalysis(const std::string& data) {
    if (std::regex_search(data, std::regex(R"(<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>)")) ||
        std::regex_search(data, std::regex(R"(eval\()"))) {
        return true;
    }
    return false;
}

// Alerting system
void ThreatDetection::alertAdmin(const std::string& message) {
    std::cout << "ALERT: " << message << std::endl;
}
