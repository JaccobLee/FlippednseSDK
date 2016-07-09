//
//  UtilsBook.m
//  iEnglish
//
//  Created by 陈梦悦 on 16/6/1.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import "UtilsBook.h"
#import "ModelUser.h"
#import "ModelBookInfo.h"
#import "NSDate+Category.h"
#import "NetworkService+Books.h"

#define State_expired_books    @"bookOfExpiredState"
@implementation UtilsBook

+(BOOL)checkTheBookIsExpiredWithBookCode:(NSString *)code{
    int userId=[ConfigGlobal loginUser].userId;
    if (!userId) {
        return NO;
    }
    NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:State_expired_books];
    if (!dict || ![dict objectForKey:code]) {
        return NO;

    }
    return [[dict objectForKey:code] boolValue];

}

+(void)checkTheBookIsExpiredWithBookCode:(NSString *)code resultExpired:(void (^)(BOOL bookIsExpired))result{
    int userId=[ConfigGlobal loginUser].userId;
    if (!userId) {
        result(NO);
        return;
    }
    NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:State_expired_books];
    if (!dict || ![dict objectForKey:code]) {
        result(NO);
        return;
    }
    result([[dict objectForKey:code] boolValue]);
    
   
    
//    [NetworkService requestBooksWithDeadlineWithUserId:userId withSuccess:^(id responseObject) {
//        NSMutableArray *arraySheme=[NSMutableArray arrayWithArray:responseObject];
//        
//        if ([trimOfNoNullStr(code) isEqualToString:@""]|| ![arraySheme count]) {
//            result(NO);
//
//            return;
//        }
//        BOOL isExpired=NO;
//        for ( ModelBookSchema *sheme in arraySheme) {
//            if ([code isEqualToString:sheme.book_eid]) {
//                isExpired=[UtilsBook compareTimeIsAfter:sheme.deadline];
//
//                break;
//            }
//        }
//        result(isExpired);
//
//    } failure:^(NSError *error) {
//        result(NO);
//
//    }];
//    
    
}


+(void)clearBookExpiredState{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:State_expired_books];

//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    [defaults setObject:[NSMutableDictionary dictionary] forKey:State_expired_books];
//    [defaults synchronize];
}



//-(void)loadFiredTimeRequest{
//    int userId=[ConfigGlobal loginUser].userId;
//    if (!userId) {
//        return;
//    }
//    [NetworkService requestBooksWithDeadlineWithUserId:userId withSuccess:^(id responseObject) {
//        if ([responseObject isKindOfClass:[NSArray class]]) {
//            _arrayBookScheme=[NSMutableArray arrayWithArray:responseObject];
//        }
//        
//        [self resetBookExpires];
//    } failure:^(NSError *error) {
//        [self resetBookExpires];
//        
//    }];
//}
//
//-(void)resetBookExpires{
//    if (![_arrayBooksData count] || ![_arrayBookScheme count]) {
//        return;
//    }
//    
//    for ( ModelBookSchema *sheme in _arrayBookScheme) {
//        for (int i=0; i<[_arrayBooksData count]; i++) {
//            UserBookShelfOnLocal *localBook=_arrayBooksData[i];
//            if ([localBook.bookCode isEqualToString:sheme.book_eid]) {
//                localBook.isFailureTime=[UtilsBook compareTimeIsAfter:sheme.deadline];
//                
//            }
//        }
//    }
//}

+(void)resetLocalBookStateOfExpired:(NSMutableArray *)arraySheme{
    NSMutableDictionary *dictOfExpired=[NSMutableDictionary dictionary];
    for ( ModelBookSchema *sheme in arraySheme) {
        BOOL isExpired=[UtilsBook compareTimeIsAfter:sheme.deadline];
        if ([dictOfExpired objectForKey:sheme.book_eid]) {
            
            int hasSavedValue=[[dictOfExpired objectForKey:sheme.book_eid] intValue];
            if ((hasSavedValue+isExpired)==1) {
                [dictOfExpired setObject:[NSNumber numberWithBool:NO] forKey:sheme.book_eid];
            }
            
            continue;
        }
        [dictOfExpired setObject:[NSNumber numberWithBool:isExpired] forKey:sheme.book_eid];
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:dictOfExpired forKey:State_expired_books];
    [defaults synchronize];

}

+(void)requestBookExpiredState{
    int userId=[ConfigGlobal loginUser].userId;
    if (!userId) {
        [self clearBookExpiredState];
        return;
    }
    [NetworkService requestBooksWithDeadlineWithUserId:userId withSuccess:^(id responseObject) {
        NSMutableArray *arraySheme=[NSMutableArray arrayWithArray:responseObject];
        [self resetLocalBookStateOfExpired:arraySheme];
    } failure:^(NSError *error) {
        
    }];
    

}


+(BOOL)compareTimeIsAfter:(NSString *)compareTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr=[formatter stringFromDate:[NSDate date]];
    NSDate *curDate=[formatter dateFromString:currentDateStr];
    
    NSDate *compareDate=[formatter dateFromString:compareTime];
    
    return [curDate isLaterThanDate:compareDate];
}



@end
