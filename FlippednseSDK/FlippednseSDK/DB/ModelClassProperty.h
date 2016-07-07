//
//  DBInit.h
//  iEnglish
//
//  Created by Jacob on 16/3/20.
//  Copyright (c) 2016年 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ModelClassProperty : NSObject
+ (ModelClassProperty *)property:(objc_property_t)property;
@property (nonatomic,assign) BOOL isPrimaryKey;//是主键
@property (nonatomic,assign) BOOL isUnique;//唯一值
@property (nonatomic,strong) NSString *name;//属性名称
@property (nonatomic,strong) NSString *type;//属性类型
@end
