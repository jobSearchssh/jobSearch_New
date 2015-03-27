//
//  JobDetailTableViewController.h
//  jobSearch
//
//  Created by Leione on 15/3/24.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobModel.h"

@interface JobDetailController : UIViewController
@property (strong, nonatomic)jobModel*jobModel;

@property (strong, nonatomic)NSString *origin;

@property (strong, nonatomic)NSString *contactPhoneNumber;
@end
