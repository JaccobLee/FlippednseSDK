//
//  SelectModuleView.h
//  iEnglish
//
//  Created by JacobLi on 5/30/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@protocol SelectModuleViewDelegate <NSObject>

- (void)selectModuleViewAtPageIndex:(int)page;

@end

@interface SelectModuleView : UIView
{
    __weak id<SelectModuleViewDelegate> delegate;
}

@property (nonatomic, assign) BOOL  isShowing;
@property (nonatomic, weak) id<SelectModuleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withModuleList:(NSArray *)moduleList;
- (void)layoutView;

@end
