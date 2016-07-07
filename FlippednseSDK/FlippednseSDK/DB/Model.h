//
//  DBInit.h
//  iEnglish
//
//  Created by Jacob on 16/3/20.
//  Copyright (c) 2016年 Jacob. All rights reserved.
//

#import "JSONModel.h"
#import "FMDB.h"
#import "DatabaseManager.h"
//主键
@protocol PrimaryKey
@end

//唯一
@protocol Unique
@end

@interface Model : JSONModel

/**
 *  解析FMResultSet
 *
 *  @param rs FMResultSet 实例
 *
 *  @return Model 实例
 */
- (instancetype)initWithResultSet:(FMResultSet *)rs;

/**
 *  返回建表的sql语句
 *
 *  @return 字符串
 */
+ (NSString *)create;

/**
 *  插入语句
 *
 *  @return sql语句
 */
+ (NSString *)insert;

/**
 *  插入一条属性值
 *
 *  @return 成功标志
 */
- (BOOL)insert;

/**
 *  拿到所有属性值
 *
 *  @return obj的NSArray
 */
+ (NSArray *)all;

/**
 *  批量插入
 *
 *  @param dataSource obj的NSArray
 *
 *  @return 成功标志
 */
+ (BOOL)insertAll:(NSArray *)dataSource;

/**
 *  删除一条属性值
 *
 *  @return 成功标志
 */
- (BOOL)delete;

-(int)getPrimaryKeyAutoIncreaseIdValue:(ModelMetadate *)dbModelMetadate;
/**
 *  删除所有数据
 *
 *  @return 成功YES
 */
+ (BOOL)deleteAll;

/**
 *  根据属性删除属性值
 *
 *  @param propertyName         属性名
 *  @param propertyValue        属性值
 *
 *  @return 成功标志
 */
+ (BOOL)deleteByProperty:(NSString *)propertyName propertyValue:(id)propertyValue;

/**
 *  更新属性值的某个字段
 *
 *  @param propertyName         属性名
 *  @param propertyValue        属性值
 *
 *  @return 成功标志
 */
- (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue;

/**
 *  根据主键更新的某个字段
 *
 *  @param propertyName         属性名
 *  @param propertyValue        属性值
 *  @param keyValue             主键值
 *
 *  @return 成功标志
 */
+ (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue keyValue:(id)keyValue;

/**
 *  根据多条属性修改多条属性
 *
 *  @param propertyMaps       属性
 *  @param updatePropertyMaps 要更新的属性
 *
 *  @return 成功标志
 */
+ (BOOL)updateByPropertyMaps:(NSDictionary *)propertyMaps updatePropertyMaps:(NSDictionary *)updatePropertyMaps;

+ (BOOL)updateByWHERE:(NSString *)sql propertyName:(NSString *)propertyName propertyValue:(id)propertyValue;

/**
 *  根据属性查询属性值
 *
 *  @param propertyName         属性名称
 *  @param propertyValue        属性值
 *
 *  @return 对象数组
 */
+ (NSArray *)selectByProperty:(NSString *)propertyName propertyValue:(id)propertyValue;

/**
 *  根据多条属性查询
 *
 *  @param propertys 属性键值对
 *
 *  @return 对象数组
 */
+ (NSArray *)selectByPropertyMaps:(NSDictionary *)selectByPropertyMaps;

+ (NSArray *)selectBySQL:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps;


+ (NSArray *)selectByWHERE:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps;
@end
