//
//  NetWorkServiceOfDownload.m
//  iEnglish
//
//  Created by Zang Sam on 16/4/25.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import "NetWorkServiceOfDownload.h"
#import "ModelUser.h"
#import "UtilBooksOnLocal.h"
#import <ZipArchive/ZipArchive.h>
#import "ConfigNetwork.h"
#import "UtilMethod.h"
#import "NSDictionary+safeObjectForKeyValue.h"
#import "UIAlertView+Blocks.h"

#define isOnSql 1


#pragma mark -BookOfURLSessionDownloadTask
@implementation BookOfURLSessionDownloadTask
@synthesize identityOfTask,progressValue,downloadTaskState;

@end

static NetWorkServiceOfDownload *downloadService;

#pragma mark -NetWorkServiceOfDownload
@implementation NetWorkServiceOfDownload
@synthesize serviceDownloadManager,delegate;


+ (instancetype)sharedNetworkServiceOfDownload
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!downloadService)
        {
            downloadService = [[self alloc] init];
            
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            config.timeoutIntervalForRequest = 10;
            downloadService.serviceDownloadManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
            
            [downloadService.serviceDownloadManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request)
             {
                 return task.currentRequest;
             }];
        }
    });
    
    return downloadService;
}
- (void)requestGetBookMetaDataWithBookId:(NSString *)bid withEid:(NSString *)eid withMode:(NSString *)mode
{
    NSLog(@"download task has not task to resume 8 is duting:%@",bid);

    NetWorkServiceOfDownload *service = [NetWorkServiceOfDownload sharedNetworkServiceOfDownload];
//    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],@"timestamp", eid,@"id", @"preview",@"mode",nil];
    NSDictionary *dicParameters;
    
    if ([mode isEqualToString:@"preview"]) {
        dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],@"timestamp", eid,@"id", @"preview",@"mode",nil];
 
    }else
    if ([ConfigGlobal loginUser].userId) {
        dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],@"timestamp", eid,@"id", [ConfigGlobal loginUser].userId?@"all":@"preview",@"mode", [NSNumber numberWithInt:[ConfigGlobal loginUser].userId],@"user_eid", [UtilMethod deviceIsIphone]?@"mobile":@"pad",@"device_type", [UtilMethod deviceUUId],@"device",nil];
    }else{
        dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],@"timestamp", eid,@"id", @"preview",@"mode",nil];
    }

//    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],@"timestamp", eid,@"id", [ConfigGlobal loginUser].userId?@"preview":@"all",@"mode",  [ConfigGlobal loginUser].userId,@"user_eid", [UtilMethod deviceIsIphone]?@"mobile":@"pad",@"device_type", [UtilMethod deviceUUId],@"device",nil];
    
//            NSLog(@"downloadThe book:%@\n params:%@",[NSString stringWithFormat:@"%@%@%@%@",BaseUrlWebSite,@"api/v1/books/",eid,@"/meta"],AddSignWithRequestParameters(dicParameters));

    [service requestUrl:[NSString stringWithFormat:@"%@%@%@%@",BaseUrlWebSite,@"api/v1/books/",eid,@"/meta"] parameters:AddSignWithRequestParameters(dicParameters) success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse *response2 = responseObject;

         NSLog(@"downloadThe book:%@\n params:%@ \n result:%@",[NSString stringWithFormat:@"%@%@%@%@",BaseUrlWebSite,@"api/v1/books/",eid,@"/meta"],AddSignWithRequestParameters(dicParameters),[[response2 allHeaderFields] safeObjectForKey:@"Location"]);

         
         NSString *locationUrl=@"";
         if ([responseObject isKindOfClass:[NSHTTPURLResponse class]])
         {
             NSHTTPURLResponse *response = responseObject;
             locationUrl = [[response allHeaderFields] safeObjectForKey:@"Location"];
             
             if ([trimOfNoNullStr(locationUrl) length]) {
                 [self insertDownloadRunningBookInfo:bid progress:0.0f location:locationUrl state:DownloadTaskOfStatePrepare];
                 [self requestDownLoadBookWithLocation:locationUrl bookId:bid parameters:nil resumeData:nil];
             }
             
         }
         if ([trimOfNoNullStr(locationUrl) length]) {
             if (delegate && [delegate respondsToSelector:@selector(requestTheBookLocationResult:withBookId:)]) {
                 [delegate requestTheBookLocationResult:locationUrl withBookId:bid];
             }
             
         }else{
             if (delegate && [delegate respondsToSelector:@selector(requestTheBookLocationResultFailed:response:)]) {
                 [delegate requestTheBookLocationResultFailed:bid response:nil];
             }
         }
         
        
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"downloadThe book failed:%@\n params:%@ \n result:%@",[NSString stringWithFormat:@"%@%@%@%@",BaseUrlWebSite,@"api/v1/books/",eid,@"/meta"],AddSignWithRequestParameters(dicParameters),error);

         if (delegate && [delegate respondsToSelector:@selector(requestTheBookLocationResultFailed:response:)]) {
             [delegate requestTheBookLocationResultFailed:bid response:error];
         }
              } method:@"GET"];
}

- (void)requestGetBookMetaDataWithBookId:(NSString *)bid withMode:(NSString *)mode
{
    
//    if([UtilBooksOnLocal bookIsHasInLocal:bid]){
////        if (delegate && [delegate respondsToSelector:@selector(localHasExitsTheBook:)]) {
////            [delegate localHasExitsTheBook:bid];
////        }
//        return;
//    }
    
    NSLog(@"download task has not task to resume 6 is duting:%@",bid);

    NetWorkServiceOfDownload *service = [NetWorkServiceOfDownload sharedNetworkServiceOfDownload];
    //    [mode isEqualToString:@""]?([ConfigGlobal loginUser].userId?@"all":@"preview"):mode
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],@"timestamp", bid,@"id", @"preview",@"mode",nil];
    
    [service requestUrl:[NSString stringWithFormat:@"%@%@%@%@",BaseUrlWebSite,@"api/v1/books/",bid,@"/meta"] parameters:AddSignWithRequestParameters(dicParameters) success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         NSString *locationUrl=@"";
         if ([responseObject isKindOfClass:[NSHTTPURLResponse class]])
         {
             NSHTTPURLResponse *response = responseObject;
             locationUrl = [[response allHeaderFields] safeObjectForKey:@"Location"];
             [self insertDownloadRunningBookInfo:bid progress:0.0f location:locationUrl state:DownloadTaskOfStatePrepare];
             [self requestDownLoadBookWithLocation:locationUrl bookId:bid parameters:nil resumeData:nil];

         }
         
         if (delegate && [delegate respondsToSelector:@selector(requestTheBookLocationResult:withBookId:)]) {
             [delegate requestTheBookLocationResult:locationUrl withBookId:bid];
         }
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         if (delegate && [delegate respondsToSelector:@selector(requestTheBookLocationResultFailed:response:)]) {
             [delegate requestTheBookLocationResultFailed:bid response:error];
         }
         
         
     } method:@"GET"];
}

#if isOnSql

-(UserDownloadRunningRecord *)bookInLocalIsHasDownload:(NSString *)bookId{
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    
    if ([arrayUserBooksSelect count]) {
        return [arrayUserBooksSelect objectAtIndex:0];
    }
//    for (UserDownloadRunningRecord *record in arrayUserBooksSelect) {
//        return record;
////        NSURLSessionDownloadTask *task=[self downloadTaskOfTheBook:bookId withUrlLoaction:record.downloadStr];
////        if (task) {
////            return record;
////        }
//    }
//    
    return nil;

}
-(void)updateDownloadBookProgress:(NSString *)bookId progress:(float)progress{
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count]) {
        
        for (UserDownloadRunningRecord *storeUser in arrayUserBooksSelect) {
//            if (progress>0) {
                [storeUser updateByProperty:@"progress" propertyValue:[NSNumber numberWithFloat:progress]];
//            }
        }
    }
}
-(void)updateDownloadBookState:(NSString *)bookId  state:(NSInteger)state{
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count]) {
        for (UserDownloadRunningRecord *storeUser in arrayUserBooksSelect) {
            if (state==storeUser.downloadState) {
                continue;
            }
            [storeUser updateByProperty:@"downloadState" propertyValue:[NSNumber numberWithInteger:state]];
        }
    }
}


-(void)updateDownloadingBook:(NSString *)bookId progress:(float)progress state:(NSInteger)state{
//    int userId=[ConfigGlobal loginUser].userId;
//    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];

    if ([arrayUserBooksSelect count]) {
        for (UserDownloadRunningRecord *storeUser in arrayUserBooksSelect) {
//            if (progress>=0) {
                [storeUser updateByProperty:@"progress" propertyValue:[NSNumber numberWithFloat:progress]];

//            }
            if (state==storeUser.downloadState) {
                continue;
            }
            [storeUser updateByProperty:@"downloadState" propertyValue:[NSNumber numberWithInteger:state]];
        }
    }
}


-(void)updateDownloadingBook:(NSString *)bookId location:(NSString *)locationUrl{
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];

//    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count]) {
        for (UserDownloadRunningRecord *storeUser in arrayUserBooksSelect) {
            [storeUser updateByProperty:@"downloadStr" propertyValue:locationUrl];
        }
    }
}


-(void)deleteCacheBook:(NSString *)bookIdDelete withIsDeleteDataRecord:(BOOL)isDeleteData{
    //删除已经缓存的文件
    if (isDeleteData) {
        [self downloadDoneWithBook:bookIdDelete];

    }
    //删掉缓存文件
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    // 创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bookDirPath isDirectory:nil])
    {
        if (![fileManager createDirectoryAtPath:bookDirPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            return;
        }
    }
    
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",bookIdDelete]];
    if ([fileManager fileExistsAtPath:bookPathUnzip])
    {
        [fileManager removeItemAtPath:bookPathUnzip error:nil];
    }
    
    [UtilBooksOnLocal bookDeleteLocalFile:[UtilBooksOnLocal bookCacheDirectoryOfLocalWithBookId:bookIdDelete]];
    [UtilBooksOnLocal bookDeleteLocalFile:[UtilBooksOnLocal bookDirectoryOfLocalWithBookId:bookIdDelete]];
    
}

-(void)downloadDoneWithBook:(NSString *)bookId{
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];
    for (UserDownloadRunningRecord *storeUser in arrayUserBooksSelect) {
        [storeUser delete];
    }
    
}



-(void)insertDownloadRunningBookInfo:(NSString *)bookId progress:(float)progress location:(NSString *)locationUrl state:(NSInteger)state{
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count]) {
        for (UserDownloadRunningRecord *storeUser in arrayUserBooksSelect) {
            [storeUser updateByProperty:@"progress" propertyValue:[NSNumber numberWithFloat:progress]];
            [storeUser updateByProperty:@"downloadStr" propertyValue:locationUrl];
            [storeUser updateByProperty:@"downloadState" propertyValue:[NSNumber numberWithInteger:state]];
        }
    }else{
        UserDownloadRunningRecord *storeDownload=[[UserDownloadRunningRecord alloc]init];
        storeDownload.bookId=bookId;
        storeDownload.userId=[ConfigGlobal loginUser].userId;
        storeDownload.downloadStr=locationUrl;
        storeDownload.progress=progress;
        storeDownload.downloadState=state;
        storeDownload.isWillDelete=NO;
        [storeDownload insert];
        
    }
}

#endif

-(void)requestDownLoadBookWithLocation:(NSString *)strUrl bookId:(NSString *)bid parameters:(id)parameters resumeData:(NSData *)redata
{
    NetWorkServiceOfDownload *service = [NetWorkServiceOfDownload sharedNetworkServiceOfDownload];

    [self updateDownloadBookState:bid state:DownloadTaskOfStateDuring];
    NSLog(@"download task has not task to resume 7 is duting:%@",bid);

    [service downLoadWithStrUrl:strUrl userInfo:bid parameters:parameters progress:^(NSProgress *progress) {
        
        if (progress.totalUnitCount>=progress.completedUnitCount) {
            float downProgress=0.0f;

            if (progress.totalUnitCount > 0)
            {
                downProgress=progress.completedUnitCount * 1.0 / (progress.totalUnitCount * 1.0);
            }
            
            if(downProgress>=1.0){
//                NSLog(@"download progress ：1  %.2f;",downProgress);
                [self updateDownloadBookState:bid state:DownloadTaskOfStateUnZip];
            }
//            NSLog(@"download other progress : %.2f;",downProgress);
            [self updateDownloadBookProgress:bid progress:downProgress];
            
            if (delegate && [delegate respondsToSelector:@selector(downloadTheProgressOfBook:progress:downProgressObj:)]) {
                [delegate downloadTheProgressOfBook:bid progress:[NSNumber numberWithFloat:downProgress] downProgressObj:progress];
            }

        }
        
      
    } cachePath:^(NSString *path, id userAddition)
     {
         [self downloadDownWithPath:path withBook:bid];
     
     } success:^(NSURLSessionDataTask *task, id responseObject)
     {
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self updateDownloadBookState:bid state:DownloadTaskOfStateFailed];
         //删掉缓存文件
         [UtilBooksOnLocal bookDeleteLocalFile:[UtilBooksOnLocal bookCacheDirectoryOfLocalWithBookId:bid]];
#if 1
         NSString *bookDirPath = [ConfigGlobal cachePathBooks];
         // 创建目录
         NSFileManager *fileManager = [NSFileManager defaultManager];
         if (![fileManager fileExistsAtPath:bookDirPath isDirectory:nil])
         {
             if (![fileManager createDirectoryAtPath:bookDirPath withIntermediateDirectories:YES attributes:nil error:nil])
             {
                 return;
             }
         }
         
         
         NSString *bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",bid]];
         NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
         if ([fileManager fileExistsAtPath:bookPath])
         {
             [fileManager removeItemAtPath:bookPath error:nil];
         }
         if ([fileManager fileExistsAtPath:bookPathUnzip])
         {
             [fileManager removeItemAtPath:bookPathUnzip error:nil];
         }
         
#endif
         if (delegate && [delegate respondsToSelector:@selector(downloadFailedOfBook:response:)]) {
             [delegate downloadFailedOfBook:bid response:error];
         }
     } resumeData:redata];
    
}


- (void)downloadLoadUseUnWIFIcertain:(void (^)())wwanMethod cancel:(void (^)())cancelMethod wifiMethod:(void (^)())wifiMethod
{
    
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus networkStatus = [reachManager networkReachabilityStatus];
    switch (networkStatus)
    {
        case AFNetworkReachabilityStatusUnknown:
        {
            return;
        }
            break;
        case AFNetworkReachabilityStatusNotReachable:
        {
            return;
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            [UIAlertView showAlertViewWithTitle:Locale(@"未连接到wifi网络，是否使用流量下载") message:nil cancelButtonTitle:nil otherButtonTitles:@[Locale(@"取消"),Locale(@"确认下载")] onDismiss:^(int buttonIndex) {
                if (buttonIndex == -1)
                {
                    cancelMethod();
                    return;
                }
                else if (buttonIndex == 0)
                {
                    wwanMethod();
                }
            } onCancel:^{
            }];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            wifiMethod();
        }
            break;
        default:
            break;
    }
}



//(lldb) po path
///Users/sam/Library/Developer/CoreSimulator/Devices/757E95F8-D4C7-454B-BB4C-7E47303D58D5/data/Containers/Data/Application/184B3A7E-0DC9-44D3-9168-D2F106C613BA/tmp/CFNetworkDownload_ay0rp0.tmp
//
//(lldb) po bookPath
///Users/sam/Library/Developer/CoreSimulator/Devices/757E95F8-D4C7-454B-BB4C-7E47303D58D5/data/Containers/Data/Application/184B3A7E-0DC9-44D3-9168-D2F106C613BA/Documents/books/11.zip
//
//(lldb) po bookPathUnzip
///Users/sam/Library/Developer/CoreSimulator/Devices/757E95F8-D4C7-454B-BB4C-7E47303D58D5/data/Containers/Data/Application/184B3A7E-0DC9-44D3-9168-D2F106C613BA/Documents/books/11
//
//(lldb) po bookDirPath
///Users/sam/Library/Developer/CoreSimulator/Devices/757E95F8-D4C7-454B-BB4C-7E47303D58D5/data/Containers/Data/Application/184B3A7E-0DC9-44D3-9168-D2F106C613BA/Documents/books

-(void)downloadDownWithPath:(NSString *)path  withBook:(NSString *)bid{

    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    // 创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bookDirPath isDirectory:nil])
    {
        if (![fileManager createDirectoryAtPath:bookDirPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            return;
        }
    }
    
    
    NSString *bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",bid]];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    if ([fileManager fileExistsAtPath:bookPath])
    {
        [fileManager removeItemAtPath:bookPath error:nil];
    }
    if ([fileManager fileExistsAtPath:bookPathUnzip])
    {
        [fileManager removeItemAtPath:bookPathUnzip error:nil];
    }
    
    if ([fileManager copyItemAtPath:path toPath:bookPath error:nil]) {
        ZipArchive *zip = [[ZipArchive alloc] initWithFileManager:fileManager];
        __block ZipArchive *tempZip = zip;
        zip.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles)
        {
            if (percentage == 100)
            {
                [tempZip UnzipCloseFile];
//                  success(@"下载并解压完成");
                
                NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bid,@"bookId", nil]];

                BOOL isDelete=NO;
                if ([arrayUserBooksSelect count]) {
                    UserDownloadRunningRecord *storeUser=arrayUserBooksSelect[0];
                    if (storeUser.isWillDelete) {
                        isDelete=YES;
                    }
                }else{
                     isDelete=YES;
                }
    
                if (isDelete) {
                    [self deleteCacheBook:bid withIsDeleteDataRecord:YES];
                    [UtilBooksOnLocal bookDeleteLocalFile:path];

                }else{
                    NSArray *share=[ModelBookStoreShare selectByProperty:@"bookId" propertyValue:bid];
                    ModelBookStoreShare *bookTemp;
                    bookTemp=[share objectAtIndex:0];
                    NSTimeInterval downloadTime=[[NSDate date] timeIntervalSince1970];
                    
                    NSArray *arrayUnit=[bookTemp.bookUnits componentsSeparatedByString:@","];
                    [UtilBooksOnLocal insertBookStoreUnitDownloadWithId:bookTemp.bookId unitName:[arrayUnit objectAtIndex:0] downloadTime:downloadTime];
                    [UtilBooksOnLocal insertBookStoreDownloadRecordWithId:bookTemp.bookId moduleName:[arrayUnit objectAtIndex:0] downloadTime:downloadTime];
                    [UtilBooksOnLocal insertBookOnLocalRecordWithId:bookTemp.bookId moduleName:[arrayUnit objectAtIndex:0] downloadTime:downloadTime];
                    
                    [self downloadDoneWithBook:bid];
                    if (delegate && [delegate respondsToSelector:@selector(cacheSuccessOfBook:response:)]) {
                        [delegate cacheSuccessOfBook:bid response:@"下载并解压完成"];
                    }

                }
                
//                [self downloadDoneWithBook:bid];

            }
        };
        if ([zip UnzipOpenFile:bookPath])
        {
            [zip UnzipFileTo:bookPathUnzip overWrite:NO];
            
            [fileManager removeItemAtPath:bookPath error:nil];
//            [self updateDownloadBookState:bid state:DownloadTaskOfStateDown];
//            
//            if (delegate && [delegate respondsToSelector:@selector(cacheSuccessOfBook:response:)]) {
//                [delegate cacheSuccessOfBook:bid response:@"下载并解压完成"];
//            }
//            
//            [self downloadDoneWithBook:bid];
        }
    }

}

-(void)unZaipPathWithBookId:(NSString *)bookId{
    
    
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    // 创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bookDirPath isDirectory:nil])
    {
        if (![fileManager createDirectoryAtPath:bookDirPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            return;
        }
    }
    NSString *bookTemp=[UtilBooksOnLocal bookCacheDirectoryOfLocalWithBookId:trimOfNoNullStr(bookId)];
    
    BOOL isHasBook_temp=[bookTemp length] && [fileManager fileExistsAtPath:bookTemp];
    
    NSString *bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",bookId]];
    
    BOOL isHasBookPath=[bookPath length] && [fileManager fileExistsAtPath:bookPath];

    
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bookId];
    
    BOOL isHasBookPathUnZip=[bookPathUnzip length] && [fileManager fileExistsAtPath:bookPathUnzip];

    //有书本了
    if (isHasBookPathUnZip) {
        
        return;
    }
    
    //解压
    if(isHasBookPath){
        
    }
    
    if(isHasBook_temp){
        
    }
//    
//    if (isha) {
//        <#statements#>
//    }
//    
//        ZipArchive *zip = [[ZipArchive alloc] initWithFileManager:fileManager];
//        __block ZipArchive *tempZip = zip;
//        zip.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles)
//        {
//            if (percentage == 100)
//            {
//                [tempZip UnzipCloseFile];
//                //                  success(@"下载并解压完成");
//                
//                NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bid,@"bookId", nil]];
//                
//                BOOL isDelete=NO;
//                if ([arrayUserBooksSelect count]) {
//                    UserDownloadRunningRecord *storeUser=arrayUserBooksSelect[0];
//                    if (storeUser.isWillDelete) {
//                        isDelete=YES;
//                    }
//                }else{
//                    isDelete=YES;
//                }
//                
//                if (isDelete) {
//                    [self deleteCacheBook:bid withIsDeleteDataRecord:YES];
//                    [UtilBooksOnLocal bookDeleteLocalFile:path];
//                    
//                }else{
//                    NSArray *share=[ModelBookStoreShare selectByProperty:@"bookId" propertyValue:bid];
//                    ModelBookStoreShare *bookTemp;
//                    bookTemp=[share objectAtIndex:0];
//                    NSTimeInterval downloadTime=[[NSDate date] timeIntervalSince1970];
//                    
//                    NSArray *arrayUnit=[bookTemp.bookUnits componentsSeparatedByString:@","];
//                    [UtilBooksOnLocal insertBookStoreUnitDownloadWithId:bookTemp.bookId unitName:[arrayUnit objectAtIndex:0] downloadTime:downloadTime];
//                    [UtilBooksOnLocal insertBookStoreDownloadRecordWithId:bookTemp.bookId moduleName:[arrayUnit objectAtIndex:0] downloadTime:downloadTime];
//                    [UtilBooksOnLocal insertBookOnLocalRecordWithId:bookTemp.bookId moduleName:[arrayUnit objectAtIndex:0] downloadTime:downloadTime];
//                    
//                    [self downloadDoneWithBook:bid];
//                    if (delegate && [delegate respondsToSelector:@selector(cacheSuccessOfBook:response:)]) {
//                        [delegate cacheSuccessOfBook:bid response:@"下载并解压完成"];
//                    }
//                    
//                }
//                
//                //                [self downloadDoneWithBook:bid];
//                
//            }
//        };
//        if ([zip UnzipOpenFile:bookPath])
//        {
//            [zip UnzipFileTo:bookPathUnzip overWrite:NO];
//            
//            [fileManager removeItemAtPath:bookPath error:nil];
//            //            [self updateDownloadBookState:bid state:DownloadTaskOfStateDown];
//            //
//            //            if (delegate && [delegate respondsToSelector:@selector(cacheSuccessOfBook:response:)]) {
//            //                [delegate cacheSuccessOfBook:bid response:@"下载并解压完成"];
//            //            }
//            //            
//            //            [self downloadDoneWithBook:bid];
//        }
//    
//
//    
//    
//    
//    
//    NSString *bookPath=[UtilBooksOnLocal bookCacheDirectoryOfLocalWithBookId:trimOfNoNullStr(bookId)];
//    if (![bookPath length]) {
//        return ;
//    }
//    // 创建目录
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:bookPath])
//    {
//        [fileManager removeItemAtPath:bookPath error:nil];
//    }
//    
//    [dataTemp writeToFile:bookPath atomically:YES];
}

-(void)resumeDownloadTaskWithTheBook:(NSString *)bookId withRefreshView:(void (^)(BOOL isNeed))refreshView{
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];
    
    if (!arrayUserBooksSelect || ![arrayUserBooksSelect count]) {
        return;
    }
    
    NSString *bookPath = [UtilBooksOnLocal bookCacheDirectoryOfLocalWithBookId:bookId];
    NSData *dataResume = [NSData dataWithContentsOfFile: bookPath];
    if(!dataResume)
    {
        [self requestGetBookMetaDataWithBookId:bookId withMode:@"preview"];
        //        [self requestGetBookMetaDataWithBookId:bookId withMode:[ConfigGlobal loginUser].userId?@"all":@"preview"];
    }else
    {
        [self requestDownLoadBookWithLocation:nil bookId:bookId parameters:nil resumeData:dataResume];
        refreshView(YES);
        
    }

}


-(void)resumeDownloadTaskWithTheBook:(NSString *)bookId withBookCode:(NSString *)bookCode withSuccessResume:(void (^)())successResume isFailResume:(void (^)())failResume{
    //已经下载了此书,无需继续下载
    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];
    
    if (!arrayUserBooksSelect || ![arrayUserBooksSelect count]) {
        NSLog(@"download task has not task to resume 1 is duting:%@",bookId);

        failResume();
        return;
    }

    NSString *bookPath = [UtilBooksOnLocal bookCacheDirectoryOfLocalWithBookId:bookId];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath:bookPath]) {
//        NSLog(@"download task has not task to resume 2 is duting:%@",bookId);
//        [self requestGetBookMetaDataWithBookId:bookId withEid:bookCode withMode:@"preview"];
//
////        [self requestGetBookMetaDataWithBookId:bookId withMode:@"preview"];
//        return;
//    }

    NSData *dataResume = [NSData dataWithContentsOfFile: bookPath];
    if(!dataResume)
    {
        
//        if([UtilBooksOnLocal bookIsHasInLocal:bookId]){
////            [self downloadDoneWithBook:bookId];
////            if (delegate && [delegate respondsToSelector:@selector(cacheSuccessOfBook:response:)]) {
////                [delegate cacheSuccessOfBook:bookId response:@"下载并解压完成"];
////            }
//            return;
//        }
        
        UserDownloadRunningRecord *record=arrayUserBooksSelect[0];

        if ([record.downloadStr isEqualToString:@""]) {
            NSLog(@"download task has not task to resume 10 is duting:%@",bookId);

            [[NetWorkServiceOfDownload sharedNetworkServiceOfDownload] deleteCacheBook:record.bookId withIsDeleteDataRecord:NO];
            //                        [self downloadTaskWithPause];
//            [self downloadTaskWithFailed];
            [self requestGetBookMetaDataWithBookId:bookId withEid:bookCode withMode:@"preview"];

        }else{
            
            NSArray *arrayRequest=[record.downloadStr componentsSeparatedByString:@"?"];
            if ([[arrayRequest objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"http://private.cdn.test.ienglish.jiaoxuebang.cn/images/%@-all.zip",bookCode]]) {
//                [self downloadTaskWithPause];
                NSLog(@"download task has not task to resume 11 is duting:%@",bookId);

                [self requestDownLoadBookWithLocation:record.downloadStr bookId:bookId parameters:nil resumeData:dataResume];

            }else{
                NSLog(@"download task has not task to resume 12 is duting:%@",bookId);

                [[NetWorkServiceOfDownload sharedNetworkServiceOfDownload] deleteCacheBook:record.bookId withIsDeleteDataRecord:NO];
                //                        [self downloadTaskWithPause];
                [self requestGetBookMetaDataWithBookId:bookId withEid:bookCode withMode:@"preview"];
            }
        }
        
        
        NSLog(@"download task has not task to resume 3 is duting:%@",bookId);

//        [self requestGetBookMetaDataWithBookId:bookId withEid:bookCode withMode:@"preview"];

        //        [self requestGetBookMetaDataWithBookId:bookId withMode:[ConfigGlobal loginUser].userId?@"all":@"preview"];
        successResume();
    }else
    {
        NSLog(@"download task has not task to resume 4 is duting:%@",bookId);

        [self requestDownLoadBookWithLocation:nil bookId:bookId parameters:nil resumeData:dataResume];
        successResume();
        
    }
}

-(void)pauseTheDownloadTask:(NSString *)locationUrl book:(NSString *)bookId  withSuccessPause:(void (^)())successPause isFailPause:(void (^)())failPause{

    
//    NSArray *arrayUserBooksSelect= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];
//    
//    if (!arrayUserBooksSelect || ![arrayUserBooksSelect count]) {
//        failPause();
//        return;
//    }
//    UserDownloadRunningRecord *record=arrayUserBooksSelect[0];
//    if (record.progress>=0.98) {
////    if (record.progress>=1.00) {
//        failPause();
//        return;
//    }

    NetWorkServiceOfDownload *service = [NetWorkServiceOfDownload sharedNetworkServiceOfDownload];
    
    for (NSURLSessionDownloadTask *task in service.serviceDownloadManager.downloadTasks)
    {
        if ([[task.originalRequest.URL absoluteString] isEqualToString:locationUrl])
        {
          
            //后加的
            NSArray *arrayUserBooksSelect2= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"bookId", nil]];
            
            if (!arrayUserBooksSelect2 || ![arrayUserBooksSelect2 count]) {
                failPause();
                return;
            }
            UserDownloadRunningRecord *record=arrayUserBooksSelect2[0];
            if (record.progress>=0.98) {
                failPause();
                return;
            }
            
            if([UtilBooksOnLocal bookIsHasInLocal:bookId]){
                [self downloadDoneWithBook:bookId];
                failPause();
                return;
            }

//原先的起点处
            
            
            [self updateDownloadBookState:bookId state:DownloadTaskOfStatePause];
            
            [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                NSData *dataTemp = resumeData;
                
                
                NSString *bookPath=[UtilBooksOnLocal bookCacheDirectoryOfLocalWithBookId:trimOfNoNullStr(bookId)];
                if (![bookPath length]) {
                    return ;
                }
                // 创建目录
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:bookPath])
                {
                    [fileManager removeItemAtPath:bookPath error:nil];
                }
                
                [dataTemp writeToFile:bookPath atomically:YES];
            }];
            
            [task cancel];
            successPause();
            return;
            break;

        }
    }
    
    
  
 
}


-(void)pauseDownloadTaskWithTheBook:(NSString *)bookId  bookUrlLocation:(NSString *)locationUrl{
    
//    UserDownloadRunningRecord *record=[self bookInLocalIsHasDownload:bookId];
//    if ( record && record.progress>1.0) {
//        return;
//    }
    
//    if (record.downloadState==DownloadTaskOfStatEnding) {
//        NSLog(@"下载完毕，无法暂停");
//        return;
//    }
    
    NSURLSessionDownloadTask *task=[self downloadTaskOfTheBook:bookId withUrlLoaction:locationUrl];
    if (task) {
        [self pauseDownloadTask:task withBookId:bookId];
    }
}

-(void)pauseDownloadTask:(NSURLSessionDownloadTask *)task withBookId:(NSString *)bookId{
    if (!task) {
        return;
    }
    [self updateDownloadBookState:bookId state:DownloadTaskOfStatePause];

    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        NSData *dataTemp = resumeData;
        
        NSString *bookDirPath = [ConfigGlobal cachePathBooks];
        // 创建目录
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:bookDirPath isDirectory:nil])
        {
            if (![fileManager createDirectoryAtPath:bookDirPath withIntermediateDirectories:YES attributes:nil error:nil])
            {
                return;
            }
        }
        
        NSString *bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"book_%@_temp",trimOfNoNullStr(bookId)]];
        if ([fileManager fileExistsAtPath:bookPath])
        {
            [fileManager removeItemAtPath:bookPath error:nil];
        }
        
        [dataTemp writeToFile:bookPath atomically:YES];
    }];
    
    [task cancel];
    
}



-(NSURLSessionDownloadTask *)downloadTaskOfTheBook:(NSString *)bookId withUrlLoaction:(NSString *)locationUrl{
    NetWorkServiceOfDownload *service = [NetWorkServiceOfDownload sharedNetworkServiceOfDownload];
    @synchronized(service.serviceDownloadManager){
        if ([service.serviceDownloadManager.downloadTasks count]==0) {
            return nil;
        }
        
        for (NSURLSessionDownloadTask *task in service.serviceDownloadManager.downloadTasks)
        {
            if ([[task.originalRequest.URL absoluteString] isEqualToString:locationUrl])
            {
                return task;
            }
        }
        return nil;

    }
}


- (void)downLoadWithStrUrl:(NSString *)URLString userInfo:(id)userinfo parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgres cachePath:(void (^)(NSString *path, id userAddition))cachePath  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure resumeData:(NSData*)redata
{
    __block id userAddition = userinfo;
    
    if (redata)
    {
        NSURLSessionDownloadTask *downloadTask = [downloadService.serviceDownloadManager downloadTaskWithResumeData:redata progress:^(NSProgress * _Nonnull downloadProgress) {
            downloadProgres(downloadProgress);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSString *strTarget = [targetPath absoluteString];
            if ([strTarget hasPrefix:@"file://"])
            {
                strTarget = [strTarget substringFromIndex:7];
            }
            
            cachePath(strTarget, userAddition);
            
            NSURL *sourcePath = [NSURL URLWithString:strTarget];
            return sourcePath;
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSLog(@"%@\n%@",[response description], [filePath absoluteString]);
            if (error)
            {
            }
        }];
        [downloadTask resume];
    }
    else if (URLString)
    {
        NSURLSessionDownloadTask *downloadTask =[downloadService.serviceDownloadManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] progress:^(NSProgress * _Nonnull downloadProgress) {
            downloadProgres(downloadProgress);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response){
            NSString *strTarget = [targetPath absoluteString];
            if ([strTarget hasPrefix:@"file://"])
            {
                strTarget = [strTarget substringFromIndex:7];
            }
            
            cachePath(strTarget, userAddition);
            
            NSURL *sourcePath = [NSURL URLWithString:strTarget];
            return sourcePath;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error){
            NSLog(@"%@\n%@",[response description], [filePath absoluteString]);
            if (error)
            {
            }
        }];
        
        [downloadTask resume];
    }
}


-(void)pauseAllDownlaodProgress{
    NSArray *allDownloading=[UserDownloadRunningRecord all];
    for (UserDownloadRunningRecord *record in allDownloading) {
//        if ([UtilBooksOnLocal stateOfBookInLocal:record.bookId]==LocalBookStateIsOnDownloadDuring) {
//            [self pauseTheDownloadTask:record.downloadStr book:record.bookId withSuccessPause:^{
//                [self updateDownloadBookState:record.bookId state:DownloadTaskOfStateResume];
//                
//            } isFailPause:^{
//                
//            }];
            
            NetWorkServiceOfDownload *service = [NetWorkServiceOfDownload sharedNetworkServiceOfDownload];
        if (![service.serviceDownloadManager.downloadTasks count]) {
            //后加的
            NSArray *arrayUserBooksSelect2= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:record.bookId,@"bookId", nil]];
            if (!arrayUserBooksSelect2 || ![arrayUserBooksSelect2 count]) {
                continue;
            }
            UserDownloadRunningRecord *record=arrayUserBooksSelect2[0];
            if([UtilBooksOnLocal bookIsHasInLocal:record.bookId]){
                [self downloadDoneWithBook:record.bookId];
                continue;
            }
            //原先的起点处
            [self updateDownloadBookState:record.bookId state:DownloadTaskOfStateResume];
            continue;
        }
        
            for (NSURLSessionDownloadTask *task in service.serviceDownloadManager.downloadTasks)
            {
                NSLog(@"++++++++++++++++++++%@++++++++++++++++++++%@",[task.originalRequest.URL absoluteString],record.downloadStr);
                
                if ([[task.originalRequest.URL absoluteString] isEqualToString:record.downloadStr])
                {
                    
                    NSLog(@";------------------------------");
                    //后加的
                    NSArray *arrayUserBooksSelect2= [UserDownloadRunningRecord selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:record.bookId,@"bookId", nil]];
                    if (!arrayUserBooksSelect2 || ![arrayUserBooksSelect2 count]) {
//                        return;
                        break;
                    }
                    UserDownloadRunningRecord *record=arrayUserBooksSelect2[0];
                    if([UtilBooksOnLocal bookIsHasInLocal:record.bookId]){
                        [self downloadDoneWithBook:record.bookId];
//                        return;
                        break;
                    }
                    //原先的起点处
                    [self updateDownloadBookState:record.bookId state:DownloadTaskOfStatePause];
                    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                        NSData *dataTemp = resumeData;
                        NSString *bookPath=[UtilBooksOnLocal bookCacheDirectoryOfLocalWithBookId:trimOfNoNullStr(record.bookId)];
                        if (![bookPath length]) {
                            return ;
                        
                        }
                        // 创建目录
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        if ([fileManager fileExistsAtPath:bookPath])
                        {
                            [fileManager removeItemAtPath:bookPath error:nil];
                        }
                        
                        [dataTemp writeToFile:bookPath atomically:YES];
                    }];
                    
                    [task cancel];
                    [self updateDownloadBookState:record.bookId state:DownloadTaskOfStateResume];
                    return;
                    break;
                    
                }
            }
            
            

//        }
    
    }
}
//-(void)resumeAllDownlaodProgress{
//    NSArray *allDownloading=[UserDownloadRunningRecord all];
//    for (UserDownloadRunningRecord *record in allDownloading) {
//        
//        if (record.downloadState==DownloadTaskOfStateDuring||record.downloadState==DownloadTaskOfStateResume) {
//            [self resumeDownloadTaskWithTheBook:record.bookId withSuccessResume:^{
//                
//            } isFailResume:^{
//                
//            }];
//        }
//
////        if ([UtilBooksOnLocal stateOfBookInLocal:record.bookId]==LocalBookStateIsOnDownloadDuring) {
//////            [self pauseTheDownloadTask:record.downloadStr book:record.bookId withSuccessPause:^{
//////                
//////            } isFailPause:^{
//////                
//////            }];
////            [self resumeDownloadTaskWithTheBook:record.bookId withSuccessResume:^{
////                
////            } isFailResume:^{
////                
////            }];
////        }
//        
//    }
//}

@end
