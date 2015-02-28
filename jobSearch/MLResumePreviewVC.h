//
//  MLResumePreviewVC.h
//  jobSearch
//
//  Created by 田原 on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coverFlowView.h"
#import "freeselectViewCell.h"
#import "ViewController.h"
#import "netAPI.h"
#import "MBProgressHUD.h"
#import "DateUtil.h"
#define type_preview_edit 0
#define type_preview 1

@interface MLResumePreviewVC : ViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) userModel *mainUserModel;

@end
