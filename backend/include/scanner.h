#ifndef SCANNER_H
#define SCANNER_H

#include <string>

class Scanner {
public:
    void startScan();
    void stopScan();
    void realTimeScan();
    bool scanFile(const std::string& filePath);
    bool behavioralScan();
    bool sandboxAnalysis(const std::string& filePath); // Add sandboxAnalysis
    void alertAdmin(const std::string& message); // Add alertAdmin

private:
    bool patternBasedDetection(const std::string& fileContent);
    bool heuristicAnalysis(const std::string& fileContent);
};

#endif // SCANNER_H
