//
//  MLResumeVideoVC.h
//  jobSearch
//
//  Created by 田原 on 15/1/30.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBJVision.h"
#import "PBJStrobeView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"
#import "Reachability.h"

@protocol getVideoURLDelegate <NSObject>

//设置新的url
- (void) getVideoURLDelegate:(NSObject *)videoURL;

@end

@interface MLResumeVideoVC : UIViewController<UIGestureRecognizerDelegate,PBJVisionDelegate,UIAlertViewDelegate>
-(void)puloadVedio;

//回调协议
@property (assign, nonatomic) NSObject<getVideoURLDelegate> *setVideoURLDelegate;

@end
