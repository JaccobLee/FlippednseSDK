//
//  ImageBrowerView.h
//  TestForImageBrowser
//
//  Created by xhw on 15/12/4.
//  Copyright © 2015年 JXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookStudyViewModel.h"
#import "BookStudyTabBarView.h"
#import "ImageShowView.h"
#import "BaseView.h"

typedef NS_ENUM(NSInteger, ImgLocation) {
    ImgLocationLeft,
    ImgLocationCenter,
    ImgLocationRight,
};


@protocol ImageBrowerViewDelegate <NSObject>

- (void)browerViewSelectedAtIndex:(int)index;

@end

@interface ImageBrowerView : UIScrollView<UIScrollViewDelegate>
{
    NSDictionary* _imgShowViewDic;   // 展示板组
    CGFloat scale;
    
    __weak id<ImageBrowerViewDelegate> imageBrowerViewDelegate;
}

@property (nonatomic, weak) id<ImageBrowerViewDelegate>  imageBrowerViewDelegate;

@property(nonatomic ,assign)NSInteger curIndex;     // 当前显示图片在数据源中的下标

@property(nonatomic ,retain)NSMutableArray *imgSource;

@property(nonatomic ,readonly)ImgLocation imgLocation;    // 图片在空间中的位置

@property (nonatomic, weak) BookStudyViewModel  *modelBookStudy;
@property (nonatomic, assign) BookStudyTabBarSelectType type;
@property (nonatomic, assign) CGFloat   scale;

- (id)initWithFrame:(CGRect)frame withSourceData:(BookStudyViewModel *)model withIndex:(NSInteger)index;
- (void)selectLayerType:(BookStudyTabBarSelectType)type;
- (void)displayPageCurIndex:(int)index;
- (ImageShowView *)getDisplayCenterView;

- (void)showReadLayer;
- (void)showMenusLayer;
- (void)showTranslateLayer;
- (void)showWordLayer;
- (void)showLanguageLayer;

- (void)dismissReadLayer;
- (void)dismissMenusLayer;
- (void)dismissTranslateLayer;
- (void)dismissWordLayer;
- (void)dismissLanguageLayer;

@end
