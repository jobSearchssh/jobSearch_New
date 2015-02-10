//
//  PiPeiView.h
//  jobSearch
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobModel.h"

@interface PiPeiView : UIViewController
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *entepriseLogoView;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobPublishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobWorkPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRecuitNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobSalaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobSettlementWay;
@property (weak, nonatomic) IBOutlet UITextView *jobDescribleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRequireLabel;

@property (strong, nonatomic) jobModel *jobModel;
- (void)initData;
@end
