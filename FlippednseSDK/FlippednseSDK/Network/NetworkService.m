//
//  NetworkService.m
//  iEnglish
//
//  Created by JacobLi on 2/26/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "NetworkService.h"
#import "ModelUser.h"

static NetworkService *service;

@implementation NetworkService
@synthesize serviceManager;


+ (instancetype)sharedNetworkService
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!service)
        {
            service = [[self alloc] init];
            
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            config.timeoutIntervalForRequest = 10;
            service.serviceManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
            
            [service.serviceManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request)
             {
                 return task.currentRequest;
             }];
        }
    });
    
    return service;
}

- (void)requestUrl:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure method:(NSString *)method
{
    [self requestUrl:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    } method:method needAuthToken:NO];
}

- (void)requestApi:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure method:(NSString *)method
{
    [self requestUrl:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    } method:method needAuthToken:YES];
}


- (void)requestUrl:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure method:(NSString *)method needAuthToken:(BOOL)needAuthToken
{
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (needAuthToken == YES)
    {
        
        NSString *token=[ConfigGlobal loginUser]?[ConfigGlobal loginUser].token:@"";
        if ([trimOfNoNullStr(token) length]) {
            [dicParameters setObject:token forKey:@"token"];
        }
        
        [dicParameters setObject:AuthAPI forKey:@"auth"];
    }
    
    if (method)
    {
        if ([method isEqualToString:@"POST"])
        {
            [service.serviceManager POST:URLString parameters:dicParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(task, error);
            }];
            return;
        }
    }
    
    [service.serviceManager GET:URLString parameters:dicParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}


- (void)downLoadWithStrUrl:(NSString *)URLString userInfo:(id)userinfo parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgres cachePath:(void (^)(NSString *path, id userAddition))cachePath  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure resumeData:(NSData*)redata
{
    __block id userAddition = userinfo;
    
    if (redata)
    {
        NSURLSessionDownloadTask *downloadTask = [service.serviceManager downloadTaskWithResumeData:redata progress:^(NSProgress * _Nonnull downloadProgress) {
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
            if (error)
            {
            }
        }];
        [downloadTask resume];
    }
    else if (URLString)
    {
        NSURLSessionDownloadTask *downloadTask = [service.serviceManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] progress:^(NSProgress * _Nonnull downloadProgress) {
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
            if (error)
            {
            }
        }];
        
        [downloadTask resume];
    }
}

- (NSURLSessionDownloadTask *)downLoadWithStrUrl:(NSString *)URLString userInfo:(id)userinfo progress:(void (^)(NSProgress *))downloadProgres cachePath:(void (^)(NSString *path, id userAddition))cachePath  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure resumeData:(NSData*)redata
{
    __block id userAddition = userinfo;
    
    if (redata)
    {
        NSURLSessionDownloadTask *downloadTask = [service.serviceManager downloadTaskWithResumeData:redata progress:^(NSProgress * _Nonnull downloadProgress) {
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
            if (error)
            {
            }
        }];
        [downloadTask resume];
        
        return downloadTask;
    }
    else
    {
        NSURLSessionDownloadTask *downloadTask = [service.serviceManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] progress:^(NSProgress * _Nonnull downloadProgress) {
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
            if (error)
            {
            }
        }];
        
        [downloadTask resume];
        
        return downloadTask;
    }
}




@end
