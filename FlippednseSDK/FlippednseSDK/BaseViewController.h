//
//  BaseViewController.h
//  iEnglish
//
//  Created by JacobLi on 2/24/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import <JSONModel/JSONModel.h>
#import <FMDB/FMDB.h>
#import "UICategory.h"
#import "ConfigGlobal.h"
#import "ConfigNetwork.h"
#import "UtilMethod.h"
#import "Model.h"
#import <XMLReader/XMLReader.h>

#import "NetworkService+Books.h"
#import "NetWorkServiceOfDownload.h"
#import "NetworkService.h"

@interface BaseViewController : UIViewController

- (void)setStanderNavBar;
- (void)setStanderBackButton;

- (void)backAction;

- (void)setRightStanderImgButton:(NSString *)imgStr selectImg:(NSString *)selectImgStr withSel:(SEL)method;

@end
