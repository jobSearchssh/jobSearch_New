//
//  CompanyIntroCell.h
//  jobSearch
//
//  Created by Leione on 15/3/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyIntroCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyIntro;

+ (CGFloat)getHighWithString:(NSString *)string;
- (void)changeLabelSizeWithString:(NSString *)string;
@end
