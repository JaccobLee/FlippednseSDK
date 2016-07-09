//
//  ModelClickRead.h
//  iEnglish
//
//  Created by JacobLi on 4/1/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Model.h"

@interface ModelClickRead : Model

@property (nonatomic, assign) CGFloat   startX;
@property (nonatomic, assign) CGFloat   startY;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, copy) NSString    *cid;
@property (nonatomic, copy) NSString    *text;
@property (nonatomic, assign) BOOL      visible;

@property (nonatomic, copy) NSString<Optional> *filePath;

@end

@interface ModelTranslate : Model

@property (nonatomic, assign) CGFloat   x;
@property (nonatomic, assign) CGFloat   y;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, copy) NSString    *cid;
@property (nonatomic, copy) NSString    *text;
@property (nonatomic, copy) NSString    *version;
@property (nonatomic, copy) NSString    *des;

// 添加界面布局属性，附加属性
@property (nonatomic, assign) CGFloat   sizeFitX;
@property (nonatomic, assign) CGFloat   sizeFitY;

@end
