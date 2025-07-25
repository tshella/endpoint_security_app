#ifndef BREACH_NOTIFIER_H
#define BREACH_NOTIFIER_H

#include <string>
#include <vector>
#include <chrono>

class BreachNotifier {
public:
    // Constructor and Destructor
    BreachNotifier();
    ~BreachNotifier();

    // Sends a breach notification to the appropriate channel
    void notify(const std::string& message);

    // Sets the threshold for sending notifications
    void setNotificationThreshold(int threshold, std::chrono::seconds timeFrame);

    // Logs the notification
    void logNotification(const std::string& message);

private:
    // Helper function to format the message with a timestamp
    std::string formatMessage(const std::string& message) const;

    // Helper function to check if the notification threshold is exceeded
    bool isThresholdExceeded();

    // Tracks the recent notification timestamps for threshold checking
    std::vector<std::chrono::steady_clock::time_point> recentNotifications;

    int notificationThreshold;             // Max notifications within the specified timeframe
    std::chrono::seconds timeFrame;        // Timeframe for evaluating the notification threshold
};

#endif // BREACH_NOTIFIER_H
