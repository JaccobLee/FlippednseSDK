//
//  PopTextView.h
//  iEnglish
//
//  Created by JacobLi on 4/14/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface PopTextView : UIView

@property (nonatomic, strong) NSString  *content;

- (void)layoutView;

@end
