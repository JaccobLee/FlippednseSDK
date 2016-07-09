//
//  NSData+AES256.h
//  yyl
//
//  Created by zhaoyk10 on 12-9-12.
//  Copyright (c) 2012年 Szfusion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SF_AESMode) {
    SFAESModeECB		= 1,
	SFAESModeCBC		= 2,
	SFAESModeCFB		= 3,
};

typedef NS_ENUM(NSInteger, SF_AESPadding) {
    SFNoPadding			= 0,
	SFPKCS7Padding		= 1,
};

typedef NS_ENUM(NSInteger, SF_AESkeyLength) {
    SFAES128        = 0,
	SFAES256		= 1,
};

NSData* dataWithHexString(NSString *hexString);

@interface NSData (AES)

- (NSData *)MD5;
- (NSData *)SHA1;

/*
 key 长度必须与 keyLength 匹配
 */
- (NSData *)AESUseMode:(SF_AESMode)mode
               padding:(SF_AESPadding)padding
               WithKey:(NSString *)key
             keyLength:(SF_AESkeyLength)keyLength
                    IV:(NSString *)iv
             isEncrypt:(BOOL)isEncrypt;

- (NSString *)toHexString;


@end
