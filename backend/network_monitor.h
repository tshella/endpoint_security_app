#ifndef NETWORK_MONITOR_H
#define NETWORK_MONITOR_H

#include <string>
#include <unordered_set>

#ifdef _WIN32
#include <winsock2.h>
#include <pcap.h> // For packet capturing
typedef unsigned char u_char;
typedef unsigned int u_int;
#else
#include <sys/time.h>
#include <pcap.h>
#endif

class NetworkMonitor {
public:
    NetworkMonitor();

    void monitorTraffic();
    bool checkURLReputation(const std::string& url);
    void inspectTraffic();

private:
    static const std::unordered_set<std::string> suspiciousIPs;
    static const std::unordered_set<int> abnormalPorts;

    // Callback function used by pcap to handle each packet
    static void packetHandler(u_char* userData, const struct pcap_pkthdr* pkthdr, const u_char* packet);

    bool isSuspiciousIP(const std::string& ip) const;
    bool isAbnormalPort(int port) const;
    bool containsMaliciousPattern(const u_char* payload, int len) const;
    void logSuspiciousActivity(const std::string& srcIP, const std::string& dstIP, const std::string& message) const;

    void analyzePacket(const unsigned char* packet, int length);
    void alertAdmin(const std::string& message) const;
};

#endif // NETWORK_MONITOR_H
