#ifndef UTILITY_H
#define UTILITY_H

#include <string>

// Generates a random password of specified length.
// - length: The desired length of the generated password.
// - includeSpecialChars: If true, includes special characters in the password (default is true).
// Returns: A randomly generated password as a string.
std::string generateRandomPassword(size_t length, bool includeSpecialChars = true);

#endif // UTILITY_H
