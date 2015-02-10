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


@property (strong, nonatomic) jobModel *jobModel;
- (void)initData;
@end
