#ifndef VPN_ENCRYPTION_H
#define VPN_ENCRYPTION_H

#include <string>
#include <openssl/evp.h>

class VpnEncryption {
public:
    VpnEncryption();
    ~VpnEncryption();

    void initialize(unsigned char* key, unsigned char* iv);
    std::string encrypt(const std::string& data);
    std::string decrypt(const std::string& data);

private:
    EVP_CIPHER_CTX* encryptCtx;
    EVP_CIPHER_CTX* decryptCtx;
};

#endif // VPN_ENCRYPTION_H
