//
//  NetWorkServiceOfDownload.h
//  iEnglish
//
//  Created by Zang Sam on 16/4/25.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetworkService.h"
#import "ModelBookStore.h"

@interface BookOfURLSessionDownloadTask: NSURLSessionDownloadTask{
   NSString *identityOfTask; //标志 书本
   NSNumber *progressValue; //标志 书本
   DownloadTaskOfState  downloadTaskState;
}
@property(nonatomic,strong)NSString *identityOfTask; //标志 书本
@property(nonatomic,strong)NSNumber *progressValue; //标志 书本
@property(nonatomic,assign)DownloadTaskOfState  downloadTaskState;
@end

//typedef void (^DownloadTheProgress)(float progressValue,NSProgress *downprogress);

@protocol DownloadBooksDelegate <NSObject>
//请求书本的下载地址的结果，若没有请求到，返回空字符串，请求到的时候，返回下载地址
-(void)requestTheBookLocationResult:(NSString *)bookLocationOnUrl withBookId:(NSString *)booId;

//本地已经有这本书的时候，不用系在
//-(void)localHasExitsTheBook:(NSString *)bid;

//书本缓存失败时调用的方法
-(void)requestTheBookLocationResultFailed:(NSString *)booId response:(NSError *)error;

//下载进度
-(void)downloadTheProgressOfBook:(NSString *)booId progress:(NSNumber *)progressValue downProgressObj:(NSProgress *)downprogress;

//书本缓存完成时调用的方法
-(void)cacheSuccessOfBook:(NSString *)booId response:(id)responseObject;
@optional
//书本缓存成功时调用的方法，目前没用到，因为用的时cacheSuccessOfBook这个方法
-(void)downloadSuccessOfBook:(NSString *)booId response:(id)responseObject;

//书本缓存失败时调用的方法
-(void)downloadFailedOfBook:(NSString *)booId response:(NSError *)error;
@end




@interface NetWorkServiceOfDownload : NetworkService{
    AFHTTPSessionManager    *serviceDownloadManager;
    __weak  id<DownloadBooksDelegate>  delegate;

}
@property (nonatomic, weak) id<DownloadBooksDelegate>  delegate;
@property (nonatomic, strong) AFHTTPSessionManager  *serviceDownloadManager;

+ (instancetype)sharedNetworkServiceOfDownload;

- (void)requestGetBookMetaDataWithBookId:(NSString *)bid withEid:(NSString *)eid withMode:(NSString *)mode;

- (void)requestGetBookMetaDataWithBookId:(NSString *)bid withMode:(NSString *)mode;

-(void)requestDownLoadBookWithLocation:(NSString *)strUrl bookId:(NSString *)bid parameters:(id)parameters resumeData:(NSData *)redata;
-(void)resumeDownloadTaskWithTheBook:(NSString *)bookId withBookCode:(NSString *)bookCode withSuccessResume:(void (^)())successResume isFailResume:(void (^)())failResume;

//-(void)resumeDownloadTaskWithTheBook:(NSString *)bookId withRefreshView:(void (^)(BOOL isNeed))refreshView;

-(void)downloadDownWithPath:(NSString *)path  withBook:(NSString *)bid;
-(void)pauseTheDownloadTask:(NSString *)locationUrl book:(NSString *)bookId  withSuccessPause:(void (^)())successPause isFailPause:(void (^)())failPause;
//-(void)pauseDownloadTaskWithTheBook:(NSString *)bookId  bookUrlLocation:(NSString *)locationUrl;


- (void)downloadLoadUseUnWIFIcertain:(void (^)())wwanMethod cancel:(void (^)())cancelMethod wifiMethod:(void (^)())wifiMethod;

-(void)pauseDownloadTask:(NSURLSessionDownloadTask *)task withBookId:(NSString *)bookId;
-(void)deleteCacheBook:(NSString *)bookIdDelete withIsDeleteDataRecord:(BOOL)isDeleteData;
-(UserDownloadRunningRecord *)bookInLocalIsHasDownload:(NSString *)bookId;
-(NSURLSessionDownloadTask *)downloadTaskOfTheBook:(NSString *)bookId withUrlLoaction:(NSString *)locationUrl;

-(void)pauseAllDownlaodProgress;

-(void)downloadDoneWithBook:(NSString *)bookId;
//-(void)resumeAllDownlaodProgress;
@end
