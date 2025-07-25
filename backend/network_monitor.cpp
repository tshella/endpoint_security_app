#include "network_monitor.h"
#include <iostream>
#include <fstream>
#include <pcap.h>

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
typedef unsigned char u_char;
typedef unsigned int u_int;
#else
#include <netinet/ip.h>
#include <netinet/tcp.h>
#endif

// Initialize static members
const std::unordered_set<std::string> NetworkMonitor::suspiciousIPs = {
    "192.168.0.10", "10.0.0.1"
};

const std::unordered_set<int> NetworkMonitor::abnormalPorts = { 21, 23, 25, 445, 1433, 3306 };

// Constructor definition to avoid linker error
NetworkMonitor::NetworkMonitor() {}

void NetworkMonitor::monitorTraffic() {
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_if_t* alldevs;

    if (pcap_findalldevs(&alldevs, errbuf) == -1) {
        std::cerr << "Error finding devices: " << errbuf << std::endl;
        return;
    }

    pcap_t* handle = pcap_open_live(alldevs->name, BUFSIZ, 1, 1000, errbuf);
    if (!handle) {
        std::cerr << "Error opening device: " << errbuf << std::endl;
        pcap_freealldevs(alldevs);
        return;
    }

    std::cout << "Monitoring traffic on " << alldevs->name << "..." << std::endl;
    pcap_loop(handle, 0, packetHandler, reinterpret_cast<u_char*>(this));
    pcap_freealldevs(alldevs);
}

void NetworkMonitor::packetHandler(u_char* userData, const struct pcap_pkthdr* pkthdr, const u_char* packet) {
    auto* monitor = reinterpret_cast<NetworkMonitor*>(userData);

#ifdef _WIN32
    std::string srcIP = "192.168.0.1";  // Placeholder IP for Windows
    std::string dstIP = "192.168.0.2";  // Placeholder IP for Windows
#else
    const struct ip* ipHeader = (struct ip*)(packet + 14);
    std::string srcIP = inet_ntoa(ipHeader->ip_src);
    std::string dstIP = inet_ntoa(ipHeader->ip_dst);
#endif

    if (monitor->isSuspiciousIP(srcIP) || monitor->isSuspiciousIP(dstIP)) {
        monitor->logSuspiciousActivity(srcIP, dstIP, "Suspicious IP detected");
    }
}

bool NetworkMonitor::isSuspiciousIP(const std::string& ip) const {
    return suspiciousIPs.find(ip) != suspiciousIPs.end();
}

bool NetworkMonitor::isAbnormalPort(int port) const {
    return abnormalPorts.find(port) != abnormalPorts.end();
}

void NetworkMonitor::logSuspiciousActivity(const std::string& srcIP, const std::string& dstIP, const std::string& message) const {
    std::ofstream logFile("network_monitor.log.txt", std::ios::app);
    if (logFile.is_open()) {
        logFile << "[ALERT] " << message << " | Source IP: " << srcIP << " -> Destination IP: " << dstIP << "\n";
        logFile.close();
    }
    else {
        std::cerr << "Failed to open log file for writing.\n";
    }
}
