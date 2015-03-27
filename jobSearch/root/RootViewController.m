//
//  RootViewController.m
//  jobSearch
//
//  Created by Leione on 15/3/25.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "RootViewController.h"
#import "MLFirstVC.h"
#import "MLMessageVC.h"
#import "MLMatchVC.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MLFirstVC *firstVC = [MLFirstVC sharedInstance];
    UINavigationController *firstNaVC = [[UINavigationController alloc]initWithRootViewController:firstVC];
    UIImage *normalImage1 = [[UIImage imageNamed:@"location"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage1 = [[UIImage imageNamed:@"location"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstNaVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"职位" image:normalImage1 selectedImage:selectImage1];
    
    MLMessageVC *messageVC=[[MLMessageVC alloc]init];
    UINavigationController *messageNaVC = [[UINavigationController alloc]initWithRootViewController:messageVC];
    messageNaVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:normalImage1 selectedImage:selectImage1];
    
    
    MLMatchVC *matchVC = [[MLMatchVC alloc]init];
    UINavigationController *matchNaVC = [[UINavigationController alloc]initWithRootViewController:matchVC];
    matchNaVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"精灵管家" image:normalImage1 selectedImage:selectImage1];
    
    self.viewControllers = @[firstNaVC, messageNaVC,matchNaVC];
    self.view .backgroundColor = [UIColor whiteColor];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
