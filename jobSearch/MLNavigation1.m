//
//  MLNavigation1.m
//  jobSearch
//
//  Created by RAY on 15/3/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLNavigation1.h"

@interface MLNavigation1 ()
{
    BOOL firstLoad;

}
@end

@implementation MLNavigation1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:54.0/255.0 green:59.0/255.0 blue:81.0/255.0 alpha:1.0]];
    self.navigationBar.translucent=NO;
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationItem.backBarButtonItem.tintColor=[UIColor whiteColor];
}

- (void)viewWillLayoutSubviews{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationItem.backBarButtonItem.tintColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end