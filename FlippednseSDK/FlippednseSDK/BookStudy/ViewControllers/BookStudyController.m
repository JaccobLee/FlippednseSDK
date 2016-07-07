//
//  BookStudyController.m
//  iEnglish
//
//  Created by JacobLi on 3/30/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "BookStudyController.h"
#import "ImageBrowerView.h"
#import "PlayerUtil.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "AudioPlayerView.h"
#import "PopTextView.h"
#import "BookStudyTabBarView.h"
#import "ModelClickRead.h"
#import "ModelWordNode.h"
#import "PopWordView.h"
#import "NetworkService+Books.h"
#import "PopDownloadProgressView.h"
#import "ModelBookStore.h"
#import "PopTranslateAndGramarView.h"
#import "ModelUser.h"
#import "UtilBooksOnLocal.h"
#import "KxMenu.h"
#import "ImageShowView.h"
#import "PopGramarView.h"
#import "SelectModuleView.h"
#import "UIViewExt.h"
#import "ZipArchive.h"

#define BrowerToolBarHeight     HeightScale(64.0f)
// 补足在iphone上上面留白的像素
//#define IphoneMarginHeight      (([[UIScreen mainScreen] bounds].size.height == 480) ? 0 : (([[UIScreen mainScreen] bounds].size.height < 1024 ? 15.0 : 0.0)))

@interface BookStudyController() <AVPlayerViewControllerDelegate,BookStudyTabBarViewDelegate,ImageBrowerViewDelegate,UITextFieldDelegate,PopDownloadProgressViewDelegate,UIGestureRecognizerDelegate,SelectModuleViewDelegate>

@property (nonatomic, strong) ImageBrowerView       *browerView;
@property (nonatomic, strong) AudioPlayerView       *viewAudioPlayer;
@property (nonatomic, strong) PopTextView           *popTextView;
@property (nonatomic, strong) PopWordView           *popWordView;
@property (nonatomic, strong) PopTranslateAndGramarView *popTranslateGramarView;
@property (nonatomic, strong) PopGramarView         *popGramarView;
@property (nonatomic, strong) PopDownloadProgressView   *popDownloadView;
@property (nonatomic, strong) BookStudyTabBarView   *bookTabbar;

@property (nonatomic, assign) BookStudyTabBarSelectType  tabbarType;
@property (nonatomic, assign) int      indexBrower;
@property (nonatomic, strong) UITextField           *textFiledPage;
@property (nonatomic, strong) UILabel               *lbTotalPages;
@property (nonatomic, strong) UIButton              *btnSelectModule;

@property (nonatomic, strong) SelectModuleView      *selectModuleView;
@property (nonatomic, strong) NSString              *moduleResourceLocation;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) BOOL                  isDownloadingModuleUnit;
@property (nonatomic, strong) NSString              *downloadingModuleUnit;

@end

@implementation BookStudyController

- (void)viewDidLoad
{
    
    [self setStanderNavBar];
    [self setBackBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _viewModel = [[BookStudyViewModel alloc] initWithBookid:_bookId];
    _viewModel.bookEid = _bookEid;
    [UtilBooksOnLocal updateBookStoreUserInfoOfStateReadWithBookId:_bookId lastReadTime:[[NSDate date]timeIntervalSince1970]];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    _tapGesture.delegate = self;
    [self.view addGestureRecognizer:_tapGesture];
    
    [self layoutView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"StudyPageGuideLoaded"]) {
        UIButton *guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        guideBtn.adjustsImageWhenHighlighted = NO;
        guideBtn.tag = 0;
        guideBtn.frame = [UIScreen mainScreen].bounds;
        [guideBtn setBackgroundImage:[UIImage imageNamed:@"img_navigate1"] forState:UIControlStateNormal];
        [guideBtn addTarget:self action:@selector(changeGuideImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.view addSubview:guideBtn];
    }
}

- (void)changeGuideImage:(UIControl *)sender
{
    if (sender.tag == 0) {
        [sender removeFromSuperview];
        
        UIButton *guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        guideBtn.adjustsImageWhenHighlighted = NO;
        guideBtn.tag = 1;
        guideBtn.frame = [UIScreen mainScreen].bounds;
        [guideBtn setBackgroundImage:[UIImage imageNamed:@"img_navigate2"] forState:UIControlStateNormal];
        [guideBtn addTarget:self action:@selector(changeGuideImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.view addSubview:guideBtn];
    }
    else if (sender.tag == 1) {
        [sender removeFromSuperview];
        
        UIControl *control = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [control addTarget:self action:@selector(changeGuideImage:) forControlEvents:UIControlEventTouchUpInside];
        control.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        control.tag = 2;
        [self.navigationController.view addSubview:control];
        UIImageView *guideView = [[UIImageView alloc] initWithFrame:CGRectZero];
        guideView.size = CGSizeMake(SCREEN_WIDTH/3 * 92/225 * 175/95, SCREEN_WIDTH/3 * 92/225);
        guideView.origin = CGPointMake(SCREEN_WIDTH - WidthScale(200) - 35, 64+15);
        guideView.image = [UIImage imageNamed:@"img_ffyl_ml"];
        [control addSubview:guideView];
    }
    else if (sender.tag == 2) {
        [sender removeFromSuperview];
        
        UIControl *control = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [control addTarget:self action:@selector(changeGuideImage:) forControlEvents:UIControlEventTouchUpInside];
        control.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        control.tag = 3;
        [self.navigationController.view addSubview:control];
        UIImageView *guideView = [[UIImageView alloc] initWithFrame:CGRectZero];
        guideView.size = CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3 * 92/225);
        guideView.origin = CGPointMake(SCREEN_WIDTH - guideView.width -  WidthScale(130), 64+15);
        guideView.image = [UIImage imageNamed:@"img_navigate_pagesearch"];
        [control addSubview:guideView];
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"StudyPageGuideLoaded"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (sender.tag == 3) {
        [sender removeFromSuperview];
    }
    else {
        [sender removeFromSuperview];
    }
}

- (void)setBackBtn
{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];

    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [backBtn setTitle:Locale(@"书架") forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)setUpNavbarItems
{
    _lbTotalPages = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - WidthScale(100), 0, WidthScale(80), 44)];
    _lbTotalPages.text = [NSString stringWithFormat:@"/ %d",_viewModel.countTotal - _viewModel.countCovers - 2];
    _lbTotalPages.backgroundColor = [UIColor clearColor];
    _lbTotalPages.textColor = [UIColor blackColor];
    _lbTotalPages.textAlignment = NSTextAlignmentLeft;
    _lbTotalPages.font = KSystemfont(15);
    [self.navigationController.navigationBar addSubview:_lbTotalPages];
    
    _textFiledPage = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - _lbTotalPages.frame.size.width - WidthScale(20) - WidthScale(90), 12, WidthScale(80), 22)];
    _textFiledPage.text = [NSString stringWithFormat:@"%d", _indexBrower];
    _textFiledPage.delegate = self;
    _textFiledPage.backgroundColor = [UIColor whiteColor];
    _textFiledPage.tintColor = [UIColor blackColor];
    _textFiledPage.textAlignment = NSTextAlignmentCenter;
    _textFiledPage.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _textFiledPage.returnKeyType = UIReturnKeyGo;
    _textFiledPage.font = KSystemfont(15);
    [self.navigationController.navigationBar addSubview:_textFiledPage];
    
    _btnSelectModule = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSelectModule.frame = CGRectMake(_textFiledPage.frame.origin.x - 20 - 30, 6, 30, 34);
    [_btnSelectModule setBackgroundImage:[UIImage imageNamed:@"bookstudy_btn_menuList"] forState:UIControlStateNormal];
    [_btnSelectModule setBackgroundImage:[UIImage imageNamed:@"bookstudy_btn_menuList_selected"] forState:UIControlStateSelected];
    [_btnSelectModule addTarget:self action:@selector(btnSelectModuleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_btnSelectModule];
}

- (void)clearNavbarItems
{
    if (_lbTotalPages)
    {
        [_lbTotalPages removeFromSuperview];
    }
    if (_textFiledPage)
    {
        [_textFiledPage removeFromSuperview];
    }
    if (_btnSelectModule)
    {
        [_btnSelectModule removeFromSuperview];
    }
    
    [self stopPlayAudio];
    [self stopPlayListenWord];
    [self dismissPopTextView];
}

- (void)layoutView
{
//    #define IphoneMarginHeight      (([[UIScreen mainScreen] bounds].size.height == 480) ? 0 : (([[UIScreen mainScreen] bounds].size.height < 1024 ? 15.0 : 0.0)))
    
    CGFloat IphoneMarginHeight = 0.0f;
    if ([[UIScreen mainScreen] bounds].size.height < 1024)
    {
        if ([[UIScreen mainScreen] bounds].size.height > 480)
        {
            IphoneMarginHeight = 20.0f;
        }
    }
    
    _browerView = [[ImageBrowerView alloc]
                   initWithFrame:CGRectMake(0, IphoneMarginHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BrowerToolBarHeight - 64 - 2 * IphoneMarginHeight)
                   withSourceData:_viewModel
                   withIndex:0];
    _browerView.imageBrowerViewDelegate = self;
    [self.view addSubview:_browerView];
    
    
    _indexBrower = 0;
    
    _tabbarType = BookStudyTabBarSelectType_read;
    _bookTabbar = [[BookStudyTabBarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - BrowerToolBarHeight, SCREEN_WIDTH, BrowerToolBarHeight)];
    int type = 0;
    if ([_viewModel.modelXml.gradeid isEqualToString:@"1l"] || [_viewModel.modelXml.gradeid isEqualToString:@"3l"])
    {
        type = 0;
    }
    else
    {
        type = 1;
    }
    _bookTabbar.type = type;
    _bookTabbar.delegate = self;
    [self.view addSubview:_bookTabbar];
    
    [_bookTabbar layoutView];
    
    int userId=[ConfigGlobal loginUser].userId;
    NSArray *arrayUserBooksSelect= [ModelBookStoreUser selectByPropertyMaps:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userId",_bookId,@"bookId", nil]];
    if ([arrayUserBooksSelect count])
    {
        ModelBookStoreUser *storeUser = [arrayUserBooksSelect lastObject];
    
        [_browerView displayPageCurIndex:storeUser.lastReadPage];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self setUpNavbarItems];
    
    [Notif addObserver:self selector:@selector(playListenWord:) name:Notif_Play_ListenWord object:nil];
    [Notif addObserver:self selector:@selector(playVideo:) name:Notif_Play_Video object:nil];
    [Notif addObserver:self selector:@selector(playAudio:) name:Notif_Play_Audio object:nil];
    [Notif addObserver:self selector:@selector(playShowText:) name:Notif_Play_ShowText object:nil];
    [Notif addObserver:self selector:@selector(playTranslate:) name:Notif_Play_Translate object:nil];
    [Notif addObserver:self selector:@selector(playGramar:) name:Notif_Play_Gramar object:nil];
    [Notif addObserver:self selector:@selector(playWord:) name:Notif_Play_Word object:nil];
    
    [Notif addObserver:self selector:@selector(needDownloadModule) name:Notif_Need_DownLoad_Module object:nil];
    [Notif addObserver:self selector:@selector(needBuyBook) name:Notif_Need_Buy_Book object:nil];
    [Notif addObserver:self selector:@selector(needReBuyBook) name:Notif_Need_ReBuy_Book object:nil];
    [Notif addObserver:self selector:@selector(playWordListen:) name:Notif_Play_Word_ListenWord object:nil];
    
    [Notif addObserver:self selector:@selector(hidePopView:) name:Notif_Hide_PopView object:nil];
    
    [Notif addObserver:self selector:@selector(downLoadPauseAction) name:Notif_Download_Module_Pause object:nil];
    [Notif addObserver:self selector:@selector(confirmDownLoadTaskResume) name:Notif_Download_Module_Resume object:nil];
    
    [self loadDownableModuleUnitsName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [Notif removeObserver:self];
    
    [self clearNavbarItems];
}

- (void)backAction
{
    [UtilBooksOnLocal updateBookStoreUserInfoOfStateReadWithBookId:_bookId lastReadPage:_viewModel.lastReadPage lastReadTime:[[NSDate date]timeIntervalSince1970]];
    
/*
    NSArray *arrVC = self.navigationController.viewControllers;
    
    id rootViewController;
    
    if ([[arrVC firstObject] isKindOfClass:[MainPageController class]])
    {
        rootViewController = [arrVC firstObject];
    }
    else
    {
        for (int i = 0; i < [arrVC count]; i++)
        {
            id vc = [arrVC objectAtIndex:i];
            if ([vc isKindOfClass:[MainPageController class]])
            {
                rootViewController = vc;
                break;
            }
        }
    }

    if (rootViewController)
    {
        MainPageController *rootvc = rootViewController;
        [self.navigationController popToViewController:rootvc animated:NO];
        if ([rootvc respondsToSelector:@selector(pushBookStoreMainAction)])
        {
            [rootvc performSelector:@selector(pushBookStoreMainAction) withObject:nil afterDelay:0];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
*/
    
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnSelectModuleAction:(id)sender
{
    if (_selectModuleView)
    {
        if (_selectModuleView.isShowing)
        {
            [self dismissSelectModuleView];
        }
        else
        {
            [self showSelectModuleView];
        }
    }
    else
    {
        [self showSelectModuleView];
    }
}

- (void)loadDownableModuleUnitsName
{
    [NetworkService requestBookGetDownloadableModuleUnitBookEid:_bookEid success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]])
        {
            _viewModel.arrDownloadableModules = responseObject;
        }
    } failure:^(NSError *error)
    {
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        if (CGRectContainsPoint(_bookTabbar.frame,[touch locationInView:self.view]))
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)tapRecognizer:(UITapGestureRecognizer *)gesture
{
    if (_popTranslateGramarView)
    {
        if (!CGRectContainsPoint(_popTranslateGramarView.frame, [gesture locationInView:self.view]))
        {
            [self dismissPopTranslateAndGramarAndWord];
        }
    }
    
    if (_popGramarView)
    {
        if (!CGRectContainsPoint(_popGramarView.frame, [gesture locationInView:self.view]))
        {
            [self dismissPopTranslateAndGramarAndWord];
        }
    }
    
    if (_popWordView)
    {
        if (!CGRectContainsPoint(_popWordView.frame, [gesture locationInView:self.view]))
        {
            [self dismissPopWordView];
        }
    }
    
    if (_selectModuleView)
    {
        if (!CGRectContainsPoint(_selectModuleView.frame, [gesture locationInView:self.view]))
        {
            [self dismissSelectModuleView];
        }
    }
    
    if ([_textFiledPage isFirstResponder])
    {
        [_textFiledPage resignFirstResponder];
    }
    
    [self nextResponder];
}

- (void)showSelectModuleView
{
    [self dismissSelectModuleView];
    
    _selectModuleView = [[SelectModuleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - HeightScale(300)) withModuleList:_viewModel.arrModuleUnitList];
    _selectModuleView.delegate = self;
    [self.view addSubview:_selectModuleView];
    
    [_selectModuleView layoutView];
    
    _selectModuleView.isShowing = YES;
    
}

- (void)dismissSelectModuleView
{
    _selectModuleView.isShowing = NO;
    [_selectModuleView removeFromSuperview];
    _selectModuleView = nil;
    
    [_btnSelectModule setBackgroundColor:[UIColor clearColor]];
}

- (void)selectModuleViewAtPageIndex:(int)page
{
    if (page >= 0 && page <= _viewModel.countTotal - _viewModel.countCovers - 2)
    {
        _indexBrower = page;
        [_browerView displayPageCurIndex:_indexBrower + _viewModel.countCovers];
        
        [self dismissSelectModuleView];
    }
}

- (void)playListenWord:(NSNotification *)not
{
    [self stopPlayAudio];
    [self stopPlayListenWord];
    [self dismissPopTextView];
    
    NSString *filePath = not.object;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *fileCopyPath = [DirectoryUtil tmpPath];
        fileCopyPath = [NSString stringWithFormat:@"%@/playWordListen.mp3",fileCopyPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileCopyPath])
        {
            [fileManager removeItemAtPath:fileCopyPath error:nil];
        }
        
        if ([fileManager copyItemAtPath:filePath toPath:fileCopyPath error:nil])
        {
            PlayerUtil *util = [PlayerUtil sharedPlayer];
            [util stop];
            [util setPlayPath:fileCopyPath];
            [util play];
        }
    });
}

- (void)playWordListen:(NSNotification *)not    // word弹出层
{
    [self stopPlayAudio];
    [self stopPlayListenWord];
//    [self dismissPopTextView];        不隐藏word弹出层
    
    NSString *filePath = not.object;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *fileCopyPath = [DirectoryUtil tmpPath];
        fileCopyPath = [NSString stringWithFormat:@"%@/playWordListen.mp3",fileCopyPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileCopyPath])
        {
            [fileManager removeItemAtPath:fileCopyPath error:nil];
        }
        
        if ([fileManager copyItemAtPath:filePath toPath:fileCopyPath error:nil])
        {
            PlayerUtil *util = [PlayerUtil sharedPlayer];
            [util stop];
            [util setPlayPath:fileCopyPath];
            [util play];
        }
    });
}

- (void)playAudio:(NSNotification *)not
{
    [self stopPlayAudio];
    [self stopPlayListenWord];
    [self dismissPopTranslateAndGramarAndWord];
    
    NSString *filePath = not.object;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *fileCopyPath = [DirectoryUtil tmpPath];
        fileCopyPath = [NSString stringWithFormat:@"%@/playVideo.mp3",fileCopyPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileCopyPath])
        {
            [fileManager removeItemAtPath:fileCopyPath error:nil];
        }
        
        if ([fileManager copyItemAtPath:filePath toPath:fileCopyPath error:nil])
        {
            _viewAudioPlayer = [[AudioPlayerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - HeightScale(120), SCREEN_WIDTH, HeightScale(120))];
            [_viewAudioPlayer setPlayPath:fileCopyPath];
            _viewAudioPlayer.layer.cornerRadius = 5;
            [self.view addSubview:_viewAudioPlayer];
            
            [_viewAudioPlayer play];
        }
    });
}

- (void)stopPlayListenWord
{
    PlayerUtil *util = [PlayerUtil sharedPlayer];
    [util stop];
}

- (void)stopPlayAudio
{
    if (_viewAudioPlayer)
    {
        [_viewAudioPlayer stop];
        [_viewAudioPlayer removeFromSuperview];
        _viewAudioPlayer = nil;
    }
}

- (void)playVideo:(NSNotification *)not
{
    NSString *filePath = not.object;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *fileCopyPath = [DirectoryUtil tmpPath];
        fileCopyPath = [NSString stringWithFormat:@"%@/playVideo.mov",fileCopyPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileCopyPath])
        {
            [fileManager removeItemAtPath:fileCopyPath error:nil];
        }
        
        if ([fileManager copyItemAtPath:filePath toPath:fileCopyPath error:nil])
        {
            NSURL *url = [[NSURL alloc] initFileURLWithPath:fileCopyPath];
            
            AVPlayerViewController *play = [[AVPlayerViewController alloc] init];
            play.player = [[AVPlayer alloc] initWithURL:url];
            [self presentViewController:play animated:YES completion:^{
                [play.player play];
            }];
        }
    });
}

- (void)showPopTextViewWithContentString:(NSString *)content
{
    [self stopPlayListenWord];
    [self dismissPopTextView];
    [self dismissPopTranslateAndGramarAndWord];
    
    _popTextView = [[PopTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2 + WidthScale(150), SCREEN_HEIGHT / 2)];
    _popTextView.center = CGPointMake(SCREEN_WIDTH / 2,  (SCREEN_HEIGHT - 64) / 2);
    _popTextView.layer.cornerRadius = 5;
    _popTextView.backgroundColor = [UIColor clearColor];
    _popTextView.content = content;
    
    [_popTextView layoutView];
    
    [self.view addSubview:_popTextView];
}

- (void)dismissPopTextView
{
    if (_popTextView)
    {
        [_popTextView removeFromSuperview];
        _popTextView = nil;
    }
}

- (void)dismissPopTranslateAndGramarAndWord
{
    if (_popTranslateGramarView)
    {
        [_popTranslateGramarView removeFromSuperview];
        _popTranslateGramarView = nil;
    }
    
    [self dismissGramarView];
    
    [self dismissPopWordView];
}

- (void)showPopTranslateAndGramarWithRect:(CGRect)rect String:(NSString *)popValue
{
    [self stopPlayAudio];
    [self stopPlayListenWord];
    [self dismissPopTextView];
    [self dismissPopTranslateAndGramarAndWord];
    [KxMenu dismissMenu];
    
    CGFloat scale = 1.0f;
    if (_browerView.scale != 0)
    {
        scale = _browerView.scale;
    }
    
    ImageShowView *showView = [_browerView getDisplayCenterView];
    CGFloat zoomScale = showView.zoomScale;
    
    CGFloat additionWidth = WidthScale(200);
    
    CGRect rectNew = CGRectMake((rect.origin.x * zoomScale) ,rect.origin.y * zoomScale,rect.size.width * zoomScale + additionWidth,rect.size.height * zoomScale);
    
    if (rectNew.origin.x + rectNew.size.width > showView.contentSize.width)
    {
        rectNew.size.width = showView.contentSize.width - rectNew.origin.x - WidthScale(20);
    }
    
    _popTranslateGramarView = [[PopTranslateAndGramarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _popTranslateGramarView.backgroundColor = [UIColor clearColor];
    CGSize size = [_popTranslateGramarView layoutViewWithContentStr:popValue withContentViewFrame:rectNew];
    if (rectNew.origin.y + size.height > showView.frame.size.height)
    {
        rectNew = CGRectMake(rectNew.origin.x, rectNew.origin.y - size.height, rectNew.size.width, rectNew.size.height);
        [_popTranslateGramarView layoutViewWithContentStr:popValue withContentViewFrame:rectNew];
    }
    
    [showView addSubview:_popTranslateGramarView];
}

- (void)showPopGramarWithRect:(CGRect)rect String:(NSString *)popValue
{
    [self stopPlayAudio];
    [self stopPlayListenWord];
    [self dismissPopTextView];
    [self dismissPopTranslateAndGramarAndWord];
    [KxMenu dismissMenu];
    
    CGFloat scale = 1.0f;
    if (_browerView.scale != 0)
    {
        scale = _browerView.scale;
    }
    
    _popGramarView = [[PopGramarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - BrowerToolBarHeight)];
    _popGramarView.backgroundColor = [UIColor clearColor];
    [_popGramarView layoutViewWithContentStr:popValue withContentViewFrame:rect];
    
    [self.view addSubview:_popGramarView];
}

- (void)dismissGramarView
{
    if (_popGramarView)
    {
        [_popGramarView removeFromSuperview];
        _popGramarView = nil;
    }
}


- (void)showPopWordView:(ModelWordNode *)word
{
    [self stopPlayAudio];
    [self stopPlayListenWord];
    [self dismissPopTextView];
    [self dismissPopTranslateAndGramarAndWord];
    [KxMenu dismissMenu];
    
    CGFloat scale = 1.0f;
    if (_browerView.scale != 0)
    {
        scale = _browerView.scale;
    }
    
    _popWordView = [[PopWordView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - BrowerToolBarHeight)];
    _popWordView.center = CGPointMake(SCREEN_WIDTH / 2, (SCREEN_HEIGHT - 64 - BrowerToolBarHeight) / 2);
    _popWordView.backgroundColor = [UIColor clearColor];
    _popWordView.model = word;
    
    [_popWordView layoutView];
    [self.view addSubview:_popWordView];
}

- (void)dismissPopWordView
{
    if (_popWordView)
    {
        [_popWordView removeFromSuperview];
        _popWordView = nil;
    }
}

- (void)hidePopView:(NSNotification *)not
{
    [self dismissPopTranslateAndGramarAndWord];
    
    [KxMenu dismissMenu];
}

- (void)playShowText:(NSNotification *)not
{
    NSString *str = not.object;
    
    str = [str stringByReplacingOccurrencesOfString:@"&#xA;" withString:@"\n"];
    
    [self showPopTextViewWithContentString:str];
}

- (void)playTranslate:(NSNotification *)not
{
    ModelTranslate *translate = not.object;
    
    CGRect rect = CGRectMake(translate.x, translate.y, translate.width, translate.height);
    NSString *popValue = translate.des;
    
    [self showPopTranslateAndGramarWithRect:rect String:popValue];
}

- (void)playGramar:(NSNotification *)not
{
    ModelTranslate *translate = not.object;
    
    CGRect rect = CGRectMake(_browerView.center.x - translate.width / 2, _browerView.center.y - translate.height / 2, translate.width, translate.height);
    NSString *popValue = @"";
    if (translate.text.length > 0)
    {
        popValue = [popValue stringByAppendingString:@"<P>"];
        popValue = [popValue stringByAppendingString:translate.text];
        popValue = [popValue stringByAppendingString:@"</P>"];
    }
    
    popValue = [popValue stringByAppendingString:translate.des];
    
    [self showPopGramarWithRect:rect String:popValue];
}

- (void)playWord:(NSNotification *)not
{
    ModelWordNode *word = not.object;
    
    [self showPopWordView:word];
}

- (void)needBuyBook
{
    [_textFiledPage resignFirstResponder];
    
/*
    
    [UIAlertView showAlertViewWithTitle:Locale(@"请先购买本书") message:nil cancelButtonTitle:Locale(@"取消") otherButtonTitles:@[Locale(@"购买本书")] onDismiss:^(int buttonIndex) {
        BookDetailController *vc = [[BookDetailController alloc] init];
        vc.detailOfBook = [[ModelBookInfoDetail alloc] init];
        vc.detailOfBook.bookId = _viewModel.bookId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } onCancel:^{
    }];
 */
}

- (void)needReBuyBook
{
    [_textFiledPage resignFirstResponder];
    
/*
    [UIAlertView showAlertViewWithTitle:Locale(@"本书访问权限已过期，请重新购买") message:nil cancelButtonTitle:Locale(@"取消") otherButtonTitles:@[Locale(@"去购买")] onDismiss:^(int buttonIndex) {
        BookDetailController *vc = [[BookDetailController alloc] init];
        vc.detailOfBook = [[ModelBookInfoDetail alloc] init];
        vc.detailOfBook.bookId = _viewModel.bookId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } onCancel:^{
    }];
 */
    
}

- (void)needDownloadModule
{
    _isDownloadingModuleUnit = NO;
    
    [_textFiledPage resignFirstResponder];
    
    [UIAlertView showAlertViewWithTitle:Locale(@"您还未下载该模块数据包，请点击下载") message:nil cancelButtonTitle:Locale(@"取消") otherButtonTitles:@[Locale(@"立即下载")] onDismiss:^(int buttonIndex) {
        [self confirmDownloadModuleUnitResource];
    } onCancel:^{
    }];
}

#pragma mark -- TextFiled delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text intValue] >= 0 && [textField.text intValue] <= _viewModel.countTotal - _viewModel.countCovers - 2)
    {
        _indexBrower = [textField.text intValue];
        [_browerView displayPageCurIndex:_indexBrower + _viewModel.countCovers];
    }
    else
    {
        [UIAlertView showAlertViewWithTitle:nil message:Locale(@"请输入正确的页数") cancelButtonTitle:@"OK" otherButtonTitles:nil onDismiss:^(int buttonIndex)
         {
         } onCancel:^{
         }];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text intValue] >= 0 && [textField.text intValue] <= _viewModel.countTotal - _viewModel.countCovers - 2)
    {
        _indexBrower = [textField.text intValue];
        
        [_browerView displayPageCurIndex:_indexBrower + _viewModel.countCovers];
        
        [textField resignFirstResponder];
    }
    else
    {
        [UIAlertView showAlertViewWithTitle:nil message:Locale(@"请输入正确的页数") cancelButtonTitle:@"OK" otherButtonTitles:nil onDismiss:^(int buttonIndex)
         {
         } onCancel:^{
         }];
    }
    return YES;
}

#pragma mark -- tabbarView delegate
- (void)selectTabbarType:(BookStudyTabBarSelectType)type
{
    
    if (_tabbarType == type)
    {
        return;
        
    }
    
    [self stopPlayAudio];
    [self stopPlayListenWord];
    [self dismissPopTextView];
    [self dismissPopTranslateAndGramarAndWord];
    [KxMenu dismissMenu];
    
    _tabbarType = type;
    
    [_browerView selectLayerType:_tabbarType];
    
    switch (_tabbarType)
    {
        case BookStudyTabBarSelectType_read:
        {
            [_browerView dismissLanguageLayer];
            [_browerView dismissTranslateLayer];
            [_browerView dismissWordLayer];
            
            [_browerView showReadLayer];
        }
            break;
        case BookStudyTabBarSelectType_translate:
        {
            [_browerView dismissLanguageLayer];
            [_browerView dismissWordLayer];
            [_browerView dismissReadLayer];
            
            [_browerView showTranslateLayer];
        }
            break;
        case BookStudyTabBarSelectType_word:
        {
            [_browerView dismissLanguageLayer];
            [_browerView dismissTranslateLayer];
            [_browerView dismissReadLayer];
            
            [_browerView showWordLayer];
        }
            break;
        case BookStudyTabBarSelectType_language:
        {
            [_browerView dismissTranslateLayer];
            [_browerView dismissWordLayer];
            [_browerView dismissReadLayer];
            
            [_browerView showLanguageLayer];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark -- browerDelegate
- (void)browerViewSelectedAtIndex:(int)index
{
    if (index - _viewModel.countCovers >= 0)
    {
        _indexBrower = index - _viewModel.countCovers;
        if (_textFiledPage)
        {
            _textFiledPage.text = [NSString stringWithFormat:@"%d",_indexBrower];
        }
    }
    else
    {
        if (_textFiledPage)
        {
            _textFiledPage.text = [NSString stringWithFormat:@"%d",0];
        }
    }
    
    ImageShowView *v = [self.browerView getDisplayCenterView];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"StudyPageMenuGuideLoaded"] && v.menuLayer.arrCtrlsSource && v.menuLayer.arrCtrlsSource.count) {
        UIButton *guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        guideBtn.adjustsImageWhenHighlighted = NO;
        guideBtn.frame = [UIScreen mainScreen].bounds;
        guideBtn.tag = 3;
        [guideBtn setBackgroundImage:[UIImage imageNamed:@"navigate5(1)"] forState:UIControlStateNormal];
        [self.navigationController.view addSubview:guideBtn];
        [guideBtn addTarget:self action:@selector(changeGuideImage:) forControlEvents:UIControlEventTouchUpInside];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"StudyPageMenuGuideLoaded"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -- download module unit resource
- (void)confirmDownloadModuleUnitResource
{
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus networkStatus = [reachManager networkReachabilityStatus];
    switch (networkStatus)
    {
        case AFNetworkReachabilityStatusUnknown:
        {
            return;
        }
            break;
        case AFNetworkReachabilityStatusNotReachable:
        {
            return;
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            [UIAlertView showAlertViewWithTitle:Locale(@"未连接到wifi网络，是否使用流量下载") message:nil cancelButtonTitle:nil otherButtonTitles:@[Locale(@"取消"),Locale(@"确认下载")] onDismiss:^(int buttonIndex) {
                if (buttonIndex == -1)
                {
                    [self downLoadTaskCancel];
                    return;
                }
                else if (buttonIndex == 0)
                {
                    [self downloadModuleUnitResource];
                }
            } onCancel:^{
            }];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            [self downloadModuleUnitResource];
        }
            break;
        default:
            break;
    }
}

- (void)downloadModuleUnitResource
{
    _isDownloadingModuleUnit = YES;
    
    _downloadingModuleUnit = _viewModel.currentModuleUnit;
    
    _textFiledPage.userInteractionEnabled = NO;
    _btnSelectModule.userInteractionEnabled = NO;
    
    [NetworkService requestBookGetModuleUnitMetaDataWithBookId:_bookEid withModuleName:_downloadingModuleUnit success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSString class]])
        {
            _moduleResourceLocation = responseObject;
            [self downloadResourceWithLocation:responseObject withResumeData:nil withModuleName:_downloadingModuleUnit];
        }
    } failure:^(NSError *error)
    {
        
        _isDownloadingModuleUnit = NO;
        [UIAlertView showAlertViewWithTitle:nil message:Locale(@"获取下载内容失败，请稍后重试") cancelButtonTitle:Locale(@"确定") otherButtonTitles:nil onDismiss:^(int buttonIndex) {
        } onCancel:^{
            
            _textFiledPage.userInteractionEnabled = YES;
            _btnSelectModule.userInteractionEnabled = YES;
        }];
    }];
}

- (void)downloadResourceWithLocation:(NSString *)location withResumeData:(NSData *)resumeData withModuleName:(NSString *)moduleName
{
    [self layoutPorgressView];
    
    _isDownloadingModuleUnit = YES;
    
    [NetworkService downLoadBookModuleUnitWithLocation:location bookId:_viewModel.bookId parameters:moduleName resumeData:resumeData progress:^(NSProgress *progress)
    {
        if (progress.totalUnitCount > 1000)
        {
            [self resetPorgressViewWithCurrentByte:(int)progress.completedUnitCount WithTotalByte:(int)progress.totalUnitCount];
        }
    } success:^(id responseObject)
    {
        _isDownloadingModuleUnit = YES;
        
        [self hideProgressView];
        
        [self saveDownloadRecord];
        
    } failure:^(NSError *error)
    {
        _isDownloadingModuleUnit = NO;
        
        [self hideProgressView];
        
        [UIAlertView showAlertViewWithTitle:nil message:Locale(@"下载失败，请稍后重试") cancelButtonTitle:Locale(@"确定") otherButtonTitles:nil onDismiss:^(int buttonIndex) {
        } onCancel:^{
        }];
    }];
}

- (void)downLoadPauseAction
{
    NetworkService *service = [NetworkService sharedNetworkService];
    
    for (NSURLSessionDownloadTask *task in service.serviceManager.downloadTasks)
    {
        if ([[task.originalRequest.URL absoluteString] isEqualToString:_moduleResourceLocation])
        {
            [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                NSData *dataTemp = resumeData;
                
                NSString *bookDirPath = [ConfigGlobal cachePathBooks];
                // 创建目录
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:bookDirPath isDirectory:nil])
                {
                    if (![fileManager createDirectoryAtPath:bookDirPath withIntermediateDirectories:YES attributes:nil error:nil])
                    {
                        return;
                    }
                }
                
                NSString *bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_temp",_viewModel.bookId,_downloadingModuleUnit]];
                if ([fileManager fileExistsAtPath:bookPath])
                {
                    [fileManager removeItemAtPath:bookPath error:nil];
                }
                
                [dataTemp writeToFile:bookPath atomically:YES];
            }];
            
            [task cancel];
        }
    }
}

- (void)downLoadTaskPause
{
    _isDownloadingModuleUnit = NO;
    
    NetworkService *service = [NetworkService sharedNetworkService];
    
    for (NSURLSessionDownloadTask *task in service.serviceManager.downloadTasks)
    {
        if ([[task.originalRequest.URL absoluteString] isEqualToString:_moduleResourceLocation])
        {
            [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                NSData *dataTemp = resumeData;
                
                NSString *bookDirPath = [ConfigGlobal cachePathBooks];
                // 创建目录
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:bookDirPath isDirectory:nil])
                {
                    if (![fileManager createDirectoryAtPath:bookDirPath withIntermediateDirectories:YES attributes:nil error:nil])
                    {
                        return;
                    }
                }
                
                NSString *bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_temp",_viewModel.bookId,_downloadingModuleUnit]];
                if ([fileManager fileExistsAtPath:bookPath])
                {
                    [fileManager removeItemAtPath:bookPath error:nil];
                }
                
                [dataTemp writeToFile:bookPath atomically:YES];
            }];
            
            [task cancel];
        }
    }
}

- (void)restartDownLoadTask
{
    _isDownloadingModuleUnit = YES;
    
    [self confirmDownLoadTaskResume];
}

- (void)confirmDownLoadTaskResume
{
    if (_isDownloadingModuleUnit == NO)
    {
        return;
    }
    
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus networkStatus = [reachManager networkReachabilityStatus];
    switch (networkStatus)
    {
        case AFNetworkReachabilityStatusUnknown:
        {
            return;
        }
            break;
        case AFNetworkReachabilityStatusNotReachable:
        {
            return;
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            [UIAlertView showAlertViewWithTitle:Locale(@"未连接到wifi网络，是否使用流量下载") message:nil cancelButtonTitle:nil otherButtonTitles:@[Locale(@"取消"),Locale(@"确认下载")] onDismiss:^(int buttonIndex) {
                if (buttonIndex == -1)
                {
                    [self downLoadTaskCancel];
                    return;
                }
                else if (buttonIndex == 0)
                {
                    [self downLoadTaskResume];
                }
            } onCancel:^{
            }];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            [self downLoadTaskResume];
        }
            break;
        default:
            break;
    }
}

- (void)downLoadTaskResume
{
    if (_isDownloadingModuleUnit == NO)
    {
        return;
    }
    
    
    NSString *bookDirPath = [ConfigGlobal cachePathBooks];
    NSString *bookPath = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_moduletemp.zip",_bookId,_downloadingModuleUnit]];

    NSString *bookPathUnzip = [bookDirPath stringByAppendingPathComponent:_bookId];
    bookPathUnzip = [bookPathUnzip stringByAppendingString:@"/"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:bookPath])
    {
        _isDownloadingModuleUnit = NO;
        
        [self resetPorgressViewWithCurrentByte:1001 WithTotalByte:1001];
        
        ZipArchive *zip = [[ZipArchive alloc] initWithFileManager:fileManager];
        __block ZipArchive *tempZip = zip;
        zip.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles)
        {
            if (percentage == 100)
            {
                [tempZip UnzipCloseFile];
                
                [self hideProgressView];
                [self saveDownloadRecord];
            }
        };
        if ([zip UnzipOpenFile:bookPath])
        {
            [zip UnzipFileTo:bookPathUnzip overWrite:NO];
            
            [fileManager removeItemAtPath:bookPath error:nil];
        }
    }
    else
    {
        
        NSArray *arrRecord = [ModelBookRecordOfDownloadUnit selectByPropertyMaps:@{@"bookId" : _viewModel.bookId, @"moduleName" : _downloadingModuleUnit}];
        if ([arrRecord count] > 0)
        {
            _isDownloadingModuleUnit = NO;
            [self hideProgressView];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_browerView displayPageCurIndex:_indexBrower + _viewModel.countCovers];
            });
            return;
        }
        
        NSString *bookPathTemp = [bookDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_temp",_viewModel.bookId,_downloadingModuleUnit]];
        NSData *dataResume = [NSData dataWithContentsOfFile: bookPathTemp];
        if(!dataResume)
        {
            [self downloadModuleUnitResource];
        }else
        {
            [self downloadResourceWithLocation:_moduleResourceLocation withResumeData:dataResume withModuleName:_downloadingModuleUnit];
        }

    }
}

- (void)downLoadTaskCancel
{
    [self downLoadTaskPause];
    [self hideProgressView];
}

- (void)saveDownloadRecord
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    ModelBookStoreUnitDownload *unit = [[ModelBookStoreUnitDownload alloc] init];
    unit.bookId = _viewModel.bookId;
    unit.unitName = _downloadingModuleUnit;
    unit.timeStampDownload = time;
    unit.userId=[ConfigGlobal loginUser].userId;
    [unit insert];

    ModelBookStoreDownloadRecord *record = [[ModelBookStoreDownloadRecord alloc] init];
    record.bookId = _viewModel.bookId;
    record.moduleName = _downloadingModuleUnit;
    record.timeStampDownload = time;
    [record insert];
    
    
    [UtilBooksOnLocal insertBookOnLocalRecordWithId:_viewModel.bookId moduleName:_downloadingModuleUnit downloadTime:time];


    dispatch_async(dispatch_get_main_queue(), ^{
        [_browerView displayPageCurIndex:_indexBrower + _viewModel.countCovers];
    });
    
    _textFiledPage.userInteractionEnabled = YES;
    _btnSelectModule.userInteractionEnabled = YES;
}

- (void)layoutPorgressView
{
    
    _textFiledPage.userInteractionEnabled = NO;
    _btnSelectModule.userInteractionEnabled = NO;
    
    [_textFiledPage resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_popDownloadView)
        {
            _popDownloadView = [[PopDownloadProgressView alloc] initWithFrame:CGRectMake(0, -64 , SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
            [_popDownloadView setProgressWithCurrentByte:0 withTotalByte:0];
            _popDownloadView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4f];
            [self.view addSubview:_popDownloadView];
            
            _popDownloadView.delegate = self;
            [_popDownloadView layoutViewWithTitle:[NSString stringWithFormat:@"%@ : %@ (%@)",Locale(@"正在下载"),_viewModel.modelXml.bookname,_downloadingModuleUnit]];
        }
        
    });
}

- (void)resetPorgressViewWithCurrentByte:(int)cb WithTotalByte:(int)tb
{
    if (_popDownloadView && tb > 1000)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_popDownloadView setProgressWithCurrentByte:cb withTotalByte:tb];
        });
    }
}


- (void)hideProgressView
{
    _textFiledPage.userInteractionEnabled = YES;
    _btnSelectModule.userInteractionEnabled = YES;
    
    if (_popDownloadView)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_popDownloadView removeFromSuperview];
            _popDownloadView = nil;
        });
    }
}

@end
