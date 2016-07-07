//
//  NSData+AES256.m
//  yyl
//
//  Created by zhaoyk10 on 12-9-12.
//  Copyright (c) 2012年 Szfusion. All rights reserved.
//

#import "NSData+AES.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
//#import "DateUtil.h"

static inline uint8_t hexchar2int(unichar c) {
    if (c >= '0' && c <= '9') {
        return c - '0';
    } else if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    } else {
        // not a hex char
        return -1;
    }
}

NSData* dataWithHexString(NSString *hexString) {
    NSUInteger length = [hexString length] / 2;
    NSMutableData *mdata = [NSMutableData dataWithCapacity: length];
    for (int i = 0; i < length; ++i) {
        unichar c1 = [hexString characterAtIndex:i * 2], c2 = [hexString characterAtIndex:(i * 2 + 1)];
        uint8_t i1 = hexchar2int(c1), i2 = hexchar2int(c2);
        Byte b = ((i1 & 0x0F) << 4) | (i2 & 0x0F);
        [mdata appendBytes:&b length:1];
    }
    return [NSData dataWithData:mdata];
}

@implementation NSData (AES)

- (NSData *)MD5 {
    uint8_t result[16];
    CC_MD5(self.bytes, [self length], result);

    return [NSData dataWithBytes:&result length:16];
}

- (NSData *)SHA1 {
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, self.length, digest);
    
    return [NSData dataWithBytes:&digest length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *)AESUseMode:(SF_AESMode)mode
               padding:(SF_AESPadding)padding
               WithKey:(NSString *)key
             keyLength:(SF_AESkeyLength)_keyLength
                    IV:(NSString *)iv
             isEncrypt:(BOOL)isEncrypt {
    
    NSData *keyData, *ivData;
    size_t keyLength = 0;
    
    if (_keyLength == SFAES128) {
        keyLength = kCCKeySizeAES128;
    } else if (_keyLength == SFAES256) {
        keyLength = kCCKeySizeAES256;
    } else {
        NSAssert1(NO, @"keyLength error: %d", _keyLength);
    }
    char keyPtr[keyLength + 1], ivPtr[kCCBlockSizeAES128 + 1];
    size_t dataLength;
    
    size_t bufferSize;
    void *buffer;
    
    BOOL useIv;
    
    CCCryptorRef cccryptoref;
    CCCryptorStatus cryptStatus;
    size_t numberUpdated, numberFinal;
    
    useIv = (iv != nil);
    dataLength = [self length];
    if (dataLength == 0) {
        return nil;
    }
    
    keyData = dataWithHexString(key);
    ivData = dataWithHexString(iv);
    NSAssert2([keyData length] == keyLength, @"key length error, should %lu, now: %u byte.", keyLength, [keyData length]);
    if (useIv) {
        NSAssert1([ivData length] == kCCBlockSizeAES128, @"AES iv must 128bit, now: %u byte", [ivData length]);
    }
    memset(keyPtr, 0, sizeof(keyPtr));
    [keyData getBytes:&keyPtr];
    
    if (useIv) {
        memset(ivPtr, 0, sizeof(ivPtr));
        [ivData getBytes:&ivPtr];
    }
    
    cryptStatus = CCCryptorCreateWithMode(isEncrypt ? kCCEncrypt : kCCDecrypt,
                                          mode,
                                          kCCAlgorithmAES128,   // 128 指block size, 不是 key size
                                          padding,
                                          (useIv ? ivPtr : NULL),
                                          keyPtr,
                                          keyLength,
                                          NULL, 0, 0, 0,
                                          &cccryptoref);
    if (cryptStatus == kCCSuccess) {
        bufferSize = CCCryptorGetOutputLength(cccryptoref, dataLength, YES);
        buffer = malloc(bufferSize);
        
        cryptStatus = CCCryptorUpdate(cccryptoref, [self bytes], dataLength, buffer, bufferSize, &numberUpdated);
        if (cryptStatus == kCCSuccess) {
            cryptStatus = CCCryptorFinal(cccryptoref, buffer + numberUpdated, bufferSize - numberUpdated, &numberFinal);
            
            CCCryptorRelease(cccryptoref);
            if (cryptStatus == kCCSuccess) {
                return [NSData dataWithBytesNoCopy:buffer length:(numberUpdated + numberFinal)];
            } else {
                DLOG(@"CCCryptorFinal error for %i", cryptStatus);
                free(buffer);
                return nil;
            }
        } else {
            DLOG(@"CCCryptorUpdate error for %i", cryptStatus);
            free(buffer);
            CCCryptorRelease(cccryptoref);
            return nil;
        }
    } else {
        DLOG(@"CCCryptorCreateWithMode error for %i", cryptStatus);
        return nil;
    }
}
# pragma mark -

- (NSString *)toHexString {
    unsigned char *bytes = (unsigned char *)self.bytes;
    NSMutableString *output = [[NSMutableString alloc] init];
    for (int i = 0; i < self.length; ++i) {
        [output appendFormat:@"%02x", bytes[i]];
    }
    return output;
}



@end
