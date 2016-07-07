//
//  SDTransparentPieProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-20.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDTransparentPieProgressView.h"

@implementation SDTransparentPieProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - SDProgressViewItemMargin;
    
    // 背景遮罩
//    [SDProgressViewBackgroundColor set];
    
//    CGFloat lineW = MAX(rect.size.width, rect.size.height) * 0.5;
//    CGContextSetLineWidth(ctx, lineW);
//    CGContextAddArc(ctx, xCenter, yCenter, radius + lineW * 0.5 + 5, 0, M_PI * 2, 1);
//    CGContextStrokePath(ctx);
    
    // 进程圆
    [SDColorMaker(0, 255, 0, 0.8) set];
    CGContextSetLineWidth(ctx, 1);
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, yCenter - radius);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, radius,- M_PI * 0.5, to, 0);
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
    
    
    // 进度数字
    NSString *progressStr = [NSString stringWithFormat:@"%.0f%s", self.progress * 100, "\%"];
    if (self.progress >= 1.0)
    {
        progressStr = Locale(@"解压中");
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:18 * SDProgressViewFontScale];
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    [self setCenterProgressText:progressStr withAttributes:attributes];
}

@end
