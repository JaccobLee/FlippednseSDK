//
//  NSString+AES.m
//  seafishing2
//
//  Created by LiuHuanQing on 15/7/27.
//  Copyright (c) 2015年 Szfusion. All rights reserved.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (AES)

//- (NSString *)MD5String
//{
//    const char *cStr = [self UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, self.length, digest );
//    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [result appendFormat:@"%02x", digest[i]];
//    
//    return result;
//}

- (NSString *)MD5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//大写验证码
+ (NSString *)MD5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        //        [ret appendFormat:@"%02x",result[i]];
        [ret appendFormat:@"%02X",result[i]];
    }
    
    return ret;
}

- (NSString *)MD5String16
{
    return [[[self MD5String] substringToIndex:24] substringFromIndex:8];
}

@end
