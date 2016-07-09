//
//  PopDownloadProgressView.m
//  iEnglish
//
//  Created by JacobLi on 4/28/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "PopDownloadProgressView.h"

@interface PopDownloadProgressView ()

@property (nonatomic, strong) UIProgressView   *progressView;
@property (nonatomic, strong) UILabel       *lbTitle;
@property (nonatomic, strong) UILabel       *lbPercent;
@property (nonatomic, strong) UIButton      *btnPlay;
@property (nonatomic, strong) UIButton      *btnStop;
@property (nonatomic, strong) UIView        *bgView;
@property (nonatomic, strong) UIActivityIndicatorView   *indicatorView;

@end

@implementation PopDownloadProgressView
@synthesize delegate;

- (void)layoutViewWithTitle:(NSString *)title
{
    CGFloat offsetHeight = 0;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - WidthScale(250), HeightScale(220))];
    _bgView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    _bgView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _bgView.layer.cornerRadius = 5.0f;
    [self addSubview:_bgView];
    
    offsetHeight += HeightScale(30);
    
    _lbTitle = [UILabel createLabelWithFrame:CGRectMake(WidthScale(30), offsetHeight, _bgView.frame.size.width - WidthScale(60), HeightScale(50)) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:title];
    _lbTitle.numberOfLines = 0;
    [_lbTitle sizeToFit];
    [_bgView addSubview:_lbTitle];
    
    offsetHeight += _lbTitle.frame.size.height + HeightScale(18);
    
    _lbPercent = [UILabel createLabelWithFrame:CGRectMake(_bgView.frame.size.width - WidthScale(30 + 150), offsetHeight, WidthScale(150), HeightScale(17)) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15) textalignment:NSTextAlignmentCenter text:@"0M / 0M"];
    _lbPercent.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_lbPercent];
    
    offsetHeight += HeightScale(15 + 5);
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(WidthScale(30), offsetHeight, _bgView.frame.size.width - WidthScale(60), HeightScale(20))];
    _progressView.progressTintColor = [UIColor greenColor];
    _progressView.trackTintColor = [UIColor lightGrayColor];
    _progressView.progressViewStyle = UIProgressViewStyleBar;
    _progressView.userInteractionEnabled = NO;
    [_bgView addSubview:_progressView];
    

    offsetHeight += HeightScale(20) + HeightScale(20);
    
    _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPlay.frame = CGRectMake(_bgView.frame.size.width / 2 - WidthScale(120), offsetHeight, WidthScale(90), HeightScale(45));
    [_btnPlay setTitle:Locale(@"暂停") forState:UIControlStateNormal];
    [_btnPlay setTitle:Locale(@"继续") forState:UIControlStateSelected];
    [_btnPlay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal | UIControlStateSelected];
    _btnPlay.backgroundColor = [UIColor colorWithHex:0x2185d5 alpha:1.0f];
    _btnPlay.layer.cornerRadius = 5.0f;
    [_btnPlay addTarget:self action:@selector(btnPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnPlay.titleLabel.font = KSystemfont(15);
    [_bgView addSubview:_btnPlay];
    
    
    _btnStop = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStop.frame = CGRectMake(_bgView.frame.size.width / 2 + WidthScale(40), offsetHeight, WidthScale(90), HeightScale(45));
    [_btnStop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStop setTitle:Locale(@"取消") forState:UIControlStateNormal];
    _btnStop.layer.cornerRadius = 5.0f;
    _btnStop.backgroundColor = [UIColor lightGrayColor];
    [_btnStop addTarget:self action:@selector(btnStopAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnStop.titleLabel.font = KSystemfont(15);
    [_bgView addSubview:_btnStop];
}

- (void)setProgressWithCurrentByte:(int)cb  withTotalByte:(int)tb
{
    if (tb > 0)
    {
        CGFloat percent = cb * 1.0f / tb * 1.0f;
        int totalMB = ceil(tb * 1.0f / 1024 / 1024);
        int currentMB = ceil(cb * 1.0f / 1024 / 1024);
        
        [_progressView setProgress:percent animated:NO];
        _lbPercent.text = [NSString stringWithFormat:@"%dM / %dM",currentMB, totalMB];
        
        if (percent >= 1.0)
        {
            if (!_indicatorView)
            {
                [self showIndicatorView];
            }
        }

    }
}

- (void)showIndicatorView
{
    if (_progressView)
    {
        [_progressView removeFromSuperview];
    }
    if (_btnPlay)
    {
        [_btnPlay removeFromSuperview];
    }
    if (_btnStop)
    {
        [_btnStop removeFromSuperview];
    }
    if (_lbPercent)
    {
        [_lbPercent removeFromSuperview];
    }
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _indicatorView.center = CGPointMake(_bgView.frame.size.width / 2, _bgView.frame.size.height / 2);
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_bgView addSubview:_indicatorView];
    
    [_indicatorView startAnimating];
    
    UILabel *lbStatus = [UILabel createLabelWithFrame:CGRectMake(0, 0, 100, HeightScale(140)) backgroundColor:[UIColor clearColor] textColor:[UIColor grayColor] font:KSystemfont(15) textalignment:NSTextAlignmentCenter text:Locale(@"解压中")];
    lbStatus.center = CGPointMake(_bgView.frame.size.width / 2, _bgView.frame.size.height / 2);
    [_bgView addSubview:lbStatus];
}

- (void)btnPlayAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected)
    {
        if (delegate && [delegate respondsToSelector:@selector(downLoadTaskPause)])
        {
            [delegate downLoadTaskPause];
        }
    }
    else
    {
        if (delegate && [delegate respondsToSelector:@selector(downLoadTaskResume)]) {
            [delegate restartDownLoadTask];
        }
    }
}

- (void)btnStopAction:(UIButton *)btn
{
    if (delegate && [delegate respondsToSelector:@selector(downLoadTaskCancel)])
    {
        [delegate downLoadTaskCancel];
    }
}

@end
