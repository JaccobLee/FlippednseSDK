//
//  BookStudyViewModel.h
//  iEnglish
//
//  Created by JacobLi on 3/30/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBookInfo.h"

@interface BookStudyViewModel : NSObject

@property (nonatomic, strong) NSString          *bookId;
@property (nonatomic, strong) NSString          *bookEid;
@property (nonatomic, assign) int               countTotal;  //总页数
@property (nonatomic, assign) int               countCovers;    //封面数
@property (nonatomic, assign) int               countContents;  //内容页数
@property (nonatomic, assign) int               countAppends;   //附页

@property (nonatomic, strong) ModelBookDataXml  *modelXml;

@property (nonatomic, strong) NSMutableArray    *arrPaths;      // 书本内所有底图的存放路径， 包括封面，附页，内容,封底
@property (nonatomic, strong) NSArray           *arrModules;    // 本书单元模块结构\

@property (nonatomic, strong) NSArray           *arrModuleUnitList;     // 书目录结构

@property (nonatomic, strong) NSArray           *arrDownloadableModules;  // 可下载单元

@property (nonatomic, assign) int               currentPage;    // 当前阅读页
@property (nonatomic, assign) int               lastReadPage;   // 纪录当前页  包含封面前言
@property (nonatomic, strong) NSString          *currentModule;
@property (nonatomic, strong) NSString          *currentUnit;
@property (nonatomic, strong) NSString          *currentModuleUnit;

- (instancetype)initWithBookid:(NSString *)bid;

- (NSString *)getModuleUnitNameWithPageIndex:(int)index;
- (NSString *)getModuleNameWithPageIndex:(int)index;
- (NSString *)getUnitNameWithPageIndex:(int)index;

- (NSArray *)getBlockInfosWithContentPageIndex:(int)index;
- (NSArray *)getMenusWithContentPageIndex:(int)index;
- (NSArray *)getTranslateWithContentPageIndex:(int)index;
- (NSArray *)getGrammarWithContentPageIndex:(int)index;
- (NSArray *)getNewWordsWithContentPageIndex:(int)index;

- (BOOL)needBuyBook;

@end
