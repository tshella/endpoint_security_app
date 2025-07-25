#include <random>
#include <string>
#include <iostream>

std::string generateRandomPassword(size_t length, bool includeSpecialChars = true) {
    const std::string upperChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const std::string lowerChars = "abcdefghijklmnopqrstuvwxyz";
    const std::string numbers = "0123456789";
    const std::string specialChars = "!@#$%^&*()-_=+[]{};:,.<>?";

    // Combine all character types into one pool based on options
    std::string charPool = upperChars + lowerChars + numbers;
    if (includeSpecialChars) {
        charPool += specialChars;
    }

    std::random_device rd;
    std::mt19937 generator(rd());
    std::uniform_int_distribution<> distribution(0, charPool.size() - 1);

    std::string password;
    for (size_t i = 0; i < length; ++i) {
        password += charPool[distribution(generator)];
    }

    return password;
}
