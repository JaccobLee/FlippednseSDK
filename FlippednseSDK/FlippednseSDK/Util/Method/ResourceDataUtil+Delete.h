//
//  ResourceDataUtil+Delete.h
//  iEnglish
//
//  Created by wj on 16/5/13.
//  Copyright © 2016年 jxb. All rights reserved.
//

#import "ResourceDataUtil.h"
@class ModelBookDownloadEnableModuleUnit;

@interface ResourceDataUtil (Delete)

+ (BOOL)deleteModuleUnitWithBookId:(NSString *)bid unitModel:(ModelBookDownloadEnableModuleUnit *)unit;

@end
