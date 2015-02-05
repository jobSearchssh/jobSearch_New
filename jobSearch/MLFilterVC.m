//
//  MLFilterVC.m
//  jobSearch
//
//  Created by RAY on 15/1/17.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFilterVC.h"
#import "MLSelectJobTypeVC.h"

@interface MLFilterVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSeg;

@end

@implementation MLFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
}

- (void)done{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectDistance:(id)sender {
    NSLog(@"%ld",(long)self.distanceSeg.selectedSegmentIndex);
}

- (IBAction)setApplicationType:(id)sender {
    MLSelectJobTypeVC *selectVC=[[MLSelectJobTypeVC alloc]init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:selectVC animated:YES];
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
