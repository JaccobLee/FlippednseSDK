//
//  BookStudyTabBarView.h
//  iEnglish
//
//  Created by JacobLi on 4/14/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

typedef enum {
    BookStudyTabBarSelectType_read,
    BookStudyTabBarSelectType_translate,
    BookStudyTabBarSelectType_word,
    BookStudyTabBarSelectType_language
} BookStudyTabBarSelectType;

@protocol BookStudyTabBarViewDelegate <NSObject>

- (void)selectTabbarType:(BookStudyTabBarSelectType)type;

@end

@interface BookStudyTabBarView : BaseView
{
    __weak id<BookStudyTabBarViewDelegate> delegate;
}

@property (nonatomic, weak) id<BookStudyTabBarViewDelegate> delegate;
@property (nonatomic, assign) int       type;       // 0 : 小学   1 : 初中

- (void)layoutView;

@end
