//
//  UtilBooksOnLocal.m
//  iEnglish
//
//  Created by Zang Sam on 16/4/14.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import "UtilBooksOnLocal.h"
#import "ModelUser.h"


NSInteger bookLocalArraySort(id user1, id user2, void *context)
{
    UserBookShelfOnLocal *u1,*u2;
    //类型转换
    u1 = (UserBookShelfOnLocal*)user1;
    u2 = (UserBookShelfOnLocal*)user2;
    
//    return  [u1.category localizedCaseInsensitiveCompare:u2.category];
    return u1.lastReadTime<u2.lastReadTime;
}


@implementation UtilBooksOnLocal

/*
 *判断本地是否有共享书本，用于未登录的时候
 */

+(BOOL)isHasSharedBookOnLocal{
    NSArray *arrayShared=[ModelBookStoreUser selectByProperty:@"userId" propertyValue:[NSNumber numberWithInt:0]];
    for (int i=0; i<[arrayShared count]; i++) {
        ModelBookStoreUser *user=arrayShared[i];
        NSArray *arrayBooksLocal=[ModelBookStoreShare selectByProperty:@"bookId" propertyValue:user.bookId];
        if ([arrayBooksLocal count]) {
            return YES;
        }
    }
    return NO;
}

+(LocalBookState)stateOfBookInLocal:(NSString *)bookId{
    if ([UtilBooksOnLocal bookIsHasInLocal:bookId]) {
        return LocalBookStateHasDownload;
    }
    BOOL isDownloadState=[UtilBooksOnLocal isDownloadStateOfBook:bookId];
    return isDownloadState?LocalBookStateIsOnDownloadDuring:LocalBookStateNotExists;
}

+(BOOL)isDownloadStateOfBook:(NSString *)bookId{
    
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count]) {
        return YES;
    }
    return NO;
}

//+(BOOL)bookOfUserHasDownload:(NSString *)bookId{
//    if (![UtilBooksOnLocal bookIsHasInLocal:bookId]) {
//        return NO;
//    }
//    NSArray *arrayUserBooksRecord=[ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[ConfigGlobal loginUser].userId],@"userId",bookId,@"bookId", nil]];
//    
//    if ([arrayUserBooksRecord count]) {
//        return YES;
//    }
//    return NO;
//}

+(BookStateOfUser)bookOfUserState:(NSString *)bookId{
#if 0 //下载状态 根据人 而言  下载，未下载  下载中
    NSArray *arrayUserBooksRecord=[ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[ConfigGlobal loginUser].userId],@"userId",bookId,@"bookId", nil]];
    
    if (!arrayUserBooksRecord || ![arrayUserBooksRecord count]) {
        return BookStateOfUserUnDownload;
    }
    
        if ([UtilBooksOnLocal isDownloadStateOfBook:bookId]) {
            return BookStateOfUserDownloadDuring;
        }

    if ([UtilBooksOnLocal bookIsHasInLocal:bookId]) {
        return BookStateOfUserHasDownload;
    }
    
    return BookStateOfUserUnDownload;
#else  //下载状态 根据本地的书本 而言  下载，未下载  下载中
    
    
    if ([UtilBooksOnLocal isDownloadStateOfBook:bookId]) {
        return BookStateOfUserDownloadDuring;
    }
    
    
    if (![UtilBooksOnLocal bookIsHasInLocal:bookId]) {
        return BookStateOfUserUnDownload;
    }
    
    if([ConfigGlobal loginUser].userId){
        return BookStateOfUserHasDownload;
    }
        
    
    NSArray *arrayUserBooksRecord=[ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"userId",nil]];
    
//    if (!arrayUserBooksRecord || ![arrayUserBooksRecord count]) {
//        return BookStateOfUserUnDownload;
//
//    }
    
    for(ModelBookStoreUser *user in arrayUserBooksRecord){
        if (![user.bookId isEqualToString:bookId]) {
            return BookStateOfUserUnDownload;
        }
    }
    return BookStateOfUserHasDownload;


//    if ([UtilBooksOnLocal bookIsHasInLocal:bookId]) {
//        return BookStateOfUserHasDownload;
//    }
//
//    NSArray *arrayUserBooksRecord=[ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[ConfigGlobal loginUser].userId],@"userId",bookId,@"bookId", nil]];
//    
//    if (!arrayUserBooksRecord || ![arrayUserBooksRecord count]) {
//        return BookStateOfUserUnDownload;
//    }
//    
//    if ([UtilBooksOnLocal isDownloadStateOfBook:bookId]) {
//        return BookStateOfUserDownloadDuring;
//    }
//    return BookStateOfUserHasDownload;


#endif

}

+(BOOL)bookIsHasInLocal:(NSString *)bookId{
    
    NSString *bookSavePath=[UtilBooksOnLocal bookDirectoryOfLocalWithBookId:bookId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:bookSavePath];
    
}

+(BOOL)bookIsDeleteFromLocal:(NSString *)bookId{
    BOOL isHasTheBook=[UtilBooksOnLocal bookIsHasInLocal:bookId];
    if (isHasTheBook) {
        return NO;
    }
    
    BOOL isDownloadState=[UtilBooksOnLocal isDownloadStateOfBook:bookId];
    
    return isDownloadState?NO:YES;

}

////这个需要修复
//+(BOOL)bookIsDeleteFromLocalWithWithDirectory:(NSString *)directory{
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    return ![fileManager fileExistsAtPath:directory];
//}

+(void)bookDeleteLocalFile:(NSString *)directory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:directory]) {
        NSError *err;
       [fileManager removeItemAtPath:directory error:&err];
    }
}

+(NSString *)bookDirectoryOfLocalWithBookId:(NSString *)bid{
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    // 创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bookDirPath isDirectory:nil])
    {
        if (![fileManager createDirectoryAtPath:bookDirPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            return  @"";
        }
    }
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    return bookPathUnzip;
    
}

+(NSString *)bookCacheDirectoryOfLocalWithBookId:(NSString *)bid{
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    // 创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bookDirPath isDirectory:nil])
    {
        if (![fileManager createDirectoryAtPath:bookDirPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            return  @"";
        }
    }
    NSString *bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"book_%@_temp",trimOfNoNullStr(bid)]];

    return bookPath;
    
}


//获取本地书架，如果是进入的书架，需要调用此函数
+(NSMutableArray *)localBookshelf{
//    NSLog(@"direct save:%@",[UtilBooksOnLocal bookDirectoryOfLocalWithBookId:@"12"]);
    ModelUser *loginUser=[ConfigGlobal loginUser];
    //    int userId=loginUser&& loginUser.userId?loginUser.userId:0;
    //获取没有登录条件下的  书架书本
    
#if 0
    NSMutableArray *bookShelfOfShared=[UtilBooksOnLocal localBookshelfOfUser:0];
    
    if(!(loginUser && loginUser.userId)){
        return bookShelfOfShared;
    }
#endif
    //获取当前登录者的用户书架
    NSMutableArray *bookShelfOfLoginedUser=[UtilBooksOnLocal localBookshelfOfUser:loginUser.userId];
    
    //当前登录者的用户书架  和  共享书架的集合
//    NSMutableArray *array_Shelf=[NSMutableArray arrayWithArray:bookShelfOfLoginedUser];
    
     NSMutableArray *array_Shelf = [NSMutableArray arrayWithArray:[bookShelfOfLoginedUser sortedArrayUsingFunction:bookLocalArraySort context:nil]];

 
#if 0
    for (UserBookShelfOnLocal *sharedBook in bookShelfOfShared) {
        
        BOOL isInUserBook=NO;//判断本地的共享图书是否包含在当前登录用户的书架中
        
        for (UserBookShelfOnLocal *userBook in bookShelfOfLoginedUser) {
            if ([sharedBook.bookId isEqualToString:userBook.bookId]&&[UtilBooksOnLocal stateOfBookInLocal:userBook.bookId]==LocalBookStateHasDownload) {
                
                isInUserBook=YES;
                break;
            }
        }
        
        if (!isInUserBook) {
            [array_Shelf addObject:sharedBook];
        }
    }
    
#endif
    return array_Shelf;
}

//获取某个用户的本地书架上
+(NSMutableArray *)localBookshelfOfUser:(int)userId{
    
    NSMutableArray *bookShelf=[NSMutableArray array];
    
    NSArray *arrayUserBooksRecord=[ModelBookStoreUser selectByProperty:@"userId" propertyValue:[NSNumber numberWithInt:userId]];
    
    for (int i=0; i<[arrayUserBooksRecord count]; i++) {
        
        ModelBookStoreUser *user=arrayUserBooksRecord[i];
        
        NSArray *arrayBooksLocal=[ModelBookStoreShare selectByProperty:@"bookId" propertyValue:user.bookId];
        
        for (ModelBookStoreShare *bookShared in arrayBooksLocal) {
            
            if (![bookShared.bookId isEqualToString:user.bookId]) {
                continue;
            }
            
            UserBookShelfOnLocal *shelf=[[UserBookShelfOnLocal alloc]init];
            shelf.bookId=bookShared.bookId;
            shelf.bookCode=bookShared.bookCode;
            shelf.bookName=bookShared.bookName;
                        shelf.bookCachePath=bookShared.bookCachePath;
            shelf.bookCover=bookShared.bookCover; //这个 跟是否删除在意义相同
            shelf.bookUnits=bookShared.bookUnits;
            shelf.timeStampDownload=bookShared.timeStampDownload;
            shelf.userId=user.userId;
            shelf.isProbation=user.isProbation;
            shelf.lastReadPage=user.lastReadPage;
            shelf.lastReadTime=user.lastReadTime;
            shelf.bookState=[UtilBooksOnLocal stateOfBookInLocal:bookShared.bookId];

            if (shelf.bookState==LocalBookStateNotExists) {
                 shelf.bookCachePath=@"";
            }
            
            //计算是否到期
            shelf.isFailureTime=NO;
            
            [bookShelf addObject:shelf];
        }
    }
    
    return bookShelf;
}


+(void)bookOfUserDeleteFromShelf:(NSString *)bookId withBookStoreShareId:(int)bookStoreShareId finishRefreshView:(void (^)())refreshView{
    ModelUser *loginUser=[ConfigGlobal loginUser];
    int userId=loginUser&& loginUser.userId?loginUser.userId:0;
    NSArray *arrayUserBooksSelect= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    for (int i=0; i<[arrayUserBooksSelect count]; i++) {
        ModelBookStoreUser *user=arrayUserBooksSelect[i];
        [user delete];
//        user.isShowInShelf=NO;
//       [user updateByProperty:@"isShowInShelf" propertyValue:[NSNumber numberWithBool:NO]];
    }

    refreshView();
}

+(void)bookOfUserDeleteFromShelfAndLocal:(NSString *)bookId withBookStoreShareId:(int)bookStoreShareId finishRefreshView:(void (^)())refreshView{
    
    
    [UtilBooksOnLocal bookOfUserDeleteFromShelf:bookId withBookStoreShareId:bookStoreShareId finishRefreshView:^{
        
    }];
#if 1
    //删除本地书架上的东西
    NSArray *arrayShared= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"userId",bookId,@"bookId", nil]];
    
    for (int i=0; i<[arrayShared count]; i++) {
        ModelBookStoreUser *user=arrayShared[i];
        [user delete];
    }
#endif
    NSArray *arrayBookSharedSelect= [ModelBookStoreShare selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];
    for (int i=0; i<[arrayBookSharedSelect count]; i++) {
        ModelBookStoreShare *book=arrayBookSharedSelect[i];
        //                    [book delete];
        if ([book.bookId isEqualToString:bookId]) {
            [UtilBooksOnLocal bookDeleteLocalFile:[UtilBooksOnLocal bookDirectoryOfLocalWithBookId:book.bookId]];
            [UtilBooksOnLocal localBookHasRecordDelete:book.bookId];
            book.bookCachePath=@"";
            [book updateByProperty:@"bookCachePath" propertyValue:@""];
            //            [book delete];
        }
    }
    
    refreshView();
    
//         NSLog(@"data book result:%@  \n",[ModelBookStoreShare all]);
}

+(void)localBookHasRecordDelete:(NSString *)bookId{
    NSArray *arrayBookSharedSelect= [ModelBookRecordOfDownloadUnit selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];
    NSTimeInterval time=[[NSDate date]timeIntervalSince1970];
    for (int i=0; i<[arrayBookSharedSelect count]; i++) {
        ModelBookRecordOfDownloadUnit *book=arrayBookSharedSelect[i];
        [UtilBooksOnLocal insertBookDelete:book.bookId module:book.moduleName time:time];
        [book delete];
    }

}

+(void)checkIsInUserShelfWhenStudy:(NSString *)bookId withBookCode:(NSString *)bookCode isFreeTrail:(BOOL)isFreeTrail{

    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count]) {
        return;
    }
    [UtilBooksOnLocal insertBookStoreUser:bookId withBookCode:bookCode isTrail:isFreeTrail lastReadPage:0 lastReadTime:[[NSDate date] timeIntervalSince1970]];
//    [UtilBooksOnLocal insertBookStoreUser:bookId isTrail:isFreeTrail lastReadPage:0 lastReadTime:[[NSDate date] timeIntervalSince1970]];
    
}
//保存下载书本的信息
+(void)saveBookInfoToLocal:(BOOL)isFreeTrail bookInfo:(ModelBookInfoDetail *)bookInfo{
    //    NSLog(@"book resources:%@",[UtilBooksOnLocal bookDirectoryOfLocalWithBookId:bookInfo.bookId]);
    
    NSTimeInterval downloadTime=[[NSDate date] timeIntervalSince1970];
    //保存书本 信息进入数据库
    [UtilBooksOnLocal insertLocalBookInfo:bookInfo];
    
    //保存用户信息进入数据库，用户的书本
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookInfo.bookId,@"bookId", nil]];
    
    if (userId) {
        if ([arrayUserBooksSelect count]) {
            [UtilBooksOnLocal updatedBookOfUserInfoWithBookId:bookInfo.bookId isTrail:isFreeTrail lastReadPage:0 lastReadTime:downloadTime];
        }else{
            [UtilBooksOnLocal insertBookStoreUser:bookInfo.bookId withBookCode:bookInfo.code isTrail:isFreeTrail lastReadPage:0 lastReadTime:downloadTime];
        }
        
    }else{
        
        if ([arrayUserBooksSelect count]) {
            [ModelBookStoreUser deleteAll];
        }
        [UtilBooksOnLocal insertBookStoreUser:bookInfo.bookId withBookCode:bookInfo.code isTrail:isFreeTrail lastReadPage:0 lastReadTime:downloadTime];

//        [UtilBooksOnLocal insertBookStoreUser:bookInfo.bookId isTrail:isFreeTrail lastReadPage:0 lastReadTime:downloadTime];
        
    }
}


//保存下载书本的信息
+(void)saveDownloadOfBookInfo:(BOOL)isFreeTrail bookInfo:(ModelBookInfoDetail *)bookInfo  isDownloadFromServer:(BOOL)isFromServer{
//    NSLog(@"book resources:%@",[UtilBooksOnLocal bookDirectoryOfLocalWithBookId:bookInfo.bookId]);

    [UtilBooksOnLocal saveBookInfoToLocal:isFreeTrail bookInfo:bookInfo];
//    if (isFromServer) {
//        NSArray *arrayUnit=[bookInfo.usableUnits componentsSeparatedByString:@","];
//        
//        [UtilBooksOnLocal insertBookStoreUnitDownloadWithId:bookInfo.bookId unitName:[arrayUnit objectAtIndex:0] downloadTime:downloadTime];
//        //所有下载模块记录  保存进入数据库
//        [UtilBooksOnLocal insertBookStoreDownloadRecordWithId:bookInfo.bookId moduleName:[arrayUnit objectAtIndex:0] downloadTime:downloadTime];
//
//    }
    //本地书库下载单元信息  保存进入数据库
   //        NSLog(@"data insert result:\n book:%@ \n user:%@  \n unitdownload:%@  \n record:%@",[ModelBookStoreShare all],[ModelBookStoreUser all],[ModelBookStoreUnitDownload all],[ModelBookStoreDownloadRecord all]);
    
}


+(void)insertBookStoreUnitDownloadWithId:(NSString *)bookId unitName:(NSString *)unitName downloadTime:(NSTimeInterval)downloadTime{

    ModelBookStoreUnitDownload *storeDownload=[[ModelBookStoreUnitDownload alloc]init];
    storeDownload.bookId=bookId;
    storeDownload.unitName=unitName;
    storeDownload.timeStampDownload=downloadTime;
    storeDownload.userId=[ConfigGlobal loginUser].userId;
    [storeDownload insert];
}

+(void)insertBookStoreDownloadRecordWithId:(NSString *)bookId moduleName:(NSString *)moduleName downloadTime:(NSTimeInterval)downloadTime{

    ModelBookStoreDownloadRecord *storeRecord=[[ModelBookStoreDownloadRecord alloc]init];
    storeRecord.moduleName=moduleName;
    storeRecord.bookId=bookId;
    storeRecord.timeStampDownload=downloadTime;
    [storeRecord insert];
}

+(void)insertBookOnLocalRecordWithId:(NSString *)bookId moduleName:(NSString *)moduleName downloadTime:(NSTimeInterval)downloadTime{
    ModelBookRecordOfDownloadUnit *storeRecord=[[ModelBookRecordOfDownloadUnit alloc]init];
    storeRecord.moduleName=moduleName;
    storeRecord.bookId=bookId;
    storeRecord.timeStampDownload=downloadTime;
    [storeRecord insert];
}

+(void)insertBookStoreUser:(NSString *)bookId withBookCode:(NSString *)bookCode isTrail:(BOOL)isTrail lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime{
    ModelBookStoreUser *storeUser=[[ModelBookStoreUser alloc]init];
    storeUser.bookId=bookId;
    storeUser.userId=[ConfigGlobal loginUser].userId;
    storeUser.bookCode=bookCode;
    storeUser.isProbation=isTrail;
    storeUser.lastReadTime=lastReadTime;
    storeUser.lastReadPage=lastReadPage;
    [storeUser insert];

}

//+(void)insertBookStoreUser:(NSString *)bookId isTrail:(BOOL)isTrail lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime{
//
//    ModelBookStoreUser *storeUser=[[ModelBookStoreUser alloc]init];
//    storeUser.bookId=bookId;
//   storeUser.userId=[ConfigGlobal loginUser].userId;
//    storeUser.isProbation=isTrail;
//    storeUser.lastReadTime=lastReadTime;
//    storeUser.lastReadPage=lastReadPage;
//    [storeUser insert];
//}

+(void)insertBookDelete:(NSString *)bookId module:(NSString *)module time:(NSTimeInterval)deleteTime{
    ModelBookDeleteRecord *record=[[ModelBookDeleteRecord alloc]init];
    record.bookId=bookId;
    record.userId=[ConfigGlobal loginUser].userId;
    record.moduleName=module;
    record.timeStampDelete=deleteTime;
    [record insert];
}

+(void)updateBookStoreUser:(ModelBookStoreUser *)storeUser isTrail:(BOOL)isTrail lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime{
    if (storeUser.isProbation != isTrail) {
        [storeUser updateByProperty:@"isProbation" propertyValue:[NSNumber numberWithBool:isTrail]];
    }
    
    if(lastReadPage<0){
        
    }else if (storeUser.lastReadPage != lastReadPage) {
        [storeUser updateByProperty:@"lastReadPage" propertyValue:[NSNumber numberWithInt:lastReadPage]];
    }
    
    if (lastReadTime<1) {
        
    }else if (storeUser.lastReadTime != lastReadTime) {
        [storeUser updateByProperty:@"lastReadTime" propertyValue:[NSNumber numberWithDouble:lastReadTime]];
    }
}


//添加或者更新 用户的书本状态 ，是试用、购买，
+(void)updateBookStoreUserInfoOfStateBuyWithBookId:(NSString *)bookId  isTrail:(BOOL)isTrail{
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count]) {
        for (ModelBookStoreUser *storeUser in arrayUserBooksSelect) {
            [UtilBooksOnLocal updateBookStoreUser:storeUser isTrail:isTrail lastReadPage:-1 lastReadTime:0];
        }
        
    }
    
//    else{
//        [UtilBooksOnLocal insertBookStoreUser:bookId isTrail:isTrail lastReadPage:0 lastReadTime:[[NSDate date] timeIntervalSince1970]];
//    }

}

+(void)updateBookStoreUserInfoOfStateReadWithBookId:(NSString *)bookId lastReadTime:(NSTimeInterval)lastReadTime{
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    if (![arrayUserBooksSelect count]) {
        return;
    }
    
    for (ModelBookStoreUser *storeUser in arrayUserBooksSelect) {
        if (storeUser.lastReadTime != lastReadTime) {
            [storeUser updateByProperty:@"lastReadTime" propertyValue:[NSNumber numberWithDouble:lastReadTime]];
        }
    }
}

+(void)updateBookStoreUserInfoOfStateReadWithBookId:(NSString *)bookId lastReadPage:(int)lastReadPage{
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    if (![arrayUserBooksSelect count]) {
        return;
    }
    
    for (ModelBookStoreUser *storeUser in arrayUserBooksSelect) {
        
        if(lastReadPage>=0 && storeUser.lastReadPage != lastReadPage){
            [storeUser updateByProperty:@"lastReadPage" propertyValue:[NSNumber numberWithInt:lastReadPage]];

        }
    }
}

//添加或者更新 用户的书本阅读状态 最后阅读时间，最后阅读页  lastReadPage=-1的时候表示不更新  lastReadTime==0的时候表示不更新
+(void)updateBookStoreUserInfoOfStateReadWithBookId:(NSString *)bookId  lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime{
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count]) {
        for (ModelBookStoreUser *storeUser in arrayUserBooksSelect) {
            [UtilBooksOnLocal updateBookStoreUser:storeUser isTrail:storeUser.isProbation lastReadPage:lastReadPage lastReadTime:lastReadTime];
        }
        
    }
}

//添加或者更新 用户的指定书本的信息 ，是否是试用、购买，最后阅读时间，最后阅读页  lastReadPage=-1的时候表示不更新  lastReadTime==0的时候表示不更新
+(void)updatedBookOfUserInfoWithBookId:(NSString *)bookId isTrail:(BOOL)isTrail lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime{
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count]) {
        for (ModelBookStoreUser *storeUser in arrayUserBooksSelect) {
            [UtilBooksOnLocal updateBookStoreUser:storeUser isTrail:isTrail lastReadPage:lastReadPage lastReadTime:lastReadTime];
        }
    }
//    else{
////        [UtilBooksOnLocal insertBookStoreUser:bookId isTrail:isTrail lastReadPage:lastReadPage lastReadTime:lastReadTime];
//        
//    }
    
}


// 把书本的信息添加到本地书库
+(void)insertLocalBookInfo:(ModelBookInfoDetail *)bookInfo{
    
    NSArray *arraySelectBook=[ModelBookStoreShare selectByProperty:@"bookId" propertyValue:bookInfo.bookId];
    NSTimeInterval downloadTime=[[NSDate date] timeIntervalSince1970];
    
    if ([arraySelectBook count]<1) {
        ModelBookStoreShare *shareBook=[[ModelBookStoreShare alloc]init];
        shareBook.bookId=bookInfo.bookId;
        shareBook.bookCode=bookInfo.code;
        shareBook.bookName=bookInfo.bookName;
        shareBook.bookCachePath=[UtilBooksOnLocal bookDirectoryOfLocalWithBookId:bookInfo.bookId];
        shareBook.bookCover=bookInfo.cover;
        shareBook.timeStampDownload=downloadTime;//下载时间
        shareBook.bookUnits=bookInfo.usableUnits;
        [shareBook insert];
        
    }else{
        for (ModelBookStoreShare *shareBook in arraySelectBook) {
            [shareBook updateByProperty:@"bookCachePath" propertyValue:[UtilBooksOnLocal bookDirectoryOfLocalWithBookId:shareBook.bookId]];

        }
    }
}

@end
