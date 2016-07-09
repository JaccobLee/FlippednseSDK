//
//  ImageBrowerView.m
//  TestForImageBrowser
//
//  Created by xhw on 15/12/4.
//  Copyright © 2015年 JXB. All rights reserved.
//

#import "ImageBrowerView.h"

#pragma mark -定义宏常量
#define kImgViewCount 3

#define kImgZoomScaleMin 1
#define kImgZoomScaleMax 2

#pragma mark -定义展示板
#define kImgVLeft (ImageShowView *)[_imgShowViewDic valueForKey:@"imgLeft"]
#define kImgVCenter (ImageShowView *)[_imgShowViewDic valueForKey:@"imgCenter"]
#define kImgVRight (ImageShowView *)[_imgShowViewDic valueForKey:@"imgRight"]

@implementation ImageBrowerView
@synthesize scale;
@synthesize imageBrowerViewDelegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame withSourceData:(BookStudyViewModel *)model withIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置数据源
        _modelBookStudy = model;
        [self setImgSource:_modelBookStudy.arrPaths];
        
        // 初始化控件属性
        [self initScrollView];
        
        // 设置图片下标
        _curIndex = 0;
        [self setCurIndex:index];
        
        [self setConSize];
    }
    return self;
}

#pragma mark -属性
// 展示板尺寸设置
- (void)setConSize{
    
    CGSize size = self.frame.size;
    
    //设置内容视图的大小--单页填充、横向划动
    self.contentSize = CGSizeMake(size.width * kImgViewCount, size.height);
    
    // 设置显示页
    [self setContentOffset:CGPointMake(size.width, 0)];
}

- (void)setCurIndex:(NSInteger)curIndex{
    
    if (_imgSource.count > curIndex && curIndex >= 0) {
        _curIndex = curIndex;
    } else if (curIndex == -1){
        _curIndex = _imgSource.count - 1;
    } else if (curIndex == _imgSource.count){
        _curIndex = 0;
    }
    
    if (_imgSource.count) {
        [self setAllImgVContentFromImage:[self imgListFromIndex:_curIndex] withIndex:_curIndex];
    }
    
    if (imageBrowerViewDelegate && [imageBrowerViewDelegate respondsToSelector:@selector(browerViewSelectedAtIndex:)])
    {
        [imageBrowerViewDelegate browerViewSelectedAtIndex:(int)_curIndex];
    }
}

- (void)displayPageCurIndex:(int)index
{
    _curIndex = index;
    [self setCurIndex:_curIndex];
    
    [kImgVCenter setZoomScale:kImgZoomScaleMin];
}

#pragma mark -数据切换

// 载入一组图片
- (void)setAllImgVContentFromImage:(NSArray *)imgList withIndex:(NSInteger)index
{
    
    // 将所有imgList中的数据载入展示板
    ImageShowView *vLift = kImgVLeft;
    ImageShowView *vCenter = kImgVCenter;
    ImageShowView *vRight = kImgVRight;
    
    if (imgList.count) {
        [vLift setImage:imgList[ImgLocationLeft]];
        [vCenter setImage:imgList[ImgLocationCenter]];
        [vRight setImage:imgList[ImgLocationRight]];
        
        
        _modelBookStudy.currentPage = 0;
        _modelBookStudy.currentModule = @"";
        _modelBookStudy.currentModuleUnit = @"";
        _modelBookStudy.currentUnit = @"";
        
        vCenter.arrListenBlocks = nil;
        vCenter.arrMenus = nil;
        vCenter.arrTranslates = nil;
        vCenter.arrLanguage = nil;
        vCenter.arrWords = nil;
        
        _modelBookStudy.lastReadPage = (int)index;
        
        if (index - _modelBookStudy.countCovers - 1 > 0)
        {
            int indexPage = (int)(index - _modelBookStudy.countCovers);
            
            _modelBookStudy.currentPage = (int)index - _modelBookStudy.countCovers;
            _modelBookStudy.currentUnit = [_modelBookStudy getUnitNameWithPageIndex:indexPage];
            _modelBookStudy.currentModule = [_modelBookStudy getModuleNameWithPageIndex:indexPage];
            _modelBookStudy.currentModuleUnit = [_modelBookStudy getModuleUnitNameWithPageIndex:indexPage];
            
            vCenter.arrListenBlocks = [_modelBookStudy getBlockInfosWithContentPageIndex:indexPage];
            vCenter.arrMenus = [_modelBookStudy getMenusWithContentPageIndex:indexPage];
            vCenter.arrTranslates = [_modelBookStudy getTranslateWithContentPageIndex:indexPage];
            vCenter.arrLanguage = [_modelBookStudy getGrammarWithContentPageIndex:indexPage];
//            vCenter.arrWords = [_modelBookStudy  getWordsWithContentPageIndex:indexPage];
            vCenter.arrWords = [_modelBookStudy getNewWordsWithContentPageIndex:indexPage];
            
            vCenter.modelBookStudy = _modelBookStudy;
        }
        
        [self showMenusLayer];
        
        switch (_type)
        {
            case BookStudyTabBarSelectType_read:
                [self showReadLayer];
                break;
            case BookStudyTabBarSelectType_translate:
                [self showTranslateLayer];
                break;
            case BookStudyTabBarSelectType_word:
                [self showWordLayer];
                break;
            case BookStudyTabBarSelectType_language:
                [self showLanguageLayer];
                break;
            default:
                break;
        }
    }
}

- (NSArray *)imgListFromIndex:(NSInteger)curIndex{
    
    long sCount = _imgSource.count;
    NSArray *imgList;
    
    NSString *imgL;
    NSString *imgC;
    NSString *imgR;
    
    if (sCount) {
        
        // 首位
        if (curIndex == 0) {
            imgL = [_imgSource lastObject];
            imgC = _imgSource[curIndex];
            long nextIndex = curIndex == sCount - 1 ? curIndex : curIndex + 1;
            imgR = _imgSource[nextIndex];
            // 末位
        } else if (curIndex == sCount - 1){
            long lastIndex = curIndex == 0 ? curIndex : curIndex - 1;
            imgL = _imgSource[lastIndex] ;
            imgC = [_imgSource lastObject];
            imgR = _imgSource[0];
            // 中间
        } else {
            imgL = _imgSource[curIndex - 1];
            imgC = _imgSource[curIndex];
            imgR = _imgSource[curIndex + 1];
        }
        
        UIImage *imageLeft = [UIImage imageWithContentsOfFile:imgL];
        if (!imageLeft)
        {
            imageLeft = [UIImage imageNamed:@"login_password"];
        }
        UIImage *imageCenter = [UIImage imageWithContentsOfFile:imgC];
        if (!imageCenter)
        {
            imageCenter = [UIImage imageNamed:@"login_password"];
        }
        UIImage *imageRight = [UIImage imageWithContentsOfFile:imgR];
        if (!imageRight)
        {
            imageRight = [UIImage imageNamed:@"login_password"];
        }
        
        imgList = [[NSArray alloc] initWithObjects:imageLeft, imageCenter, imageRight, nil];
    }
    
    return imgList;
}

#pragma mark -显示按钮
- (void)showReadLayer
{
    [kImgVCenter addListenLayer];
}

- (void)dismissReadLayer
{
    [kImgVCenter dismissListenLayer];
}

- (void)showMenusLayer
{
    [kImgVCenter addMenuLayer];
}

- (void)dismissMenusLayer
{
    [kImgVCenter dismissMenuLayer];
}

- (void)showTranslateLayer
{
    [kImgVCenter addTranslateLayer];
}

- (void)dismissTranslateLayer
{
    [kImgVCenter dismissTranslateLayer];
}

- (void)showWordLayer
{
    [kImgVCenter addWordLayer];
}

- (void)dismissWordLayer
{
    [kImgVCenter dismissWordLayer];
}

- (void)showLanguageLayer
{
    [kImgVCenter addLanguageLayer];
}

- (void)dismissLanguageLayer
{
    [kImgVCenter dismissLanguageLayer];
}


#pragma mark -初始化控件
- (void)initScrollView{
    
    // 设置代理
    self.delegate = self;
    
    // 不显示滚动条
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.canCancelContentTouches = YES;
    self.delaysContentTouches = NO;
    // 设置分页显示
    self.pagingEnabled = YES;
    
    //设置背景颜色
    self.backgroundColor = [UIColor clearColor];
    
    // 构建展示组
    [self initImgShowViewDic];
}


// 初始化展示板组
- (void)initImgShowViewDic{    
    ImageShowView *imgLeft = [self creatImageShowViewWithLocation:ImgLocationLeft];
    
    ImageShowView *imgCenter =[self creatImageShowViewWithLocation:ImgLocationCenter];

    ImageShowView *imgRight = [self creatImageShowViewWithLocation:ImgLocationRight];
    
    _imgShowViewDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                   imgLeft, @"imgLeft",
                   imgCenter, @"imgCenter",
                   imgRight, @"imgRight", nil];
    
    // 放入展示板
    [self addSubview:imgLeft];
    [self addSubview:imgCenter];
    [self addSubview:imgRight];
}

// 通过创建展示板
- (ImageShowView *)creatImageShowViewWithLocation:(ImgLocation)imgLocation{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    ImageShowView *imgShowView = [[ImageShowView alloc] initWithFrame:CGRectMake(width * imgLocation, 0, width, height)];
    imgShowView.image = nil;
    
    imgShowView.scale = (_modelBookStudy.modelXml.width / width < _modelBookStudy.modelXml.height / height) ? 1/(_modelBookStudy.modelXml.width / width) :  1/(_modelBookStudy.modelXml.height / height);
    scale = imgShowView.scale;
    
    return imgShowView;
}

- (ImageShowView *)getDisplayCenterView
{
    if (kImgVCenter)
    {
        return kImgVCenter;
    }
    
    return nil;
}

#pragma mark -- Layer
- (void)selectLayerType:(BookStudyTabBarSelectType)type
{
    _type = type;
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [Notif postNotificationName:Notif_Hide_PopView object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self == scrollView) {
        CGFloat width = self.frame.size.width;
        int currentOffset = scrollView.contentOffset.x/width - 1;
        [self setCurIndex:_curIndex + currentOffset];
        [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        [kImgVCenter setZoomScale:kImgZoomScaleMin];
        
        
        [Notif postNotificationName:Notif_Hide_PopView object:nil];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.scrollEnabled = YES;
}
@end
