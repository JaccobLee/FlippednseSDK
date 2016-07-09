//
//  EncryptUtil.m
//  ienglish
//
//  Created by xhw on 15/12/24.
//  Copyright © 2015年 JXB. All rights reserved.
//

#import "EncryptUtil.h"
#import <CommonCrypto/CommonDigest.h>
 #import<CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "ConfigGlobal.h"

@implementation EncryptUtil

+ (NSString *)md5_32:(NSString *)input
{
    if(!isValidStr(input))
    {
        return nil;
    }
    NSInteger length = 16;
    const char* original_str=[input UTF8String];
    unsigned char digist[length];
    CC_MD5(original_str, (uint32_t)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<length;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];
    }
    
    return [outPutStr lowercaseString];
}


+ (NSString *)md5_16:(NSString *)input
{
    if(!isValidStr(input))
    {
        return nil;
    }
    NSInteger length = 16;
    const char* original_str=[input UTF8String];
    unsigned char digist[length];
    CC_MD5(original_str, (uint32_t)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =4; i<length - 4;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];
    }
    
    return [outPutStr lowercaseString];
}

static NSString *key = @"LmMGStGtOpF4xNyvYt54EQ==";

+ (NSString *)encryptWithText:(NSString *)sText
{
    if(!isValidStr(sText))
    {
        return nil;
    }
    //kCCEncrypt 加密
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:@"LmMGStGt" initIv:@"OpF4xNyv"];
}

+ (NSString *)decryptWithText:(NSString *)sText
{
    if(!isValidStr(sText))
    {
        return nil;
    }
    //kCCDecrypt 解密
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:@"LmMGStGt" initIv:@"OpF4xNyv"];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key initIv:(NSString *)initIv
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
//    const void *vkey = (const void *) [key UTF8String];
    Byte vkey[] = {46, 99, 6, 74, -47, -83, 58, -111};
//    const void *iv = (const void *) [initIv UTF8String];
    Byte iv[] = {120, -60, -36, -81, 98, -34, 120, 17};

    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        NSMutableData *data = [NSMutableData dataWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved]];
        [data replaceBytesInRange:NSMakeRange(0, 16) withBytes:NULL length:0];
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return result;
}

@end
