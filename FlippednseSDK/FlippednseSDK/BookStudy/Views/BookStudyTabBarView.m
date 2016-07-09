//
//  BookStudyTabBarView.m
//  iEnglish
//
//  Created by JacobLi on 4/14/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "BookStudyTabBarView.h"

#define MarginSide      50

@interface BookStudyTabBarView ()

@property (nonatomic, strong) NSMutableArray        *arrCtrls;

@end

@implementation BookStudyTabBarView
@synthesize delegate;

- (void)layoutView
{
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    _arrCtrls = [NSMutableArray array];
    
    if (_type == 0)
    {
        [self layoutViewSchool];    // 小学
    }
    else
    {
        [self layoutViewJunior];    // 初中
    }
}

- (void)layoutViewSchool
{
    for (int i = 0; i < 3; i++)
    {
        UIControl *ctrl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, WidthScale(120), HeightScale(50))];
        ctrl.backgroundColor = [UIColor clearColor];
        ctrl.tag = i;
        ctrl.center = CGPointMake(self.bounds.size.width / 4 * (i + 1), self.bounds.size.height / 2);
        [self addSubview:ctrl];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScale(30), HeightScale(25))];
        icon.center = CGPointMake(ctrl.frame.size.width / 2, HeightScale(13));
        [ctrl addSubview:icon];
        
        UILabel     *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ctrl.frame.size.width, HeightScale(22))];
        lbTitle.font = KSystemfont(15);
        lbTitle.textColor = [UIColor grayColor];
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.center = CGPointMake(ctrl.frame.size.width / 2, ctrl.frame.size.height - HeightScale(11));
        [ctrl addSubview:lbTitle];
        
        
        switch (i)
        {
            case 0:
            {
                lbTitle.text = Locale(@"点读模式");
                icon.image = [UIImage imageNamed:@"bookstudy_btn_read"];
                [ctrl addTarget:self action:@selector(btnReadClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 1:
            {
                lbTitle.text = Locale(@"辅助翻译");
                icon.image = [UIImage imageNamed:@"bookstudy_btn_translate"];
                [ctrl addTarget:self action:@selector(btnTranslateClick:) forControlEvents:UIControlEventTouchUpInside];
               
            }
                break;
            case 2:
            {
                lbTitle.text = Locale(@"重点词汇");
                icon.image = [UIImage imageNamed:@"bookstudy_btn_word"];
                [ctrl addTarget:self action:@selector(btnWordClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
                break;
        }
        
        [_arrCtrls addObject:ctrl];
        
        [self btnReadClick:nil];
    }
}

- (void)layoutViewJunior
{
    for (int i = 0; i < 4; i++)
    {
        UIControl *ctrl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, WidthScale(120), HeightScale(50))];
        ctrl.backgroundColor = [UIColor clearColor];
        ctrl.tag = i;
        ctrl.center = CGPointMake(self.bounds.size.width / 5 * (i + 1), self.bounds.size.height / 2);
        [self addSubview:ctrl];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScale(30), HeightScale(25))];
        icon.center = CGPointMake(ctrl.frame.size.width / 2, HeightScale(13));
        [ctrl addSubview:icon];
        
        UILabel     *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ctrl.frame.size.width, HeightScale(22))];
        lbTitle.font = KSystemfont(15);
        lbTitle.textColor = [UIColor grayColor];
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.center = CGPointMake(ctrl.frame.size.width / 2, ctrl.frame.size.height - HeightScale(11));
        [ctrl addSubview:lbTitle];
        
        
        switch (i)
        {
            case 0:
            {
                lbTitle.text = Locale(@"点读模式");
                icon.image = [UIImage imageNamed:@"bookstudy_btn_read"];
                [ctrl addTarget:self action:@selector(btnReadClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 1:
            {
                lbTitle.text = Locale(@"辅助翻译");
                icon.image = [UIImage imageNamed:@"bookstudy_btn_translate"];
                [ctrl addTarget:self action:@selector(btnTranslateClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }
                break;
            case 2:
            {
                lbTitle.text = Locale(@"重点词汇");
                icon.image = [UIImage imageNamed:@"bookstudy_btn_word"];
                [ctrl addTarget:self action:@selector(btnWordClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 3:
            {
                lbTitle.text = Locale(@"语言知识");
                icon.image = [UIImage imageNamed:@"bookstudy_btn_language"];
                [ctrl addTarget:self action:@selector(btnLanguageClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
                break;
        }
        
        [_arrCtrls addObject:ctrl];
        
        [self btnReadClick:nil];
    }
}

- (void)resetCtrlsWithSelectedType:(BookStudyTabBarSelectType)t
{
    for (UIControl *ctrl in _arrCtrls)
    {
        for (id temp in ctrl.subviews)
        {
            if ([temp isKindOfClass:[UILabel class]])
            {
                UILabel *lb = temp;
                lb.textColor = [UIColor grayColor];
                
                if (ctrl.tag == t)
                {
                    lb.textColor = [UIColor blueColor];
                }
            }
            if ([temp isKindOfClass:[UIImageView class]])
            {
                UIImageView *icon = temp;
                switch (ctrl.tag)
                {
                    case 0:
                    {
                        icon.image = [UIImage imageNamed:@"bookstudy_btn_read"];
                        
                        if (t == 0)
                        {
                            icon.image = [UIImage imageNamed:@"bookstudy_btn_read_selected"];
                        }
                    }
                        break;
                    case 1:
                    {
                        icon.image = [UIImage imageNamed:@"bookstudy_btn_translate"];
                        
                        if (t == 1)
                        {
                            icon.image = [UIImage imageNamed:@"bookstudy_btn_translate_selected"];
                        }
                        
                    }
                        break;
                    case 2:
                    {
                        icon.image = [UIImage imageNamed:@"bookstudy_btn_word"];
                        if (t == 2)
                        {
                            icon.image = [UIImage imageNamed:@"bookstudy_btn_word_selected"];
                        }
                    }
                        break;
                    case 3:
                    {
                        icon.image = [UIImage imageNamed:@"bookstudy_btn_language"];
                        if (t == 3)
                        {
                            icon.image = [UIImage imageNamed:@"bookstudy_btn_language_selected"];
                        }
                    }
                        break;
                    default:
                        break;
                }

            }
        }
    }
}


#pragma mark -- Actions
- (void)btnReadClick:(id)sender
{
    [self resetCtrlsWithSelectedType:BookStudyTabBarSelectType_read];
    
    if (delegate && [delegate respondsToSelector:@selector(selectTabbarType:)])
    {
        [delegate selectTabbarType:BookStudyTabBarSelectType_read];
    }
}

- (void)btnTranslateClick:(id)sender
{
    [self resetCtrlsWithSelectedType:BookStudyTabBarSelectType_translate];
    
    if (delegate && [delegate respondsToSelector:@selector(selectTabbarType:)])
    {
        [delegate selectTabbarType:BookStudyTabBarSelectType_translate];
    }
}

- (void)btnWordClick:(id)sender
{
    [self resetCtrlsWithSelectedType:BookStudyTabBarSelectType_word];
    
    if (delegate && [delegate respondsToSelector:@selector(selectTabbarType:)])
    {
        [delegate selectTabbarType:BookStudyTabBarSelectType_word];
    }
}

- (void)btnLanguageClick:(id)sender
{
    [self resetCtrlsWithSelectedType:BookStudyTabBarSelectType_language];
    
    if (delegate && [delegate respondsToSelector:@selector(selectTabbarType:)])
    {
        [delegate selectTabbarType:BookStudyTabBarSelectType_language];
    }
}

@end
