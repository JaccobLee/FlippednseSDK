//
//  LanguageLayer.m
//  iEnglish
//
//  Created by JacobLi on 4/15/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "LanguageLayer.h"
#import "ModelClickRead.h"
#import "ModelBookStore.h"
#import "UtilsBook.h"

@implementation LanguageLayer
@synthesize arrResourceBlocks;

- (void)setParentView:(UIView *)parentView
{
    _parentView = parentView;
}

- (void)loadSource
{
    if (!_arrCtrlsSource)
    {
        _arrCtrlsSource = [NSMutableArray array];
    }
    
    [_arrCtrlsSource removeAllObjects];
    
    if (arrResourceBlocks)
    {
        NSMutableArray *arrTemp = [NSMutableArray array];
        for (int i = 0; i < [arrResourceBlocks count]; i++)
        {
            __weak ModelTranslate *modelRead = [arrResourceBlocks objectAtIndex:i];
            
            CGRect rect = CGRectMake(modelRead.x * _scale + _rectFit.origin.x, modelRead.y * _scale + _rectFit.origin.y, modelRead.width * _scale, modelRead.height * _scale);
            
            modelRead.sizeFitX = _rectFit.origin.x;
            modelRead.sizeFitY = _rectFit.origin.y;
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithHex:0x66c400fd alpha:0.3f];
            btn.tag = i;
            btn.frame = rect;
            [btn addTarget:self action:@selector(btnTranslateAction:) forControlEvents:UIControlEventTouchUpInside];
            [arrTemp addObject:btn];
        }
        
        [_arrCtrlsSource addObjectsFromArray:arrTemp];
    }
}

- (void)btnTranslateAction:(id)sender
{
    if ([_modelBookStudy needBuyBook])
    {
        [Notif postNotificationName:Notif_Need_Buy_Book object:nil];
        return;
    }
    
    if ([UtilsBook checkTheBookIsExpiredWithBookCode:_modelBookStudy.bookEid])
    {
        if (![_modelBookStudy.currentModule isEqualToString:@"MODULE 1"])
        {
            [Notif postNotificationName:Notif_Need_ReBuy_Book object:nil];
            return;
        }
    }
    
    if ([_modelBookStudy.arrDownloadableModules containsObject:_modelBookStudy.currentModuleUnit])
    {
        NSArray *arrResult = [ModelBookRecordOfDownloadUnit selectByPropertyMaps:@{@"bookId":_modelBookStudy.bookId,@"moduleName":_modelBookStudy.currentModuleUnit}];
        if ([arrResult count] == 0)
        {
            [Notif postNotificationName:Notif_Need_DownLoad_Module object:nil];
            return;
        }
    }
    
    
    if ([arrResourceBlocks count] > 0)
    {
        int index = (int)[sender tag];
        
        if (index < [arrResourceBlocks count])
        {
            ModelTranslate *modelTranslate = [arrResourceBlocks objectAtIndex:index];
            
            [Notif postNotificationName:Notif_Play_Gramar object:modelTranslate];
        }
    }
}

- (void)addCtrls
{
    if (!_parentView)
    {
        return;
    }
    
    for (UIButton *btn in _arrCtrlsSource)
    {
        [_parentView addSubview:btn];
    }
}

- (void)clearCtrls
{
    for (UIButton *btn in _arrCtrlsSource)
    {
        [btn removeFromSuperview];
    }
}



@end
