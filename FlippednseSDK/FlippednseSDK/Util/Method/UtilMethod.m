//
//  UtilMethod.m
//  iEnglish
//
//  Created by JacobLi on 3/2/16.
//  Copyright © 2016 jxb. All rights reserved.
//

//#import <AdSupport/ASIdentifierManager.h>
#import "UtilMethod.h"
#import "FlippednseHeader.h"
#import "NSDictionary+safeObjectForKeyValue.h"
#import "NSString+AES.h"
#import "ConfigGlobal.h"
#import "ConfigNetwork.h"

NSMutableDictionary *AddSignWithRequestParameters(NSDictionary *dic)
{
    NSArray *arrSortKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSMutableDictionary *dicResult = [NSMutableDictionary dictionary];
    NSString *str = @"";
    for (int i = 0; i < [arrSortKeys count]; i++)
    {
        NSString *key = [arrSortKeys objectAtIndex:i];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key, [dic safeObjectForKey:key]]];
        
        [dicResult setObject:[dic safeObjectForKey:key] forKey:key];
    }
    str = [str stringByAppendingString:APP_Secret];
    str = [str MD5String];
    
    [dicResult setObject:str forKey:@"sign"];
    
    return dicResult;
}

NSString *SignWithRequestParameters(NSDictionary *dic)
{
    NSArray *arrSortKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSString *str = @"";
    for (int i = 0; i < [arrSortKeys count]; i++)
    {
        NSString *key = [arrSortKeys objectAtIndex:i];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key, [dic safeObjectForKey:key]]];
        
    }
    str = [str stringByAppendingString:APP_Secret];
    str = [str MD5String];
    return str;
}

NSString *StringValueIn100FromInt(int i)
{
    NSString *str = @"0";
    if (i < 10)
    {
        str = [NSString stringWithFormat:@"00%d",i];
    }
    else if (i >= 10 && i < 100)
    {
        str = [NSString stringWithFormat:@"0%d",i];
    }
    else
    {
        str = [NSString stringWithFormat:@"%d",i];
    }
    return str;
}

@implementation UtilMethod

+(CGFloat)getHeightWithWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size.height;
}
+(CGFloat)getWidthWithHeight:(CGFloat)height text:(NSString *)text font:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size.width;
}

+(NSString *)deviceUUId{
    //　　identifierForVendor对供应商来说是唯一的一个值，也就是说，由同一个公司发行的的app在相同的设备上运行的时候都会有这个相同的标识符。然而，如果用户删除了这个供应商的app然后再重新安装的话，这个标识符就会不一致。
//    return  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return [UtilMethod deviceOnlyOriginalUUId];
}

static NSString * const KEY_IN_KEYCHAIN_ORIGIN_APPINFO = @"com.ienglish.app.appinfo";
static NSString * const KEY_ORIGIN_UUID = @"com.ienglish.app.orginalUUID";

+(NSString *)deviceOnlyOriginalUUId{
    
    NSMutableDictionary *dict_UUID = (NSMutableDictionary *)[UtilMethod load:KEY_IN_KEYCHAIN_ORIGIN_APPINFO];
    if (!dict_UUID || [trimOfNoNullStr([dict_UUID objectForKey:KEY_ORIGIN_UUID]) isEqualToString:@""]) {
        dict_UUID= [NSMutableDictionary dictionary];
        NSString *appUUID=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [dict_UUID setObject:appUUID forKey:KEY_ORIGIN_UUID];
        [UtilMethod save:KEY_IN_KEYCHAIN_ORIGIN_APPINFO data:dict_UUID];
    }
    return [dict_UUID objectForKey:KEY_ORIGIN_UUID];
    
//    [self delete:KEY_IN_KEYCHAIN];

}

+(NSString *)deviceType
{
    NSString *modelOfDevice= [UIDevice currentDevice].model;
    return modelOfDevice;
}

+(BOOL)deviceIsIphone{
    NSString *modelOfDevice= [UIDevice currentDevice].model;
    if ([modelOfDevice rangeOfString:@"iPhone"].length>0) {
        return YES;
    }
    return NO;
}


#pragma mark ===keychain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
