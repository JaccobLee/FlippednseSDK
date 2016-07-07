//
//  SelectModuleView.m
//  iEnglish
//
//  Created by JacobLi on 5/30/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "SelectModuleView.h"
#import "ModelBookInfo.h"

#define RowHeight  36

@interface SelectModuleView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView   *tbModules;
@property (nonatomic, strong) NSArray       *arrModuleList;

@end

@implementation SelectModuleView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame withModuleList:(NSArray *)moduleList
{
    if (self = [super initWithFrame:frame])
    {
        _arrModuleList = [NSArray arrayWithArray:moduleList];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [[self layer] setShadowOffset:CGSizeMake(1, 1)];
        [[self layer] setShadowOpacity:1];
        [[self layer] setShadowColor:[UIColor blackColor].CGColor];
     
        [[self layer] setBorderWidth:1];
        [[self layer] setBorderColor:[UIColor whiteColor].CGColor];
    }
    
    return self;
}

- (void)layoutView
{
    [self becomeFirstResponder];
    
    UILabel *lbTitle = [UILabel createLabelWithFrame:CGRectMake(self.frame.size.width / 2 - 100, 0, 200, RowHeight - 1) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentCenter text:Locale(@"目录")];
    [self addSubview:lbTitle];
    
    UIView *vTopline = [[UIView alloc] initWithFrame:CGRectMake(0, RowHeight - 1, self.frame.size.width, 1)];
    vTopline.backgroundColor = [UIColor colorFontDark];
    [self addSubview:vTopline];
    
    _tbModules = [[UITableView alloc] initWithFrame:CGRectMake(20, RowHeight + 10, SCREEN_WIDTH - 40, self.frame.size.height - RowHeight - 10 - 20) style:UITableViewStylePlain];
    _tbModules.dataSource = self;
    _tbModules.delegate = self;
    _tbModules.backgroundColor = [UIColor clearColor];
    _tbModules.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbModules.layer.borderColor = [UIColor colorFontMiddle].CGColor;
    _tbModules.layer.borderWidth = 1.0f;
    _tbModules.rowHeight = RowHeight;
    _tbModules.userInteractionEnabled = YES;
    [_tbModules setAllowsSelection:YES];
    [self addSubview:_tbModules];
}

#pragma mark -- tableView datasource And delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return RowHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < [_arrModuleList count])
    {
        ModelBookModuleInfo *moduleInfo = [_arrModuleList objectAtIndex:section];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RowHeight)];
        v.backgroundColor = [UIColor whiteColor];
        
        if (section > 0)
        {
            UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5f, v.frame.size.width, 1)];
            vLine.backgroundColor = [UIColor colorFontLight];
            [v addSubview:vLine];
        }
        
        UILabel *lbModule = [UILabel createLabelWithFrame:CGRectMake(10, 0, v.frame.size.width - 20, v.frame.size.height) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0) textalignment:NSTextAlignmentLeft text:moduleInfo.name];
        [v addSubview:lbModule];
        
        UIButton *btnModule = [UIButton buttonWithType:UIButtonTypeCustom];
        btnModule.frame = CGRectMake(0, 0, v.frame.size.width, RowHeight);
        btnModule.backgroundColor = [UIColor clearColor];
        btnModule.tag = section;
        [btnModule addTarget:self action:@selector(btnModuleSelect:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btnModule];
        
        return v;
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < [_arrModuleList count])
    {
        ModelBookModuleInfo *moduleInfo = [_arrModuleList objectAtIndex:section];
        
        if (moduleInfo.units)
        {
            return [moduleInfo.units count];
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        
        
    }
    
    for (UIView *v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section < [_arrModuleList count])
    {
        ModelBookModuleInfo *moduleInfo = [_arrModuleList objectAtIndex:indexPath.section];
        
        if (moduleInfo.units)
        {
            if (indexPath.row < [moduleInfo.units count])
            {
                UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 1)];
                vLine.backgroundColor = [UIColor colorFontLight];
                [cell.contentView addSubview:vLine];
                
                ModelBookUnitInfo *unit = [moduleInfo.units objectAtIndex:indexPath.row];
                
                NSString *strUnitName = unit.name;
                if (unit.title)
                {
                    if (unit.title.length > 0)
                    {
                        strUnitName = [NSString stringWithFormat:@"%@ - ",strUnitName];
                    }
                }
                
                UILabel *lbName = [UILabel createLabelWithFrame:CGRectMake(20, 11, 100, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontMiddle] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:[NSString stringWithFormat:@"%@",strUnitName]];
                [lbName sizeToFit];
                [cell.contentView addSubview:lbName];
                
                if (unit.title)
                {
                    if (unit.title.length > 0)
                    {
                        UILabel *lbContent = [UILabel createLabelWithFrame:CGRectMake(lbName.frame.origin.x + lbName.frame.size.width, 0, SCREEN_WIDTH - 40 - 20 - (lbName.frame.origin.x + lbName.frame.size.width), RowHeight) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontMiddle] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:[NSString stringWithFormat:@"%@",unit.title]];
                        lbContent.numberOfLines = 2;
                        lbContent.lineBreakMode = NSLineBreakByTruncatingTail;
                        [cell.contentView addSubview:lbContent];
                    }
                }
                
                UIButton *btnUnit = [UIButton buttonWithType:UIButtonTypeCustom];
                btnUnit.frame = CGRectMake(0, 0, SCREEN_WIDTH, RowHeight);
                btnUnit.backgroundColor = [UIColor clearColor];
                btnUnit.tag = indexPath.section * 1000 + indexPath.row;
                [btnUnit addTarget:self action:@selector(btnUnitSelect:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btnUnit];
            }
            
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arrModuleList count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section < [_arrModuleList count])
    {
        ModelBookModuleInfo *moduleInfo = [_arrModuleList objectAtIndex:indexPath.section];
        
        if (moduleInfo.units)
        {
            if (indexPath.row < [moduleInfo.units count])
            {
                ModelBookUnitInfo *unit = [moduleInfo.units objectAtIndex:indexPath.row];
                
                if (delegate && [delegate respondsToSelector:@selector(selectModuleViewAtPageIndex:)])
                {
                    [delegate selectModuleViewAtPageIndex:unit.startPage];
                }
            }
        }
    }
}

- (void)btnModuleSelect:(UIButton *)btn
{
    if (btn.tag < [_arrModuleList count])
    {
        ModelBookModuleInfo *moduleInfo = [_arrModuleList objectAtIndex:btn.tag];
        
        if (delegate && [delegate respondsToSelector:@selector(selectModuleViewAtPageIndex:)])
        {
            [delegate selectModuleViewAtPageIndex:moduleInfo.startPage];
        }
    }
}

- (void)btnUnitSelect:(UIButton *)btn
{
    int moduleIndex = floorl(btn.tag / 1000);
    int unitIndex = fmodl(btn.tag, 1000);
    
    if (moduleIndex < [_arrModuleList count])
    {
        ModelBookModuleInfo *moduleInfo = [_arrModuleList objectAtIndex:moduleIndex];
        
        if (moduleInfo.units)
        {
            if (unitIndex < [moduleInfo.units count])
            {
                ModelBookUnitInfo *unit = [moduleInfo.units objectAtIndex:unitIndex];
                
                if (delegate && [delegate respondsToSelector:@selector(selectModuleViewAtPageIndex:)])
                {
                    [delegate selectModuleViewAtPageIndex:unit.startPage];
                }
            }
        }
    }
}

@end
