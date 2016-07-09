//
//  DBInit.h
//  iEnglish
//
//  Created by Jacob on 16/3/20.
//  Copyright (c) 2016年 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelMetadate : NSObject
@property (nonatomic,strong) NSArray  *propertys;//HQModelClassProperty类型的数组
@property (nonatomic,strong) NSString *primaryKey;//主键名称
@property (nonatomic,strong) NSString *createSQL;//建表语句
@property (nonatomic,strong) NSString *insertSQL;//插入语句
@property (nonatomic,strong) NSString *delectSQL;//删除语句
@property (nonatomic,strong) NSString *dbName;    //所属库

@property (nonatomic,strong) NSString *insertSQLWithOutPrimary;//插入语句


/**
 *  生成DBModelMetadate
 *
 *  @param class 类对象
 *
 *  @return DBModelMetadate
 */
- (instancetype)initWithClass:(Class)class;
// 判定是否自增主键且name为id
- (BOOL)isPrimaryKeyAutoIncreaseId;
// 获取自增主键值
- (int)getPrimaryKeyIdValue;
@end
