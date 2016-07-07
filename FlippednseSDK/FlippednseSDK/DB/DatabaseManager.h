//
//  DBInit.h
//  iEnglish
//
//  Created by Jacob on 16/3/20.
//  Copyright (c) 2016年 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB/FMDB.h"
#import "ModelMetadate.h"

#define DEFAULT_DB_QUEUE [[DatabaseManager sharedInstance] dbQueueWithName:IENGLISH_DB] //默认的数据库队列

@interface DatabaseManager : NSObject
+ (instancetype)sharedInstance;

/**
 *  创建一个FMDatabaseQueue
 *
 *  @param dbName 库名
 */
- (void)createDBQueue:(NSString *)dbName;

/**
 *  获得一个FMDatabaseQueue
 *
 *  @param dbName 库名
 *
 *  @return FMDatabaseQueue实例
 */
- (FMDatabaseQueue *)dbQueueWithName:(NSString *)dbName;

/**
 *  解析DBModel
 *
 *  @param class 类对象
 */
- (void)inspectDBModel:(Class)class;

/**
 *  获得一个ModelMetadate对象
 *
 *  @param class 类对象
 *
 *  @return ModelMetadate 实例
 */
- (ModelMetadate *)dbModelMetadate:(Class)class;

/**
 *  创建一个库同时创建所需要的表
 *
 *  @param dbName 库名称
 *  @param array  Model的类对象
 */
- (void)createDBQueue:(NSString *)dbName withTalbe:(NSArray *)array;
/**
 *  通过类型获取所存放的库
 *
 *  @param class 类型
 *
 *  @return 库
 */
- (FMDatabaseQueue *)getDBQueueWithClass:(Class)class;

@end
