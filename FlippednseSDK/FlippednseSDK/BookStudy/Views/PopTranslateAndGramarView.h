//
//  PopTranslateAndGramarView.h
//  iEnglish
//
//  Created by JacobLi on 5/3/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopTranslateAndGramarView : UIView

- (CGSize)layoutViewWithContentStr:(NSString *)str withContentViewFrame:(CGRect)rect;
- (void)relayoutContentViewWithFrame:(CGRect)frame;

@end
