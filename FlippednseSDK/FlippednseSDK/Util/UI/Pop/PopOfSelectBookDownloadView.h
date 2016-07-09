//
//  ShowPopMenuView.h
//  WaterMan
//
//  Created by baichun on 15/12/30.
//  Copyright © 2015年 baichun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIPopoverListView.h"


@protocol PopViewDelegate <NSObject>

-(void)popDidSlected:(int)selectRow;


@end

@interface PopOfSelectBookDownloadView : NSObject<UIPopoverListViewDataSource, UIPopoverListViewDelegate>
@property (nonatomic,strong)UIPopoverListView *selectImgPopView;
@property (nonatomic,strong)UIView *superView;
@property (nonatomic,strong)id <PopViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title forView:(UIView *)viewSuper delegate:(id<PopViewDelegate>)delegate source:(NSMutableArray *)arraySource;

-(void)showPopView;
@end
