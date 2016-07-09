//
//  ModelOrder.h
//  iEnglish
//
//  Created by JacobLi on 4/25/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ModelOrder : Model

@property (nonatomic, strong) NSString              *bookName;
@property (nonatomic, assign) int                   bookOrderId;
@property (nonatomic, strong) NSString<Optional>    *closeTime;
@property (nonatomic, strong) NSString              *code;
@property (nonatomic, strong) NSString              *cover;
@property (nonatomic, strong) NSArray<Ignore>       *coverList;
@property (nonatomic, strong) NSString<Optional>    *createTime;
@property (nonatomic, strong) NSString              *editionName;
@property (nonatomic, assign) BOOL                  isActivityOrder;
@property (nonatomic, assign) BOOL                  isPackage;
@property (nonatomic, assign) int                   num;
@property (nonatomic, strong) NSString              *orderSn;
@property (nonatomic, strong) NSString<Optional>    *packageName;
@property (nonatomic, strong) NSString<Optional>    *packageType;
@property (nonatomic, strong) NSString<Optional>    *payTime;
@property (nonatomic, assign) CGFloat               price;
@property (nonatomic, strong) NSString<Optional>    *publishingHouseName;
@property (nonatomic, assign) int                   status;
@property (nonatomic, assign) CGFloat               totalPrice;
@property (nonatomic, assign) int                   type;
@property (nonatomic, assign) int                   validity;

@end


@interface ModelOrderHistory : Model

@property (nonatomic, strong) NSString              *bookName;
@property (nonatomic, strong) NSString              *code;
@property (nonatomic, strong) NSString<Optional>    *publishingHouseName;
@property (nonatomic, assign) int                   type;      // 1 : 标准版  2 : 互动版
@property (nonatomic, strong) NSString<Optional>    *createTime;
@property (nonatomic, strong) NSString<Optional>    *startDate;
@property (nonatomic, strong) NSString<Optional>    *endDate;
@property (nonatomic, assign) int                   purchaseType;   // 1.在线购买,2.免费申请,3.代理商同步,4.活动免费购买,5.激活码券购买

@end
