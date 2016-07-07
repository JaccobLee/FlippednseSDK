//
//  ModelBookStore.h
//  iEnglish
//
//  Created by JacobLi on 3/24/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
// 共享书库
@interface ModelBookStoreShare : Model

@property (nonatomic, assign) int               id;
@property (nonatomic, strong) NSString          *bookId;//<PrimaryKey>
@property (nonatomic, strong) NSString          *bookName;
@property (nonatomic, strong) NSString          *bookCachePath;     // 保存路径
@property (nonatomic, strong) NSString          *bookCover;         // 书本封面
@property (nonatomic, strong) NSString          *bookUnits;         // 可下载单元
@property (nonatomic, assign) NSTimeInterval    timeStampDownload;  // 下载时间
@property (nonatomic, strong) NSString          *bookCode;//后添加  用于书本的下载，eid

@end

// 用户书库信息
@interface ModelBookStoreUser : Model

@property (nonatomic, assign) int               id;
@property (nonatomic, strong) NSString          *bookId;//<PrimaryKey>
@property (nonatomic, strong) NSString          *bookCode;//<PrimaryKey>

@property (nonatomic, assign) int               userId;             // 用户id，关联登录信息
@property (nonatomic, assign) BOOL              isProbation;        // 是否试用
@property (nonatomic, assign) NSTimeInterval    lastReadTime;       // 最后阅读时间
@property (nonatomic, assign) int               lastReadPage;       // 最后阅读页

@end

// 本地书库下载单元信息
@interface ModelBookStoreUnitDownload : Model   //目前是只在下载完成的时候，进行保存的操作，没有删除的操作，（包含用户）

@property (nonatomic, assign) int               id;
@property (nonatomic, strong) NSString           *bookId;
@property (nonatomic, strong) NSString          *unitName;          // 单元名称
@property (nonatomic, assign) NSTimeInterval    timeStampDownload;  // 下载时间
@property(nonatomic,assign)int userId;
@end

// 当前服务器单元版本信息
@interface ModelBookStoreServerUnitInfo : Model

@property (nonatomic, assign) int               id;
@property (nonatomic, strong) NSString          *bookId;
@property (nonatomic, strong) NSString          *unitName;
@property (nonatomic, assign) CGFloat           version;        // 服务器版本
@end

// 所有下载模块记录
@interface ModelBookStoreDownloadRecord : Model

@property (nonatomic, assign) int               id;
@property (nonatomic, strong) NSString          *bookId;
@property (nonatomic, strong) NSString          *moduleName;
@property (nonatomic, assign) NSTimeInterval    timeStampDownload;
@end

//本地当前  书本已经下载的模块
@interface ModelBookRecordOfDownloadUnit : Model   //目前是表示本地目前已经下载的模块单元信息，随时更新，删除
@property (nonatomic, assign) int               id;
@property (nonatomic, strong) NSString          *bookId;
@property (nonatomic, strong) NSString          *moduleName;
@property (nonatomic, assign) NSTimeInterval    timeStampDownload;
@end


// 所有删除模块记录
@interface ModelBookDeleteRecord : Model    //表示用户的删除记录，当用户删除书本或者模块单元的时候，会删

@property (nonatomic, assign) int               id;
@property(nonatomic,assign)int userId;
@property (nonatomic, strong) NSString          *bookId;
@property (nonatomic, strong) NSString          *moduleName;
@property (nonatomic, assign) NSTimeInterval    timeStampDelete;

@end



typedef enum : NSUInteger {
    //    DownloadTaskOfStateNone,  //没有开始
    DownloadTaskOfStatePrepare=1,//下载的准备
    DownloadTaskOfStateWaiting,//x
    DownloadTaskOfStateStart,
    DownloadTaskOfStateDuring,
    DownloadTaskOfStatePause, //进度，是哪个下载进程
    DownloadTaskOfStateResume, //进度，是哪个下载进程
    DownloadTaskOfStatEnding, //进度，是哪个下载进程
    DownloadTaskOfStateDown,
    DownloadTaskOfStateUnZip,
    DownloadTaskOfStateFailed,
} DownloadTaskOfState;


typedef enum : NSUInteger {
    LocalBookStateNone,
    LocalBookStateHasDownload,  //正常
    LocalBookStateNotExists,  //不存在fileExistsAtPath
    LocalBookStateIsOnDownloadDuring, //在下载期间
} LocalBookState;

//cmy添加
@interface UserBookShelfOnLocal : NSObject
//@property (nonatomic, assign) int               bookStoreShareId;   // 外键， 关联到ModelBookStoreShare的id属性
//@property (nonatomic, assign) int               bookStoreUserId;   // 外键， 关联到ModelBookStoreShare的id属性
@property (nonatomic, strong) NSString          *bookId;//

@property (nonatomic, strong) NSString          *bookCode;//

@property (nonatomic, strong) NSString          *bookName;
@property (nonatomic, strong) NSString          *bookCachePath;     // 保存路径
@property (nonatomic, strong) NSString          *bookCover;         // 书本封面
@property (nonatomic, strong) NSString          *bookUnits;         // 可下载单元
@property (nonatomic, assign) NSTimeInterval    timeStampDownload;  // 下载时间

@property (nonatomic, assign) int               userId;             // 用户id，关联登录信息
@property (nonatomic, assign) BOOL              isProbation;        // 是否试用
@property (nonatomic, assign) NSTimeInterval    lastReadTime;       // 最后阅读时间
@property (nonatomic, assign) int               lastReadPage;       // 最后阅读页
@property (nonatomic, assign) LocalBookState       bookState;       // 最后阅读页

@property (nonatomic, assign) BOOL              isFailureTime;       // 是否失效，是否过期
//@property (nonatomic, assign)DownloadTaskOfState stateOfDownload;
@end


@interface UserDownloadRunningRecord : Model
@property (nonatomic, assign) int               id;
@property (nonatomic, strong) NSString          *bookId;
@property (nonatomic, assign) int               userId;
@property (nonatomic, assign) float             progress;
@property (nonatomic, assign) NSInteger         downloadState;
@property (nonatomic, strong) NSString          *downloadStr;
@property (nonatomic, assign) NSTimeInterval    timeStampDownload;
@property(nonatomic,assign)BOOL isWillDelete;
@end



