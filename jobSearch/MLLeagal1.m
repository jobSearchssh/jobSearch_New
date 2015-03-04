//
//  MLLeagal1.m
//  jobSearch
//
//  Created by RAY on 15/3/4.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLLeagal1.h"

@interface MLLeagal1 ()

@end

@implementation MLLeagal1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"兼职精灵用户使用协议";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(touchBack)];
    self.navigationItem.leftBarButtonItem = backItem;

}

- (void)touchBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate legalBack];
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
