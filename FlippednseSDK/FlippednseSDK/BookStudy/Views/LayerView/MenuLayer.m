//
//  MenuLayer.m
//  iEnglish
//
//  Created by JacobLi on 4/13/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "MenuLayer.h"
#import "ModelContentMenus.h"
#import "KxMenu.h"
#import "ModelBookStore.h"
#import "UtilsBook.h"

@interface MenuLayer ()

@property (nonatomic, strong) NSMutableArray *arrActions;

@end

@implementation MenuLayer
@synthesize arrResourceMenus;

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
    
    if (arrResourceMenus)
    {
        NSMutableArray *arrTemp = [NSMutableArray array];
        
        for (int i = 0; i < [arrResourceMenus count]; i++)
        {
            ModelContentMenus *modelMenu = [arrResourceMenus objectAtIndex:i];
            
            if (!([modelMenu.item count] > 0))
            {
                continue;
            }
            
            CGRect rect = CGRectMake(modelMenu.x * _scale + _rectFit.origin.x - WidthScale(35), modelMenu.y * _scale + _rectFit.origin.y - 10, HeightScale(60), HeightScale(60));
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = i;
            btn.frame = rect;
            btn.userInteractionEnabled = YES;
            [btn setBackgroundImage:[UIImage imageNamed:@"bookstudy_btn_menu"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnMenuAction:) forControlEvents:UIControlEventTouchUpInside];
            [arrTemp addObject:btn];
        }
        
        [_arrCtrlsSource addObjectsFromArray:arrTemp];
    }
}

- (void)btnMenuAction:(id)sender
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

    if (arrResourceMenus)
    {
        int index = (int)[sender tag];
        
        if (index < [arrResourceMenus count])
        {
            ModelContentMenus *modelMenu = [arrResourceMenus objectAtIndex:index];
            
            if (_arrActions) 
            {
                [_arrActions removeAllObjects];
                _arrActions = nil;
            }
            
            _arrActions = [NSMutableArray array];
            
            for (ModelContentMenuAction *action in modelMenu.item)
            {
                if ([action.action isEqualToString:MenuActionTypePlayAudio] || [action.action isEqualToString:MenuActionTypePlayFlash] || [action.action isEqualToString:MenuActionTypeShowText])
                {
                    [_arrActions addObject:action];
                    
                    continue;
                }
            }
            
            if ([_arrActions count] > 0)
            {
                [self showMenu:sender];
            }
        }
    }
}

- (NSString *)getActionNameWithStr:(NSString *)s
{
    NSString *str = s;
    if ([str isEqualToString:@"播放录音"])
    {
        str = Locale(@"听录音");
    }
    else if ([str isEqualToString:@"播放动画"])
    {
        str = Locale(@"看动画");
    }
    
    return str;
}

- (void)showMenu:(UIButton *)sender
{
    NSMutableArray *menuItems = [NSMutableArray array];
    
    for (ModelContentMenuAction *action in _arrActions)
    {
        NSString *actionName = [self getActionNameWithStr:(action.name)];
        
        KxMenuItem *item = [KxMenuItem menuItem:actionName image:nil target:self action:@selector(actionPlay:) actionType:action.action filePath:action.filePath];
        [menuItems addObject:item];
    }
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor whiteColor];
    first.alignment = NSTextAlignmentLeft;
    
    [KxMenu showMenuInView:_parentView
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)actionPlay:(id)sender
{
    KxMenuItem *item = sender;
    if ([item.actionType isEqualToString:MenuActionTypePlayAudio])
    {
        [Notif postNotificationName:Notif_Play_Audio object:item.filePath];
    }
    else if ([item.actionType isEqualToString:MenuActionTypePlayFlash])
    {
        [Notif postNotificationName:Notif_Play_Video object:item.filePath];
    }
    else if ([item.actionType isEqualToString:MenuActionTypeShowText])
    {
        [Notif postNotificationName:Notif_Play_ShowText object:item.filePath];
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
    
    [KxMenu dismissMenu];
}


@end
