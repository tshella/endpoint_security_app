#ifndef NETWORK_MONITOR_H
#define NETWORK_MONITOR_H

#include <string>

class NetworkMonitor {
public:
    NetworkMonitor();
    ~NetworkMonitor();
    
    bool checkURLReputation(const std::string& url);
    void inspectTraffic();

private:
    // Implement DPI functions
};

#endif // NETWORK_MONITOR_H
