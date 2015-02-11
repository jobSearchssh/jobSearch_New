//
//  MLCell2.h
//  jobSearch
//
//  Created by RAY on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AsyncImageView.h"
@interface MLCell2 : SWTableViewCell
@property (weak, nonatomic) IBOutlet AsyncImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobPriceLabel;

@end
