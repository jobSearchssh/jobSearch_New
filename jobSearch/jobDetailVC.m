//
//  jobDetailVC.m
//  jobSearch
//
//  Created by RAY on 15/1/18.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "jobDetailVC.h"
#import "MLMapView.h"


@interface jobDetailVC ()

@end

@implementation jobDetailVC
@synthesize applyButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *buttonItem1=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"export"] style:UIBarButtonItemStylePlain target:self action:@selector(shareJob)];
    buttonItem1.tintColor=[UIColor colorWithRed:174.0/255.0 green:197.0/255.0 blue:80.0/255.0 alpha:1.0];
    UIBarButtonItem *buttonItem2=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star"] style:UIBarButtonItemStylePlain target:self action:@selector(saveJob)];
    buttonItem2.tintColor=[UIColor colorWithRed:174.0/255.0 green:197.0/255.0 blue:80.0/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItems = @[buttonItem1,buttonItem2];
    
    MLMapView *mapView=[[MLMapView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
    [self.view addSubview:mapView];
    
    [self.applyButton setTitle:self.buttonTitle forState:UIControlStateNormal];
}

- (void)shareJob{
    
}

- (void)saveJob{
    
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
