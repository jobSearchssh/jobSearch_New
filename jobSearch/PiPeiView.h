//
//  PiPeiView.h
//  jobSearch
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobModel.h"

@protocol childViewDelegate <NSObject>
@required
- (void)deleteJob:(int)index;
@end

@interface PiPeiView : UIViewController


@property (strong, nonatomic) jobModel *jobModel;
@property (strong, nonatomic)id <childViewDelegate>childViewDelegate;
@property (nonatomic) int index;
- (void)initData;

@end
