//
//  BaseViewController.m
//  iEnglish
//
//  Created by JacobLi on 2/24/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+Hex.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self setStanderNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStanderNavBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0x2185d5 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}


- (void)setStanderBackButton
{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 39)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];

    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)setRightStanderImgButton:(NSString *)imgStr selectImg:(NSString *)selectImgStr withSel:(SEL)method;
{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];

    [backBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    if (![selectImgStr isEqualToString:@""]) {
        [backBtn setImage:[UIImage imageNamed:selectImgStr] forState:UIControlStateSelected];

    }else{
        [backBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateSelected];

    }

    [backBtn addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self.navigationItem setRightBarButtonItem:backItem];
}



- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
