//
//  JobDetailView.h
//  jobSearch
//
//  Created by Leione on 15/3/24.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobModel.h"
#import "MLMapView.h"
#import "ButtonForJob.h"

@interface JobDetailView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)jobModel*jobmodel;
@property (nonatomic,strong)MLMapView *mapView;
@property (strong, nonatomic)NSString *origin;
@property (nonatomic,strong)ButtonForJob *buttonView;
@property (strong, nonatomic)NSString *contactPhoneNumber;
@end
