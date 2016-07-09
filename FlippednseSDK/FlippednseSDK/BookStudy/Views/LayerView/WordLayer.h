//
//  WordLayer.h
//  iEnglish
//
//  Created by JacobLi on 4/19/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookStudyViewModel.h"
#import "BaseView.h"

@interface WordLayer : NSObject
{
    NSArray *arrResourceBlocks;
}

@property (nonatomic, weak) BookStudyViewModel  *modelBookStudy;

@property (nonatomic, strong) NSArray       *arrResourceBlocks;
@property (nonatomic, assign) CGFloat       scale;
@property (nonatomic, assign) CGRect        rectFit;
@property (nonatomic, strong) NSMutableArray       *arrCtrlsSource;


@property (nonatomic, weak)   UIView        *parentView;

- (void)loadSource;
- (void)addCtrls;
- (void)clearCtrls;

@end
