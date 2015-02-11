//
//  jobRecmendVC.h
//  jobSearch
//
//  Created by RAY on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageModel.h"

@protocol finishHandle <NSObject>
@required
- (void)finishHandle;
@end

@interface jobRecmendVC : UIViewController
@property (strong, nonatomic)messageModel*jobModel;

@property(nonatomic,weak) id<finishHandle> handleDelegate;

@end
