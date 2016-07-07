//
//  NetworkService.h
//  iEnglish
//
//  Created by JacobLi on 2/26/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface NetworkService : NSObject
{
    AFHTTPSessionManager    *serviceManager;
}

@property (nonatomic, strong) AFHTTPSessionManager  *serviceManager;

+ (instancetype)sharedNetworkService;

- (void)requestUrl:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure method:(NSString *)method;

- (void)requestApi:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure method:(NSString *)method;

- (void)requestUrl:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure method:(NSString *)method needAuthToken:(BOOL)needAuthToken;


- (void)downLoadWithStrUrl:(NSString *)URLString userInfo:(id)userinfo parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgres cachePath:(void (^)(NSString *path, id userAddition))cachePath  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure resumeData:(NSData*)redata;

- (NSURLSessionDownloadTask *)downLoadWithStrUrl:(NSString *)URLString userInfo:(id)userinfo progress:(void (^)(NSProgress *))downloadProgres cachePath:(void (^)(NSString *path, id userAddition))cachePath  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure resumeData:(NSData*)redata;

@end
