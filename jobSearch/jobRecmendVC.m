//
//  jobRecmendVC.m
//  jobSearch
//
//  Created by RAY on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "jobRecmendVC.h"
#import "MLMapView.h"
@interface jobRecmendVC ()

@end

@implementation jobRecmendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MLMapView *mapView=[[MLMapView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
    [self.view addSubview:mapView];

}

- (IBAction)accept:(id)sender {
    
}

- (IBAction)refuse:(id)sender {
    
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
