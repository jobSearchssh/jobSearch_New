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

@interface MLResumeVideoVC : UIViewController<UIGestureRecognizerDelegate,PBJVisionDelegate,UIAlertViewDelegate>
-(void)puloadVedio;
@end
