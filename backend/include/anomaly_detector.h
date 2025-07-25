#ifndef ANOMALY_DETECTOR_H
#define ANOMALY_DETECTOR_H

#include <string>
#include <vector>

class AnomalyDetector {
public:
    AnomalyDetector(double threshold = 5.0, size_t windowSize = 10);

    // Detect anomaly in the user activity
    bool detectAnomaly(const std::string& userActivity);

private:
    // Helper methods
    double calculateStandardDeviation(const std::vector<int>& values);
    int calculateActivityScore(const std::string& userActivity);

    // Data members
    double threshold;
    size_t windowSize;
    std::vector<int> activityData;
};

#endif // ANOMALY_DETECTOR_H
