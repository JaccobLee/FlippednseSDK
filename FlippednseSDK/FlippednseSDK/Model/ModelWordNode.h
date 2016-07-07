//
//  ModelWordNode.h
//  iEnglish
//
//  Created by JacobLi on 4/20/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ModelWordNode : NSObject

@property (nonatomic, strong) NSString      *word;
@property (nonatomic, strong) NSString      *entry;
@property (nonatomic, strong) NSString      *frequency;
@property (nonatomic, strong) NSString      *pronunciationPath;
@property (nonatomic, strong) NSArray       *definitions;  // definitionList数组
@property (nonatomic, strong) NSArray       *entry_examples;    // exampleList数组

@property (nonatomic, assign) BOOL          hasImage;
@property (nonatomic, strong) NSString      *imagePath;

@end


@interface definitionList : NSObject

@property (nonatomic, strong) NSString      *imagePath;
@property (nonatomic, strong) NSString      *pos;
@property (nonatomic, strong) NSString      *definition;

@property (nonatomic, strong) NSMutableArray       *arrTagB;
@property (nonatomic, strong) NSMutableArray       *arrTagI;

@end



@interface ModelWord : NSObject

@property (nonatomic, strong) NSString      *cid;
@property (nonatomic, strong) NSString      *version;
@property (nonatomic, assign) CGFloat       x;
@property (nonatomic, assign) CGFloat       y;
@property (nonatomic, assign) CGFloat       width;
@property (nonatomic, assign) CGFloat       height;
@property (nonatomic, strong) NSString      *text;

@property (nonatomic, strong) ModelWordNode *modelWordNode;

@end

