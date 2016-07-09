//
//  ListenLayerView.m
//  iEnglish
//
//  Created by JacobLi on 3/31/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "ListenLayerView.h"
#import "ModelClickRead.h"

@implementation ListenLayerView
@synthesize arrResourceBlocks;

- (instancetype)initWithArrDatas:(NSArray *)arr
{
    if (self = [super init])
    {
        arrResourceBlocks = arr;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    for (id v in self.subviews)
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            [v removeFromSuperview];
        }
    }
    
    if (arrResourceBlocks)
    {
        for (int i = 0; i < [arrResourceBlocks count]; i++)
        {
             ModelClickRead *modelRead = [arrResourceBlocks objectAtIndex:i];
            if (modelRead.visible == NO)
            {
                continue;
            }
        
            CGRect rect = CGRectMake(modelRead.startX, modelRead.startY, modelRead.width, modelRead.height);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithRed:0 green:0.5f blue:0.2f alpha:0.6f];
            btn.tag = i;
            btn.frame = rect;
            [btn addTarget:self action:@selector(btnListenAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
}

- (void)btnListenAction:(id)sender
{
    if (arrResourceBlocks)
    {
        int index = (int)[sender tag];
        
        if (index < [arrResourceBlocks count])
        {
            ModelClickRead *modelRead = [arrResourceBlocks objectAtIndex:index];
            
            [Notif postNotificationName:Notif_Play_ListenWord object:modelRead.text];
        }
    }
}

@end
