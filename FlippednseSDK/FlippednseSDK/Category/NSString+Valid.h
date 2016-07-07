/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import <Foundation/Foundation.h>

@interface NSString (Valid)
-(BOOL)isChinese;

//验证手机
+ (BOOL) validateMobile:(NSString *)mobile;
//验证邮箱
+ (BOOL)validateEmail:(NSString *)email;

//是否只包含 compareStr 里的字符
+(BOOL)validateIsFitText:(NSString *)isFitStr compareStr:(NSString *)compareStr;
//验证是否是纯数字
+(BOOL)validateNumber:(NSString*)number;

//验证密码是否符合格式
+(BOOL)validatePassword:(NSString *)passwordStr;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end
