//
//  NetworkService+Books.m
//  iEnglish
//
//  Created by JacobLi on 3/1/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "NetworkService+Books.h"
#import "ModelBookInfo.h"
#import "ModelOrder.h"
#import "ModelUser.h"
#import <ZipArchive/ZipArchive.h>
#import "ConfigNetwork.h"
#import "UtilMethod.h"
#import "NSDictionary+safeObjectForKeyValue.h"
#import "ConfigGlobal.h"

@implementation NetworkService (Books)

/*
 通过dictionary返回所有类别中的书目，key为类别名， value为存放书目model的array
*/
+ (void)requestBookGetAllBooksWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],@"timestamp", nil];
    
    [service requestUrl:Url_WebSite_BooksAll parameters:AddSignWithRequestParameters(dicParameters) success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject isKindOfClass:[NSArray class]])
        {
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionary];
            for (id dic in responseObject)
            {
                if ([dic isKindOfClass:[NSDictionary class]])
                {
                    NSArray *arrBooks = [ModelBookInfo arrayOfModelsFromDictionaries:[dic objectForKey:@"books"]];
//                     NSArray *arrkeys = [[dicResult allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                    if (arrBooks)
                    {
                        [dicResult setObject:arrBooks forKey:[dic safeObjectForKey:@"category"]];
                    }
                }
            }
            success(dicResult);
            return;
        }
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    } method:@"GET"];
}


/*
 通过dictionary返回所有类别中的书目，key为类别名， value为存放书目model的array
 */
+ (void)requestBookGetAllOnlineBooksWithUser:(int)user success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:user?[NSNumber numberWithInt:user]:[NSNumber numberWithInt:[ConfigGlobal loginUser].userId],@"userId", nil];//AddSignWithRequestParameters(dicParameters)
    [service requestApi:Url_API_BookStack parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         if([[responseObject objectForKey:@"success"] intValue]){

             NSMutableArray *arrayBooks=[NSMutableArray array];
             for (NSDictionary *dictemp in [responseObject objectForKey:@"data"]) {
                 [arrayBooks addObject:[[BookStoreInfo alloc] initBookStoreInfoWithDictionary:dictemp]];
             }
        
             success(arrayBooks);

             return ;
         }
         success(nil);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         failure(error);
     } method:@"GET"];
}

+ (void)requestBookDetailInfoWithUserId:(int)userId withBookId:(NSString *)bookId  withCode:(NSString *)bookCode  withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionary];
    
    if (userId > 0)
    {
        [dicParameters setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    }
//    if (![trimOfNoNullStr(bookId) isEqualToString:@""])
    if (isValidStr(bookId))

    {
        [dicParameters setObject:bookId forKey:@"bookId"];
    }

        if (isValidStr(bookCode))
        {
            [dicParameters setObject:bookCode forKey:@"code"];
        }
  
    
    [service requestApi:Url_API_BookInfo parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicResult = responseObject;
        if ([[dicResult objectForKey:@"success"] boolValue] == NO)
        {
            success([dicResult safeObjectForKey:@"data"]);
            return;
        }
        
        ModelBookInfoDetail *model = [[ModelBookInfoDetail alloc] initWithDictionary:[dicResult objectForKey:@"data"] error:nil];
        
        if ([[dicResult objectForKey:@"data"] objectForKey:@"bookEditions"])
        {
            NSMutableArray *arrEditions = [ModelBookEdition arrayOfModelsFromDictionaries:[[dicResult objectForKey:@"data"] objectForKey:@"bookEditions"]];
            
            model.bookEditions = arrEditions;
        }
        if ([[dicResult objectForKey:@"data"] objectForKey:@"bookPackageList"])
        {
            NSMutableArray *arrPackages = [ModelBookPackage arrayOfModelsFromDictionaries:[[dicResult objectForKey:@"data"] objectForKey:@"bookPackageList"]];
            
            model.bookPackageList = arrPackages;
        }
        

        success(model);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    } method:@"GET"];
}


+ (void)requestBooksWithDeadlineWithUserId:(int)userWaiYansheId  withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionary];
    
    if (userWaiYansheId > 0)
    {
        [dicParameters setObject:[NSNumber numberWithInt:userWaiYansheId] forKey:@"user_eid"];
    }
    [dicParameters setObject:APP_ID forKey:@"app_id"];
    [dicParameters setObject:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
    [dicParameters setObject:@"pad" forKey:@"device_type"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"nsloag request Dealind time:%@",destDateString);
    [service requestUrl:Url_WebSite_Bought parameters:AddSignWithRequestParameters(dicParameters) success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]])
        {
            
          NSArray *arrayScheme = [ModelBookSchema arrayOfModelsFromDictionaries:responseObject];
            if (arrayScheme && [arrayScheme count]) {
                success(arrayScheme);
            }
            return;
        }
        
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    } method:@"GET"];
}


+ (void)requestBookGetBookMetaDataWithBookId:(NSString *)bid withMode:(NSString *)mode success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],@"timestamp", bid,@"id", mode,@"mode",nil];
    
    [service requestUrl:[NSString stringWithFormat:@"%@%@%@%@",BaseUrlWebSite,@"api/v1/books/",bid,@"/meta"] parameters:AddSignWithRequestParameters(dicParameters) success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSHTTPURLResponse class]])
         {
             NSHTTPURLResponse *response = responseObject;
             NSString *strUrl = [[response allHeaderFields] safeObjectForKey:@"Location"];
             success(strUrl);
             return;
         }
         success(nil);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         failure(error);
     } method:@"GET"];
}

+ (void)downLoadBookWithLocation:(NSString *)strUrl bookId:(NSString *)bid parameters:(id)parameters resumeData:(NSData *)redata progress:(void (^)(NSProgress *))downprogress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    
    [service downLoadWithStrUrl:strUrl userInfo:bid parameters:parameters progress:^(NSProgress *progress) {
        downprogress(progress);
    } cachePath:^(NSString *path, id userAddition)
    {
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
                                        success(@"下载并解压完成");
                                    }
                                };
            if ([zip UnzipOpenFile:bookPath])
            {
                [zip UnzipFileTo:bookPathUnzip overWrite:NO];
                
                [fileManager removeItemAtPath:bookPath error:nil];
            }
        }
    } success:^(NSURLSessionDataTask *task, id responseObject)
    {
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        failure(error);
    } resumeData:redata];
}


// 获取书目某单元模块的元数据下载地址， bookid为书目id或者eid
+ (void)requestBookGetModuleUnitMetaDataWithBookId:(NSString *)bid withModuleName:(NSString *)moduleName success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]],@"timestamp", bid,@"id", moduleName,@"name",[NSString stringWithFormat:@"%d",[ConfigGlobal loginUser].userId],@"user_eid",nil];
    
    [service requestUrl:[NSString stringWithFormat:@"%@%@%@%@",BaseUrlWebSite,@"api/v1/books/",bid,@"/module_data"] parameters:AddSignWithRequestParameters(dicParameters) success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSHTTPURLResponse class]])
         {
             NSHTTPURLResponse *response = responseObject;
             NSString *strUrl = [[response allHeaderFields] safeObjectForKey:@"Location"];
             success(strUrl);
             return;
         }
         success(nil);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         failure(error);
     } method:@"GET"];
}


// 通过书目的下载地址进行下载
+ (void)downLoadBookModuleUnitWithLocation:(NSString *)strUrl bookId:(NSString *)bid parameters:(id)parameters resumeData:(NSData *)redata progress:(void (^)(NSProgress *))downprogress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    
    [service downLoadWithStrUrl:strUrl userInfo:bid parameters:parameters progress:^(NSProgress *progress) {
        downprogress(progress);
    } cachePath:^(NSString *path, id userAddition)
     {
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
         
         NSString *bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"moduletemp.zip"]];
         if ([parameters isKindOfClass:[NSString class]])
         {
             bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_moduletemp.zip",bid,parameters]];
         }
         NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
         bookPathUnzip = [bookPathUnzip stringByAppendingString:@"/"];
    
         if ([fileManager fileExistsAtPath:bookPath])
         {
             [fileManager removeItemAtPath:bookPath error:nil];
         }
         
         if ([fileManager copyItemAtPath:path toPath:bookPath error:nil]) {
             ZipArchive *zip = [[ZipArchive alloc] initWithFileManager:fileManager];
             __block ZipArchive *tempZip = zip;
             zip.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles)
             {
                 if (percentage == 100)
                 {
                     [tempZip UnzipCloseFile];
                     success(@"下载并解压完成");
                 }
             };
             if ([zip UnzipOpenFile:bookPath])
             {
                 [zip UnzipFileTo:bookPathUnzip overWrite:NO];
                 
                 [fileManager removeItemAtPath:bookPath error:nil];
             }
         }
     } success:^(NSURLSessionDataTask *task, id responseObject)
     {
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(error);
     } resumeData:redata];
}

// 获取书本可下载单元模块名称
+ (void)requestBookGetDownloadableModuleUnitBookEid:(NSString *)bid success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",bid,@"ids",nil];
    
    [service requestUrl:Url_WebSite_ModuleVersion parameters:AddSignWithRequestParameters(dicParameters) success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSArray class]])
         {
             NSDictionary *dicTemp = [responseObject firstObject];
             if ([[dicTemp objectForKey:@"versions"] isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dicModules = [dicTemp objectForKey:@"versions"];
                 success([dicModules allKeys]);
             }
         }
         success(nil);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         failure(error);
     } method:@"GET"];
}


+ (void)requestFreeBuyBookWithUserId:(int)userId withBookEditionId:(int)bookEditionId withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionary];
    if (!userId) {
    
        return;
    }
    [dicParameters setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];

    [dicParameters setObject:[NSNumber numberWithInt:bookEditionId] forKey:@"bookEditionId"];
    [dicParameters setObject:APP_ID forKey:@"appId"];
    [dicParameters setObject:[NSNumber numberWithInt:2] forKey:@"source"];


    [service requestApi:Url_API_BookBuyFree parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dicResult = responseObject;
        if ([[dicResult objectForKey:@"success"] boolValue] == NO)
        {
            success(responseObject);
//            if ([[dicResult objectForKey:@"data"] isEqualToString:@""]) {
//                 success(@"免费购书失败");
//                return ;
//            }
//            success([dicResult safeObjectForKey:@"data"]);
            return;
        }

          success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    } method:@"POST"];
}


+ (void)requestBookBuyBookWithUserId:(int)userId withBookEditionId:(int)bookEditionId withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionary];
    if (!userId) {
        
        return;
    }
    
    [dicParameters setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [dicParameters setObject:[NSNumber numberWithInt:bookEditionId] forKey:@"bookEditionId"];
    [dicParameters setObject:APP_ID forKey:@"appId"];
    [dicParameters setObject:[NSNumber numberWithInt:2] forKey:@"source"];
    
    
    [service requestApi:Url_API_AddBookOrder parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dicResult = responseObject;
        if ([[dicResult objectForKey:@"success"] boolValue] == NO)
        {
            if ([[dicResult objectForKey:@"data"] isEqualToString:@""]) {
                success(@"购书失败");
                return ;
            }
            success([dicResult safeObjectForKey:@"data"]);
            return;
        }
        
        if ([dicResult objectForKey:@"data"])
        {
            ModelOrder *model = [[ModelOrder alloc] initWithDictionary:[dicResult objectForKey:@"data"] error:nil];
            success(model);
            return;
        }
        
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    } method:@"POST"];
}


+ (void)requestBookBuyPackageBookWithUserId:(int)userId withBookPackageId:(int)bookPackageId withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionary];
    if (!userId) {
        
        return;
    }
    
    [dicParameters setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [dicParameters setObject:[NSNumber numberWithInt:bookPackageId] forKey:@"bookPackageId"];
    [dicParameters setObject:APP_ID forKey:@"appId"];
    [dicParameters setObject:[NSNumber numberWithInt:2] forKey:@"source"];
    
    
    [service requestApi:Url_API_AddBookPackageOrder parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dicResult = responseObject;
        if ([[dicResult objectForKey:@"success"] boolValue] == NO)
        {
            if ([[dicResult objectForKey:@"data"] isEqualToString:@""]) {
                success(@"购书失败");
                return ;
            }
            success([dicResult safeObjectForKey:@"data"]);
            return;
        }
        
        if ([dicResult objectForKey:@"data"])
        {
            ModelOrder *model = [[ModelOrder alloc] initWithDictionary:[dicResult objectForKey:@"data"] error:nil];
            success(model);
            return;
        }
        
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    } method:@"POST"];
}



+ (void)requestBookGetPayHistoryWithUserId:(int)userId withPage:(int)page withRows:(int)rows withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionary];
    if (!userId) {
        
        return;
    }
    
    [dicParameters setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    
    [dicParameters setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dicParameters setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [dicParameters setObject:APP_ID forKey:@"appId"];
    [dicParameters setObject:[NSNumber numberWithInt:2] forKey:@"source"];
    
    
    [service requestApi:Url_API_PayHistory parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dicResult = responseObject;
        if ([[dicResult objectForKey:@"success"] boolValue] == NO)
        {
            success(Locale(@"获取信息失败，请稍后重试"));
            return;
        }
        
        if ([dicResult objectForKey:@"data"])
        {
            NSArray *arrBooks = [dicResult[@"data"] objectForKey:@"bookList"];
            
            NSMutableArray *arrHistory = [NSMutableArray array];
            
            if ([arrBooks isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in arrBooks)
                {
                    ModelOrderHistory *model = [[ModelOrderHistory alloc] initWithDictionary:dic error:nil];
                    if (model)
                    {
                        [arrHistory addObject:model];
                    }
                }
            }
            else if ([arrBooks isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary *)arrBooks;
                ModelOrderHistory *model = [[ModelOrderHistory alloc] initWithDictionary:dic error:nil];
                if (model)
                {
                    [arrHistory addObject:model];
                }
            }
            success(arrHistory);
            return;
        }
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    } method:@"POST"];
}


+ (void)requestBookIsNeedUnBind:(NSString *)book_eid withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionary];

    [dicParameters setObject:book_eid forKey:@"book_id"];
    [dicParameters setObject:[NSNumber numberWithInt:[ConfigGlobal loginUser].userId] forKey:@"user_eid"];
    [dicParameters setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];

    
    [dicParameters setObject:APP_ID forKey:@"app_id"];
    [dicParameters setObject:[UtilMethod deviceIsIphone]?@"mobile":@"pad" forKey:@"device_type"];
    [dicParameters setObject:[UtilMethod deviceUUId] forKey:@"device"];

//    NSLog(@"isneedUnbind:%@\n params:%@",Url_WebSite_DeviceNeed,AddSignWithRequestParameters(dicParameters));
    [service requestUrl:Url_WebSite_DeviceNeed parameters:AddSignWithRequestParameters(dicParameters) success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         NSLog(@"isneedUnbind:%@\n params:%@,result:%@",Url_WebSite_DeviceNeed,AddSignWithRequestParameters(dicParameters),responseObject);

         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             success([responseObject objectForKey:@"need_binding"]);
             return ;
         }
         success(Locale(@"获取书本绑定信息失败，请稍后重试"));
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"isneedUnbind failed:%@\n params:%@,result:%@",Url_WebSite_DeviceNeed,AddSignWithRequestParameters(dicParameters),error);

         failure(error);
     } method:@"GET"];
}

+ (void)requestBookSwitchToBind:(NSString *)book_eid withSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionary];
    
    [dicParameters setObject:book_eid forKey:@"book_id"];
    [dicParameters setObject:[NSNumber numberWithInt:[ConfigGlobal loginUser].userId] forKey:@"user_eid"];
    [dicParameters setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
    
    
    [dicParameters setObject:APP_ID forKey:@"app_id"];
    [dicParameters setObject:[UtilMethod deviceIsIphone]?@"mobile":@"pad" forKey:@"device_type"];
    [dicParameters setObject:[UtilMethod deviceUUId] forKey:@"device"];
//    NSLog(@"requestBookSwitchToBind:%@\n params:%@",Url_WebSite_DeviceSwitch,AddSignWithRequestParameters(dicParameters));

    [service requestUrl:Url_WebSite_DeviceSwitch parameters:AddSignWithRequestParameters(dicParameters) success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"requestBookSwitchToBind:%@\n params:%@ \n result:%@",Url_WebSite_DeviceSwitch,AddSignWithRequestParameters(dicParameters),responseObject);

         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             success([responseObject objectForKey:@"left"]);
             return ;
         }
         success(Locale(@"切换到新设备失败，请稍后重试"));
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"requestBookSwitchToBind failed:%@\n params:%@ \n result:%@",Url_WebSite_DeviceSwitch,AddSignWithRequestParameters(dicParameters),error);

         failure(error);
     } method:@"POST"];
}
@end
