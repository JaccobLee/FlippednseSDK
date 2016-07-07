//
//  PlayerUtil.m
//  iEnglish
//
//  Created by JacobLi on 4/1/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "PlayerUtil.h"
#import <AVFoundation/AVFoundation.h>

static PlayerUtil *player;

@interface PlayerUtil()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *avPlayer;

@end

@implementation PlayerUtil

+ (instancetype)sharedPlayer
{
    if (!player)
    {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            player = [[self alloc] init];
        });
    }
    return player;
}

- (void)setPlayPath:(NSString *)filePath
{
    if (player.avPlayer)
    {
        [player.avPlayer stop];
        player.avPlayer = nil;
    }
    
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:filePath];
    //初始化音频类 并且添加播放文件
    player.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //设置代理
    player.avPlayer.delegate = player;
    //设置初始音量大小
    // avAudioPlayer.volume = 1;
    //设置音乐播放次数  -1为一直循环
    player.avPlayer.numberOfLoops = 0;
    //预播放
    [player.avPlayer prepareToPlay];
}

- (void)play
{
   [player.avPlayer play];
}

- (void)pause
{
    [player.avPlayer pause];
}

- (void)stop
{
   [player.avPlayer stop];
    player.avPlayer = nil;
}

//播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    [p stop];
}

@end
