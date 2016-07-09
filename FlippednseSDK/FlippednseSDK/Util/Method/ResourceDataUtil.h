//
//  ResourceDataUtil.h
//  iEnglish
//
//  Created by JacobLi on 3/10/16.
//  Copyright © 2016 jxb. All rights reserved.
//

/* 
 ** jacob : 用来处理书本阅读相关的数据，xml的解析
 */

#import <Foundation/Foundation.h>

@class ModelBookDataXml;

@interface ResourceDataUtil : NSObject


// 获取书本所有底图
+ (NSMutableArray *)getImageFilePathWithBookDataXml:(ModelBookDataXml *)model withBookId:(NSString *)bid;
// 获取书本封面图
+ (NSString *)getMainCoverFilePathWithBookId:(NSString *)bid;
// 获取书本前几页covers图
+ (NSArray *)getCoversFileNameWithCount:(int)count startIndex:(int)index bookId:(NSString *)bid;
// 获取书本内容页底图
+ (NSArray *)getContentsFileNameWithCount:(int)count startIndex:(int)index bookId:(NSString *)bid;
// 获取书本背面图
+ (NSString *)getBackCoverFilePathWithBookId:(NSString *)bid;

// 获取书本cover某一页底图
//+ (NSString *)getCoverFileNameWithIndex:(int)index;
//// 获取书本内容某一页底图
//+ (NSString *)getContentFileNameWithIndex:(int)index;

// 获取书本某一页的页内资源信息 -- 点读
+ (NSArray *)getBlockInfosWithPageIndex:(int)index withBookId:(NSString *)bid withModuleName:(NSString *)moduleName;
// 获取书本某一页的页内资源信息 -- 功能菜单项
+ (NSArray *)getMenusWithPageIndex:(int)index withBookId:(NSString *)bid withModuleName:(NSString *)moduleName;
// 获取本书的单元信息结构
+ (NSMutableArray *)getModuleListWithBookid:(NSString *)bid;
+ (NSMutableArray *)getDownloadEableModuleListWithBookid:(NSString *)bid;
// 获取单元模块名称
+ (NSString *)getModuleUnitNameWithIndex:(int)index withModuleList:(NSArray *)moduleList;
+ (NSString *)getModuleNameWithIndex:(int)index withModuleList:(NSArray *)moduleList;
+ (NSString *)getUnitNameWithIndex:(int)index withModuleList:(NSArray *)moduleList;
// isTranslate == YES : 获取辅助翻译  | isTranslate == NO : 获取语言知识
+ (NSArray *)getTranslateOrGrammarWithPageIndex:(int)index withBookId:(NSString *)bid withModuleName:(NSString *)moduleName isTranslate:(BOOL)isTranslate;

// 获取书本某一页的资源信息 -- word
+ (NSArray *)getNewWordsWithPageIndex:(int)index withBookId:(NSString *)bid withModuleName:(NSString *)moduleName;

@end
