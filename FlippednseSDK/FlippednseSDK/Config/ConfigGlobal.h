//
//  ConfigGlobal.h
//  iEnglish
//
//  Created by JacobLi on 2/26/16.
//  Copyright © 2016 jxb. All rights reserved.
//


// 定义正式版环境， 如非正式版发布， 请注释掉该定义
/*
 #ifndef  Environment_Distribution
 #define  Environment_Distribution   1
 #endif
 */

#pragma mark - globalSettings
#import <Foundation/Foundation.h>
@class ModelUser;

#pragma mark - Screen

#define iPhone3 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320,480), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
//#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080,1920), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
////#define SizeScale(s) ([[UIScreen mainScreen] bounds].size.height > 568 ?  ([[UIScreen mainScreen] bounds].size.height / 568.0 * (s)) : (s * 1.0))

#define iPad  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size)) : NO)

#define DEVICE_IS_IPAD  iPad

#define SCREEN_ADAPTER_HEIGHT(heightOfPad,heightOfIphone)  (DEVICE_IS_IPAD?((heightOfPad * 1.0) / 1024.0) * ([[UIScreen mainScreen] bounds].size.height):([[UIScreen mainScreen] bounds].size.height / 568.0 * (heightOfIphone)))

#define SCREEN_ADAPTER_WIDTH(widthOfPad,widthOfIphone)  (DEVICE_IS_IPAD?((widthOfPad * 1.0) / 768.0) * ([[UIScreen mainScreen] bounds].size.width):([[UIScreen mainScreen] bounds].size.width *(widthOfIphone*1.0)/320.0 ))

#define FONT_SCALE_FIT(xOfPad,xOfiPhone)   (DEVICE_IS_IPAD?[UIFont systemFontOfSize:xOfPad]:[UIFont systemFontOfSize:xOfiPhone])


#define SYSTEM_FONT_(x)                    [UIFont systemFontOfSize:x]
#define SYSTEM_FONT_BOLD_(a)               [UIFont boldSystemFontOfSize:a]



#define HeightScale(s)  ((s * 1.0) / 1024) * ([[UIScreen mainScreen] bounds].size.height)
#define WidthScale(s)    ((s * 1.0) / 768) *  ([[UIScreen mainScreen] bounds].size.width)
//#define HeightScale(s) ([[UIScreen mainScreen] bounds].size.height < 1024 ? ((s * 1.0) / 1024) *  [[UIScreen mainScreen] bounds].size.height : (s * 1.0))
//#define WidthScale(s) ([[UIScreen mainScreen] bounds].size.width < 768 ? ((s * 1.0) / 768) *  [[UIScreen mainScreen] bounds].size.width : (s * 1.0))

//App
#define AppDel_whole        ((AppDelegate *)[UIApplication sharedApplication].delegate)


#define CGPointMakeScale(x,y) CGPointMake(WidthScale(x),HeightScale(y))
#define CGRectMakeScale(x,y,w,h) CGRectMake(WidthScale(x),HeightScale(y),WidthScale(w),HeightScale(h))

#pragma mark - log
#define DNSLog(frmt, ...)  NSLog(@"[%@:%@ %d]  %@", \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent],   \
NSStringFromSelector(_cmd), \
__LINE__,   \
[NSString stringWithFormat:(frmt), ##__VA_ARGS__])

#if DEBUG
#define DLOG(frmt, ...)   DNSLog(frmt, ##__VA_ARGS__)
#define ERRLOG(frmt, ...) DNSLog(frmt, ##__VA_ARGS__)
#else
#define DLOG(frmt, ...)
// TODO: use crashlytics log
#define ERRLOG(frmt, ...)
#endif

#define DEBUG_SQL           (0)
#if defined(DEBUG_SQL) && DEBUG_SQL > 0
#define DSQL(frmt, ...)   DLOG(frmt, ##__VA_ARGS__)
#else
#define DSQL(frmt, ...)
#endif

#pragma mark - 有效性校验
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isKindOfClass:[NSNull class]]) )

#define isValidStr(_ref) ((IsNilOrNull(_ref)==NO) && ([[_ref stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>0))

#define notSet(_ref) isValidStr(_ref) ? _ref : @"未设置";

#define trimOfNoNullStr(_ref)  ((IsNilOrNull(_ref)==NO) && ![_ref isEqualToString:@"null"])?[_ref stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]:@""

#define IS_CH_SYMBOL(chr) ((int)(chr)>127)      //宽字符

#pragma mark - utils
#define Locale(str)            NSLocalizedString(str, nil)

#define LOADIMAGE(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:(fileName) ofType:@"png"]]
#define LOADIPGIMAGE(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:(fileName) ofType:@"jpg"]]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define KSystemfont(x)  ([[UIScreen mainScreen] bounds].size.height >= 1024 ? [UIFont systemFontOfSize:x] : [UIFont systemFontOfSize:x - 3])
#define KSystemfontBold(x)  ([[UIScreen mainScreen] bounds].size.height >= 1024 ? [UIFont boldSystemFontOfSize:x] : [UIFont boldSystemFontOfSize:x - 3])


#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define CONTENT_HEIGHT                      [UIScreen mainScreen].bounds.size.height-NavBarHeight-20

#pragma mark - UserDefault
#define UserDefault                     [NSUserDefaults standardUserDefaults]
#define UserDefault_UserBookStore       @"UserDefault_UserBookStore"
#define UserDefault_OrderPayQueue       @"UserDefault_OrderPayQueue"

#pragma mark - Notification
#define Notif                           [NSNotificationCenter defaultCenter]
#define Notif_Hide_PopView              @"notif_hide_popView"
#define Notif_DragAction                @"notif_dragaction"
#define Notif_Play_ListenWord           @"notif_play_listenword"
#define Notif_Play_Video                @"notif_play_video"
#define Notif_Play_Audio                @"notif_play_audio"
#define Notif_Play_ShowText             @"notif_play_showtext"
#define Notif_Play_Translate            @"notif_play_translate"
#define Notif_Play_Gramar               @"notif_play_gramar"
#define Notif_Play_Word                 @"notif_play_word"
#define Notif_Play_Word_ListenWord      @"notif_play_word_listenword"

#define Notif_Need_Buy_Book             @"notif_need_buy_book"
#define Notif_Need_ReBuy_Book           @"notif_need_rebuy_book"
#define Notif_Need_DownLoad_Module      @"notif_need_download_module"

#define Notif_Download_Module_Pause     @"notif_download_module_pause"
#define Notif_Download_Module_Resume    @"notif_download_module_resume"

#define Notif_DragAction_showModuleList         @"Notif_DragAction_showModuleList"
#define Notif_DragAction_ModuleListMoved        @"Notif_DragAction_ModuleListMoved"
#define Notif_DragAction_showModuleListFinish   @"Notif_DragAction_showModuleListFinish"
#define Notif_DragAction_cancelModuleList       @"Notif_DragAction_cancelModuleList"

#define Notif_OrderPay_Iap_Success              @"Notif_OrderPay_Iap_Success"
#define Notif_OrderPay_Iap_Faild                @"Notif_OrderPay_Iap_Faild"

#pragma mark - User
typedef enum {
    UserRoleType_Student,
    UserRoleType_Parent,
    UserRoleType_Teacher
} UserRoleType;

#pragma mark - interface
@interface ConfigGlobal : NSObject

//@property (nonatomic, strong) NSString      *loginToken;
@property (nonatomic, strong) ModelUser     *loginUser;

+ (instancetype)sharedCofigGlobal;
//  登陆令牌
//+ (NSString *)loginToken;
+ (ModelUser *)loginUser;
+ (void)clearLoginInfo;//清除登录用户信息

//  存储路径
+ (NSString *)cachePathBooks;
+ (NSString *)cachePathGrammar;
+ (NSString *)cachePathDict;

+ (BOOL)grammarDownloaded;
+ (BOOL)dictDownloaded;

//  通过别名或者特殊字符串来对应教材类别名称
+ (NSString *)bookCategoryNameWithStr:(NSString *)strCategory;


@end
