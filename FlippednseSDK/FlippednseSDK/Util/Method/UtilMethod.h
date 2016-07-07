//
//  UtilMethod.h
//  iEnglish
//
//  Created by JacobLi on 3/2/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EncryptUtil.h"
#import "ResourceDataUtil.h"
#import "AppStartManager.h"

NSMutableDictionary *AddSignWithRequestParameters(NSDictionary *dic);
NSString *SignWithRequestParameters(NSDictionary *dic);
NSString *StringValueIn100FromInt(int i);


@interface UtilMethod : NSObject
+(CGFloat)getHeightWithWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font;
+(CGFloat)getWidthWithHeight:(CGFloat)height text:(NSString *)text font:(UIFont *)font;
+(NSString *)deviceUUId;
+(BOOL)deviceIsIphone;
@end
