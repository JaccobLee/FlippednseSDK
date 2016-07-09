//
//  ModelContentMenus.h
//  iEnglish
//
//  Created by JacobLi on 4/8/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import <CoreGraphics/CoreGraphics.h>

#define MenuActionTypePlayAudio     @"PlayAudio"    // 播放录音
#define MenuActionTypePlayFlash     @"PlayFlash"    // 播放视频
#define MenuActionTypeFollowRead    @"FollowRead"   // 跟读
#define MenuActionTypeRead          @"Read"         // 自读
#define MenuActionTypeRolePlay      @"RolePlay"     // 对话
#define MenuActionTypeRecite        @"Recite"       // 背诵
#define MenuActionTypeShowText      @"ShowText"     // 显示原文
#define MenuActionTypePopInput      @"PopInput"     // 答题

// 书本内容页功能菜单节点
@interface ModelContentMenus : Model

@property (nonatomic, assign) CGFloat               x;
@property (nonatomic, assign) CGFloat               y;
@property (nonatomic, copy) NSString                *cid;
@property (nonatomic, copy) NSString<Optional>      *text;
@property (nonatomic, copy) NSString<Optional>      *version;
@property (nonatomic, strong) NSArray               *item;   // 节点包含的行为列表


@end

// 功能菜单节点对应行为
@interface ModelContentMenuAction : Model

@property (nonatomic, copy) NSString        *action;
@property (nonatomic, copy) NSString        *file;
@property (nonatomic, copy) NSString        *name;
@property (nonatomic, copy) NSString<Optional>        *text;
@property (nonatomic, copy) NSString<Optional>        *version;

@property (nonatomic, copy) NSString<Optional> *filePath;


@end
