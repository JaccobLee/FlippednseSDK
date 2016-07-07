//
//  ListenLayer.m
//  iEnglish
//
//  Created by JacobLi on 4/11/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "ListenLayer.h"
#import "ModelClickRead.h"
#import "ModelBookStore.h"
#import "UtilsBook.h"

@implementation ListenLayer
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
            ModelClickRead *modelRead = [arrResourceBlocks objectAtIndex:i];
            if (modelRead.visible == NO)
            {
                continue;
            }
            
            CGRect rect = CGRectMake( modelRead.startX * _scale + _rectFit.origin.x, modelRead.startY * _scale +  _rectFit.origin.y, modelRead.width * _scale, modelRead.height * _scale);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithHex:0x6644A6FF alpha:0.5];
            btn.tag = i;
            btn.frame = rect;
            [btn addTarget:self action:@selector(btnListenAction:) forControlEvents:UIControlEventTouchUpInside];
            [arrTemp addObject:btn];
        }
        
        [_arrCtrlsSource addObjectsFromArray:arrTemp];
    }
}

- (void)btnListenAction:(id)sender
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
        
        for (UIButton *btn in _arrCtrlsSource)
        {
            btn.backgroundColor = [UIColor colorWithHex:0x6644A6FF alpha:0.5f];
            
            if (btn.tag == index)
            {
                btn.backgroundColor = [UIColor colorWithHex:0xFF7256 alpha:0.3f];
            }
        }
        
        if (index < [arrResourceBlocks count])
        {
            ModelClickRead *modelRead = [arrResourceBlocks objectAtIndex:index];

            [Notif postNotificationName:Notif_Play_ListenWord object:modelRead.filePath];
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
