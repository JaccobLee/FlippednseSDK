//
//  DBInit.h
//  iEnglish
//
//  Created by Jacob on 16/3/20.
//  Copyright (c) 2016年 Jacob. All rights reserved.
//

#import "ModelClassProperty.h"

@implementation ModelClassProperty

+ (ModelClassProperty *)property:(objc_property_t)property
{
    ModelClassProperty *dbModel = [[ModelClassProperty alloc] init];
    NSScanner* scanner            = nil;
    NSString *propertyType        = nil;
    
    const char *name         = property_getName(property);
    dbModel.name = @(name);
    
    const char *attrs = property_getAttributes(property);
    NSString* propertyAttributes = @(attrs);
    
    scanner = [NSScanner scannerWithString: propertyAttributes];
    [scanner scanUpToString:@"T" intoString: nil];
    [scanner scanString:@"T" intoString:nil];
    
    if ([scanner scanString:@"@\"" intoString: &propertyType])
    {//对象
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                intoString:&propertyType];
        dbModel.type = propertyType;
        
        //解析协议
        dbModel.isPrimaryKey = NO;
        dbModel.isUnique = NO;
        while ([scanner scanString:@"<" intoString:NULL]) {
            NSString* protocolName = nil;
            [scanner scanUpToString:@">" intoString: &protocolName];
            if ([protocolName isEqualToString:@"PrimaryKey"]) {
                dbModel.isPrimaryKey = YES;
            }
            else if ([protocolName isEqualToString:@"Unique"])
            {
                dbModel.isUnique = YES;
            }
            [scanner scanString:@">" intoString:NULL];
        }
        
    }
    else if ([scanner scanString:@"{" intoString: &propertyType])
    {//结构体
        [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet]
                            intoString:&propertyType];
        
        dbModel.type = propertyType;
        
    }
    else
    {//基本类型
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","]
                                intoString:&propertyType];
        dbModel.type = propertyType;
        
// 如果为int类型且属性名为id的，视为自增主键
        if ([dbModel.name isEqualToString:@"id"] && ([propertyType isEqualToString:@"i"]||[propertyType isEqualToString:@"I"]||[propertyType isEqualToString:@"int"]))
        {
            dbModel.isPrimaryKey = YES;
        }
    }
    
    return dbModel;
}

@end
