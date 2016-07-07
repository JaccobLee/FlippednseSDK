//
//  MyVerticalLable.h
//  WaterMan
//
//  Created by baichun on 16/1/8.
//  Copyright © 2016年 baichun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface MyVerticalLable : UILabel{
@private
    VerticalAlignment _verticalAlignment;
}
@property (nonatomic) VerticalAlignment verticalAlignment;

@end
