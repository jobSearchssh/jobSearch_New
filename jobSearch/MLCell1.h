//
//  MLCell1.h
//  jobSearch
//
//  Created by RAY on 15/2/3.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AsyncImageView.h"

@interface MLCell1 : SWTableViewCell
@property (weak, nonatomic) IBOutlet AsyncImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDistance;
@property (weak, nonatomic) IBOutlet UILabel *jobNumberRemainLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end
