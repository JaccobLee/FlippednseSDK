//
//  NetworkService+Books.h
//  iEnglish
//
//  Created by JacobLi on 3/1/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "NetworkService.h"

@interface NetworkService (Books)

// 获取所有书目列表
+ (void)requestBookGetAllBooksWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

// 获取所有书目列表 在线
+ (void)requestBookGetAllOnlineBooksWithUser:(int)user success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

// 通过bookid或者bookCode(书本编码，出版社系统书本ID)获取详情，userId选填， bookId和bookCode必填一个
+ (void)requestBookDetailInfoWithUserId:(int)userId withBookId:(NSString *)bookId  withCode:(NSString *)bookCode  withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//通过外研社用户ID 返回用户购买的课本信息及绑定的设备信息
+ (void)requestBooksWithDeadlineWithUserId:(int)userWaiYansheId  withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
// 获取书目元数据下载地址， bookid为书目id或者eid ， mode为preview/all两种模式
+ (void)requestBookGetBookMetaDataWithBookId:(NSString *)bid withMode:(NSString *)mode success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
// 通过书目的下载地址进行下载
+ (void)downLoadBookWithLocation:(NSString *)strUrl bookId:(NSString *)bid parameters:(id)parameters resumeData:(NSData *)redata progress:(void (^)(NSProgress *))downprogress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


// 获取书目某单元模块的元数据下载地址， bookid为书目id或者eid
+ (void)requestBookGetModuleUnitMetaDataWithBookId:(NSString *)bid withModuleName:(NSString *)moduleName success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
// 通过书目的下载地址进行下载
+ (void)downLoadBookModuleUnitWithLocation:(NSString *)strUrl bookId:(NSString *)bid parameters:(id)parameters resumeData:(NSData *)redata progress:(void (^)(NSProgress *))downprogress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
// 获取书本可下载单元模块名称
+ (void)requestBookGetDownloadableModuleUnitBookEid:(NSString *)bid success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

// O元购书
+ (void)requestFreeBuyBookWithUserId:(int)userId withBookEditionId:(int)bookEditionId withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

// 下订单
+ (void)requestBookBuyBookWithUserId:(int)userId withBookEditionId:(int)bookEditionId withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
// 套餐订单
+ (void)requestBookBuyPackageBookWithUserId:(int)userId withBookPackageId:(int)bookPackageId withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//获取用户未购书库
+ (void)requestBookNoBuyWithUserId:(int)userId withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
// 购买纪录
+ (void)requestBookGetPayHistoryWithUserId:(int)userId withPage:(int)page withRows:(int)rows withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+(void)requestBookIsNeedUnBind:(NSString *)book_eid withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)requestBookSwitchToBind:(NSString *)book_eid withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end
