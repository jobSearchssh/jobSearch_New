//
//  ViewController.m
//  jobSearch
//
//  Created by RAY on 15/1/15.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "AppDelegate.h"
#import "MLNavigation.h"
#import "ViewController.h"
#import "MLFirstVC.h"
#import "MLMyCollection.h"
#import "MLMyApplication.h"
#import "MLProfileVC.h"
#import "MLLoginVC.h"
#import "MLMatchVC.h"
#import "MLResumePreviewVC.h"
#import "MLFeedBackVC.h"
#import "MLLegalVC.h"
#import "MLLoginBusiness.h"
#import "badgeNumber.h"


@interface ViewController ()<UIAlertViewDelegate>
{
    UINavigationController *currentnavigationController;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mainItem"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    self.navigationController.navigationBar.translucent = NO;
    currentnavigationController=self.navigationController;
    
    badgeNumber*bn=[badgeNumber sharedInstance];
    
    [bn addObserver:self forKeyPath:@"applyCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

#pragma mark -
#pragma mark Button actions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }else if (buttonIndex==1) {
        [MLLoginBusiness logout];
        
        RESideMenu* _side=[RESideMenu sharedInstance];
        
        [_side setTableItem:0 Title:@"未登录" Subtitle:@"游客" ImageUrl:nil];
        
        [self setBadge];
    }
}

- (void)showMenu
{
    _sideMenu=[RESideMenu sharedInstance];
    
    if (!_sideMenu) {
       //登录逻辑
        NSString *title;
        NSString *subtitle;
        NSString *url;
        
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        NSString *currentUserObjectId=[mySettingData objectForKey:@"currentUserObjectId"];
        
       if ([currentUserObjectId length]>0)  {
            title=[mySettingData objectForKey:@"currentUserName"];
           subtitle=@"点击退出";
           url=[mySettingData objectForKey:@"currentUserlogoUrl"];
       }else{
           title=@"未登录";
           subtitle=@"游客";
           url=nil;
       }
        
        RESideMenuItem *usrItem = [[RESideMenuItem alloc] initWithTitle:title setFlag:USRCELL setSubtitle:subtitle image:nil imageUrl:url highlightedImage:[UIImage imageNamed:@"avatar_round_m"] action:^(RESideMenu *menu, RESideMenuItem *item){
            
            NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
            NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
            
            if ([currentUserObjectId length]>0) {
                UIAlertView *logoutAlert=[[UIAlertView alloc] initWithTitle:@"确定要退出该账号？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                [logoutAlert show];
            }else{
                [menu hide];
                
                MLLoginVC *viewController = [[MLLoginVC alloc] init];

                [currentnavigationController pushViewController:viewController animated:YES];
            }
        }];
        
        RESideMenuItem *searchItem = [[RESideMenuItem alloc] initWithTitle:@"搜索职位" setFlag:NORMALCELL image:[UIImage imageNamed:@"search"] highlightedImage:[UIImage imageNamed:@"search"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            MLFirstVC *viewController = [MLFirstVC sharedInstance];
            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:viewController];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            [self setNavigationBar:navigationController];
            viewController.title=@"搜索职位";
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];
        }];

        [searchItem setIsClick:YES];
        
        
        RESideMenuItem *savedItem = [[RESideMenuItem alloc] initWithTitle:@"我的收藏" setFlag:NORMALCELL image:[UIImage imageNamed:@"collection"] highlightedImage:[UIImage imageNamed:@"collection"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            MLMyCollection *secondViewController = [MLMyCollection sharedInstance];
            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:secondViewController];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            [self setNavigationBar:navigationController];
            secondViewController.title=@"我的收藏";
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *applicationItem = [[RESideMenuItem alloc] initWithTitle:@"我的申请" setFlag:NORMALCELL image:[UIImage imageNamed:@"apply"] highlightedImage:[UIImage imageNamed:@"apply"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            MLMyApplication *_profilehVC=[MLMyApplication sharedInstance];
            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:_profilehVC];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            [self setNavigationBar:navigationController];
            _profilehVC.title=@"我的申请";
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *dailymatchItem = [[RESideMenuItem alloc] initWithTitle:@"我的简历" setFlag:NORMALCELL image:[UIImage imageNamed:@"calendar"] highlightedImage:[UIImage imageNamed:@"calendar"] action:^(RESideMenu *menu, RESideMenuItem *item)  {

            MLResumePreviewVC *_dailyMatchVC=[[MLResumePreviewVC alloc] init];

            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:_dailyMatchVC];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            [self setNavigationBar:navigationController];
            _dailyMatchVC.title=@"我的简历";
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *feedbackItem = [[RESideMenuItem alloc] initWithTitle:@"发送反馈" setFlag:NORMALCELL image:[UIImage imageNamed:@"send"] highlightedImage:[UIImage imageNamed:@"send"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            MLFeedBackVC *feedBackVC=[MLFeedBackVC sharedInstance];
            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:feedBackVC];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            [self setNavigationBar:navigationController];
            feedBackVC.title=@"发送反馈";
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];

        }];
        
        RESideMenuItem *aboutusItem = [[RESideMenuItem alloc] initWithTitle:@"声明" setFlag:NORMALCELL image:[UIImage imageNamed:@"notice"] highlightedImage:[UIImage imageNamed:@"notice"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            MLLegalVC *legalVC=[MLLegalVC sharedInstance];
            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:legalVC];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            [self setNavigationBar:navigationController];
            legalVC.title=@"声明";
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];
        }];
        
//        RESideMenuItem *logoutsItem = [[RESideMenuItem alloc] initWithTitle:@"退出" setFlag:NORMALCELL image:[UIImage imageNamed:@"logout"] highlightedImage:[UIImage imageNamed:@"logout"] action:^(RESideMenu *menu, RESideMenuItem *item) {
//            NSLog(@"Item %@", item);
//            [menu hide];
//        }];
        
//        RESideMenuItem *loginItem = [[RESideMenuItem alloc] initWithTitle:Nil setFlag:LOGINCELL action:^(RESideMenu *menu, RESideMenuItem *item) {
//            if ([item getTapFlag] == ACTION_LOGINFLAG) {
//                NSLog(@"点击登陆");
//            }
//            if ([item getTapFlag] == ACTION_REGISTERFLAG) {
//                NSLog(@"点击注册");
//            }
//            [item setTapFlag:ACTION_NONFLAG];
//            [menu hide];
//        }];

        
        _sideMenu=[RESideMenu initInstanceWithItems:@[usrItem,searchItem, savedItem, applicationItem,dailymatchItem,feedbackItem, aboutusItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    }
    
    //显示未读消息
    [self setBadge];
    
    [_sideMenu show];
}

- (void)setNavigationBar:(UINavigationController*)navigationController{

    navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
}

- (void)setBadge{
    
    _sideMenu=[RESideMenu sharedInstance];
    
    badgeNumber *bn=[badgeNumber sharedInstance];
    
    if ([bn.applyCount intValue]>0)
        [_sideMenu setBadgeView:3 badgeText:[NSString stringWithFormat:@"%@",bn.applyCount]];
    else
        [_sideMenu setBadgeView:3 badgeText:@"0"];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqual:@"applyCount"]) {
        [self setBadge];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
