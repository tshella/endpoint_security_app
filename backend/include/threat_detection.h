#ifndef THREAT_DETECTION_H
#define THREAT_DETECTION_H

#include <string>

class ThreatDetection {
public:
    ThreatDetection();
    ~ThreatDetection();
    
    bool detectThreat(const std::string& behaviorData);
    void loadModel(const std::string& modelPath);

private:
    // Model variables, e.g., a TensorFlow Lite interpreter
};

#endif // THREAT_DETECTION_H
