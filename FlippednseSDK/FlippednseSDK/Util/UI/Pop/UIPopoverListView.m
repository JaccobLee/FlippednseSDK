//
//  UIPopoverListView.m
//  UIPopoverListViewDemo
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "UIPopoverListView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Hex.h"

//#define FRAME_X_INSET 20.0f
//#define FRAME_Y_INSET 40.0f

@interface UIPopoverListView ()

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end

@implementation UIPopoverListView

@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

@synthesize listView = _listView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defalutInit];
    }
    return self;
}

- (void)defalutInit
{
//    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    self.layer.borderWidth = 1.0f;
//    self.layer.cornerRadius = 10.0f;
//    self.clipsToBounds = TRUE;
    
    _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleView.font = [UIFont systemFontOfSize:17.0f];
//    _titleView.backgroundColor = [UIColor colorWithRed:59./255.
//                                                 green:89./255.
//                                                  blue:152./255.
//                                                 alpha:1.0f];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.textColor = [UIColor colorFontDark];
    CGFloat xWidth = self.bounds.size.width;
       _titleView.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleView.frame = CGRectMake(0, 0, xWidth, 32.0f);
    [self addSubview:_titleView];
    
    CGRect tableFrame = CGRectMake(0, 32.0f, xWidth, self.bounds.size.height-32.0f);
    _listView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _listView.dataSource = self;
    _listView.delegate = self;
    if ([self.listView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.listView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.listView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self addSubview:_listView];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor clearColor];

    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(popoverListView:numberOfRowsInSection:)])
    {
        return [self.datasource popoverListView:self numberOfRowsInSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(popoverListView:cellForIndexPath:)])
    {
        return [self.datasource popoverListView:self cellForIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(popoverListView:heightForRowAtIndexPath:)])
    {
        return [self.delegate popoverListView:self heightForRowAtIndexPath:indexPath];
    }
    
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(popoverListView:didSelectIndexPath:)])
    {
        [self.delegate popoverListView:self didSelectIndexPath:indexPath];
    }
    
    [self dismiss];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - animations

- (void)fadeIn
{
//    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
//    self.alpha = 0;
//    [UIView animateWithDuration:.35 animations:^{
//        self.alpha = 1;
//        self.transform = CGAffineTransformMakeScale(1, 1);
//    }];
//    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
//    self.alpha = 0;
//    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
//    }];
}
- (void)fadeOut
{
//    [UIView animateWithDuration:.35 animations:^{
//        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
////        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        self.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
//        }
//    }];
}

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
    if (!title||[title isEqualToString:@""]) {
        _titleView.hidden=YES;
        _listView.frame=CGRectMake(_listView.frame.origin.x, 0.0f, _listView.frame.size.width,self.bounds.size.height);
    }
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
//    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
//                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(fadeOutAction)]) {
        [self.delegate fadeOutAction];
    }
}

#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListViewCancel:)]) {
        [self.delegate popoverListViewCancel:self];
    }
    
    // dismiss self
    [self dismiss];
}



//
// draw round rect corner
//
/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [_fillColor CGColor]);
    CGContextSetStrokeColorWithColor(c, [_borderColor CGColor]);

    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, 10.0f, 10.0f);
    CGContextFillPath(c);

    CGContextSetLineWidth(c, 1.0f);
    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, 10.0f, 10.0f);
    CGContextStrokePath(c);
}


static void addRoundedRectToPath(CGContextRef context, CGRect rect,
								 float ovalWidth,float ovalHeight)

{
    float fw, fh;

    if (ovalWidth == 0 || ovalHeight == 0) {// 1
        CGContextAddRect(context, rect);
        return;
    }

    CGContextSaveGState(context);// 2

    CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
						   CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
    fw = CGRectGetWidth (rect) / ovalWidth;// 5
    fh = CGRectGetHeight (rect) / ovalHeight;// 6

    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context);// 12

    CGContextRestoreGState(context);// 13
}
*/

@end
