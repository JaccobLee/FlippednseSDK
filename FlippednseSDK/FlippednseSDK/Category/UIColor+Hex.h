//
//  UIColor+Hex.h
//  Yiqiba
//
//  Created by jacob on 15/9/6.
//  Copyright (c) 2015年 Jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorMainBg;
+ (UIColor *)colorSeparateLine;
+ (UIColor *)colorNaviLine;
+ (UIColor *)colorNaviBg;
+ (UIColor *)colorFontDark;
+ (UIColor *)colorFontMiddle;
+ (UIColor *)colorFontLight;

@end
