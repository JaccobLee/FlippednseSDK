//
//  NSDictionary+safeObjectForKeyValue.m
//  MobileAssistant
//
//  Created by rqst on 14-3-26.
//  Copyright (c) 2014年 com.rqst. All rights reserved.
//

#import "NSDictionary+safeObjectForKeyValue.h"
//#define checkNull(__X__)   (__X__) == [NSNull null] || (__X__) == nil ? @"[]" : [NSString stringWithFormat:@"%@", (__X__)]
#define checkNull(__X__)      (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

@implementation NSDictionary (safeObjectForKeyValue)

- (NSString *)safeObjectForKey:(id)key
{
    return checkNull([self objectForKey:key]);
}


@end
