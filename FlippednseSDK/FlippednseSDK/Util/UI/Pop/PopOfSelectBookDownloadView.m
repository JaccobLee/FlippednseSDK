//
//  ShowPopMenuView.m
//  WaterMan
//
//  Created by baichun on 15/12/30.
//  Copyright © 2015年 baichun. All rights reserved.
//

#import "PopOfSelectBookDownloadView.h"


@interface PopOfSelectBookDownloadView ()
@property(nonatomic,strong)NSMutableArray *array_PopMenu_title;
//@property(nonatomic,strong)NSMutableArray *array_PopMenu_Img;

@end

@implementation PopOfSelectBookDownloadView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title forView:(UIView *)viewSuper delegate:(id<PopViewDelegate>)delegate source:(NSMutableArray *)arraySource
{
    self = [super init];
    if (self) {
        _superView=viewSuper;
        _delegate = delegate;
        
        _array_PopMenu_title=arraySource;

        CGFloat yHeight=[_array_PopMenu_title count]>6?SCREEN_ADAPTER_HEIGHT(264, 264):32+SCREEN_ADAPTER_HEIGHT(44, 44)*[_array_PopMenu_title count];

        if (!title||[title isEqualToString:@""]) {
            yHeight-=32;
        }
        
        _selectImgPopView = [[UIPopoverListView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, yHeight)];
        _selectImgPopView.delegate = self;
        _selectImgPopView.datasource = self;
        _selectImgPopView.listView.separatorInset= UIEdgeInsetsMake(0,SCREEN_ADAPTER_WIDTH(8, 8), 0, 0);
        _selectImgPopView.listView.scrollEnabled = [_array_PopMenu_title count]>6?YES:NO;
        _selectImgPopView.listView.separatorColor = [UIColor colorSeparateLine];
        [_selectImgPopView setTitle:title];
        
    }
    return self;
}


-(void)showPopView{
    [_selectImgPopView show];
    
}


#pragma mark - UIPopoverListViewDataSource
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
    
    cell.backgroundColor = [UIColor whiteColor];
//    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"聊天_更多_按下"]];
//    cell.imageView.image = [UIImage imageNamed:_array_PopMenu_Img[indexPath.row]];
    cell.textLabel.font = SYSTEM_FONT_(15);
    cell.textLabel.textColor = [UIColor colorFontDark];
    cell.textLabel.text = _array_PopMenu_title[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section{
    return [_array_PopMenu_title count];
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath{
    if (_delegate&&[_delegate respondsToSelector:@selector(popDidSlected:)]) {
        [_delegate popDidSlected:(int)indexPath.row];
    }
}
- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_ADAPTER_HEIGHT(44, 44);
}

@end
