//
//  UIColor+Hex.m
//  Yiqiba
//
//  Created by jacob on 15/9/6.
//  Copyright (c) 2015年 Jacob. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
    
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)colorMainBg
{
    return [UIColor colorWithHex:0xeeeeee alpha:1.0];
}

+ (UIColor *)colorSeparateLine
{
    return [UIColor colorWithHex:0xe7e7e7 alpha:1.0];
}

+ (UIColor *)colorNaviLine
{
    return [UIColor colorWithHex:0xdddddd alpha:1.0];
}

+ (UIColor *)colorNaviBg
{
    return [UIColor colorWithHex:0xf8f8f8 alpha:1.0];
}

+ (UIColor *)colorFontDark
{
    return [UIColor colorWithHex:0x333333 alpha:1.0];
}

+ (UIColor *)colorFontMiddle
{
    return [UIColor colorWithHex:0x666666 alpha:1.0];
}

+ (UIColor *)colorFontLight
{
    return [UIColor colorWithHex:0xa5a5a5 alpha:1.0];
}

@end
