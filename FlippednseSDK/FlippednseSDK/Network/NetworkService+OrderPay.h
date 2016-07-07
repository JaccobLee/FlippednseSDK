//
//  NetworkService+OrderPay.h
//  iEnglish
//
//  Created by JacobLi on 5/6/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "NetworkService.h"

@interface NetworkService (OrderPay)

// 预付订单
+ (void)requestOrderPrePayWithUser:(int)user withBookOrderId:(int)orderId withPayType:(int)payType success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

// 订单支付完成
+ (void)requestOrderPayFinishWithUser:(int)user withBookOrderId:(int)orderId withPayType:(int)payType withPayAmount:(CGFloat)amount success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


+ (void)requestOrderIapPayFinishWithUser:(int)user withBookOrderId:(int)orderId withReceipt:(NSString *)receipt success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
