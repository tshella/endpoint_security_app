#include "threat_intelligence.h"
#include <iostream>
#include <cpprest/http_client.h>

ThreatIntelligence::ThreatIntelligence() {
    fetchLatestThreats();
}

bool ThreatIntelligence::fetchLatestThreats() {
    // Simulate fetching threat hashes from an API
    std::vector<std::string> fetchedThreats = { "abc123", "def456", "ghi789" };
    updateThreatDatabase(fetchedThreats);
    return true;
}

bool ThreatIntelligence::isThreatKnown(const std::string& hash) {
    return std::find(knownThreatHashes.begin(), knownThreatHashes.end(), hash) != knownThreatHashes.end();
}

void ThreatIntelligence::updateThreatDatabase(const std::vector<std::string>& newThreats) {
    knownThreatHashes.insert(knownThreatHashes.end(), newThreats.begin(), newThreats.end());
}
