//
//  ResourceDataUtil.m
//  iEnglish
//
//  Created by JacobLi on 3/10/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "ResourceDataUtil.h"
#import "ModelBookInfo.h"
#import "ModelClickRead.h"
#import "ModelContentMenus.h"
#import "ModelWordNode.h"
#import "GDataXMLNode.h"
#import "ConfigGlobal.h"
#import "EncryptUtil.h"
#import "NSString+AES.h"
#import "XMLReader.h"
#import "NSDictionary+safeObjectForKeyValue.h"
#import "UtilMethod.h"

#define BookXmlPath(book) [book stringByAppendingPathComponent:[@"book.xml" MD5String]]
#define MainCoverXmlPath(book) [book stringByAppendingPathComponent:[@"page&xml/cover/layout.xml" MD5String]]
#define AdditionCoverXmlPath(book,x) [bookPathUnzip stringByAppendingPathComponent:[[NSString stringWithFormat:@"page&xml/cover%@/layout.xml",(x)] MD5String]]
#define AppendXmlPath(book,x) [bookPathUnzip stringByAppendingPathComponent:[[NSString stringWithFormat:@"page&xml/append%@/layout.xml",(x)] MD5String]]
#define ContentXmlPath(book,x) [bookPathUnzip stringByAppendingPathComponent:[[NSString stringWithFormat:@"page&xml/page%@/layout.xml",(x)] MD5String]]
#define BackCoverXmlPath(book) [book stringByAppendingPathComponent:[@"page&xml/backcover/layout.xml" MD5String]]


#define BookXmlPathTemp(book) [book stringByAppendingPathComponent:@"book.xml"]
#define MainCoverXmlPathTemp(book) [book stringByAppendingPathComponent:@"page&xml/cover/layout.xml"]
#define AdditionCoverXmlPathTemp(book,x) [bookPathUnzip stringByAppendingPathComponent:[NSString stringWithFormat:@"page&xml/cover%@/layout.xml",(x)]]
#define AppendXmlPathTemp(book,x) [bookPathUnzip stringByAppendingPathComponent:[NSString stringWithFormat:@"page&xml/append%@/layout.xml",(x)]]
#define ContentXmlPathTemp(book,x) [bookPathUnzip stringByAppendingPathComponent:[NSString stringWithFormat:@"page&xml/page%@/layout.xml",(x)]]
#define BackCoverXmlPathTemp(book) [book stringByAppendingPathComponent:@"page&xml/backcover/layout.xml"]


@implementation ResourceDataUtil

+ (NSString *)trimPrefixSpace:(NSString *)str
{
    while (([str hasPrefix:@" "]) || ([str hasPrefix:@"\n"]))
    {
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:1 range:NSMakeRange(0, 1)];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@"" options:1 range:NSMakeRange(0, 1)];
    }
    
    return str;
}

+ (NSString *)trimSuffixSpace:(NSString *)str
{
    while (([str hasSuffix:@" "]) || ([str hasSuffix:@"\n"]))
    {
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:1 range:NSMakeRange(str.length - 3, 3)];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@"" options:1 range:NSMakeRange(str.length - 2, 2)];
    }
    
    return str;
}

+ (NSString *)trimLineWithSpace:(NSString *)str
{
    if ([str rangeOfString:@"\n "].location != NSNotFound)
    {
        while ([str rangeOfString:@"\n "].location != NSNotFound)
        {
            str = [str stringByReplacingOccurrencesOfString:@"\n " withString:@"\n"];
        }
        
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }
    
    return str;
}

+ (NSMutableArray *)getImageFilePathWithBookDataXml:(ModelBookDataXml *)model withBookId:(NSString *)bid
{
    NSMutableArray *arr = [NSMutableArray array];
    
    NSMutableArray *arrTempNames = [NSMutableArray array];
    
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    
    int countTotal = model.totalpages + 3;
    int countCovers = model.coverpages;
    int countContents = model.contentpages;
    int countAppends = countTotal - countCovers - countContents - 2;
    for (int i = 0; i < countTotal; i++)
    {
        if (i == 0)
        {
            NSString *mainCoverXMLPath = MainCoverXmlPath(bookPathUnzip);
            NSString *mainCoverXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:mainCoverXMLPath encoding:NSUTF8StringEncoding error:nil]];
            NSDictionary *dicXml = [XMLReader dictionaryForXMLString:mainCoverXml error:nil];
            
            NSString *cover = [[[dicXml  objectForKey:@"layout"] objectForKey:@"background"] safeObjectForKey:@"file"];
            cover = [cover stringByReplacingOccurrencesOfString:@"swf" withString:@"jpg"];
            if (cover)
            {
                cover = [[@"jpgPage/" stringByAppendingString:cover] MD5String];
                [arr addObject:[NSString stringWithFormat:@"%@/%@",bookPathUnzip,cover]];
            }
            else
            {
                [arr addObject:@"no data"];
            }
            
            [arrTempNames addObject:MainCoverXmlPathTemp(bookPathUnzip)];
        }
        else if (i <= countCovers)
        {
            NSString *strIndex = StringValueIn100FromInt(i);
            
            NSString *coverXMLPath = AdditionCoverXmlPath(bookPathUnzip, strIndex);
            NSString *coverXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:coverXMLPath encoding:NSUTF8StringEncoding error:nil]];
            NSDictionary *dicXml = [XMLReader dictionaryForXMLString:coverXml error:nil];
            NSString *cover = [[[dicXml  objectForKey:@"page"] objectForKey:@"background"] safeObjectForKey:@"file"];
            cover = [cover stringByReplacingOccurrencesOfString:@"swf" withString:@"jpg"];
            if (cover)
            {
                cover = [[@"jpgPage/" stringByAppendingString:cover] MD5String];
                [arr addObject:[NSString stringWithFormat:@"%@/%@",bookPathUnzip,cover]];
                
                
                [arrTempNames addObject: AdditionCoverXmlPathTemp(bookPathUnzip, strIndex)];
                continue;
                
            }
            else
            {
                cover = [[[dicXml  objectForKey:@"layout"] objectForKey:@"background"] safeObjectForKey:@"file"];
                cover = [cover stringByReplacingOccurrencesOfString:@"swf" withString:@"jpg"];
                
                if (cover)
                {
                    cover = [[@"jpgPage/" stringByAppendingString:cover] MD5String];
                    [arr addObject:[NSString stringWithFormat:@"%@/%@",bookPathUnzip,cover]];
                }
                else
                {
                    [arr addObject:@"no data"];
                }
                
                [arrTempNames addObject: AdditionCoverXmlPathTemp(bookPathUnzip, strIndex)];
                continue;
                
            }
        }                       
        else if ((countTotal - countAppends - 1 < i) && (i < countTotal - 1))
        {
            int append_index = i - (countTotal - countAppends - 1);
            NSString *strIndex = StringValueIn100FromInt(append_index);
            
            NSString *coverXMLPath = AppendXmlPath(bookPathUnzip, strIndex);
            NSString *coverXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:coverXMLPath encoding:NSUTF8StringEncoding error:nil]];
            NSDictionary *dicXml = [XMLReader dictionaryForXMLString:coverXml error:nil];
            NSString *cover = [[[dicXml  objectForKey:@"page"] objectForKey:@"background"] safeObjectForKey:@"file"];
            cover = [cover stringByReplacingOccurrencesOfString:@"swf" withString:@"jpg"];
            if (cover)
            {
                cover = [[@"jpgPage/" stringByAppendingString:cover] MD5String];
                [arr addObject:[NSString stringWithFormat:@"%@/%@",bookPathUnzip,cover]];
            }
            else
            {
                [arr addObject:@"no data"];
            }
            
            [arrTempNames addObject:AppendXmlPathTemp(bookPathUnzip, strIndex)];
        }
        else if (i == countTotal - 1)
        {
            
            NSString *backXMLPath = BackCoverXmlPath(bookPathUnzip);
            NSString *backXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:backXMLPath encoding:NSUTF8StringEncoding error:nil]];
            NSDictionary *dicXml = [XMLReader dictionaryForXMLString:backXml error:nil];
            
            NSString *cover = [[[dicXml  objectForKey:@"layout"] objectForKey:@"background"] safeObjectForKey:@"file"];
            cover = [cover stringByReplacingOccurrencesOfString:@"swf" withString:@"jpg"];
            if (cover)
            {
                cover = [[@"jpgPage/" stringByAppendingString:cover] MD5String];
                [arr addObject:[NSString stringWithFormat:@"%@/%@",bookPathUnzip,cover]];
            }
            else
            {
                [arr addObject:@"no data"];
            }
            
            [arrTempNames addObject:BackCoverXmlPathTemp(bookPathUnzip)];
        }
        else
        {
            if (i - model.coverpages - 1 > 0)
            {
                NSString *strIndex = StringValueIn100FromInt(i - model.coverpages - 1);
                
                NSString *contentXMLPath = ContentXmlPath(bookPathUnzip, strIndex);
                NSString *contentXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:contentXMLPath encoding:NSUTF8StringEncoding error:nil]];
                NSDictionary *dicXml = [XMLReader dictionaryForXMLString:contentXml error:nil];
                NSString *content = [[[dicXml  objectForKey:@"page"] objectForKey:@"background"] safeObjectForKey:@"file"];
                
                content = [content stringByReplacingOccurrencesOfString:@"swf" withString:@"jpg"];
                
                if (content)
                {
                    content = [[@"jpgPage/" stringByAppendingString:content] MD5String];
                    [arr addObject:[NSString stringWithFormat:@"%@/%@",bookPathUnzip,content]];
                }else
                {
                    [arr addObject:@"no data"];
                }
                
                [arrTempNames addObject:ContentXmlPathTemp(bookPathUnzip, strIndex)];
            }
        }
    }
    return arr;
}


// 获取书本封面图
+ (NSString *)getMainCoverFilePathWithBookId:(NSString *)bid
{
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    
    NSString *coverXMLPath = MainCoverXmlPath(bookPathUnzip);
    NSString *coverXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:coverXMLPath encoding:NSUTF8StringEncoding error:nil]];
    NSDictionary *dicXml = [XMLReader dictionaryForXMLString:coverXml error:nil];

    NSString *cover = [[[dicXml  objectForKey:@"layout"] objectForKey:@"background"] safeObjectForKey:@"file"];
    if (cover)
    {
        cover = [[@"jpgPage/" stringByAppendingString:cover] MD5String];
        return [NSString stringWithFormat:@"%@/%@",bookPathUnzip,cover];
    }
    
    return nil;
}


// 获取书本前几页covers图
+ (NSArray *)getCoversFileNameWithCount:(int)count startIndex:(int)index bookId:(NSString *)bid
{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    
    for (int i = index; i <= count; i++)
    {
        NSString *strIndex = StringValueIn100FromInt(i);
        
        NSString *coverXMLPath = AdditionCoverXmlPath(bookPathUnzip, strIndex);
        NSString *coverXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:coverXMLPath encoding:NSUTF8StringEncoding error:nil]];
        NSDictionary *dicXml = [XMLReader dictionaryForXMLString:coverXml error:nil];
        NSString *cover = [[[dicXml  objectForKey:@"page"] objectForKey:@"background"] safeObjectForKey:@"file"];
       
        if (cover)
        {
            cover = [[@"jpgPage/" stringByAppendingString:cover] MD5String];
            [arr addObject:[NSString stringWithFormat:@"%@/%@",bookPathUnzip,cover]];
        }
        
    }
    return arr;
}

// 获取书本内容页底图
+ (NSArray *)getContentsFileNameWithCount:(int)count startIndex:(int)index bookId:(NSString *)bid
{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    
    for (int i = index; i <= count; i++)
    {
        NSString *strIndex = StringValueIn100FromInt(i);
        
        NSString *contentXMLPath = ContentXmlPath(bookPathUnzip, strIndex);
        NSString *contentXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:contentXMLPath encoding:NSUTF8StringEncoding error:nil]];
        NSDictionary *dicXml = [XMLReader dictionaryForXMLString:contentXml error:nil];
        NSString *content = [[[dicXml  objectForKey:@"page"] objectForKey:@"background"] safeObjectForKey:@"file"];
        
        if (content)
        {
            content = [[@"jpgPage/" stringByAppendingString:content] MD5String];
            [arr addObject:[NSString stringWithFormat:@"%@/%@",bookPathUnzip,content]];
        }
    }
    return arr;
}


// 获取书本背面图
+ (NSString *)getBackCoverFilePathWithBookId:(NSString *)bid
{
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    
    NSString *coverXMLPath = BackCoverXmlPath(bookPathUnzip);
    NSString *coverXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:coverXMLPath encoding:NSUTF8StringEncoding error:nil]];
    NSDictionary *dicXml = [XMLReader dictionaryForXMLString:coverXml error:nil];
    
    NSString *cover = [[[dicXml  objectForKey:@"layout"] objectForKey:@"background"] safeObjectForKey:@"file"];
    if (cover)
    {
        cover = [[@"jpgPage/" stringByAppendingString:cover] MD5String];
        return [NSString stringWithFormat:@"%@/%@",bookPathUnzip,cover];
    }
    
    return nil;

}

/*
// 获取书本cover某一页底图
+ (NSString *)getCoverFileNameWithIndex:(int)index
{

}


// 获取书本内容某一页底图
+ (NSString *)getContentFileNameWithIndex:(int)index
{
    
}
 */

+ (NSMutableArray *)getModuleListWithBookid:(NSString *)bid
{
    NSMutableArray *arrModuleList = [NSMutableArray array];
    
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    NSString *layoutUnitPath = [bookPathUnzip stringByAppendingPathComponent:[@"units.xml" MD5String]];
    
    NSString *unitXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:layoutUnitPath encoding:NSUTF8StringEncoding error:nil]];
    NSDictionary *dicXml = [XMLReader dictionaryForXMLString:unitXml error:nil];
    
    NSArray *arrTempList = [[[dicXml objectForKey:@"book"] objectForKey:@"moduleList"] objectForKey:@"module"];
    for (NSDictionary *dicTemp in arrTempList)
    {
        ModelBookModuleInfo *module = [[ModelBookModuleInfo alloc] init];
        
        module.text = [dicTemp safeObjectForKey:@"text"];
        module.startPage = [[[dicTemp objectForKey:@"startPage"] safeObjectForKey:@"text"] intValue];
        module.endPage = [[[dicTemp objectForKey:@"endPage"] safeObjectForKey:@"text"] intValue];
        module.name = [[dicTemp objectForKey:@"name"] safeObjectForKey:@"text"];
        module.hasUnit = [[[dicTemp objectForKey:@"hasUnit"] safeObjectForKey:@"text"] intValue];
        
        if ([[[dicTemp objectForKey:@"units"] objectForKey:@"unit"] isKindOfClass:[NSArray class]])
        {
            NSArray *arrUnits = [[dicTemp objectForKey:@"units"] objectForKey:@"unit"];
            if ([arrUnits count] > 0)
            {
                NSMutableArray *arrUnitsTemp = [NSMutableArray array];
                
                for (NSDictionary *dicUnit in arrUnits)
                {
                    ModelBookUnitInfo *unit = [[ModelBookUnitInfo alloc] init];
                    
                    unit.startPage = [[[dicUnit objectForKey:@"startPage"] safeObjectForKey:@"text"] intValue];
                    unit.endPage = [[[dicUnit objectForKey:@"endPage"] safeObjectForKey:@"text"] intValue];
                    unit.name = [[dicUnit objectForKey:@"name"] safeObjectForKey:@"text"];
                    unit.text = [dicUnit safeObjectForKey:@"text"];
                    unit.title = [[dicUnit objectForKey:@"title"] safeObjectForKey:@"text"];
                    
                    [arrUnitsTemp addObject:unit];
                }
                
                module.units = [NSArray arrayWithArray:arrUnitsTemp];
            }
        }
        
        [arrModuleList addObject:module];
    }
    
    return arrModuleList;
}

+ (NSMutableArray *)getDownloadEableModuleListWithBookid:(NSString *)bid
{
    NSMutableArray *arrModuleList = [NSMutableArray array];
    
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    NSString *layoutUnitPath = [bookPathUnzip stringByAppendingPathComponent:[@"units.xml" MD5String]];
    
    NSString *unitXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:layoutUnitPath encoding:NSUTF8StringEncoding error:nil]];
    NSDictionary *dicXml = [XMLReader dictionaryForXMLString:unitXml error:nil];
    
    NSString *strTempList = [[[dicXml objectForKey:@"book"] objectForKey:@"moduleobj"] objectForKey:@"text"];
    NSArray  *arrStr = [strTempList componentsSeparatedByString:@"|"];
    for (NSString *str in arrStr)
    {
        if (str.length > 0)
        {
            NSArray *arrUnits = [str componentsSeparatedByString:@","];
            if ([arrUnits count] == 3)
            {
                int startPage = [[arrUnits objectAtIndex:0] intValue];
                int endPage = [[arrUnits objectAtIndex:1] intValue];
                NSString *unitName = [arrUnits objectAtIndex:2];
                
                ModelBookDownloadEnableModuleUnit *model = [[ModelBookDownloadEnableModuleUnit alloc] init];
                model.startPage = startPage;
                model.endPage = endPage;
                model.name = unitName;
                
                [arrModuleList addObject:model];
            }
        }
    }
    return arrModuleList;
}

+ (NSString *)getModuleUnitNameWithIndex:(int)index withModuleList:(NSArray *)moduleList
{
    NSString *strModuleName = @"";
    
    for (ModelBookDownloadEnableModuleUnit *module in moduleList)
    {
        if (module.startPage <= index && module.endPage >= index)
        {
            strModuleName = module.name;
            strModuleName = [strModuleName stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(strModuleName.length - 1, 1)];
            strModuleName = [strModuleName stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)];
            return strModuleName;
        }
    }
    
    return strModuleName;
}

+ (NSString *)getModuleNameWithIndex:(int)index withModuleList:(NSArray *)moduleList
{
    NSString *strModuleName = @"";
    
    for (ModelBookDownloadEnableModuleUnit *module in moduleList)
    {
        if (module.startPage <= index && module.endPage >= index)
        {
            strModuleName = [[module.name componentsSeparatedByString:@"-"] firstObject];
            strModuleName = [strModuleName stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(strModuleName.length - 1, 1)];
            strModuleName = [strModuleName stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)];
            
            return strModuleName;
        }
    }
    
    return strModuleName;
}

+ (NSString *)getUnitNameWithIndex:(int)index withModuleList:(NSArray *)moduleList
{
    NSString *strModuleName = @"";
    
    for (ModelBookDownloadEnableModuleUnit *module in moduleList)
    {
        if (module.startPage <= index && module.endPage >= index)
        {
            strModuleName = [[module.name componentsSeparatedByString:@"-"] lastObject];
            strModuleName = [strModuleName stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(strModuleName.length - 1, 1)];
            strModuleName = [strModuleName stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)];
            
            return strModuleName;
        }
    }
    
    return strModuleName;
}


/*
+ (NSMutableArray *)getModuleListWithBookid:(NSString *)bid
{
    NSMutableArray *arrModuleList = [NSMutableArray array];
    
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    NSString *layoutUnitPath = [bookPathUnzip stringByAppendingPathComponent:[@"units.xml" MD5String]];
    
    NSString *unitXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:layoutUnitPath encoding:NSUTF8StringEncoding error:nil]];
    NSDictionary *dicXml = [XMLReader dictionaryForXMLString:unitXml error:nil];

    NSArray *arrTempList = [[[dicXml objectForKey:@"book"] objectForKey:@"moduleList"] objectForKey:@"module"];
    for (NSDictionary *dicTemp in arrTempList)
    {
        ModelBookModuleInfo *module = [[ModelBookModuleInfo alloc] init];
        
        module.text = [dicTemp safeObjectForKey:@"text"];
        module.startPage = [[[dicTemp objectForKey:@"startPage"] safeObjectForKey:@"text"] intValue];
        module.endPage = [[[dicTemp objectForKey:@"endPage"] safeObjectForKey:@"text"] intValue];
        module.name = [[dicTemp objectForKey:@"name"] safeObjectForKey:@"text"];
        module.hasUnit = [[[dicTemp objectForKey:@"hasUnit"] safeObjectForKey:@"text"] intValue];
        
        if ([[[dicTemp objectForKey:@"units"] objectForKey:@"unit"] isKindOfClass:[NSArray class]])
        {
            NSArray *arrUnits = [[dicTemp objectForKey:@"units"] objectForKey:@"unit"];
            if ([arrUnits count] > 0)
            {
                NSMutableArray *arrUnitsTemp = [NSMutableArray array];
                
                for (NSDictionary *dicUnit in arrUnits)
                {
                    ModelBookUnitInfo *unit = [[ModelBookUnitInfo alloc] init];
                    
                    unit.startPage = [[[dicUnit objectForKey:@"startPage"] safeObjectForKey:@"text"] intValue];
                    unit.endPage = [[[dicUnit objectForKey:@"endPage"] safeObjectForKey:@"text"] intValue];
                    unit.name = [[dicUnit objectForKey:@"name"] safeObjectForKey:@"text"];
                    unit.text = [dicUnit safeObjectForKey:@"text"];
                    unit.title = [[dicUnit objectForKey:@"title"] safeObjectForKey:@"text"];
                    
                    [arrUnitsTemp addObject:unit];
                }
                
                module.units = [NSArray arrayWithArray:arrUnitsTemp];
            }
        }
        
        [arrModuleList addObject:module];
    }
    
    return arrModuleList;
}

+ (NSString *)getModuleUnitNameWithIndex:(int)index withModuleList:(NSArray *)moduleList
{
    NSString *strModuleName = @"";
    
    for (ModelBookModuleInfo *module in moduleList)
    {
        for (ModelBookUnitInfo *unit in module.units)
        {
            if (unit.startPage <= index && unit.endPage >= index)
            {
                strModuleName = [NSString stringWithFormat:@"%@ - %@",module.name, unit.name];
                return strModuleName;
            }
        }
        
        if (module.startPage <= index && module.endPage >= index)
        {
            strModuleName = module.name;
            return strModuleName;
        }
    }
    
    return strModuleName;
}

+ (NSString *)getModuleNameWithIndex:(int)index withModuleList:(NSArray *)moduleList
{
    NSString *strModuleName = @"";
    
    for (ModelBookModuleInfo *module in moduleList)
    {
        for (ModelBookUnitInfo *unit in module.units)
        {
            if (unit.startPage <= index && unit.endPage >= index)
            {
                strModuleName = [NSString stringWithFormat:@"%@",module.name];
                return strModuleName;
            }
        }
        
        if (module.startPage <= index && module.endPage >= index)
        {
            strModuleName = module.name;
            return strModuleName;
        }
    }
    
    return strModuleName;
}

+ (NSString *)getUnitNameWithIndex:(int)index withModuleList:(NSArray *)moduleList
{
    NSString *strModuleName = @"";
    
    for (ModelBookModuleInfo *module in moduleList)
    {
        for (ModelBookUnitInfo *unit in module.units)
        {
            if (unit.startPage <= index && unit.endPage >= index)
            {
                strModuleName = [NSString stringWithFormat:@"%@", unit.name];
                return strModuleName;
            }
        }
        
        if (module.startPage <= index && module.endPage >= index)
        {
            strModuleName = module.name;
            return strModuleName;
        }
    }
    
    return strModuleName;
}
 */

// 获取书本某一页的页内资源信息 -- 点读
+ (NSArray *)getBlockInfosWithPageIndex:(int)index withBookId:(NSString *)bid withModuleName:(NSString *)moduleName
{
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    
    NSString *strIndex = StringValueIn100FromInt(index);
    
    NSString *contentXMLPath = ContentXmlPath(bookPathUnzip, strIndex);
    NSString *contentXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:contentXMLPath encoding:NSUTF8StringEncoding error:nil]];
    NSDictionary *dicXml = [XMLReader dictionaryForXMLString:contentXml error:nil];
    
    NSString    *eid = [[[dicXml objectForKey:@"page"] objectForKey:@"background"] objectForKey:@"file"];
    
    
    if ([eid rangeOfString:@"jh"].location != NSNotFound)
    {
        NSMutableArray *arrDicBlocks = [NSMutableArray array];
        
        if ([[[[dicXml  objectForKey:@"page"] objectForKey:@"blockInfos"] objectForKey:@"block"] isKindOfClass:[NSArray class]])
        {
            NSArray *dicBlocksTemp = [[[dicXml  objectForKey:@"page"] objectForKey:@"blockInfos"] objectForKey:@"block"];
            
            for (NSDictionary *dicTemp in dicBlocksTemp)
            {
                ModelClickRead *model = [[ModelClickRead alloc] init];
                model.cid = [dicTemp safeObjectForKey:@"code"];
                
                NSArray *arrPointStr = [[dicTemp objectForKey:@"point"] componentsSeparatedByString:@","];
                CGRect rect = CGRectMake([[arrPointStr objectAtIndex:0] floatValue], [[arrPointStr objectAtIndex:1] floatValue], [[arrPointStr objectAtIndex:2] floatValue] - [[arrPointStr objectAtIndex:0] floatValue], [[arrPointStr objectAtIndex:3] floatValue] - [[arrPointStr objectAtIndex:1] floatValue]);
                
                model.startX = rect.origin.x;
                model.startY = rect.origin.y;
                model.width = rect.size.width;
                model.height = rect.size.height;
                
                NSString *filename = [dicTemp safeObjectForKey:@"goto"];
                NSArray *arrTemp0 = [filename componentsSeparatedByString:@":"];
                NSArray *arrTemp1 = [[arrTemp0 firstObject] componentsSeparatedByString:@"\\"];
                filename = [arrTemp1 lastObject];
                filename = [ResourceDataUtil trimSuffixSpace:filename];
                
                model.text = filename;
                model.visible = [[dicTemp safeObjectForKey:@"visible"] boolValue];
                
                NSString *bookDirPath = [ConfigGlobal cachePathBooks];
                NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
                
                NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
                filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
                filePath = [filePath stringByAppendingString:@"/"];
                NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,model.text];
                filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                
                model.filePath = filePath;
                [arrDicBlocks addObject:model];
            }
        }
        else if ([[[[dicXml  objectForKey:@"page"] objectForKey:@"blockInfos"] objectForKey:@"block"] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dicTemp = [[[dicXml  objectForKey:@"page"] objectForKey:@"blockInfos"] objectForKey:@"block"];
            ModelClickRead *model = [[ModelClickRead alloc] init];
            model.cid = [dicTemp safeObjectForKey:@"code"];
            
            NSArray *arrPointStr = [[dicTemp objectForKey:@"point"] componentsSeparatedByString:@","];
            CGRect rect = CGRectMake([[arrPointStr objectAtIndex:0] floatValue], [[arrPointStr objectAtIndex:1] floatValue], [[arrPointStr objectAtIndex:2] floatValue] - [[arrPointStr objectAtIndex:0] floatValue], [[arrPointStr objectAtIndex:3] floatValue] - [[arrPointStr objectAtIndex:1] floatValue]);
            
            model.startX = rect.origin.x;
            model.startY = rect.origin.y;
            model.width = rect.size.width;
            model.height = rect.size.height;
            
            NSString *filename = [dicTemp safeObjectForKey:@"goto"];
            NSArray *arrTemp0 = [filename componentsSeparatedByString:@":"];
            NSArray *arrTemp1 = [[arrTemp0 firstObject] componentsSeparatedByString:@"\\"];
            filename = [arrTemp1 lastObject];
            filename = [ResourceDataUtil trimSuffixSpace:filename];
            
            model.text = filename;
            model.visible = [[dicTemp safeObjectForKey:@"visible"] boolValue];
            
            NSString *bookDirPath = [ConfigGlobal cachePathBooks];
            NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
            
            NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
            filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
            filePath = [filePath stringByAppendingString:@"/"];
            NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,model.text];
            filePath = [filePath stringByAppendingString:[strTemp MD5String]];
            
            model.filePath = filePath;
            [arrDicBlocks addObject:model];
        }
        
        return arrDicBlocks;
    }
    else
    {
        NSMutableArray *dicReads = [NSMutableArray array];
        
        if ([[[dicXml  objectForKey:@"page"] objectForKey:@"clickRead"] isKindOfClass:[NSArray class]])
        {
            NSArray *dicClickReads = [[dicXml  objectForKey:@"page"] objectForKey:@"clickRead"];
            for (NSDictionary *dicTemp in dicClickReads)
            {
                ModelClickRead *model = [[ModelClickRead alloc] init];
                model.cid = [dicTemp safeObjectForKey:@"cid"];
                
                model.startX = [dicTemp[@"x"] floatValue];
                model.startY = [dicTemp[@"y"] floatValue];
                model.width = [dicTemp[@"width"] floatValue];
                model.height = [dicTemp[@"height"] floatValue];
                
                model.visible = YES;
                model.text = dicTemp[@"text"];
                
                if (!model.text)
                {
                    continue;
                }
                if (model.text.length == 0)
                {
                    continue;
                }
                
                if (![model.text hasSuffix:@".mp3"])
                {
                    model.text = [model.text stringByAppendingString:@".mp3"];
                }
                
                NSString *bookDirPath = [ConfigGlobal cachePathBooks];
                NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
                
                NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
                filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
                filePath = [filePath stringByAppendingString:@"/"];
                NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,model.text];
                filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                
                model.filePath = filePath;
                [dicReads addObject:model];
            }
        }
        else if ([[[dicXml  objectForKey:@"page"] objectForKey:@"clickRead"] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dicTemp = [[dicXml  objectForKey:@"page"] objectForKey:@"clickRead"];
            
            ModelClickRead *model = [[ModelClickRead alloc] init];
            model.cid = [dicTemp safeObjectForKey:@"cid"];
            
            model.startX = [dicTemp[@"x"] floatValue];
            model.startY = [dicTemp[@"y"] floatValue];
            model.width = [dicTemp[@"width"] floatValue];
            model.height = [dicTemp[@"height"] floatValue];
            
            model.visible = YES;
            model.text = dicTemp[@"text"];
            
            if (model.text)
            {
                if (model.text.length > 0)
                {
                    if (![model.text hasSuffix:@".mp3"])
                    {
                        model.text = [model.text stringByAppendingString:@".mp3"];
                    }
                    
                    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
                    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
                    
                    NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
                    filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
                    filePath = [filePath stringByAppendingString:@"/"];
                    NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,model.text];
                    filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                    
                    model.filePath = filePath;
                    [dicReads addObject:model];
                }
            }
        }
        
        if ([[[dicXml  objectForKey:@"page"] objectForKey:@"translate"] isKindOfClass:[NSArray class]])
        {
            NSArray *dicTransLate = [[dicXml  objectForKey:@"page"] objectForKey:@"translate"];
            for (NSDictionary *dicTemp in dicTransLate)
            {
                ModelClickRead *model = [[ModelClickRead alloc] init];
                model.cid = [dicTemp safeObjectForKey:@"cid"];
                
                model.startX = [dicTemp[@"x"] floatValue];
                model.startY = [dicTemp[@"y"] floatValue];
                model.width = [dicTemp[@"width"] floatValue];
                model.height = [dicTemp[@"height"] floatValue];
                
                model.visible = YES;
                model.text = model.cid;
                if (![model.cid hasSuffix:@".mp3"])
                {
                    model.text = [model.cid stringByAppendingString:@".mp3"];
                }
                
                NSString *bookDirPath = [ConfigGlobal cachePathBooks];
                NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
                
                NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
                filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
                filePath = [filePath stringByAppendingString:@"/"];
                NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,model.text];
                filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                
                model.filePath = filePath;
                
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                if ([fileManager fileExistsAtPath:model.filePath])
                {
                    [dicReads addObject:model];
                }
                
            }
        }
        else if ([[[dicXml  objectForKey:@"page"] objectForKey:@"translate"] isKindOfClass:[NSDictionary class]])
        {
            
            NSDictionary *dicTemp = [[dicXml  objectForKey:@"page"] objectForKey:@"translate"];
            ModelClickRead *model = [[ModelClickRead alloc] init];
            model.cid = [dicTemp safeObjectForKey:@"cid"];
            
            model.startX = [dicTemp[@"x"] floatValue];
            model.startY = [dicTemp[@"y"] floatValue];
            model.width = [dicTemp[@"width"] floatValue];
            model.height = [dicTemp[@"height"] floatValue];
            
            model.visible = YES;
            model.text = model.cid;
            if (![model.cid hasSuffix:@".mp3"])
            {
                model.text = [model.cid stringByAppendingString:@".mp3"];
            }
            
            NSString *bookDirPath = [ConfigGlobal cachePathBooks];
            NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
            
            NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
            filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
            filePath = [filePath stringByAppendingString:@"/"];
            NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,model.text];
            filePath = [filePath stringByAppendingString:[strTemp MD5String]];
            
            model.filePath = filePath;
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:model.filePath])
            {
                [dicReads addObject:model];
            }
        }
        return dicReads;
    }
    return nil;
}

// 获取书本某一页的页内资源信息 -- 功能菜单项
+ (NSArray *)getMenusWithPageIndex:(int)index withBookId:(NSString *)bid withModuleName:(NSString *)moduleName
{
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    
    NSString *strIndex = StringValueIn100FromInt(index);
    
    NSString *contentXMLPath = ContentXmlPath(bookPathUnzip, strIndex);
    NSString *contentXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:contentXMLPath encoding:NSUTF8StringEncoding error:nil]];
    NSDictionary *dicXml = [XMLReader dictionaryForXMLString:contentXml options:XMLReaderOptionsProcessNamespaces error:nil];
    
    NSMutableArray *arrMenus = [NSMutableArray array];
    
    if ([[[dicXml  objectForKey:@"page"] objectForKey:@"menu"] isKindOfClass:[NSArray class]])
    {
        NSArray *dicMenusTemp = [[dicXml  objectForKey:@"page"] objectForKey:@"menu"];
        
        for (NSDictionary *dicTemp in dicMenusTemp)
        {
            ModelContentMenus *model = [[ModelContentMenus alloc] init];
            model.cid = [dicTemp safeObjectForKey:@"cid"];
            model.x = [[dicTemp safeObjectForKey:@"x"] floatValue];
            model.y = [[dicTemp safeObjectForKey:@"y"] floatValue];
            model.text = [dicTemp safeObjectForKey:@"text"];
            model.version = [dicTemp safeObjectForKey:@"version"];
            
            NSMutableArray *arrActions = [NSMutableArray array];
            
            if ([[dicTemp objectForKey:@"item"] isKindOfClass:[NSArray class]])
            {
                NSArray *arrItems = [dicTemp objectForKey:@"item"];
                
                for (NSDictionary *dicMenu in arrItems)
                {
                    ModelContentMenuAction *action = [[ModelContentMenuAction alloc] init];
                    action.action = [dicMenu safeObjectForKey:@"action"];
                    action.file = [dicMenu safeObjectForKey:@"file"];
                    action.name = [dicMenu safeObjectForKey:@"name"];
                    action.text = [dicMenu safeObjectForKey:@"text"];
                    action.version = [dicMenu safeObjectForKey:@"version"];
                    
                    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
                    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
                    
                    NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
                    filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
                    filePath = [filePath stringByAppendingString:@"/"];
                    /* 听录音 */
                    NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,action.file];
                    if ([action.action isEqualToString:MenuActionTypePlayAudio])
                    {
                        filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                        action.filePath = filePath;
                        [arrActions addObject:action];
                    }
                    /* 看视频 */
                    else if ([action.action isEqualToString:MenuActionTypePlayFlash] && [action.name isEqualToString:@"播放动画"])
                    {
                        NSString *strFileName = [action.file stringByReplacingOccurrencesOfString:@".swf" withString:@".mp4"];
                        strTemp = [NSString stringWithFormat:@"data/%@/mp4/%@",moduleName,strFileName];
                        filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                        action.filePath = filePath;
                        [arrActions addObject:action];
                    }
                    else if ([action.action isEqualToString:MenuActionTypeShowText])
                    {
                        action.filePath = action.text;
                        [arrActions addObject:action];
                    }
                    else if ([action.action isEqualToString:MenuActionTypePlayFlash] && [action.name isEqualToString:@"导教"])
                    {
//                        strTemp = [NSString stringWithFormat:@"data/%@/pdf/%@",moduleName,action.file];
                    }
                    else if ([action.action isEqualToString:@"FollowRead"] || [action.action isEqualToString:@"Read"] || [action.action isEqualToString:@"RolePlay"] || [action.action isEqualToString:@"Recite"])
                    {
                    }
                }
            }
            else if ([[dicTemp objectForKey:@"item"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dicItem = [dicTemp objectForKey:@"item"];
                
                ModelContentMenuAction *action = [[ModelContentMenuAction alloc] init];
                action.action = [dicItem safeObjectForKey:@"action"];
                action.file = [dicItem safeObjectForKey:@"file"];
                action.name = [dicItem safeObjectForKey:@"name"];
                action.text = [dicItem safeObjectForKey:@"text"];
                action.version = [dicItem safeObjectForKey:@"version"];
                
                NSString *bookDirPath = [ConfigGlobal cachePathBooks];
                NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
                
                NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
                filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
                filePath = [filePath stringByAppendingString:@"/"];
                /* 听录音 */
                NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,action.file];
                if ([action.action isEqualToString:MenuActionTypePlayAudio])
                {
                    filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                    action.filePath = filePath;
                    [arrActions addObject:action];
                }
                /* 看视频 */
                else if ([action.action isEqualToString:MenuActionTypePlayFlash] && [action.name isEqualToString:@"播放动画"])
                {
                    NSString *strFileName = [action.file stringByReplacingOccurrencesOfString:@".swf" withString:@".mp4"];
                    strTemp = [NSString stringWithFormat:@"data/%@/mp4/%@",moduleName,strFileName];
                    filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                    action.filePath = filePath;
                    [arrActions addObject:action];
                }
                else if ([action.action isEqualToString:MenuActionTypeShowText])
                {
                    action.filePath = action.text;
                    [arrActions addObject:action];
                }
                else if ([action.action isEqualToString:MenuActionTypePlayFlash] && [action.name isEqualToString:@"导教"])
                {
                    //                        strTemp = [NSString stringWithFormat:@"data/%@/pdf/%@",moduleName,action.file];
                }
                else if ([action.action isEqualToString:@"FollowRead"] || [action.action isEqualToString:@"Read"] || [action.action isEqualToString:@"RolePlay"] || [action.action isEqualToString:@"Recite"])
                {
                }
            }

            model.item = [NSArray arrayWithArray:arrActions];
            if ([model.item count] > 0)
            {
                [arrMenus addObject:model];
            }
        }
    }
    else if ([[[dicXml  objectForKey:@"page"] objectForKey:@"menu"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dicTemp = [[dicXml  objectForKey:@"page"] objectForKey:@"menu"];
        ModelContentMenus *model = [[ModelContentMenus alloc] init];
        model.cid = [dicTemp safeObjectForKey:@"cid"];
        model.x = [[dicTemp safeObjectForKey:@"x"] floatValue];
        model.y = [[dicTemp safeObjectForKey:@"y"] floatValue];
        model.text = [dicTemp safeObjectForKey:@"text"];
        model.version = [dicTemp safeObjectForKey:@"version"];
        
        NSMutableArray *arrActions = [NSMutableArray array];
        
        if ([[dicTemp objectForKey:@"item"] isKindOfClass:[NSArray class]])
        {
            NSArray *arrItems = [dicTemp objectForKey:@"item"];
            
            for (NSDictionary *dicMenu in arrItems)
            {
                ModelContentMenuAction *action = [[ModelContentMenuAction alloc] init];
                action.action = [dicMenu safeObjectForKey:@"action"];
                action.file = [dicMenu safeObjectForKey:@"file"];
                action.name = [dicMenu safeObjectForKey:@"name"];
                action.text = [dicMenu safeObjectForKey:@"text"];
                action.version = [dicMenu safeObjectForKey:@"version"];
                
                NSString *bookDirPath = [ConfigGlobal cachePathBooks];
                NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
                
                NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
                filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
                filePath = [filePath stringByAppendingString:@"/"];
                
                /* 听录音 */
                NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,action.file];
                if ([action.action isEqualToString:MenuActionTypePlayAudio])
                {
                    filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                    action.filePath = filePath;
                    [arrActions addObject:action];
                }
                /* 看视频 */
                else if ([action.action isEqualToString:MenuActionTypePlayFlash] && [action.name isEqualToString:@"播放动画"])
                {
                    NSString *strFileName = [action.file stringByReplacingOccurrencesOfString:@".swf" withString:@".mp4"];
                    strTemp = [NSString stringWithFormat:@"data/%@/mp4/%@",moduleName,strFileName];
                    filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                    action.filePath = filePath;
                    [arrActions addObject:action];
                }
                else if ([action.action isEqualToString:MenuActionTypeShowText])
                {
                    action.filePath = action.text;
                    [arrActions addObject:action];
                }
                else if ([action.action isEqualToString:MenuActionTypePlayFlash] && [action.name isEqualToString:@"导教"])
                {
                    //                        strTemp = [NSString stringWithFormat:@"data/%@/pdf/%@",moduleName,action.file];
                }
                else if ([action.action isEqualToString:@"FollowRead"] || [action.action isEqualToString:@"Read"] || [action.action isEqualToString:@"RolePlay"] || [action.action isEqualToString:@"Recite"])
                {
                }
            }
        }
        else if ([[dicTemp objectForKey:@"item"] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dicItem = [dicTemp objectForKey:@"item"];
            
            ModelContentMenuAction *action = [[ModelContentMenuAction alloc] init];
            action.action = [dicItem safeObjectForKey:@"action"];
            action.file = [dicItem safeObjectForKey:@"file"];
            action.name = [dicItem safeObjectForKey:@"name"];
            action.text = [dicItem safeObjectForKey:@"text"];
            action.version = [dicItem safeObjectForKey:@"version"];
            
            NSString *bookDirPath = [ConfigGlobal cachePathBooks];
            NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
            
            NSString *filePath = [bookPathUnzip stringByAppendingString:@"/"];
            filePath = [filePath stringByAppendingString:[moduleName MD5String16]];
            filePath = [filePath stringByAppendingString:@"/"];
            /* 听录音 */
            NSString *strTemp = [NSString stringWithFormat:@"data/%@/audio/%@",moduleName,action.file];
            if ([action.action isEqualToString:MenuActionTypePlayAudio])
            {
                filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                action.filePath = filePath;
                [arrActions addObject:action];
            }
            /* 看视频 */
            else if ([action.action isEqualToString:MenuActionTypePlayFlash] && [action.name isEqualToString:@"播放动画"])
            {
                NSString *strFileName = [action.file stringByReplacingOccurrencesOfString:@".swf" withString:@".mp4"];
                strTemp = [NSString stringWithFormat:@"data/%@/mp4/%@",moduleName,strFileName];
                filePath = [filePath stringByAppendingString:[strTemp MD5String]];
                action.filePath = filePath;
                [arrActions addObject:action];
            }
            else if ([action.action isEqualToString:MenuActionTypeShowText])
            {
                action.filePath = action.text;
                [arrActions addObject:action];
            }
            else if ([action.action isEqualToString:MenuActionTypePlayFlash] && [action.name isEqualToString:@"导教"])
            {
                //                        strTemp = [NSString stringWithFormat:@"data/%@/pdf/%@",moduleName,action.file];
            }
            else if ([action.action isEqualToString:@"FollowRead"] || [action.action isEqualToString:@"Read"] || [action.action isEqualToString:@"RolePlay"] || [action.action isEqualToString:@"Recite"])
            {
            }
        }
        
        model.item = [NSArray arrayWithArray:arrActions];
        [arrMenus addObject:model];
    }
    return arrMenus;
}


// 获取书本某一页的页内资源信息 -- 辅助翻译或者语法
+ (NSArray *)getTranslateOrGrammarWithPageIndex:(int)index withBookId:(NSString *)bid withModuleName:(NSString *)moduleName isTranslate:(BOOL)isTranslate   // isTranslate == YES : 获取辅助翻译  | isTranslate == NO : 获取语言知识
{
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    
    NSString *strIndex = StringValueIn100FromInt(index);
    
    NSString *contentXMLPath = ContentXmlPath(bookPathUnzip, strIndex);
    NSString *contentXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:contentXMLPath encoding:NSUTF8StringEncoding error:nil]];
    NSDictionary *dicXml = [XMLReader dictionaryForXMLString:contentXml options:XMLReaderOptionsProcessNamespaces error:nil];
    
    NSMutableArray *arrTranslate = [NSMutableArray array];
//    NSMutableDictionary *dicArrTranslate = [NSMutableDictionary dictionary];
    
    NSMutableArray *arrTranslateNode = [NSMutableArray array];
    
    NSString *key = @"translate";
    NSString *keysql = @"tranSql";
    if (!isTranslate)
    {
        key = @"grammar";
        keysql = @"graSql";
    }
    
    if ([[[dicXml  objectForKey:@"page"] objectForKey:key] isKindOfClass:[NSArray class]])
    {
        NSArray *dicMenusTemp = [[dicXml  objectForKey:@"page"] objectForKey:key];
        
        for (NSDictionary *dicTemp in dicMenusTemp)
        {
            ModelTranslate *model = [[ModelTranslate alloc] init];
            model.cid = [dicTemp safeObjectForKey:@"cid"];
            model.x = [[dicTemp safeObjectForKey:@"x"] floatValue];
            model.y = [[dicTemp safeObjectForKey:@"y"] floatValue];
            model.text = [dicTemp safeObjectForKey:@"text"];
            model.version = [dicTemp safeObjectForKey:@"version"];
            model.width = [[dicTemp safeObjectForKey:@"width"] floatValue];
            model.height = [[dicTemp safeObjectForKey:@"height"] floatValue];
            
            [arrTranslateNode addObject:model];
        }
    }
    else if ([[[dicXml  objectForKey:@"page"] objectForKey:key] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dicTemp = [[dicXml  objectForKey:@"page"] objectForKey:key];
        
        ModelTranslate *model = [[ModelTranslate alloc] init];
        model.cid = [dicTemp safeObjectForKey:@"cid"];
        model.x = [[dicTemp safeObjectForKey:@"x"] floatValue];
        model.y = [[dicTemp safeObjectForKey:@"y"] floatValue];
        model.text = [dicTemp safeObjectForKey:@"text"];
        model.version = [dicTemp safeObjectForKey:@"version"];
        model.width = [[dicTemp safeObjectForKey:@"width"] floatValue];
        model.height = [[dicTemp safeObjectForKey:@"height"] floatValue];
        
//        [dicArrTranslate setObject:model forKey:model.cid];
        
        [arrTranslateNode addObject:model];
    }
    
    
    if ([[dicXml  objectForKey:@"page"] objectForKey:@"sql"])
    {
        if ([[[[dicXml  objectForKey:@"page"] objectForKey:@"sql"] objectForKey:keysql] isKindOfClass:[NSArray class]])
        {
            NSArray *arrDicTemp = [[[dicXml  objectForKey:@"page"] objectForKey:@"sql"] objectForKey:keysql];
            
/*
            for (NSDictionary *dicTemp in arrDicTemp)
            {
                NSString *strCid = [dicTemp safeObjectForKey:@"cid"];
                NSString *strDes = [dicTemp safeObjectForKey:@"des"];
                NSString *strTxt = [dicTemp safeObjectForKey:@"text"];
                
                for (ModelTranslate *modelTranslate in arrTranslateNode)
                {
                    if ([modelTranslate.cid isEqualToString:strCid])
                    {
                        ModelTranslate *model = modelTranslate;
                        model.des = strDes;
                        if (strTxt.length > 0)
                        {
                            model.text = strTxt;
                        }
                        [arrTranslate addObject:model];
                        
                        continue;
                    }
                }
            }
*/
            for (ModelTranslate *modelTranslate in arrTranslateNode)
            {
                for (NSDictionary *dicTemp in arrDicTemp)
                {
                    NSString *strCid = [dicTemp safeObjectForKey:@"cid"];
                    NSString *strDes = [dicTemp safeObjectForKey:@"des"];
                    NSString *strTxt = [dicTemp safeObjectForKey:@"text"];
                    
                    if ([modelTranslate.cid isEqualToString:strCid])
                    {
                        ModelTranslate *model = modelTranslate;
                        model.des = strDes;
                        if (strTxt.length > 0)
                        {
                            model.text = strTxt;
                        }
                        [arrTranslate addObject:model];
                        
                        break;
                    }
                }
            }
        }
        else if ([[[[dicXml  objectForKey:@"page"] objectForKey:@"sql"] objectForKey:keysql] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dicTemp = [[[dicXml  objectForKey:@"page"] objectForKey:@"sql"] objectForKey:keysql];
            
            NSString *strCid = [dicTemp safeObjectForKey:@"cid"];
            NSString *strDes = [dicTemp safeObjectForKey:@"des"];
            NSString *strTxt = [dicTemp safeObjectForKey:@"text"];
            
            
            for (ModelTranslate *modelTranslate in arrTranslateNode)
            {
                if ([modelTranslate.cid isEqualToString:strCid])
                {
                    ModelTranslate *model = modelTranslate;
                    model.des = strDes;
                    if (strTxt.length > 0)
                    {
                        model.text = strTxt;
                    }
                    [arrTranslate addObject:model];
                    
                    continue;
                }
            }
        }
    }

    return arrTranslate;
}

// 获取书本某一页的资源信息 -- word
+ (NSArray *)getNewWordsWithPageIndex:(int)index withBookId:(NSString *)bid withModuleName:(NSString *)moduleName
{
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:bid];
    
    NSString *strIndex = StringValueIn100FromInt(index);
    
    NSString *contentXMLPath = ContentXmlPath(bookPathUnzip, strIndex);
    NSString *contentXml = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:contentXMLPath encoding:NSUTF8StringEncoding error:nil]];
    
    GDataXMLDocument *xml = [[GDataXMLDocument alloc] initWithXMLString:contentXml options:0 error:nil];
    GDataXMLElement *root = [xml rootElement];
    // begin 获取页面的所有word定位和标识信息 //
    NSMutableArray *arrNodeWords = [NSMutableArray array];
    // if root element is valid
    if (root)
    {
        NSArray *wordsElement = [root elementsForName:@"word"];
        
        for (GDataXMLElement *word in wordsElement)
        {
            ModelWord *w = [[ModelWord alloc] init];
            w.cid = [[word attributeForName:@"cid"] stringValue];
            w.x = [[[word attributeForName:@"x"] stringValue] floatValue];
            w.y = [[[word attributeForName:@"y"] stringValue] floatValue];
            w.text = [[word attributeForName:@"text"] stringValue];
            w.version = [[word attributeForName:@"version"] stringValue];
            w.width = [[[word attributeForName:@"width"] stringValue] floatValue];
            w.height = [[[word attributeForName:@"height"] stringValue] floatValue];
            [arrNodeWords addObject:w];
        }
    }
    // end 获取页面的所有word定位和标识信息 //
    
    
    // begin 解析每个word的详细信息 //
    for (ModelWord *word in arrNodeWords)
    {
        NSString *filePathBase = [bookPathUnzip stringByAppendingString:@"/"];
        filePathBase = [filePathBase stringByAppendingString:[moduleName MD5String16]];
        filePathBase = [filePathBase stringByAppendingString:@"/"];
        /* WordNode 解析 */
        NSString *strTemp = [NSString stringWithFormat:@"data/%@/word/xml/%@.xml",moduleName,word.text];
        NSString *filePath = [filePathBase stringByAppendingString:[strTemp MD5String]];
        
        NSString *contentWord = [EncryptUtil decryptWithText:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]];
        GDataXMLDocument *wordXml = [[GDataXMLDocument alloc] initWithXMLString:contentWord options:0 error:nil];
        GDataXMLElement *wordRoot = [wordXml rootElement];
        
        if (wordRoot)
        {
            ModelWordNode *modelWordNode = [[ModelWordNode alloc] init];
            modelWordNode.word = word.text;
            NSLog(@"%@",word.text);
            
            // features
            GDataXMLElement *features = [[wordRoot elementsForName:@"features"] firstObject];
            if ([features elementsForName:@"entry"])
            {
                if ([[features elementsForName:@"entry"] firstObject])
                {
                    modelWordNode.entry = [[[features elementsForName:@"entry"] firstObject] stringValue];
                    modelWordNode.entry = [modelWordNode.entry stringByReplacingOccurrencesOfString:@"##183;" withString:@"-"];
                }
            }
            if ([features elementsForName:@"frequency"])
            {
                if ([[features elementsForName:@"frequency"] firstObject])
                {
                    modelWordNode.frequency = [[[features elementsForName:@"frequency"] firstObject] stringValue];
                    modelWordNode.frequency = [[modelWordNode.frequency stringByReplacingOccurrencesOfString:@"^" withString:@"★"] stringByReplacingOccurrencesOfString:@"+" withString:@"☆"];
                }
            }
            if ([features elementsForName:@"pronunciationPath"])
            {
                
                if ([[features elementsForName:@"pronunciationPath"] firstObject])
                {
                    modelWordNode.pronunciationPath = [[[features elementsForName:@"pronunciationPath"] firstObject] stringValue];
                    NSString *mp3_path = modelWordNode.pronunciationPath;
                    mp3_path = [[mp3_path componentsSeparatedByString:@"/"] firstObject];
                    NSString *strTemp_mp3Path = [NSString stringWithFormat:@"data/%@/word/%@/%@.mp3",moduleName,mp3_path,word.text];
                    mp3_path = [filePathBase stringByAppendingString:[strTemp_mp3Path MD5String]];
                    modelWordNode.pronunciationPath = mp3_path;
                    
                    NSString *imagePathTemp = [NSString stringWithFormat:@"data/%@/word/img/%@.jpg",moduleName,word.text];
                    imagePathTemp = [filePathBase stringByAppendingString:[imagePathTemp MD5String]];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([fileManager fileExistsAtPath:imagePathTemp])
                    {
                        modelWordNode.hasImage = YES;
                        modelWordNode.imagePath = imagePathTemp;
                    }
                }
            }
            
            // entry_examples
            NSMutableArray *arrExamples = [NSMutableArray array];
            NSArray *entry_examples = [wordRoot elementsForName:@"entry_examples"];
            if (!entry_examples)
            {
                if ([wordRoot elementsForName:@"exampleList"])
                {
                    NSArray *arrExmList = [wordRoot elementsForName:@"exampleList"];
                    
                    for (GDataXMLElement *strElement in arrExmList)
                    {
                        NSArray *arrChild = [strElement children];
                        
                        if (arrChild)
                        {
                            for (GDataXMLElement *child in arrChild)
                            {
                                NSString *strExample = [child XMLString];
                                strExample = [strExample stringByReplacingOccurrencesOfString:@"##151;" withString:@"-"];
                                strExample = [strExample stringByReplacingOccurrencesOfString:@"##176;" withString:@"˚"];
                                [arrExamples addObject:strExample];
                            }
                        }
                        else
                        {
                            NSString *strExample = [strElement XMLString];
                            strExample = [strExample stringByReplacingOccurrencesOfString:@"##151;" withString:@"-"];
                            strExample = [strExample stringByReplacingOccurrencesOfString:@"##176;" withString:@"˚"];
                            [arrExamples addObject:strExample];
                        }
                    }
                }
            }
            else
            {
                for (GDataXMLElement *strElement in entry_examples)
                {
                    NSArray *arrChild = [strElement children];
                    
                    if (arrChild)
                    {
                        for (GDataXMLElement *child in arrChild)
                        {
                            NSString *strExample = [child XMLString];
                            strExample = [strExample stringByReplacingOccurrencesOfString:@"##151;" withString:@"-"];
                            strExample = [strExample stringByReplacingOccurrencesOfString:@"##176;" withString:@"˚"];
                            [arrExamples addObject:strExample];
                        }
                    }
                    else
                    {
                        NSString *strExample = [strElement XMLString];
                        strExample = [strExample stringByReplacingOccurrencesOfString:@"##151;" withString:@"-"];
                        strExample = [strExample stringByReplacingOccurrencesOfString:@"##176;" withString:@"˚"];
                        [arrExamples addObject:strExample];
                    }
                }
            }
            modelWordNode.entry_examples = [NSArray arrayWithArray:arrExamples];

            
            // definitions
            NSMutableArray *arrDefs = [NSMutableArray array];
            
            NSArray *definitions = [wordRoot elementsForName:@"definitions"];
            for (GDataXMLElement *tempDefinitions in definitions)
            {
                NSArray *defList = [tempDefinitions elementsForName:@"definitionList"];
                
                for (GDataXMLElement *defListElement in defList)
                {
                    NSArray *arrPos = [defListElement elementsForName:@"pos"];
                    NSArray *arrDef = [defListElement elementsForName:@"definition"];
                    
                    if ([arrPos count] > 1)
                    {
                        for (int i = 0; i < [arrPos count]; i++)
                        {
                            definitionList *deflist = [[definitionList alloc] init];
                            deflist.pos = @"";
                            deflist.definition = @"";
                            
                            if (i < [arrDef count])
                            {
                                GDataXMLElement *def = [arrDef objectAtIndex:i];
                                
                                NSArray *arrChild = [def children];
                                for (GDataXMLElement *child in arrChild)
                                {
                                    if ([[child name] isEqualToString:@"b"])
                                    {
                                        NSString *classVal = [[child attributeForName:@"class"] stringValue];
                                        NSString *styleVal = [[child attributeForName:@"style"] stringValue];
                                        
                                        BOOL extend = YES;
                                        if (classVal)
                                        {
                                            if (classVal.length > 0)
                                            {
                                                extend = NO;
                                            }
                                        }
                                        if (styleVal)
                                        {
                                            if (styleVal.length > 0)
                                            {
                                                extend = NO;
                                            }
                                        }
                                        
                                        [deflist.arrTagB addObject:[child stringValue]];
                                        
                                        if (extend)
                                        {
                                            deflist.definition = [deflist.definition stringByAppendingString:@"<br>"];
                                        }
                                        deflist.definition = [deflist.definition stringByAppendingString:[child stringValue]];
                                        deflist.definition = [deflist.definition stringByAppendingString:@" "];
                                    }
                                    else if ([[child name] isEqualToString:@"i"])
                                    {
                                        [deflist.arrTagI addObject:[child stringValue]];
                                        
                                        deflist.definition = [deflist.definition stringByAppendingString:[child stringValue]];
                                        deflist.definition = [deflist.definition stringByAppendingString:@" "];
                                    }
                                    else if ([[child name] isEqualToString:@"text"])
                                    {
                                        NSString *strText = [child XMLString];
                                        strText = [ResourceDataUtil trimPrefixSpace:strText];
                                        strText = [ResourceDataUtil trimSuffixSpace:strText];
                                        deflist.definition = [deflist.definition stringByAppendingString:strText];
                                        deflist.definition = [deflist.definition stringByAppendingString:@" "];
                                    }
                                    else
                                    {
                                        NSString *strText = [child stringValue];
                                        strText = [ResourceDataUtil trimPrefixSpace:strText];
                                        strText = [ResourceDataUtil trimSuffixSpace:strText];
                                        deflist.definition = [deflist.definition stringByAppendingString:strText];
                                        deflist.definition = [deflist.definition stringByAppendingString:@" "];
                                    }
                                }
                            }
                            
                            deflist.definition = [ResourceDataUtil trimLineWithSpace:deflist.definition];
                            deflist.definition = [deflist.definition stringByReplacingOccurrencesOfString:@"##183;" withString:@"-"];
                            deflist.definition = [deflist.definition stringByReplacingOccurrencesOfString:@"……" withString:@"······"];
                            
                            GDataXMLElement *pos = [arrPos objectAtIndex:i];
                            NSString *strPos = [pos stringValue];
                            deflist.pos = strPos;
                            
                            if (deflist.pos.length > 0 || deflist.definition.length > 0)
                            {
                                [arrDefs addObject:deflist];
                            }
                        }
                    }  // [arrPos count] > 1
                    else
                    {
                        definitionList *deflist = [[definitionList alloc] init];
                        deflist.pos = @"";
                        deflist.definition = @"";
                        deflist.arrTagB = [NSMutableArray array];
                        deflist.arrTagI = [NSMutableArray array];
                        
                        if (arrPos)
                        {
                            GDataXMLElement *pos = [arrPos firstObject];
                            NSString *strPos = [pos stringValue];
                            deflist.pos = strPos;
                        }
                        
                        for (GDataXMLElement *def in arrDef)
                        {
                            NSArray *arrChild = [def children];
                            for (GDataXMLElement *child in arrChild)
                            {
                                if ([[child name] isEqualToString:@"b"])
                                {
                                    NSString *classVal = [[child attributeForName:@"class"] stringValue];
                                    NSString *styleVal = [[child attributeForName:@"style"] stringValue];
                                    
                                    BOOL extend = YES;
                                    if (classVal)
                                    {
                                        if (classVal.length > 0)
                                        {
                                            extend = NO;
                                        }
                                    }
                                    if (styleVal)
                                    {
                                        if (styleVal.length > 0)
                                        {
                                            extend = NO;
                                        }
                                    }
                                    
                                    [deflist.arrTagB addObject:[child stringValue]];
                                    
                                    if (extend)
                                    {
                                        deflist.definition = [deflist.definition stringByAppendingString:@"<br>"];
                                    }
                                    
                                    deflist.definition = [deflist.definition stringByAppendingString:@"<b>"];
                                    deflist.definition = [deflist.definition stringByAppendingString:[child stringValue]];
                                    deflist.definition = [deflist.definition stringByAppendingString:@"</b> "];
                                }
                                else if ([[child name] isEqualToString:@"i"])
                                {
                                    [deflist.arrTagI addObject:[child stringValue]];
                                    
                                    deflist.definition = [deflist.definition stringByAppendingString:@"<i>"];
                                    deflist.definition = [deflist.definition stringByAppendingString:[child stringValue]];
                                    deflist.definition = [deflist.definition stringByAppendingString:@"</i> "];
                                }
                                else if ([[child name] isEqualToString:@"text"])
                                {
                                    NSString *strText = [child XMLString];
                                    strText = [ResourceDataUtil trimPrefixSpace:strText];
                                    strText = [ResourceDataUtil trimSuffixSpace:strText];
                                    deflist.definition = [deflist.definition stringByAppendingString:strText];
                                    deflist.definition = [deflist.definition stringByAppendingString:@" "];
                                }
                                else
                                {
                                    NSString *strText = [child stringValue];
                                    strText = [ResourceDataUtil trimPrefixSpace:strText];
                                    strText = [ResourceDataUtil trimSuffixSpace:strText];
                                    deflist.definition = [deflist.definition stringByAppendingString:strText];
                                    deflist.definition = [deflist.definition stringByAppendingString:@" "];
                                }
                            }
                        }
                        
                        deflist.definition = [ResourceDataUtil trimLineWithSpace:deflist.definition];
                        deflist.definition = [deflist.definition stringByReplacingOccurrencesOfString:@"##183;" withString:@"-"];
                        deflist.definition = [deflist.definition stringByReplacingOccurrencesOfString:@"……" withString:@"······"];
                        
                        if (deflist.pos.length > 0 || deflist.definition.length > 0)
                        {
                            [arrDefs addObject:deflist];
                        }
                    }
                }
            }
            modelWordNode.definitions = arrDefs;
            word.modelWordNode = modelWordNode;
        }
    }
    // end   解析每个word的详细信息 //
    
    return arrNodeWords;
}


@end
