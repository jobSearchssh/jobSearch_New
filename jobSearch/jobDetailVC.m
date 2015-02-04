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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobDescribleLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobRequireLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *entepriseLogoView;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobPublishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobWorkPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRecuitNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobSalaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRequireLabel;

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
    [self.containerView addSubview:mapView];
    
    [self.applyButton setTitle:self.buttonTitle forState:UIControlStateNormal];
}

- (void)updateConstraints{
    NSString *str=@"1.负责在本学校的推广。梅州转发官方微信或微博信息至少3条，以及配合e兼职线下的活动。\n2.定期反馈学校的情况，包括学校大型活动的安排（量力而行）以及用于的反馈意见和建议。\n3.定期反馈学校的情况，包括学校大型活动的安排（量力而行）以及用于的反馈意见和建议。";
    
    //工作描述label
    self.jobDescribeLabel.text=str;
    CGRect rect1 =[self.jobDescribeLabel.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-16, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}  context:nil];
    self.jobDescribleLabelHeightConstraint.constant=rect1.size.height;
    
    //任职要求label
    self.jobRequireLabel.text=str;
    CGRect rect2 =[self.jobDescribeLabel.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-16, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}  context:nil];
    self.jobRequireLabelHeightConstraint.constant=rect2.size.height;

    
    self.containerViewHeightConstraint.constant=360+rect1.size.height+rect2.size.height;
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
