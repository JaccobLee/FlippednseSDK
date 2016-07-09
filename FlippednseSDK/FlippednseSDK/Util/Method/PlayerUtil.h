//
//  PlayerUtil.h
//  iEnglish
//
//  Created by JacobLi on 4/1/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerUtil : NSObject

+ (instancetype)sharedPlayer;
- (void)setPlayPath:(NSString *)filePath;
- (void)play;
- (void)pause;
- (void)stop;

@end
