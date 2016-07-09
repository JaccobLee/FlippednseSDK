//
//  DBInit.h
//  iEnglish
//
//  Created by Jacob on 16/3/20.
//  Copyright (c) 2016年 Jacob. All rights reserved.
//

#import "Model.h"
#import "ModelClassProperty.h"
#import <objc/message.h>
#import "ConfigGlobal.h"

@implementation Model
+ (void)initialize
{
    Class cls = [self class];
    if (cls == [Model class]) {
        return;
    }
    [[DatabaseManager sharedInstance] inspectDBModel:cls];
}

//@"f":@"float", @"i":@"int", @"d":@"double", @"l":@"long", @"c":@"BOOL", @"s":@"short", @"q":@"long", @"I":@"NSInteger", @"Q":@"NSUInteger", @"B":@"BOOL", @"@?":@"Block"
- (instancetype)initWithResultSet:(FMResultSet *)rs
{
    self = [super init];
    if (self)
    {
        ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
        id value = nil;
        for (ModelClassProperty *dbProperty in dbModelMetadate.propertys)
        {
            if([dbProperty.type isEqualToString:@"NSDate"])
            {
                value = [rs dateForColumn:dbProperty.name];
            }
            else if([dbProperty.type isEqualToString:@"NSData"])
            {
                value = [rs dataForColumn:dbProperty.name];
            }
            else if(([dbProperty.type isEqualToString:@"f"]) || ([dbProperty.type isEqualToString:@"d"]))
            {
                value = @([rs doubleForColumn:dbProperty.name]);
            }
            else if([dbProperty.type isEqualToString:@"c"] || [dbProperty.type isEqualToString:@"B"])
            {
                value = @([rs boolForColumn:dbProperty.name]);
            }
            else if([dbProperty.type isEqualToString:@"i"] || [dbProperty.type isEqualToString:@"I"])
            {
                value = @([rs intForColumn:dbProperty.name]);
            }
            else if ([dbProperty.type isEqualToString:@"l"])
            {
                value = @([rs longForColumn:dbProperty.name]);
            }
            else if ([dbProperty.type isEqualToString:@"q"])
            {
                value = @([rs longLongIntForColumn:dbProperty.name]);
            }
            else if ([dbProperty.type isEqualToString:@"Q"])
            {
                value = @([rs unsignedLongLongIntForColumn:dbProperty.name]);
            }
            else
            {
                value = [rs objectForColumnName:dbProperty.name];
            }
            
            if(![value isKindOfClass:[NSNull class]])
            {
                [self setValue:value forKey:dbProperty.name];
            }
            
        }
    }
    return self;
}

//这里目前只做了简单处理,够用
- (NSDictionary *)toModleDictionary
{
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    NSMutableDictionary* tempDictionary = [NSMutableDictionary dictionaryWithCapacity:dbModelMetadate.propertys.count];
    id value;
    for (ModelClassProperty *dbModel in dbModelMetadate.propertys)
    {
        value = [self valueForKey:dbModel.name];
        if(isNull(value))
        {
            [tempDictionary setObject:[NSNull null] forKey:dbModel.name];
        }
        else
        {
            [tempDictionary setObject:value forKey:dbModel.name];
        }
    }
    return tempDictionary;
}

+ (NSString *)create
{
    return [[DatabaseManager sharedInstance] dbModelMetadate:self].createSQL;
}

+ (NSString *)insert
{
    return [[DatabaseManager sharedInstance] dbModelMetadate:self].insertSQLWithOutPrimary;

//    return [[DatabaseManager sharedInstance] dbModelMetadate:self].insertSQL;
}

- (BOOL)insert
{
    Class cla = [self class];
    FMDatabaseQueue * queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:dbModelMetadate.insertSQLWithOutPrimary withParameterDictionary:[self toModleDictionary]];

//        success = [db executeUpdate:dbModelMetadate.insertSQL withParameterDictionary:[self toModleDictionary]];
    }];
//#ifdef DEBUG
//    if(success)
//        DLOG(@"%s:操作成功",__FUNCTION__);
//    else
//        DLOG(@"%s:操作失败",__FUNCTION__);
//#endif
//    
    return success;
}

+ (BOOL)insertAll:(NSArray *)dataSource
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:cla];
    __block BOOL success = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (id obj in dataSource)
        {
            success = [db executeUpdate:dbModelMetadate.insertSQLWithOutPrimary withParameterDictionary:[obj toModleDictionary]];

//            success = [db executeUpdate:dbModelMetadate.insertSQL withParameterDictionary:[obj toModleDictionary]];
        }
    }];
//#ifdef DEBUG
//    if(success)
//        DLOG(@"%s:操作成功",__FUNCTION__);
//    else
//        DLOG(@"%s:操作失败",__FUNCTION__);
//#endif
    return success;
}

- (BOOL)delete
{
    Class cla = [self class];
    FMDatabaseQueue * queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    id keyValue;
    if ([dbModelMetadate isPrimaryKeyAutoIncreaseId])
    {

        //        keyValue = [NSString stringWithFormat:@"%d",[dbModelMetadate getPrimaryKeyIdValue]];
        keyValue = [NSString stringWithFormat:@"%d",[self getPrimaryKeyAutoIncreaseIdValue:dbModelMetadate]];

    }
    else
    {
        keyValue = objc_msgSend(self,NSSelectorFromString(dbModelMetadate.primaryKey));
    }
    
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:dbModelMetadate.delectSQL,keyValue];
    }];
//#ifdef DEBUG
//    if(success)
//        DLOG(@"%s:操作成功",__FUNCTION__);
//    else
//        DLOG(@"%s:操作失败",__FUNCTION__);
//#endif
    return success;
}

-(int)getPrimaryKeyAutoIncreaseIdValue:(ModelMetadate *)dbModelMetadate{
    NSDictionary *dictModel=[self toModleDictionary];
    return [[dictModel objectForKey:dbModelMetadate.primaryKey] intValue];
}

+ (BOOL)deleteAll
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ ",NSStringFromClass(cla)]];
    }];
//#ifdef DEBUG
//    if(success)
//        DLOG(@"%s:操作成功",__FUNCTION__);
//    else
//        DLOG(@"%s:操作失败",__FUNCTION__);
//#endif
    return success;
}

+ (BOOL)deleteByProperty:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",NSStringFromClass(cla),propertyName],propertyValue];
    }];
//#ifdef DEBUG
//    if(success)
//        DLOG(@"%s:操作成功",__FUNCTION__);
//    else
//        DLOG(@"%s:操作失败",__FUNCTION__);
//#endif
    return success;
}

- (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    __block BOOL success = YES;
    id keyValue;
    if ([dbModelMetadate isPrimaryKeyAutoIncreaseId])
    {
        //        keyValue = [NSString stringWithFormat:@"%d",[dbModelMetadate getPrimaryKeyIdValue]];
        keyValue = [NSString stringWithFormat:@"%d",[self getPrimaryKeyAutoIncreaseIdValue:dbModelMetadate]];
    }
    else
    {
        keyValue = objc_msgSend(self,NSSelectorFromString(dbModelMetadate.primaryKey));
    }
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",NSStringFromClass(cla),propertyName,dbModelMetadate.primaryKey],propertyValue,keyValue];
    }];
//#ifdef DEBUG
//    if(success)
//        DLOG(@"%s:操作成功",__FUNCTION__);
//    else
//        DLOG(@"%s:操作失败",__FUNCTION__);
//#endif
    return success;
}

+ (BOOL)updateByProperty:(NSString *)propertyName propertyValue:(id)propertyValue keyValue:(id)keyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        if(keyValue)
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",NSStringFromClass(cla),propertyName,dbModelMetadate.primaryKey],propertyValue,keyValue];
        }
        else
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? ",NSStringFromClass(cla),propertyName],propertyValue];
        }
        
    }];
//#ifdef DEBUG
//    if(success)
//        DLOG(@"%s:操作成功",__FUNCTION__);
//    else
//        DLOG(@"%s:操作失败",__FUNCTION__);
//#endif
    return success;
}

+ (BOOL)updateByWHERE:(NSString *)sql propertyName:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@",NSStringFromClass(cla),propertyName,sql],propertyValue];
    }];
//#ifdef DEBUG
//    if(success)
//        DLOG(@"%s:操作成功",__FUNCTION__);
//    else
//        DLOG(@"%s:操作失败",__FUNCTION__);
//#endif
    return success;
}

+ (BOOL)updateByPropertyMaps:(NSDictionary *)propertyMaps updatePropertyMaps:(NSDictionary *)updatePropertyMaps
{
    Class cla = [self class];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    __block BOOL success = YES;
    [queue inDatabase:^(FMDatabase *db) {
        
        NSMutableString *where = [NSMutableString string];
        NSMutableString *set = [NSMutableString string];
        NSArray *allKeys = [propertyMaps allKeys];
        
        for ( int i=0; i<allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if(i == allKeys.count -1)
            {
                
                if ([[propertyMaps objectForKey:key] isKindOfClass:[NSString class]] ) {
                    if ( [trimOfNoNullStr([propertyMaps objectForKey:key])length]) {
                        [where appendFormat:@" %@ = \'%@\'",key,[propertyMaps objectForKey:key]];
                        
                    }
                    
                }else{
                    [where appendFormat:@" %@ = %@",key,[propertyMaps objectForKey:key]];
                    
                }
            }
            else
            {
                
                if ([[propertyMaps objectForKey:key] isKindOfClass:[NSString class]] ) {
                    if ( [trimOfNoNullStr([propertyMaps objectForKey:key])length]) {
                        [where appendFormat:@" %@ = \'%@\' AND",key,[propertyMaps objectForKey:key]];

                    }
                    
                }else{
                    [where appendFormat:@" %@ = %@ AND",key,[propertyMaps objectForKey:key]];
                    
                }
                
            }
        }
        
        allKeys = [updatePropertyMaps allKeys];
        
        for ( int i=0; i<allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if ([key isEqualToString:@"id"]) {
                continue ;
            }
            
            
            if(i == allKeys.count-1 )
            {
                
                if ([[updatePropertyMaps objectForKey:key] isKindOfClass:[NSString class]] ) {
                    if ( [trimOfNoNullStr([updatePropertyMaps objectForKey:key])length]) {
                        [set appendFormat:@" %@ = \'%@\'",key,[updatePropertyMaps objectForKey:key]];
                    }
                }else{
                    [set appendFormat:@" %@ = %@",key,[updatePropertyMaps objectForKey:key]];
                    
                }
            
                
            }
            else
            {
                
                if ([[updatePropertyMaps objectForKey:key] isKindOfClass:[NSString class]] ) {
                    if ( [trimOfNoNullStr([updatePropertyMaps objectForKey:key])length]) {
                        [set appendFormat:@" %@ = \'%@\' AND",key,[updatePropertyMaps objectForKey:key]];
                    }
                }else{
                    [set appendFormat:@" %@ = %@ AND",key,[updatePropertyMaps objectForKey:key]];
                    
                }
            }
            

        }
        
        if(set.length == 0)
        {
            success = NO;
            return;
        }
        
        if(where.length)
        {
            NSMutableDictionary *maps = [NSMutableDictionary dictionaryWithDictionary:propertyMaps];
            [maps addEntriesFromDictionary:updatePropertyMaps];
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",NSStringFromClass(cla),set,where] withParameterDictionary:maps];
        }
        else
        {
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@",NSStringFromClass(cla),set]];
        }

    }];
//#ifdef DEBUG
//    if(success)
//        DLOG(@"%s:操作成功",__FUNCTION__);
//    else
//        DLOG(@"%s:操作失败",__FUNCTION__);
//#endif
    return success;
}

+ (NSArray *)all
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue * queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(cla)]];
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
            id keyValue;
            if ([dbModelMetadate isPrimaryKeyAutoIncreaseId])
            {
//                        keyValue = [NSString stringWithFormat:@"%d",[dbModelMetadate getPrimaryKeyIdValue]];
        keyValue = [NSString stringWithFormat:@"%d",[Model objOfPrimaryKeyAutoIncreaseIdValue:obj withPrimaryKey:dbModelMetadate.primaryKey]];
            }
            else
            {
                keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
            }
            if(keyValue)
            {
                [array addObject:obj];
            }
        }
        [rs close];
    }];
    return array;
}

+(int)objOfPrimaryKeyAutoIncreaseIdValue:(id)obj withPrimaryKey:(NSString *)primaryKey{
    NSDictionary *dictModel=[obj toModleDictionary];
    return [[dictModel objectForKey:primaryKey] intValue];
}


+ (NSArray *)selectByProperty:(NSString *)propertyName propertyValue:(id)propertyValue
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",NSStringFromClass(cla),propertyName],propertyValue];
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
            id keyValue;
            if ([dbModelMetadate isPrimaryKeyAutoIncreaseId])
            {
                //                        keyValue = [NSString stringWithFormat:@"%d",[dbModelMetadate getPrimaryKeyIdValue]];
                keyValue = [NSString stringWithFormat:@"%d",[Model objOfPrimaryKeyAutoIncreaseIdValue:obj withPrimaryKey:dbModelMetadate.primaryKey]];
            }
            else
            {
                keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
            }
            if(keyValue)
            {
                [array addObject:obj];
            }
        }
        [rs close];
    }];
    return array;
}

+ (NSArray *)selectByPropertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db) {
        NSMutableString *where = [NSMutableString string];
        NSArray *allKeys = [propertyMaps allKeys];
        for (int i = 0; i< allKeys.count; i++)
        {
            NSString *key = allKeys[i];
            if( i == allKeys.count -1 )
            {
                [where appendFormat:@" %@ = :%@",key,key];
            }
            else
            {
                [where appendFormat:@" %@ = :%@ AND",key,key];
            }
        }

        FMResultSet *rs;
        if(where.length)
        {
            rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",NSStringFromClass(cla),where] withParameterDictionary:propertyMaps];
        }
        else
        {
            rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(cla)]];
        }
        
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
            id keyValue;
            if ([dbModelMetadate isPrimaryKeyAutoIncreaseId])
            {
                //                        keyValue = [NSString stringWithFormat:@"%d",[dbModelMetadate getPrimaryKeyIdValue]];
                keyValue = [NSString stringWithFormat:@"%d",[Model objOfPrimaryKeyAutoIncreaseIdValue:obj withPrimaryKey:dbModelMetadate.primaryKey]];
            }
            else
            {
                keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
            }
            if(keyValue)
            {
                [array addObject:obj];
            }
        }
        [rs close];
    }];
    return array;
}

+ (NSArray *)selectBySQL:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db)
    {
        FMResultSet *rs = [db executeQuery:sql withParameterDictionary:propertyMaps];
        while ([rs next])
        {
            id obj = [[cla alloc] initWithResultSet:rs];
            id keyValue;
            if ([dbModelMetadate isPrimaryKeyAutoIncreaseId])
            {
                //                        keyValue = [NSString stringWithFormat:@"%d",[dbModelMetadate getPrimaryKeyIdValue]];
                keyValue = [NSString stringWithFormat:@"%d",[Model objOfPrimaryKeyAutoIncreaseIdValue:obj withPrimaryKey:dbModelMetadate.primaryKey]];
            }
            else
            {
                keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
            }
            if(keyValue)
            {
                [array addObject:obj];
            }
            
        }
        [rs close];
    }];
    return array;
}


+ (NSArray *)selectByWHERE:(NSString *)sql propertyMaps:(NSDictionary *)propertyMaps
{
    Class cla = [self class];
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [[DatabaseManager sharedInstance] getDBQueueWithClass:cla];
    ModelMetadate *dbModelMetadate = [[DatabaseManager sharedInstance] dbModelMetadate:[self class]];
    [queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",NSStringFromClass(cla),sql] withParameterDictionary:propertyMaps];
         while ([rs next])
         {
             id obj = [[cla alloc] initWithResultSet:rs];
             id keyValue;
             if ([dbModelMetadate isPrimaryKeyAutoIncreaseId])
             {
                 //                        keyValue = [NSString stringWithFormat:@"%d",[dbModelMetadate getPrimaryKeyIdValue]];
                 keyValue = [NSString stringWithFormat:@"%d",[Model objOfPrimaryKeyAutoIncreaseIdValue:obj withPrimaryKey:dbModelMetadate.primaryKey]];
             }
             else
             {
                 keyValue = objc_msgSend(obj,NSSelectorFromString(dbModelMetadate.primaryKey));
             }
             if(keyValue)
             {
                 [array addObject:obj];
             }
         }
         [rs close];
     }];
    return array;
}


@end
