//
//  ConfigGlobal.m
//  iEnglish
//
//  Created by JacobLi on 2/26/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "ConfigGlobal.h"
#import "ModelUser.h"

static ConfigGlobal *instance;

@implementation ConfigGlobal

+ (instancetype)sharedCofigGlobal
{
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        instance = [[ConfigGlobal alloc] init];
        instance.loginUser = [[ModelUser alloc] init];
    });
    return instance;
}
//
//+ (NSString *)loginToken
//{
//    return instance.loginToken;
//}
//
+ (ModelUser *)loginUser
{
    return instance.loginUser;
}

+(void)clearLoginInfo{
    instance.loginUser=nil;
//    instance.loginToken=@"";
}

+ (NSString *)cachePathBooks
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *bookDirPath = [documentsDirectory stringByAppendingPathComponent:@"books"];
    
    return bookDirPath;
}

+ (NSString *)bookCategoryNameWithStr:(NSString *)strCategory
{
    NSString *str = @"";
    if ([strCategory isEqualToString:@"1l"])
    {
        str = Locale(@"小学(一起)");
    }
    else if ([strCategory isEqualToString:@"3l"])
    {
        str = Locale(@"小学(三起)");
    }
    else if ([strCategory isEqualToString:@"jh"])
    {
        str = Locale(@"初中");
    }
    else
    {}
    return str;
}

+ (NSString *)cachePathGrammar
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *bookDirPath = [documentsDirectory stringByAppendingPathComponent:@"grammar"];
    
    return bookDirPath;
}

+ (NSString *)cachePathDict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *bookDirPath = [documentsDirectory stringByAppendingPathComponent:@"dict"];
    
    return bookDirPath;
}

+ (BOOL)grammarDownloaded
{
    NSString *path = [[ConfigGlobal cachePathGrammar] stringByAppendingPathComponent:@"/jh"];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if (contents) {
        return true;
    }
    return false;
}

+ (BOOL)dictDownloaded
{
    NSString *path = [[ConfigGlobal cachePathDict] stringByAppendingPathComponent:@"/word"];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if (contents) {
        return true;
    }
    return false;
}

@end
