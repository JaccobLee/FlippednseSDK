//
//  NSDictionary+safeObjectForKeyValue.h
//  MobileAssistant
//
//  Created by rqst on 14-3-26.
//  Copyright (c) 2014年 com.rqst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safeObjectForKeyValue)

- (NSString *)safeObjectForKey:(id)key;

@end
