//
//  NSString+AES.h
//  seafishing2
//
//  Created by LiuHuanQing on 15/7/27.
//  Copyright (c) 2015年 Szfusion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)
- (NSString *)MD5String;
- (NSString *)MD5String16;

+ (NSString *)MD5HexDigest:(NSString*)input;

@end
