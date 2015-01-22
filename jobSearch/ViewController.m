//
//  ViewController.m
//  jobSearch
//
//  Created by RAY on 15/1/15.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MLFirstVC.h"
#import "MLSecondVC.h"
#import "DailyMatchVC.h"
#import "MLProfileVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    
}

#pragma mark -
#pragma mark Button actions

- (void)showMenu
{
    _sideMenu=[RESideMenu sharedInstance];
    
    if (!_sideMenu) {
        RESideMenuItem *searchItem = [[RESideMenuItem alloc] initWithTitle:@"搜索职位" action:^(RESideMenu *menu, RESideMenuItem *item) {
            MLFirstVC *viewController = [MLFirstVC sharedInstance];
            viewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [menu setRootViewController:navigationController];
            [menu hide];
        }];
        
        RESideMenuItem *savedItem = [[RESideMenuItem alloc] initWithTitle:@"我的收藏" action:^(RESideMenu *menu, RESideMenuItem *item) {
            MLSecondVC *secondViewController = [MLSecondVC sharedInstance];
            secondViewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *applicationItem = [[RESideMenuItem alloc] initWithTitle:@"我的申请" image:[UIImage imageNamed:@"find"] highlightedImage:[UIImage imageNamed:@"find1"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            MLProfileVC *_profilehVC=[[MLProfileVC alloc] init];
            _profilehVC.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_profilehVC];
            [menu setRootViewController:navigationController];
            
        }];
        
        RESideMenuItem *dailymatchItem = [[RESideMenuItem alloc] initWithTitle:@"每日推荐" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            DailyMatchVC *_dailyMatchVC=[DailyMatchVC sharedInstance];
            _dailyMatchVC.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_dailyMatchVC];
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem *feedbackItem = [[RESideMenuItem alloc] initWithTitle:@"发送反馈" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
        }];
        
        RESideMenuItem *aboutusItem = [[RESideMenuItem alloc] initWithTitle:@"关于我们" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
        }];
        
        RESideMenuItem *loginItem = [[RESideMenuItem alloc] initWithTitle:@"登录" action:^(RESideMenu *menu, RESideMenuItem *item) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to log out?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
            [alertView show];
        }];
        
        _sideMenu=[RESideMenu initInstanceWithItems:@[searchItem, savedItem, applicationItem, dailymatchItem,feedbackItem, aboutusItem,loginItem]];
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
