//
//  PopWordView.h
//  iEnglish
//
//  Created by JacobLi on 4/21/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelWordNode.h"
#import "BaseView.h"

@interface PopWordView : UIView

@property (nonatomic, weak) ModelWordNode   *model;

- (void)layoutView;
- (void)addView;

@end
