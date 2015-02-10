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
}

#pragma mark -
#pragma mark Button actions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }else if (buttonIndex==1) {
        [MLLoginBusiness logout];
        
        RESideMenu* _side=[RESideMenu sharedInstance];
            
        [_side setTableItem:0 Title:@"未登录" Subtitle:@"游客" Image:[UIImage imageNamed:@"tourists"]];

    }
}

- (void)showMenu
{
    _sideMenu=[RESideMenu sharedInstance];
    
    if (!_sideMenu) {
       //登录逻辑
        NSString *title;
        NSString *subtitle;
        UIImage *image=[UIImage imageNamed:@"tourists"];
        
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        NSString *currentUserObjectId=[mySettingData objectForKey:@"currentUserObjectId"];
        
       if ([currentUserObjectId length]>0)  {
            title=[mySettingData objectForKey:@"currentUserName"];
           subtitle=@"点击退出";
       }else{
           title=@"未登录";
           subtitle=@"游客";
       }
        RESideMenuItem *usrItem = [[RESideMenuItem alloc] initWithTitle:title setFlag:USRCELL setSubtitle:subtitle  image:image highlightedImage:[UIImage imageNamed:@"avatar_round_m"] action:^(RESideMenu *menu, RESideMenuItem *item){
            
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
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *savedItem = [[RESideMenuItem alloc] initWithTitle:@"我的收藏" setFlag:NORMALCELL image:[UIImage imageNamed:@"collection"] highlightedImage:[UIImage imageNamed:@"collection"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            MLMyCollection *secondViewController = [MLMyCollection sharedInstance];
            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:secondViewController];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *applicationItem = [[RESideMenuItem alloc] initWithTitle:@"我的申请" setFlag:NORMALCELL image:[UIImage imageNamed:@"apply"] highlightedImage:[UIImage imageNamed:@"apply"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            MLMyApplication *_profilehVC=[[MLMyApplication alloc] init];
            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:_profilehVC];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];
            
        }];
        
        RESideMenuItem *dailymatchItem = [[RESideMenuItem alloc] initWithTitle:@"我的简历" setFlag:NORMALCELL image:[UIImage imageNamed:@"calendar"] highlightedImage:[UIImage imageNamed:@"calendar"] action:^(RESideMenu *menu, RESideMenuItem *item)  {

            MLResumePreviewVC *_dailyMatchVC=[[MLResumePreviewVC alloc] init];

            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:_dailyMatchVC];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *feedbackItem = [[RESideMenuItem alloc] initWithTitle:@"发送反馈" setFlag:NORMALCELL image:[UIImage imageNamed:@"send"] highlightedImage:[UIImage imageNamed:@"send"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            MLFeedBackVC *feedBackVC=[MLFeedBackVC sharedInstance];
            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:feedBackVC];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
            currentnavigationController=navigationController;
            [menu setRootViewController:navigationController];

        }];
        
        RESideMenuItem *aboutusItem = [[RESideMenuItem alloc] initWithTitle:@"声明" setFlag:NORMALCELL image:[UIImage imageNamed:@"notice"] highlightedImage:[UIImage imageNamed:@"notice"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            MLLegalVC *legalVC=[MLLegalVC sharedInstance];
            MLNavigation *navigationController = [[MLNavigation alloc] initWithRootViewController:legalVC];
            navigationController.navigationBar.translucent = NO;
            navigationController.tabBarController.tabBar.translucent = NO;
            navigationController.toolbar.translucent = NO;
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
    
    [_sideMenu show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
