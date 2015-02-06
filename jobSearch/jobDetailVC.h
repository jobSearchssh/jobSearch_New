//
//  jobDetailVC.h
//  jobSearch
//
//  Created by RAY on 15/1/18.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobModel.h"

@interface jobDetailVC : UIViewController
@property (strong, nonatomic) NSString *buttonTitle;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (strong, nonatomic)jobModel*jobModel;
@end
