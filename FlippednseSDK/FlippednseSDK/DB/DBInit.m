//
//  DBInit.h
//  iEnglish
//
//  Created by Jacob on 16/3/20.
//  Copyright (c) 2016年 Jacob. All rights reserved.
//

#import "DBInit.h"
#import "DatabaseManager.h"
#import "DirectoryUtil.h"
#import "ModelBookStore.h"
#import "ModelUser.h"
/****库名****/
#define IENGLISH_DB @"iEnglish.db"

@implementation DBInit
+ (void)dbInit
{
    [[DatabaseManager sharedInstance] createDBQueue:IENGLISH_DB withTalbe:@[[ModelBookStoreShare  class],[ModelBookStoreUser class],[ModelUser class],[ModelBookStoreDownloadRecord class],[ModelBookStoreServerUnitInfo class],[ModelBookStoreUnitDownload class],[UserDownloadRunningRecord class],[ModelBookRecordOfDownloadUnit class]]];

}


@end
