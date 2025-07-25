#ifndef FILE_INTEGRITY_H
#define FILE_INTEGRITY_H

#include <string>

class FileIntegrity {
public:
    FileIntegrity();
    bool verifySignature();
    bool detectTampering();

private:
    std::string computeFileHash(const std::string& filePath);
};

#endif // FILE_INTEGRITY_H
