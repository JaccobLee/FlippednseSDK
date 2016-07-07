//
//  PopDownloadProgressView.h
//  iEnglish
//
//  Created by JacobLi on 4/28/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopDownloadProgressViewDelegate <NSObject>

- (void)downLoadTaskPause;
- (void)restartDownLoadTask;
- (void)downLoadTaskCancel;

@end

@interface PopDownloadProgressView : UIView
{
    __weak id<PopDownloadProgressViewDelegate> delegate;
}

@property (nonatomic, weak) id<PopDownloadProgressViewDelegate> delegate;

- (void)setProgressWithCurrentByte:(int)cb  withTotalByte:(int)tb;
- (void)layoutViewWithTitle:(NSString *)title;

@end
