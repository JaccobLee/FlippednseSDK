//
//  ModelBookInfo.m
//  iEnglish
//
//  Created by JacobLi on 3/2/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "ModelBookInfo.h"

#define BookPropertyValue(property, dic) [[dic objectForKey:property] safeObjectForKey:@"text"]

@implementation ModelBookInfo

@end

@implementation ModelBookInfoOfOnline

@end

@implementation BookStoreInfo

-(instancetype)initBookStoreInfoWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init])
    {
//        self=[[BookStoreInfo alloc]initWithDictionary:dictionary error:nil];
//        NSMutableArray *arrayT=[ModelBookInfoOfOnline arrayOfModelsFromDictionaries:[dictionary objectForKey:@"books"]];
//        self.books=arrayT;
        
        self.category=[dictionary objectForKey:@"category"];
        self.books=[NSMutableArray array];
        NSArray *arrayBooks=[dictionary objectForKey:@"books"];
        
        for (int i=0; i<[arrayBooks count]; i++) {
            ModelBookInfoOfOnline *onlineBook=[[ModelBookInfoOfOnline alloc]init];
            NSDictionary *dicTemp=arrayBooks[i];
            onlineBook.bookName=[dicTemp objectForKey:@"bookName"];
            onlineBook.canFree=[[dicTemp objectForKey:@"canFree"] boolValue];
            onlineBook.code=[dicTemp objectForKey:@"code"];
            onlineBook.cover=[dicTemp objectForKey:@"cover"];
            onlineBook.hasBuy=[[dicTemp objectForKey:@"hasBuy"] boolValue];
            [self.books addObject:onlineBook];
        }
        
    }
    return self;

}

@end

@implementation ModelBookInfoDetail

//+(JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description" : @"description_default",@"usableUnits" : @"usableUnits_default"}];
//}

@end


@implementation ModelBookEdition

@end

@implementation ModelBookPackage

@end

@implementation ModelBookDataXml
// 根据xml特殊格式做相关处理
- (instancetype)initWithDictionaryTrimText:(NSDictionary *)dicXml
{
    if (self = [super init])
    {
        NSDictionary *dic = [dicXml objectForKey:@"book"];
        
        if (dic)
        {
            _bookid = BookPropertyValue(@"bookid", dic);
            _bookname = BookPropertyValue(@"bookname", dic);
            _clickReadLevel = [BookPropertyValue(@"clickReadLevel", dic) intValue];
            _clickread = [BookPropertyValue(@"clickread", dic) boolValue];
            _contentpages = [BookPropertyValue(@"contentpages", dic) intValue];
            _coverpages = [BookPropertyValue(@"coverpages", dic) intValue];
            _flashheight = [BookPropertyValue(@"flashheight", dic) floatValue];
            _flashwidth = [BookPropertyValue(@"flashwidth", dic) floatValue];
            _gradename = BookPropertyValue(@"gradename", dic);
            _gradeid = BookPropertyValue(@"gradeid", dic);
            _width = [BookPropertyValue(@"width", dic) floatValue];
            _height = [BookPropertyValue(@"height", dic) floatValue];
            _moduleobj = BookPropertyValue(@"moduleobj", dic);
            _pagename = BookPropertyValue(@"pagename", dic);
            _testid = BookPropertyValue(@"testid", dic);
            _totalpages = [BookPropertyValue(@"totalpages", dic) intValue];
            _volume = [BookPropertyValue(@"volume", dic) intValue];

        }
        
    }
    return self;
}

@end

@implementation ModelBookDownloadEnableModuleUnit

@end

@implementation ModelBookModuleInfo

@end

@implementation ModelBookUnitInfo

@end


@implementation ModelBookSchema

@end