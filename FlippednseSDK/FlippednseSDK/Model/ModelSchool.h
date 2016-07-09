//
//  ModelSchool.h
//  iEnglish
//
//  Created by wj on 16/4/27.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelSchool : NSObject

@property (strong, nonatomic) NSString *schoolId;
@property (strong, nonatomic) NSString *schoolName;
@property (strong, nonatomic) NSString *provinceName;
@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *countryName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
