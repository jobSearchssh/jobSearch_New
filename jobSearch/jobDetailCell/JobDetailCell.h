//
//  JobDetailCell.h
//  jobSearch
//
//  Created by Leione on 15/3/24.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobModel.h"

@interface JobDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *jobImageView;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;

@property (nonatomic,strong) jobModel *jobmodel;

@end
