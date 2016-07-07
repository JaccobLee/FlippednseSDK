//
//  BookStudyViewModel.m
//  iEnglish
//
//  Created by JacobLi on 3/30/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "BookStudyViewModel.h"
#import "ModelBookStore.h"
#import "ModelUser.h"

@implementation BookStudyViewModel

- (instancetype)initWithBookid:(NSString *)bid
{
    if (self = [super init])
    {
        _bookId = bid;
        
        NSString *bookDirPath = [ConfigGlobal cachePathBooks];
        NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
        NSString *bookXMLPath = [bookPathUnzip stringByAppendingPathComponent:[@"book.xml" MD5String]];
        NSString *bookXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:bookXMLPath encoding:NSUTF8StringEncoding error:nil]];
        NSDictionary *dicXml = [XMLReader dictionaryForXMLString:bookXml error:nil];
        
        _modelXml = [[ModelBookDataXml alloc] initWithDictionaryTrimText:dicXml];
        _countTotal = _modelXml.totalpages + 3;
        _countCovers = _modelXml.coverpages;
        _countContents = _modelXml.contentpages;
        _countAppends = _countTotal - _countCovers - _countContents - 2;
        _arrPaths = [ResourceDataUtil getImageFilePathWithBookDataXml:_modelXml withBookId:bid];
        
        _arrModules = [ResourceDataUtil getDownloadEableModuleListWithBookid:bid];
        
        _arrModuleUnitList = [ResourceDataUtil getModuleListWithBookid:bid];
        
    }
    return self;
}

- (NSArray *)getBlockInfosWithContentPageIndex:(int)index
{
//    NSString *moduleName = [self getModuleUnitNameWithPageIndex:index];
    if (_currentModuleUnit)
    {
        return [ResourceDataUtil getBlockInfosWithPageIndex:index withBookId:_bookId withModuleName:_currentModuleUnit];
    }
    return nil;
}

- (NSArray *)getMenusWithContentPageIndex:(int)index
{
//    NSString *moduleName = [self getModuleUnitNameWithPageIndex:index];
    if (_currentModuleUnit)
    {
        return [ResourceDataUtil getMenusWithPageIndex:index withBookId:_bookId withModuleName:_currentModuleUnit];
    }
    return nil;
}

- (NSArray *)getTranslateWithContentPageIndex:(int)index
{
//    NSString *moduleName = [self getModuleUnitNameWithPageIndex:index];
    if (_currentModuleUnit)
    {
        return [ResourceDataUtil getTranslateOrGrammarWithPageIndex:index withBookId:_bookId withModuleName:_currentModuleUnit isTranslate:YES];
    }
    return nil;
}

- (NSArray *)getGrammarWithContentPageIndex:(int)index
{
//    NSString *moduleName = [self getModuleUnitNameWithPageIndex:index];
    if (_currentModuleUnit)
    {
        return [ResourceDataUtil getTranslateOrGrammarWithPageIndex:index withBookId:_bookId withModuleName:_currentModuleUnit isTranslate:NO];
    }
    return nil;
}


- (NSArray *)getNewWordsWithContentPageIndex:(int)index
{
    //    NSString *moduleName = [self getModuleUnitNameWithPageIndex:index];
    if (_currentModuleUnit)
    {
        return [ResourceDataUtil getNewWordsWithPageIndex:index withBookId:_bookId withModuleName:_currentModuleUnit];
    }
    return nil;
}

- (NSString *)getModuleUnitNameWithPageIndex:(int)index
{
    return [ResourceDataUtil getModuleUnitNameWithIndex:index  withModuleList:_arrModules];
}

- (NSString *)getModuleNameWithPageIndex:(int)index
{
    return [ResourceDataUtil getModuleNameWithIndex:index withModuleList:_arrModules];
}

- (NSString *)getUnitNameWithPageIndex:(int)index
{
    return [ResourceDataUtil getUnitNameWithIndex:index withModuleList:_arrModules];
}


- (BOOL)needBuyBook
{
    BOOL isNeed = YES;
    
    NSString *moduleName = [ResourceDataUtil getModuleNameWithIndex:_currentPage withModuleList:_arrModules];
    NSArray *arrStr = [moduleName componentsSeparatedByString:@" "];
    if (([[arrStr lastObject] intValue] <= 1) && [[arrStr firstObject] isEqualToString:@"MODULE"])
    {
        return NO;
    }
    
    NSArray *result = [ModelBookStoreUser selectByProperty:@"bookId" propertyValue:_bookId];
    for (ModelBookStoreUser *m in result)
    {
        if (m.userId == ([ConfigGlobal loginUser].userId))
        {
            if (m.isProbation == NO)
            {
                return NO;
            }
        }
    }
    
    return isNeed;
}

@end
