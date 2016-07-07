//
//  UICategory.m
//  iEnglish
//
//  Created by JacobLi on 2/23/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "UICategory.h"

#pragma mark - UILabel

@implementation UILabel (Creation)
#pragma mark - UILabel Normal
+(UILabel *)createLabelWithFrame:(CGRect)rect backgroundColor:(UIColor *)color textColor:(UIColor *)textColor font:(UIFont *)font textalignment:(NSTextAlignment )alignment text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.backgroundColor=color;
    label.textColor=textColor;
    label.font=font;
    label.textAlignment=alignment;
    label.text=text;
    return label;
}

+(UICustomLineLabel *)createLabelWithFrame:(CGRect)rect backgroundColor:(UIColor *)color textColor:(UIColor *)textColor font:(UIFont *)font textalignment:(NSTextAlignment )alignment text:(NSString *)text lineType:(LineType)lineType lineColor:(UIColor *)lineColor{
    UICustomLineLabel *label = [[UICustomLineLabel alloc]initWithFrame:rect];
    label.lineType=lineType;
    label.lineColor=lineColor;
    
    label.backgroundColor=color;
    label.textColor=textColor;
    label.font=font;
    label.textAlignment=alignment;
    label.text=text;
    return label;
    
}

#pragma mark - UILabel MutilLine
+(MyVerticalLable *)createVerticalLabelWithFrame:(CGRect)rect backgroundColor:(UIColor *)color textColor:(UIColor *)textColor font:(UIFont *)font textalignment:(NSTextAlignment )alignment text:(NSString *)text numberOfLine:(NSInteger)numberOfline verticalAlignment:(VerticalAlignment)verticalAlign
{
    MyVerticalLable *label = [[MyVerticalLable alloc]initWithFrame:rect];
    label.backgroundColor=color;
    label.textColor=textColor;
    label.font=font;
    label.text=text;
    label.numberOfLines = numberOfline;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textAlignment=alignment;
    [label setVerticalAlignment:verticalAlign];
    
    return label;
    
}


#pragma mark - UILabel MutilLine
+(UILabel *)createLabelWithFrame:(CGRect)rect backgroundColor:(UIColor *)color textColor:(UIColor *)textColor font:(UIFont *)font textalignment:(NSTextAlignment )alignment text:(NSString *)text numberOfLine:(NSInteger)numberOfline
{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.backgroundColor=color;
    label.textColor=textColor;
    label.font=font;
    label.text=text;
    label.numberOfLines = numberOfline;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment=alignment;
    return label;
}
#pragma mark - UILabel With Border CornerRadius
+(UILabel *)createLabelWithFrame:(CGRect)rect backgroundColor:(UIColor *)color textColor:(UIColor *)textColor font:(UIFont *)font textalignment:(NSTextAlignment )alignment text:(NSString *)text conrnerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.backgroundColor=color;
    label.textColor=textColor;
    label.font=font;
    label.textAlignment=alignment;
    label.text=text;
    [label setClipsToBounds:YES];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label.layer setCornerRadius:cornerRadius];
    [label.layer setBorderWidth:borderWidth];
    [label.layer setBorderColor:borderColor.CGColor];
    return label;
}
@end



#pragma mark - UIView

@implementation UIView (Creation)
#pragma mark - UIView Normal
+(UIView *)createViewWithFrame:(CGRect)rect backgroundColor:(UIColor *)color
{
    UIView *view=[[UIView alloc]initWithFrame:rect];
    [view setBackgroundColor:color];
    return view;
}
#pragma mark - UIView With Border CornerRadius
+(UIView *)createViewWithFrame:(CGRect)rect backgroundColor:(UIColor *)color conrnerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIView *view=[[UIView alloc]initWithFrame:rect];
    [view setBackgroundColor:color];
    [view setClipsToBounds:YES];
    [view.layer setCornerRadius:cornerRadius];
    [view.layer setBorderWidth:borderWidth];
    [view.layer setBorderColor:borderColor.CGColor];
    return view;
}

@end



#pragma mark - UITextField

@implementation UITextField (Creation)

+(UITextField *)createTextFieldWithFrame:(CGRect)rect backgroundColor:(UIColor *)color borderStyle:(UITextBorderStyle)borderStyle placeholder:(NSString *)placeholder text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textalignment:(NSTextAlignment )alignment
{
    UITextField *textField=[[UITextField alloc]initWithFrame:rect];
    [textField setBackgroundColor:color];
    [textField setBorderStyle:borderStyle];
    [textField setPlaceholder:placeholder];
    [textField setText:text];
    [textField setFont:font];
    [textField setTextColor:textColor];
    [textField setTextAlignment:alignment];
    return textField;
}

@end



#pragma mark - UIButton

@implementation UIButton (Creations)
#pragma mark - UIButton With BackgroundImage
+(UIButton *)createButtonwithFrame:(CGRect)rect backgroundColor:(UIColor *)color image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor=color;
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [button setImage:image forState:UIControlStateNormal];
    return button;
}
#pragma mark - UIButton With Title
+(UIButton *)createButtonwithFrame:(CGRect)rect backgroundColor:(UIColor *)color titleColor:(UIColor *)titleColor title:(NSString *)title;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    return button;
}
#pragma mark - UIButton with SpecialFont
+(UIButton *)createButtonwithFrame:(CGRect)rect backgroundColor:(UIColor *)color titleColor:(UIColor *)titleColor font:(UIFont *)font title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor = color;
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    return button;
}
#pragma mark - UIButton with SpecialFont CornerRadius
+(UIButton *)createButtonwithFrame:(CGRect)rect backgroundColor:(UIColor *)color titleColor:(UIColor *)titleColor font:(UIFont *)font title:(NSString *)title conrnerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor = color;
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setClipsToBounds:YES];
    [button.layer setCornerRadius:cornerRadius];
    [button.layer setBorderWidth:borderWidth];
    [button.layer setBorderColor:borderColor.CGColor];
    return button;
}

+(UIButton *)createButtonwithFrame:(CGRect)rect backgroundColor:(UIColor *)color conrnerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor = color;
    //    button.titleLabel.font = font;
    //    [button setTitle:title forState:UIControlStateNormal];
    //    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setClipsToBounds:YES];
    [button.layer setCornerRadius:cornerRadius];
    [button.layer setBorderWidth:borderWidth];
    [button.layer setBorderColor:borderColor.CGColor];
    return button;
}

@end


#pragma mark - UIImageView
@implementation UIImageView (Creation)
#pragma mark - UIImageView With Image
+(UIImageView *)createImageViewWithFrame:(CGRect)rect backgroundColor:(UIColor *)color image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.backgroundColor = color;
    imageView.image = image ? image : nil;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}
#pragma mark - UIImageView With Image Border CornerRaduis
+(UIImageView *)createImageViewWithFrame:(CGRect)rect backgroundColor:(UIColor *)color image:(UIImage *)image conrnerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.backgroundColor = color;
    imageView.image = image ? image : nil;
    imageView.clipsToBounds = YES;
    [imageView.layer setCornerRadius:cornerRadius];
    [imageView.layer setBorderColor:borderColor.CGColor];
    [imageView.layer setBorderWidth:borderWidth];
    return imageView;
}
@end



#pragma mark - UIScrollView

@implementation UIScrollView (Creation)

+(UIScrollView *)creatScrollViewWithFrame:(CGRect)rect backgroundColor:(UIColor *)color contentSize:(CGSize)contentSize
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:rect];
    [scrollView setBackgroundColor:color];
    [scrollView setContentSize:contentSize];
    return scrollView;
}

@end



#pragma mark - UITableView

@implementation UITableView (Creation)
#pragma mark - UITableView Normal
+(UITableView *)createTableViewWithFrame:(CGRect)rect style:(UITableViewStyle)Style  backgroundColor:(UIColor *)color delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSourse
{
    UITableView *tableView= [[UITableView alloc]initWithFrame:rect style:Style];
    tableView.backgroundColor = color;
    tableView.delegate=delegate;
    tableView.dataSource=dataSourse;
    return tableView;
}
#pragma mark - UITableView Custom
+(UITableView *)createTableViewWithFrame:(CGRect)rect style:(UITableViewStyle)Style  backgroundColor:(UIColor *)color delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSourse  separatorColor:(UIColor *)separatorColor separatorInset:(UIEdgeInsets)separatorInset
{
    UITableView *tableView= [[UITableView alloc]initWithFrame:rect style:Style];
    tableView.backgroundColor = color;
    tableView.delegate=delegate;
    tableView.dataSource=dataSourse;
    tableView.separatorColor = separatorColor;
    tableView.separatorInset = separatorInset;
    return tableView;
}

@end



#pragma mark - UICollectionViewFlowLayout

@implementation UICollectionViewFlowLayout (Creation)

+(UICollectionViewFlowLayout *)createCollectionViewFlowLayoutWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection minimumY:(CGFloat )minimumY minimumX:(CGFloat)minimumX
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    if (!scrollDirection) {
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }else{
        [flowLayout setScrollDirection:scrollDirection];
    }
    flowLayout.minimumLineSpacing = minimumY;
    flowLayout.minimumInteritemSpacing = minimumX;
    return flowLayout;
}

@end



#pragma mark - UICollectionView

@implementation UICollectionView (Creation)

+(UICollectionView *)createCollectionViewWithFrame:(CGRect)rect collectionViewLayout:(UICollectionViewFlowLayout *)flowLayout backgroundColor:(UIColor *)color delegate:(id<UICollectionViewDelegate>)delegate dataSource:(id<UICollectionViewDataSource>)dataSourse
{
    UICollectionView *collectionView=[[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    collectionView.backgroundColor=color;
    collectionView.dataSource=dataSourse;
    collectionView.delegate=delegate;
    return collectionView;
}

@end



#pragma mark - UISegmentedControl

@implementation UISegmentedControl (Creation)

+(UISegmentedControl *)createSegmentWithFrame:(CGRect)rect nameArray:(NSArray *)nameArray backgroundColor:(UIColor *)backgroundColor tintColor:(UIColor *)tintColor selectedIndex:(NSInteger)selectedIndex
{
    UISegmentedControl *segementedControl = [[UISegmentedControl alloc]initWithItems:nameArray];
    [segementedControl setFrame:rect];
    [segementedControl setBackgroundColor:backgroundColor];
    [segementedControl setTintColor:tintColor];
    [segementedControl setSelectedSegmentIndex:selectedIndex];
    return segementedControl;
}

@end





#pragma mark - CAShapeLayer

@implementation CAShapeLayer (Creation)
#pragma mark - CAShapeLayer Line
+(CAShapeLayer *)createLineWithStartPoint:(CGPoint )startPoint endPoint:(CGPoint )endPoint color:(UIColor *)color lineWidth:(CGFloat)lineWidth
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    [layer setStrokeColor:color.CGColor];
    //    [layer setFillColor:color.CGColor];
    [layer setLineWidth:lineWidth];
    [layer setBorderWidth:0.f];
    return layer;
}
#pragma mark - CAShapeLayer Rect
+(CAShapeLayer *)createRect:(CGRect)rect fillColor:(UIColor *)fillColor strokColor:(UIColor *)strokColor lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    [layer setStrokeColor:strokColor.CGColor];
    [layer setFillColor:fillColor.CGColor];
    [layer setLineWidth:lineWidth];
    return layer;
}
@end



