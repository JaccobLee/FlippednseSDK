//
//  ListenLayerView.h
//  iEnglish
//
//  Created by JacobLi on 3/31/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListenLayerView : UIView
{
    NSArray *arrResourceBlocks;
}

@property (nonatomic, strong) NSArray *arrResourceBlocks;

- (instancetype)initWithArrDatas:(NSArray *)arr;

@end
