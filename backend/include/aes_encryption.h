#ifndef AES_ENCRYPTION_H
#define AES_ENCRYPTION_H

#include <string>

class AesEncryption {
public:
    AesEncryption();
    ~AesEncryption();

    std::string encryptAES(const std::string& data, const unsigned char* key, const unsigned char* iv);
    std::string decryptAES(const std::string& encryptedData, const unsigned char* key, const unsigned char* iv);

private:
    void handleErrors();
};

#endif // AES_ENCRYPTION_H
