//
//  EncryptUtil.h
//  ienglish
//
//  Created by xhw on 15/12/24.
//  Copyright © 2015年 JXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptUtil : NSObject

+ (NSString *)md5_32:(NSString *)input;

+ (NSString *)md5_16:(NSString *)input;

+ (NSString *)decryptWithText:(NSString *)sText;

@end
