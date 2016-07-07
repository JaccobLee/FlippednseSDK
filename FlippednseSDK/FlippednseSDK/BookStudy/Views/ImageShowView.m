//
//  ImageShowView.m
//  TestForImageBrowser
//
//  Created by xhw on 15/12/4.
//  Copyright © 2015年 JXB. All rights reserved.
//

#import "ImageShowView.h"

#define kImgZoomScaleMin 1
#define kImgZoomScaleMax 2

@implementation ImageShowView

//- (void)drawRect:(CGRect)rect
//{
//
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.canCancelContentTouches = YES;
        self.delaysContentTouches = YES;
        // 添加双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapClick:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        
        self.maximumZoomScale = kImgZoomScaleMax;
        self.minimumZoomScale = kImgZoomScaleMin;
        // 设置代理
        self.delegate = self;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
    
    imageFitRect = [self rectThatFits];
}

//获取图片显示区域，子层都贴在真实图片上，这样方便坐标计算
- (CGRect)rectThatFits
{
    CGSize imageSize = CGSizeMake(_imageView.image.size.width / _imageView.image.scale,
                                  _imageView.image.size.height / _imageView.image.scale);
    
    CGFloat widthRatio = imageSize.width / _imageView.frame.size.width;
    CGFloat heightRatio = imageSize.height / _imageView.frame.size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    CGFloat x = (_imageView.frame.size.width - imageSize.width)/2.0;
    CGFloat y = (_imageView.frame.size.height - imageSize.height)/2.0;

    return CGRectMake(x, y, imageSize.width, imageSize.height);
}

#pragma mark 按钮事
- (void)addListenLayer
{
    if (_arrListenBlocks)
    {
        if (!_listenLayer)
        {
            _listenLayer = [[ListenLayer alloc] init];
            _listenLayer.scale = _scale;
            _listenLayer.rectFit = imageFitRect;
        }
    }
    
    [_listenLayer clearCtrls];
    
    _listenLayer.arrResourceBlocks = _arrListenBlocks;
    _listenLayer.parentView = _imageView;
    _listenLayer.modelBookStudy = _modelBookStudy;
    [_listenLayer loadSource];
    [_listenLayer addCtrls];
}

- (void)dismissListenLayer
{
    if (_listenLayer)
    {
        [_listenLayer clearCtrls];
    }
}

- (void)addMenuLayer
{
    if (_arrMenus)
    {
        if (!_menuLayer)
        {
            _menuLayer = [[MenuLayer alloc] init];
            _menuLayer.scale = _scale;
            _menuLayer.rectFit = imageFitRect;
        }
    }
    
    [_menuLayer clearCtrls];
    _menuLayer.arrResourceMenus = _arrMenus;
    _menuLayer.parentView = _imageView;
    _menuLayer.modelBookStudy = _modelBookStudy;
    [_menuLayer loadSource];
    [_menuLayer addCtrls];
}

- (void)dismissMenuLayer
{
    if (_menuLayer)
    {
        [_menuLayer clearCtrls];
    }
}

- (void)addTranslateLayer
{
    if (_arrTranslates)
    {
        if (!_translateLayer)
        {
            _translateLayer = [[TranslateLayer alloc] init];
            _translateLayer.scale = _scale;
            _translateLayer.rectFit = imageFitRect;
        }
    }
    
    [_translateLayer clearCtrls];
    
    _translateLayer.arrResourceBlocks = [NSMutableArray arrayWithArray:_arrTranslates];
    _translateLayer.parentView = _imageView;
    _translateLayer.modelBookStudy = _modelBookStudy;
    [_translateLayer loadSource];
    [_translateLayer addCtrls];
}

- (void)dismissTranslateLayer
{
    if (_translateLayer)
    {
        [_translateLayer clearCtrls];
    }
}

- (void)addLanguageLayer
{
    if (_arrLanguage)
    {
        if (!_languageLayer)
        {
            _languageLayer = [[LanguageLayer alloc] init];
            _languageLayer.scale = _scale;
            _languageLayer.rectFit = imageFitRect;
        }
    }
    
    [_languageLayer clearCtrls];
    
    _languageLayer.arrResourceBlocks = _arrLanguage;
    _languageLayer.parentView = _imageView;
    _languageLayer.modelBookStudy = _modelBookStudy;
    [_languageLayer loadSource];
    [_languageLayer addCtrls];
}

- (void)dismissLanguageLayer
{
    if (_languageLayer)
    {
        [_languageLayer clearCtrls];
    }
}

- (void)addWordLayer
{
    if (_arrWords)
    {
        if (!_wordLayer)
        {
            _wordLayer = [[WordLayer alloc] init];
            _wordLayer.scale = _scale;
            _wordLayer.rectFit = imageFitRect;
        }
    }
    
    [_wordLayer clearCtrls];
    
    _wordLayer.arrResourceBlocks = _arrWords;
    _wordLayer.parentView = _imageView;
    _wordLayer.modelBookStudy = _modelBookStudy;
    [_wordLayer loadSource];
    [_wordLayer addCtrls];
}

- (void)dismissWordLayer
{
    if (_wordLayer)
    {
        [_wordLayer clearCtrls];
    }
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    [Notif postNotificationName:Notif_Hide_PopView object:nil];
    return _imageView;
}


#pragma mark -Tap手势处
- (void)doubleTapClick:(UITapGestureRecognizer *)tap{
    //判断当前放大的比例
    if (self.zoomScale > kImgZoomScaleMin) {
        //缩小
        [self setZoomScale:kImgZoomScaleMin animated:YES];
    }else{
        //放大
        CGPoint location = [tap locationInView:self];
        
        [self setZoomScale:kImgZoomScaleMax animated:NO];
        location.x *= kImgZoomScaleMax;
        location.y *= kImgZoomScaleMax;
        
        //点击位置居中
        location.x -= self.frame.size.width/2.0;
        if(location.x < 0.0)
        {
            location.x = 0.0;
        }
        else if ((location.x + self.frame.size.width) > self.contentSize.width)
        {
            location.x = self.contentSize.width - self.frame.size.width;
        }
        
        location.y -= self.frame.size.height/2.0;
        if(location.y < 0.0)
        {
            location.y = 0.0;
        }
        else if ((location.y + self.frame.size.height) > self.contentSize.height)
        {
            location.y = self.contentSize.height - self.frame.size.height;
        }
        [self setContentOffset:location animated:YES];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.scrollEnabled = YES;
}

@end
