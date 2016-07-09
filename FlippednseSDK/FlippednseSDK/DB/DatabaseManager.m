//
//  DBInit.h
//  iEnglish
//
//  Created by Jacob on 16/3/20.
//  Copyright (c) 2016年 Jacob. All rights reserved.
//

#import "DatabaseManager.h"
#import "DirectoryUtil.h"

@interface DatabaseManager()
@property (nonatomic,strong) NSMutableDictionary *dbQueues;
@property (nonatomic,strong) NSMutableDictionary *dbMetadataMaps;
@property (nonatomic,strong) NSMutableDictionary *dbTableMaps;
@end

@implementation DatabaseManager
- (void)inspectDBModel:(Class)class
{
    ModelMetadate *dbModelMetadate = [[ModelMetadate alloc] initWithClass:class];
    [self.dbMetadataMaps setObject:dbModelMetadate forKey:NSStringFromClass(class)];
}

- (ModelMetadate *)dbModelMetadate:(Class)class
{
    ModelMetadate *dbModelMetadate = [self.dbMetadataMaps objectForKey:NSStringFromClass(class)];
    return dbModelMetadate;
}

+ (instancetype)sharedInstance
{
    static DatabaseManager *_sharedInstance;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.dbQueues       = [NSMutableDictionary dictionary];
        self.dbMetadataMaps = [NSMutableDictionary dictionary];
        self.dbTableMaps    = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)createDBQueue:(NSString *)dbName
{
    NSString *docPath = [DirectoryUtil docPath];
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:[docPath stringByAppendingPathComponent:dbName]];
    [self.dbQueues setObject:dbQueue forKey:dbName];
}

- (FMDatabaseQueue *)dbQueueWithName:(NSString *)dbName
{
    return [self.dbQueues objectForKey:dbName];
}

- (void)createDBQueue:(NSString *)dbName withTalbe:(NSArray *)array
{
    NSString *docPath = [DirectoryUtil docPath];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[docPath stringByAppendingPathComponent:dbName]];
    [self.dbQueues setObject:queue forKey:dbName];
    
    [queue inDatabase:^(FMDatabase *db)
    {
        NSString *className = nil;
        for (Class cla in array)
        {
            className = NSStringFromClass(cla);
            ModelMetadate *dbModelMetadate = [self.dbMetadataMaps objectForKey:className];
            if(dbModelMetadate)
            {
                [db executeUpdate:dbModelMetadate.createSQL];
                [self.dbTableMaps setObject:dbName forKey:className];
            }
        }
    }];
}

- (FMDatabaseQueue *)getDBQueueWithClass:(Class)class
{
    NSString *className = NSStringFromClass(class);
    return [self dbQueueWithName:[self.dbTableMaps objectForKey:className]];
}

@end
