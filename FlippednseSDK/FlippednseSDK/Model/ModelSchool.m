
//
//  ModelSchool.m
//  iEnglish
//
//  Created by wj on 16/4/27.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import "ModelSchool.h"

@implementation ModelSchool

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.schoolId = dict[@"schoolId"];
        self.schoolName = dict[@"schoolName"];
        self.provinceName = dict[@"provinceName"];
        self.cityName = dict[@"cityName"];
        self.countryName = dict[@"countryName"];
    }
    return self;
}

@end
