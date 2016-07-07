//
//  UtilsBook.h
//  iEnglish
//
//  Created by 陈梦悦 on 16/6/1.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilsBook : NSObject

+(BOOL)checkTheBookIsExpiredWithBookCode:(NSString *)code;
/*
 *判断书本是否已经过期,需在判断已经购买的情况下调用
 *code: eid
 *bookIsExpired :过期返回Yes,未过期返回NO
 */
+(void)checkTheBookIsExpiredWithBookCode:(NSString *)code resultExpired:(void (^)(BOOL bookIsExpired))result;



+(void)clearBookExpiredState;
+(void)resetLocalBookStateOfExpired:(NSMutableArray *)arraySheme;
+(void)requestBookExpiredState;
/*
 *判断时间
 */
+(BOOL)compareTimeIsAfter:(NSString *)compareTime;
@end
