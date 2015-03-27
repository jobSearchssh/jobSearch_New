//
//  JobDetailTableViewController.m
//  jobSearch
//
//  Created by Leione on 15/3/24.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "JobDetailController.h"
#import "MLMapView.h"
#import "MLCell1.h"
#import "JobDetailView.h"
#import "CompanyDetailView.h"
#import "ButtonForJob.h"
#import "MLMapView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "PopoverView.h"
#import "freeselectViewCell.h"
#import "netAPI.h"
#import "AsyncImageView.h"
#import <ShareSDK/ShareSDK.h>
#import "MLLoginVC.h"
#import "CompanyDetailView.h"
#import "UIImage+ImageEffects.h"

@interface JobDetailController ()<UIActionSheetDelegate>
@property (nonatomic,strong)MLMapView *mapView;
@property (nonatomic,strong)NSArray *objArray;
@property (nonatomic,strong)JobDetailView *jobDetailView;
@property (nonatomic,strong)CompanyDetailView *companyDetailView;
@property (nonatomic,assign)BOOL isExchange;
@end

@implementation JobDetailController

- (JobDetailView *)jobDetailView
{
    if (_jobDetailView) {
        return _jobDetailView;
    }
    _jobDetailView = [[JobDetailView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [_jobDetailView.buttonView.sendButton addTarget:self action:@selector(sendResuse:) forControlEvents:UIControlEventTouchUpInside];
    [_jobDetailView.buttonView.callButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    return _jobDetailView;
}

- (CompanyDetailView *)companyDetailView
{
    if (_companyDetailView) {
        return _companyDetailView;
    }
    
    _companyDetailView = [[CompanyDetailView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_companyDetailView.backImageView.image  applyLightEffect];
    return _companyDetailView;
}


- (MLMapView *)mapView
{
    if (_mapView) {
        return _mapView;
    }
    _mapView=[[MLMapView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
    return _mapView;
}

- (NSArray *)objArray
{
    if (_objArray) {
        return _objArray;
    }
    _objArray = [NSArray arrayWithObjects:@"工作描述",@"年龄要求",@"学历要求",@"身高要求", nil];
    return _objArray;
}

- (void)sendResuse:(UIButton *)button
{
    if ([self.origin isEqualToString:@"2"]) {
        
        if (self.contactPhoneNumber) {
            UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON destructiveButtonTitle:nil otherButtonTitles:CALLENTERPRISE,MESSAGEENTERPRISE, nil];
            [actionSheet showInView:self.view];
            
        }else{
            [MBProgressHUD showError:ENTERPRISENOPHONE toView:self.view];
        }
        
    }else{
        
        NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
        NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
        if ([currentUserObjectId length]>0) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [netAPI applyTheJob:currentUserObjectId jobID:self.jobModel.getjobID withBlock:^(jobApplyModel *oprationResultModel) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (![oprationResultModel.getStatus intValue]==0) {
                    NSString *err=oprationResultModel.getInfo;
                    [MBProgressHUD showError:err toView:self.view];
                }
                else
                {
                    [MBProgressHUD showSuccess:APPLYSUCCESS toView:self.view];
                }
            }];
        }else{
            UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:NOTLOGIN message:ASKTOLOGIN delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON otherButtonTitles:LOGIN, nil];
            [loginAlert show];
        }
    }
}

- (void)callPhone:(UIButton *)button
{
    if (!self.jobModel.getjobPhone) {
        [MBProgressHUD showError:ENTERPRISENOPHONE toView:self.view];
        return;
    }
    
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    
    if ([currentUserObjectId length]>0) {
        
        NSString * str=[[NSString alloc] initWithFormat:@"tel:%@",self.jobModel.getjobPhone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }else{
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:NOTLOGIN message:ASKTOLOGIN delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON otherButtonTitles:LOGIN, nil];
        [loginAlert show];
    }
    
    
   
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        MLLoginVC *loginVC=[[MLLoginVC alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)loadView
{
    self.view = self.jobDetailView;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self sysconfigNavigationBar];
    
    [self setDataForJobDetailView];
    
}

- (void)sysconfigNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTheJob)];
    
    //创建UISegementControl
    UISegmentedControl *segement = [[UISegmentedControl alloc]initWithItems:@[@"职位信息",@"公司信息"]];
    
    segement.selectedSegmentIndex = 0; //通过数组下标
    
    segement.tintColor = [UIColor blueColor ];
    
    [segement addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged]; //改变的是数值
    
    self.navigationItem.titleView = segement;
}

- (void)setDataForJobDetailView
{
    if (self.jobModel) {
        
        self.jobDetailView.jobmodel = _jobModel;
       
        [self.jobDetailView.mapView addAnnotation:self.jobModel.getjobWorkPlaceGeoPoint Title:self.jobModel.getjobTitle peopleCount:[NSString stringWithFormat:@"招募%@人",self.jobModel.getjobRecruitNum]  tag:0 SetToCenter:YES];
    }
    
}

- (void)saveTheJob
{
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    if ([currentUserObjectId length]>0) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [netAPI saveTheJob:currentUserObjectId jobID:self.jobModel.getjobID withBlock:^(oprationResultModel *oprationResultModel) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (![oprationResultModel.getStatus intValue]==0) {
                NSString *err=oprationResultModel.getInfo;
                
                [MBProgressHUD showError:err toView:self.view];
            }
            else{
                [MBProgressHUD showSuccess:COLLOTESUCCESS toView:self.view];
            }
        }];
    }else{
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:NOTLOGIN message:ASKTOLOGIN delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON otherButtonTitles:LOGIN, nil];
        [loginAlert show];
    }
    
}

- (void)changeView:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            self.view = self.jobDetailView;
//            [self.view reloadInputViews];
            break;
        case 1:
            self.companyDetailView.backImageView.image = [[UIImage imageNamed:@"test.png"] applyLightEffect];
            self.companyDetailView.photoImageView.image = [UIImage imageNamed:@"test.png"];
            self.view = self.companyDetailView;
            
//            [self.view reloadInputViews];
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
