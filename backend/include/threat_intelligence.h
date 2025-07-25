#ifndef THREAT_INTELLIGENCE_H
#define THREAT_INTELLIGENCE_H

#include <string>
#include <vector>

class ThreatIntelligence {
public:
    ThreatIntelligence();
    bool fetchLatestThreats();
    bool isThreatKnown(const std::string& hash);

private:
    std::vector<std::string> knownThreatHashes;
    void updateThreatDatabase(const std::vector<std::string>& newThreats);
};

#endif // THREAT_INTELLIGENCE_H
