//
//  BaseViewController.h
//  iEnglish
//
//  Created by JacobLi on 2/24/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setStanderNavBar;
- (void)setStanderBackButton;

- (void)backAction;

- (void)setRightStanderImgButton:(NSString *)imgStr selectImg:(NSString *)selectImgStr withSel:(SEL)method;

@end
