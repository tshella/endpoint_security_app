#include "breach_notifier.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <chrono>

// Constructor
BreachNotifier::BreachNotifier() : notificationThreshold(5), timeFrame(std::chrono::seconds(300)) {}

// Destructor (added to resolve the linker error)
BreachNotifier::~BreachNotifier() {
    // Cleanup code if necessary (not strictly needed here)
}

// Sets the notification threshold and time frame for notifications
void BreachNotifier::setNotificationThreshold(int threshold, std::chrono::seconds timeFrame) {
    this->notificationThreshold = threshold;
    this->timeFrame = timeFrame;
}

// Formats the notification message with a timestamp using C++20 time facilities
std::string BreachNotifier::formatMessage(const std::string& message) const {
    auto now = std::chrono::system_clock::now();
    auto time_t_now = std::chrono::system_clock::to_time_t(now);
    struct tm local_tm;
    localtime_s(&local_tm, &time_t_now);  // Use localtime_s for thread safety

    std::ostringstream oss;
    oss << "[Breach Detected - " << std::put_time(&local_tm, "%Y-%m-%d %H:%M:%S") << "] ";
    oss << message;
    return oss.str();
}

// Logs the notification to a file
void BreachNotifier::logNotification(const std::string& message) {
    std::ofstream logFile("breach_notifications.log", std::ios::app);
    if (logFile.is_open()) {
        logFile << message << std::endl;
        logFile.close();
    }
    else {
        std::cerr << "[BreachNotifier] Failed to open log file for writing.\n";
    }
}

// Checks if the notification threshold has been exceeded
bool BreachNotifier::isThresholdExceeded() {
    auto now = std::chrono::steady_clock::now();

    // Remove outdated notifications
    while (!recentNotifications.empty() && (now - recentNotifications.front() > timeFrame)) {
        recentNotifications.erase(recentNotifications.begin());
    }

    return recentNotifications.size() >= notificationThreshold;
}

// Main notification function
void BreachNotifier::notify(const std::string& message) {
    if (!isThresholdExceeded()) {
        recentNotifications.push_back(std::chrono::steady_clock::now());
        std::string formattedMessage = formatMessage(message);
        logNotification(formattedMessage);
        std::cout << formattedMessage << std::endl;
    }
    else {
        std::cerr << "[BreachNotifier] Notification threshold exceeded. Suppressing notification.\n";
    }
}
