//
//  CompanyDetailView.h
//  jobSearch
//
//  Created by Leione on 15/3/24.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyDetailView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UIImageView *photoImageView;
@end
