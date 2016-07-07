//
//  UIImage+Scale.m
//  iEnglish
//
//  Created by JacobLi on 5/9/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

+(UIImage*)OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
