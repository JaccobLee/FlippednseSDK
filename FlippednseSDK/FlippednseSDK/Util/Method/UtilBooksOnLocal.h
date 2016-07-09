//
//  UtilBooksOnLocal.h
//  iEnglish
//
//  Created by Zang Sam on 16/4/14.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBookInfo.h"
#import "ModelBookStore.h"


typedef enum : NSUInteger {
    BookStateOfUserHasDownload,
    BookStateOfUserDownloadDuring,
    BookStateOfUserUnDownload,
} BookStateOfUser;

@interface UtilBooksOnLocal : NSObject

/*
 *判断本地是否有共享书本，用于未登录的时候
 */
+(BOOL)isHasSharedBookOnLocal;
/*
 *返回书本在本地的状态，正常，删除，在下载中
 */
+(LocalBookState)stateOfBookInLocal:(NSString *)bookId;
/*判断用户在本地时候下载过此书*/
//+(BOOL)bookOfUserHasDownload:(NSString *)bookId;

+(BookStateOfUser)bookOfUserState:(NSString *)bookId;


+(BOOL)isDownloadStateOfBook:(NSString *)bookId;

/*判断本地是否有该书*/
+(BOOL)bookIsHasInLocal:(NSString *)bookId;

/*
 *判断书本是否已经删除
 */
+(BOOL)bookIsDeleteFromLocal:(NSString *)bookId;
/*
 *判断书本是否已经删除,根据书本的保存路径,这个 方法现在不适用
 */
//+(BOOL)bookIsDeleteFromLocalWithWithDirectory:(NSString *)directory;

/*
 *删除本地的文件
 */
+(void)bookDeleteLocalFile:(NSString *)directory;

/*获取图书的保存在本地的路径*/
+(NSString *)bookDirectoryOfLocalWithBookId:(NSString *)bid;
+(NSString *)bookCacheDirectoryOfLocalWithBookId:(NSString *)bid;

/*
 *获取用户的书架，包含登录的用户和未登录的用户
 *return UserBookShelfOnLocal的数组
 *获取本地书架，如果是进入的书架，需要调用此函数
 */
+(NSMutableArray *)localBookshelf;


/*
 *获取某个用户的本地书架上,固定的用户
 *return UserBookShelfOnLocal的数组
 *获取单人的本地书库，需要调用此函数
 */
+(NSMutableArray *)localBookshelfOfUser:(int)userId;
/*
 *把书本从用户的书架上删除
 *bookId
 *bookStoreShareId:0
 */
+(void)bookOfUserDeleteFromShelf:(NSString *)bookId withBookStoreShareId:(int)bookStoreShareId finishRefreshView:(void (^)())refreshView;

/*把书本从用户的书架上删除,同时从本地缓存中删除*/
+(void)bookOfUserDeleteFromShelfAndLocal:(NSString *)bookId withBookStoreShareId:(int)bookStoreShareId finishRefreshView:(void (^)())refreshView;

+(void)saveBookInfoToLocal:(BOOL)isFreeTrail bookInfo:(ModelBookInfoDetail *)bookInfo;
/*保存用户的信息*/
+(void)saveDownloadOfBookInfo:(BOOL)isFreeTrail bookInfo:(ModelBookInfoDetail *)bookInfo isDownloadFromServer:(BOOL)isFromServer;

/*插入本地书库下载单元信息*/
+(void)insertBookStoreUnitDownloadWithId:(NSString *)bookId unitName:(NSString *)unitName downloadTime:(NSTimeInterval)downloadTime;
/*插入所有下载模块记录，*/
+(void)insertBookStoreDownloadRecordWithId:(NSString *)bookId moduleName:(NSString *)moduleName downloadTime:(NSTimeInterval)downloadTime;
+(void)insertBookOnLocalRecordWithId:(NSString *)bookId moduleName:(NSString *)moduleName downloadTime:(NSTimeInterval)downloadTime;
//删除标记本地的包含书的模块的记录
+(void)localBookHasRecordDelete:(NSString *)bookId;
//+(void)checkIsInUserShelfWhenStudy:(NSString *)bookId isFreeTrail:(BOOL)isFreeTrail;
+(void)checkIsInUserShelfWhenStudy:(NSString *)bookId withBookCode:(NSString *)bookCode isFreeTrail:(BOOL)isFreeTrail;
/*插入用户的书架记录，未检验该用户下是否有bookId的图书*/
+(void)insertBookStoreUser:(NSString *)bookId withBookCode:(NSString *)bookCode isTrail:(BOOL)isTrail lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime;

//+(void)insertBookStoreUser:(NSString *)bookId isTrail:(BOOL)isTrail lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime;
+(void)insertBookDelete:(NSString *)bookId module:(NSString *)module time:(NSTimeInterval)deleteTime;
//添加或者更新 用户的书本状态 ，是试用还是购买，试用传YES 购买传NO
+(void)updateBookStoreUserInfoOfStateBuyWithBookId:(NSString *)bookId  isTrail:(BOOL)isTrail;
+(void)updateBookStoreUserInfoOfStateReadWithBookId:(NSString *)bookId lastReadTime:(NSTimeInterval)lastReadTime;
+(void)updateBookStoreUserInfoOfStateReadWithBookId:(NSString *)bookId lastReadPage:(int)lastReadPage;

//添加或者更新 用户的书本阅读状态 最后阅读时间，最后阅读页  lastReadPage=-1的时候表示不更新  lastReadTime==0的时候表示不更新
+(void)updateBookStoreUserInfoOfStateReadWithBookId:(NSString *)bookId  lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime;
//添加或者更新 建议是登录的情况下用 用户的指定书本的信息 ，是否是试用、购买，最后阅读时间，最后阅读页 试用isTrail传YES 购买isTrail传NO  lastReadPage=-1的时候表示不更新  lastReadTime==0的时候表示不更新
+(void)updatedBookOfUserInfoWithBookId:(NSString *)bookId isTrail:(BOOL)isTrail lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime;
/*
 *登陆的用户
 *添加或者更新 用户的指定书本的信息 ，是否是试用、购买，最后阅读时间，最后阅读页
 */
//+(void)bookOfUserInfoUpdatedWithBookId:(NSString *)bookId isTrail:(BOOL)isTrail lastReadPage:(int)lastReadPage lastReadTime:(NSTimeInterval)lastReadTime;

// 把书本的信息添加到本地书库
+(void)insertLocalBookInfo:(ModelBookInfoDetail *)bookInfo;
@end
