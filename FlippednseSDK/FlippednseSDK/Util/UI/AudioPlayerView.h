//
//  AudioPlayerView.h
//  iEnglish
//
//  Created by JacobLi on 4/8/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AudioPlayerView : UIView

- (void)setPlayPath:(NSString *)filePath;
- (void)play;
- (void)stop;

@end
