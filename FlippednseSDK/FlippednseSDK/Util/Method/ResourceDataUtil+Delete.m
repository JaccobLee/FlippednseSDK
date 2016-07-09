//
//  ResourceDataUtil+Delete.m
//  iEnglish
//
//  Created by wj on 16/5/13.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import "ResourceDataUtil+Delete.h"
#import "ModelBookInfo.h"
#import "ModelClickRead.h"
#import "ModelContentMenus.h"
#import "ModelWordNode.h"
#import "ModelBookStore.h"
#import "ModelUser.h"
#import "NSString+AES.h"
#import "BlocksKit.h"


@implementation ResourceDataUtil (Delete)

+ (BOOL)deleteModuleUnitWithBookId:(NSString *)bid unitModel:(ModelBookDownloadEnableModuleUnit *)unit
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *bookPathUnzip = [[ConfigGlobal cachePathBooks] stringByAppendingPathComponent:bid];
    NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
    filePath = [filePath stringByAppendingString:[unit.name MD5String16]];
    
    NSArray *contents = [manager contentsOfDirectoryAtPath:filePath error:nil];
    if (!contents) {
        return false;
    }
    
    
    [contents bk_each:^(id obj) {
        [manager removeItemAtPath:[filePath stringByAppendingPathComponent:obj] error:nil];
    }];
    
    NSArray *downloadRecords = [ModelBookRecordOfDownloadUnit selectByPropertyMaps:@{@"bookId": bid, @"moduleName": unit.name}];
    if (downloadRecords.firstObject) {
        [downloadRecords[0] delete];
    }
    
    ModelBookDeleteRecord *deleteRecord = [[ModelBookDeleteRecord alloc] init];
    deleteRecord.userId = [[ConfigGlobal loginUser] userId] ?: 0;
    deleteRecord.bookId = bid;
    deleteRecord.moduleName = unit.name;
    deleteRecord.timeStampDelete = [NSDate date].timeIntervalSince1970;
    [deleteRecord insert];
        
    return true;
}

@end
