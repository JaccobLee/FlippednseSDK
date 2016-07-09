//
//  ModelUser.h
//  iEnglish
//
//  Created by JacobLi on 3/24/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "ConfigGlobal.h"

typedef enum : NSUInteger {
    UserSexMale = 1,
    UserSexFemale,
} UserSex;

typedef enum : NSUInteger {
    UserPhasePre = 1,
    UserPhasePrimary,
    UserPhaseJunior,
    UserPhaseSenior,
} UserPhase;

@interface ModelUser : Model

@property (nonatomic, assign) int                id;
@property (nonatomic, strong) NSString          *userPassword;

@property (nonatomic, assign) int               userId;
@property (nonatomic, assign) UserRoleType      userRole;
@property (nonatomic, strong) NSString          *userName;              // 用户名
@property (nonatomic, strong) NSString          *userNickName;
@property (nonatomic, strong) NSString          *userAvatar;
@property (nonatomic, strong) NSString          *userThirdPartId;       // 三方用户id
@property (nonatomic, strong) NSString          *userFullName;          // 姓名
@property (nonatomic, strong) NSString          * nseUserid; //外研社ID

@property (nonatomic, strong) NSString          *token;

@property (nonatomic, strong) NSString          *email;
@property (nonatomic, strong) NSString          *mobilePhone;
@property (nonatomic, strong) NSString          *qq;
@property (nonatomic, strong) NSString          *weixin;
@property (nonatomic, assign) UserPhase         phase;
@property (nonatomic, strong) NSString          *grade;
@property (nonatomic, strong) NSString          *schoolName;
@property (nonatomic, assign) UserSex           sex;

@end
