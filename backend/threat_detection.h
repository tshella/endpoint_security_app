#ifndef THREAT_DETECTION_H
#define THREAT_DETECTION_H

#include <string>
#include <vector>

class ThreatDetection {
public:
    bool detectThreat(const std::string& data);

private:
    bool patternBasedDetection(const std::string& data);
    bool behavioralAnalysis(const std::string& data);
    bool heuristicAnalysis(const std::string& data);
    void alertAdmin(const std::string& message);
};

#endif // THREAT_DETECTION_H
