//
//  NetworkService+OrderPay.m
//  iEnglish
//
//  Created by JacobLi on 5/6/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "NetworkService+OrderPay.h"

@implementation NetworkService (OrderPay)

+ (void)requestOrderPrePayWithUser:(int)user withBookOrderId:(int)orderId withPayType:(int)payType success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSNumber numberWithInt:orderId],@"bookOrderId", [NSNumber numberWithInt:payType],@"payType", [NSNumber numberWithInt:user],@"userId",nil];
    
    [service requestApi:Url_API_WXPayPrepayId parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject){
         NSDictionary *dicResult = responseObject;
         if ([[dicResult objectForKey:@"success"] boolValue] == NO)
         {
             success(nil);
             return;
         }
         
         success([dicResult objectForKey:@"data"]);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         failure(error);
     } method:@"GET"];
}

+ (void)requestOrderPayFinishWithUser:(int)user withBookOrderId:(int)orderId withPayType:(int)payType withPayAmount:(CGFloat)amount success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSNumber numberWithInt:orderId],@"bookOrderId", [NSNumber numberWithInt:payType],@"payType", [NSNumber numberWithInt:user],@"userId",[NSNumber numberWithFloat:amount],@"payAmount",nil];
    
    [service requestApi:Url_API_OrderPay parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject){
        NSDictionary *dicResult = responseObject;
        if ([[dicResult objectForKey:@"success"] boolValue] == NO)
        {
            failure(nil);
            return;
        }
        
        success(Locale(@"付款成功"));
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    } method:@"GET"];
}

+ (void)requestOrderIapPayFinishWithUser:(int)user withBookOrderId:(int)orderId withReceipt:(NSString *)receipt success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NetworkService *service = [NetworkService sharedNetworkService];
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:APP_ID,@"app_id",[NSNumber numberWithInt:orderId],@"bookOrderId", receipt,@"receipt", [NSNumber numberWithInt:user],@"userId",nil];
    
    [service requestApi:Url_API_OrderIapPay parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject){
        NSDictionary *dicResult = responseObject;
        if ([[dicResult objectForKey:@"success"] boolValue] == NO)
        {
            failure(nil);
            return;
        }
        
        success(Locale(@"付款成功"));
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    } method:@"GET"];
}

@end
