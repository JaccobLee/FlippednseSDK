//
//  ImageShowView.h
//  TestForImageBrowser
//
//  Created by xhw on 15/12/4.
//  Copyright © 2015年 JXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListenLayer.h"
#import "MenuLayer.h"
#import "TranslateLayer.h"
#import "LanguageLayer.h"
#import "WordLayer.h"
#import "BookStudyViewModel.h"

@interface ImageShowView : UIScrollView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *_imageView;
    
    CGRect imageFitRect;
}

@property (nonatomic, weak) BookStudyViewModel  *modelBookStudy;

@property (nonatomic, strong) ListenLayer       *listenLayer;
@property (nonatomic, strong) MenuLayer         *menuLayer;
@property (nonatomic, strong) TranslateLayer    *translateLayer;
@property (nonatomic, strong) LanguageLayer     *languageLayer;
@property (nonatomic, strong) WordLayer         *wordLayer;

@property (nonatomic, strong) NSArray  *arrListenBlocks;
@property (nonatomic, strong) NSArray  *arrMenus;
@property (nonatomic, strong) NSArray  *arrTranslates;
@property (nonatomic, strong) NSArray  *arrLanguage;
@property (nonatomic, strong) NSArray  *arrWords;

@property (nonatomic, assign) CGFloat   scale;

- (void)setImage:(UIImage *)image;


- (void)addListenLayer;
- (void)dismissListenLayer;
- (void)addMenuLayer;
- (void)dismissMenuLayer;
- (void)addTranslateLayer;
- (void)dismissTranslateLayer;
- (void)addLanguageLayer;
- (void)dismissLanguageLayer;
- (void)addWordLayer;
- (void)dismissWordLayer;

@end
