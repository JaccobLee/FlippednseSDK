//
//  AudioPlayerView.m
//  iEnglish
//
//  Created by JacobLi on 4/8/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "AudioPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "ConfigGlobal.h"
#import "UICategory.h"

@interface AudioPlayerView()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *avPlayer;
@property (nonatomic, strong) UISlider      *sliderProgress;
@property (nonatomic, strong) UIView        *viewSliderBg;
@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, strong) UILabel       *lbCurrentTime;
@property (nonatomic, strong) UILabel       *lbTotalTime;

@property (nonatomic, strong) UIButton      *btnPlay;
@property (nonatomic, strong) UIButton      *btnStop;

@end

@implementation AudioPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        _viewSliderBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        _viewSliderBg.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
        [self addSubview:_viewSliderBg];
        
        _sliderProgress = [[UISlider alloc] initWithFrame:CGRectMake(WidthScale(90), HeightScale(25), self.bounds.size.width - WidthScale(180), HeightScale(20))];
        _sliderProgress.minimumValue = 0.0f;
        _sliderProgress.maximumValue = 1.0f;
        [_sliderProgress setValue:0.0f];
        [_sliderProgress addTarget:self action:@selector(sliderProgressEnterDrag) forControlEvents:UIControlEventTouchDown];
        [_sliderProgress addTarget:self action:@selector(sliderProgressExitDrag) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [_sliderProgress setThumbImage:[UIImage imageNamed:@"player_audio_slider_thumbIcon"] forState:UIControlStateNormal];
        [self addSubview:_sliderProgress];
        
        _lbCurrentTime = [UILabel createLabelWithFrame:CGRectMake(0, HeightScale(20), WidthScale(90), HeightScale(30)) backgroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] font:KSystemfont(15) textalignment:NSTextAlignmentCenter text:@"0:00"];
        [self addSubview:_lbCurrentTime];
        
        _lbTotalTime = [UILabel createLabelWithFrame:CGRectMake(self.bounds.size.width - WidthScale(90), HeightScale(20), WidthScale(90), HeightScale(30)) backgroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] font:KSystemfont(15) textalignment:NSTextAlignmentCenter text:@"0:00"];
        [self addSubview:_lbTotalTime];
        
        
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlay.frame = CGRectMake(self.bounds.size.width / 2 - WidthScale(100), HeightScale(65), WidthScale(50), WidthScale(50));
        [_btnPlay setBackgroundImage:[UIImage imageNamed:@"player_audio_pause"] forState:UIControlStateNormal];
        [_btnPlay setBackgroundImage:[UIImage imageNamed:@"player_audio_play"] forState:UIControlStateSelected];
        _btnPlay.backgroundColor = [UIColor clearColor];
        [_btnPlay addTarget:self action:@selector(btnPlayAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnPlay];
        
        
        _btnStop = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnStop.frame = CGRectMake(self.bounds.size.width / 2 + WidthScale(50), HeightScale(65), WidthScale(50), WidthScale(50));
        [_btnStop setBackgroundImage:[UIImage imageNamed:@"player_audio_stop"] forState:UIControlStateNormal];
        _btnStop.backgroundColor = [UIColor clearColor];
        [_btnStop addTarget:self action:@selector(btnStopAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnStop];
    }
    return self;
}


- (void)setPlayPath:(NSString *)filePath
{
    if (_avPlayer)
    {
        [_avPlayer stop];
        _avPlayer = nil;
    }
    
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:filePath];
    //初始化音频类 并且添加播放文件
    _avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //设置代理
    _avPlayer.delegate = self;
    //设置初始音量大小
    // avAudioPlayer.volume = 1;
    //设置音乐播放次数  -1为一直循环
    _avPlayer.numberOfLoops = 0;
    //预播放
    [_avPlayer prepareToPlay];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
    
    _lbTotalTime.text = [self getTimeDescriptionWithSeconds:_avPlayer.duration];
}

- (void)play
{
    [_avPlayer play];
}

- (void)pause
{
    [_avPlayer pause];
}

- (void)stop
{
    [_avPlayer stop];
    _avPlayer = nil;
}

- (void)playProgress
{
    _sliderProgress.value = _avPlayer.currentTime / _avPlayer.duration;
    
    [self resetLabelCurrentTime];
    [self resetPlayButton];
}

//播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    [p stop];
}

/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (!CGRectContainsPoint(_viewSliderBg.frame, touchPoint))
    {
        [_avPlayer stop];
        
        [self removeFromSuperview];
    }
}
 */

- (void)sliderProgressEnterDrag
{
    [_timer invalidate];
    _timer = nil;
    [_avPlayer pause];
    
    [self resetPlayButton];
}

- (void)sliderProgressExitDrag
{
    _avPlayer.currentTime = _sliderProgress.value * _avPlayer.duration;
    
    [self resetLabelCurrentTime];
    
    [_avPlayer play];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];

}

- (void)resetLabelCurrentTime
{
    _lbCurrentTime.text = [self getTimeDescriptionWithSeconds:_avPlayer.currentTime];
}

- (void)resetPlayButton
{
    if (_avPlayer.isPlaying)
    {
        _btnPlay.selected = NO;
    }
    else
    {
        _btnPlay.selected = YES;
    }
}

- (NSString *)getTimeDescriptionWithSeconds:(long)time
{
    NSString *str = @"0:0";
    
    if (time >= 3600)
    {
        int hour = floor(time / 3600);
        int min  = floor((time - hour * 3600)/ 60);
        int sec  = floor(time - hour * 3600 - min * 60);
        
        NSString *strMin = [NSString stringWithFormat:@"%d",min];
        if (min < 10)
        {
            strMin = [NSString stringWithFormat:@"0%d",min];
        }
        else
        {
            strMin = [NSString stringWithFormat:@"%d",min];
        }

        
        NSString *strSec = [NSString stringWithFormat:@"%d",sec];
        if (sec < 10)
        {
            strSec = [NSString stringWithFormat:@"0%d",sec];
        }

        
        str = [NSString stringWithFormat:@"%d:%@:%@",hour,strMin,strSec];
        return str;
    }
    else
    {
        int min = floor(time / 60);
        int sec = floor(time - 60 * min);
        
        NSString *strSec = [NSString stringWithFormat:@"%d",sec];
        if (sec < 10)
        {
            strSec = [NSString stringWithFormat:@"0%d",sec];
        }
        
        str = [NSString stringWithFormat:@"%d:%@",min,strSec];
        return str;
    }
    
    return str;
}

#pragma mark -- Actions
- (void)btnPlayAction:(id)sender
{
    UIButton *btn = sender;
    
    btn.selected = !btn.selected;
    
    if (btn.selected)
    {
        [_avPlayer pause];
    }
    else if (!btn.selected)
    {
        [_avPlayer play];
    }
    
     [self resetPlayButton];
}

- (void)btnStopAction:(id)sender
{
    [_avPlayer stop];
    [self removeFromSuperview];
}

@end
