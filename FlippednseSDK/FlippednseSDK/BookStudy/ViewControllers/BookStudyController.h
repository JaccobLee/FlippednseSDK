//
//  BookStudyController.h
//  iEnglish
//
//  Created by JacobLi on 3/30/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "BaseViewController.h"
#import "BookStudyViewModel.h"
#import "DirectoryUtil.h"
#import "ConfigGlobal.h"
#import "ConfigNetwork.h"



@interface BookStudyController : BaseViewController

@property (nonatomic, strong) NSString  *bookId;
@property (nonatomic, strong) NSString  *bookEid;
@property (nonatomic, strong) BookStudyViewModel    *viewModel;

@end
